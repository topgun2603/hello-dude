import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// DPDP Act: let people delete their account themselves.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.profile.deleteAccount(
          DeleteAccountRequest(confirm: DeleteAccountRequestConfirmEnum.DELETE),
        ),
      );
      // Server already removed the sessions; clear this phone too.
      await ref.read(sessionProvider.notifier).signOut();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showError(context, switch (errorCode(e)) {
        'EARNINGS_LEFT' =>
          'Withdraw your earnings first, then delete your account.',
        'PAYOUT_PENDING' => 'Wait for your withdrawal to finish first.',
        _ => friendlyError(e),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final companion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
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
                  const SizedBox(width: 12),
                  Text('Delete account', style: AppText.heading(22)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'This can\'t be undone.',
                style: AppText.heading(20, color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              for (final t in [
                'Your name, phone number, languages and favourites are erased.',
                if (companion)
                  'Your Aadhaar, selfie and PAN photos are erased.',
                companion
                    ? 'Withdraw your earnings before deleting.'
                    : 'Unused coins are lost and can\'t be refunded.',
                'We keep payment and call records that tax law requires, and safety reports, without your name.',
                'You can sign up again later with the same number as a new account.',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t,
                          style: AppText.body(
                            14.5,
                            color: AppColors.textMuted,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirm,
                onChanged: (_) => setState(() {}),
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Type DELETE to confirm',
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: _busy || _confirm.text.trim() != 'DELETE'
                    ? null
                    : _delete,
                child: Text(
                  _busy ? 'Deleting…' : 'Delete my account',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
