import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../favourites/favourites_screen.dart';
import 'start_call.dart';

final _callSummaryProvider = FutureProvider.autoDispose
    .family<CallDetails, String>((ref, id) {
      final api = ref.watch(apiProvider);
      return api.call(() => api.calls.getCall(id));
    });

/// Design: RateCall.dc.html — summary chip, avatar, stars.
class RateScreen extends ConsumerStatefulWidget {
  const RateScreen({super.key, required this.args});
  final CallArgs args;

  @override
  ConsumerState<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends ConsumerState<RateScreen> {
  int _stars = 0;
  bool _favourite = false;
  bool _sending = false;

  static const _labels = [
    '',
    'Not good',
    'Could be better',
    'Okay',
    'Really good',
    'Loved it',
  ];

  Future<void> _submit() async {
    setState(() => _sending = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.calls.rateCall(
          widget.args.callId,
          RateCallRequest(stars: _stars),
        ),
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (!mounted) return;
      if (errorCode(e) == 'ALREADY_RATED') return context.go('/home');
      showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.args;
    final summary = ref.watch(_callSummaryProvider(a.callId)).valueOrNull;
    String? chip;
    if (summary != null) {
      final secs = summary.durationSeconds ?? 0;
      final charged = summary.coinsCharged - summary.coinsRefunded;
      chip =
          'Call ended · ${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')} · $charged coins'
          '${summary.coinsRefunded > 0 ? ' (refunded)' : ''}';
    }
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: FillScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    chip ?? 'Call ended',
                    style: AppText.body(
                      12.5,
                      color: AppColors.textSecondary,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Avatar(
                  name: a.otherName,
                  avatarId: a.otherAvatarId,
                  size: 96,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'How was your call\nwith ${a.otherName}?',
                textAlign: TextAlign.center,
                style: AppText.heading(26, spacing: -0.5).copyWith(height: 1.2),
              ),
              const SizedBox(height: 6),
              Text(
                _labels[_stars],
                textAlign: TextAlign.center,
                style: AppText.body(
                  14,
                  color: const Color(0xFFFDE68A),
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      tooltip: '$i star${i > 1 ? 's' : ''}',
                      iconSize: 44,
                      onPressed: () => setState(() => _stars = i),
                      icon: Icon(
                        i <= _stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: i <= _stars
                            ? const Color(0xFFFCD34D)
                            : AppColors.hint,
                      ),
                    ),
                ],
              ),
              if (summary != null) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _favourite,
                    activeThumbColor: AppColors.pink,
                    onChanged: (v) async {
                      setState(() => _favourite = v);
                      try {
                        await setFavourite(ref, summary.other.id, v);
                      } catch (e) {
                        if (mounted) {
                          setState(() => _favourite = !v);
                          showError(context, friendlyError(e));
                        }
                      }
                    },
                    title: Text(
                      'Add ${a.otherName} to favourites',
                      style: AppText.body(14.5, weight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Get told when they\'re online',
                      style: AppText.body(12.5, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Submit',
                loading: _sending,
                onPressed: _stars == 0 ? null : _submit,
              ),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(
                  'Skip',
                  style: AppText.body(15, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
