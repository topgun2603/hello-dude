import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// "Become a companion" — explains the deal, asks for a first name, then
/// switches the account to companion mode (router moves to /companion).
class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({super.key});

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  late final _name = TextEditingController(text: _suggested());
  bool _agree = false, _busy = false;

  String _suggested() {
    final n = ref.read(sessionProvider).profile?.displayName ?? '';
    // Server default names (old and current) mean "no name yet".
    return const {'Pesu friend', 'New friend'}.contains(n) ? '' : n;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// Switching is one-way in the app, so say so before doing it.
  Future<void> _confirmAndApply() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16142C),
        title: Text(
          'Become a companion?',
          style: AppText.heading(20, weight: FontWeight.w700),
        ),
        content: Text(
          'This account will switch to companion mode. You won\'t be able to '
          'call companions from it any more. To call people, sign in with a '
          'different phone number.',
          style: AppText.body(14.5, color: AppColors.textMuted, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, switch'),
          ),
        ],
      ),
    );
    if (ok == true) await _apply();
  }

  Future<void> _apply() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(
        () => api.companion.applyAsCompanion(
          ApplyAsCompanionRequest(firstName: _name.text.trim()),
        ),
      );
      await ref.read(sessionProvider.notifier).signIn(r.tokens, r.profile);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valid = _name.text.trim().length >= 2 && _agree;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: FillScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Earn by talking',
                style: AppText.heading(30, spacing: -0.8),
              ),
              const SizedBox(height: 8),
              Text(
                'Take voice calls from people who speak your language, from home, whenever you like.',
                style: AppText.body(
                  15,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              for (final (icon, title, sub) in const [
                (
                  Icons.payments_outlined,
                  'Earn for every minute',
                  'Paid per minute you talk, plus gifts. Withdraw to UPI.',
                ),
                (
                  Icons.verified_user_outlined,
                  'Verify once',
                  'Aadhaar offline e-KYC, a live selfie and PAN. Callers never see them.',
                ),
                (
                  Icons.shield_outlined,
                  'You are in control',
                  'Go online only when you want. End, report or block any call.',
                ),
                (
                  Icons.videocam_outlined,
                  'Video comes later',
                  'Unlocked after the training lessons and a clean record.',
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0x2610B981),
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFF6EE7B7),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppText.body(15, weight: FontWeight.w700),
                            ),
                            Text(
                              sub,
                              style: AppText.body(
                                13.5,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Your first name',
                style: AppText.body(14, weight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _name,
                maxLength: 30,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'e.g. Priya',
                  helperText: 'Callers see only this and your avatar',
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              CheckboxListTile(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF10B981),
                title: Text(
                  'I am 18 or older and will follow the companion rules — no sharing contact or payment details.',
                  style: AppText.body(13.5, color: AppColors.textMuted),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Continue to verification',
                icon: Icons.arrow_forward_rounded,
                loading: _busy,
                onPressed: valid ? _confirmAndApply : null,
              ),
              const SizedBox(height: 8),
              Text(
                "Your caller account becomes a companion account. Coins you have stay in your wallet.",
                textAlign: TextAlign.center,
                style: AppText.body(12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
