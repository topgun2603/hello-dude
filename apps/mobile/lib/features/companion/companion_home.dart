import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'companion_data.dart';
import '../notifications/notifications_screen.dart';
import '../chat/chat_screens.dart';

const _green = Color(0xFF10B981);
const _teal = Color(0xFF0E7490);

/// Design: CompanionHome.dc.html — greeting, big online switch, today's numbers, recent calls.
class CompanionHomeTab extends ConsumerWidget {
  const CompanionHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(sessionProvider).profile!;
    final home = ref.watch(companionHomeProvider);
    ref.listen(companionHomeProvider, (_, next) {
      final h = next.valueOrNull;
      if (h != null) ref.read(presenceProvider.notifier).adopt(h.online);
    });

    return RefreshIndicator(
      color: _green,
      onRefresh: () async => ref.invalidate(companionHomeProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Row(
            children: [
              Avatar(
                name: profile.displayName,
                avatarId: profile.avatarId,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${profile.displayName}',
                      style: AppText.heading(22),
                    ),
                    Text(
                      home.valueOrNull?.kycStatus ==
                              CompanionHome200ResponseKycStatusEnum.approved
                          ? 'KYC verified companion'
                          : 'Companion · not verified yet',
                      style: AppText.body(13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const ChatButton(),
              const SizedBox(width: 8),
              const NotificationBell(),
            ],
          ),
          const SizedBox(height: 18),
          home.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator(color: _green)),
            ),
            error: (e, _) => Text(
              friendlyError(e),
              style: AppText.body(14, color: AppColors.textMuted),
            ),
            data: (h) =>
                h.kycStatus == CompanionHome200ResponseKycStatusEnum.approved
                ? _Approved(h)
                : _NotApproved(h.kycStatus),
          ),
        ],
      ),
    );
  }
}

class _NotApproved extends StatelessWidget {
  const _NotApproved(this.status);
  final CompanionHome200ResponseKycStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final (title, body, cta) = switch (status) {
      CompanionHome200ResponseKycStatusEnum.submitted => (
        'Verification under review',
        'We\'ll let you know soon. Then you can go online.',
        'View details',
      ),
      CompanionHome200ResponseKycStatusEnum.rejected => (
        'Verification needs a fix',
        'Open it to see what to change.',
        'Fix and resubmit',
      ),
      _ => (
        'Finish verification',
        'Aadhaar, a live selfie, then PAN and UPI. About 5 minutes.',
        'Continue',
      ),
    };
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_green, _teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(title, style: AppText.heading(22)),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppText.body(
              14,
              color: const Color(0xFFD1FAE5),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _teal,
              minimumSize: const Size.fromHeight(46),
            ),
            onPressed: () => context.push('/kyc'),
            child: Text(
              cta,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Approved extends ConsumerStatefulWidget {
  const _Approved(this.h);
  final CompanionHome200Response h;

  @override
  ConsumerState<_Approved> createState() => _ApprovedState();
}

class _ApprovedState extends ConsumerState<_Approved> {
  bool _switching = false;

  Future<void> _toggle(bool online) async {
    setState(() => _switching = true);
    try {
      await ref.read(presenceProvider.notifier).set(online);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(presenceProvider);
    final h = widget.h;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: online
                ? const LinearGradient(
                    colors: [_green, _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: online ? null : AppColors.card,
            border: Border.all(
              color: online ? Colors.transparent : AppColors.cardBorder,
            ),
            boxShadow: online
                ? const [
                    BoxShadow(
                      color: Color(0x5510B981),
                      blurRadius: 30,
                      offset: Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      online ? 'You\'re online' : 'You\'re offline',
                      style: AppText.heading(22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      online
                          ? 'Callers can reach you now. Keep the app open.'
                          : 'Go online when you\'re ready to talk.',
                      style: AppText.body(
                        13.5,
                        color: online
                            ? const Color(0xFFD1FAE5)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: online ? 'Go offline' : 'Go online',
                child: Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    value: online,
                    onChanged: _switching ? null : _toggle,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0x66FFFFFF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Mode(
                icon: Icons.call_rounded,
                label: 'Voice',
                value: online ? 'Accepting' : 'Off',
                on: online,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Mode(
                icon: Icons.videocam_rounded,
                label: 'Video',
                value: h.videoEnabled
                    ? (online ? 'Accepting' : 'Off')
                    : 'Locked · after training',
                on: online && h.videoEnabled,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Today', style: AppText.heading(17, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Earned',
                value: rupees(h.today.earnedPaise),
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Stat(label: 'Calls', value: '${h.today.calls}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Stat(
                label: 'Talk time',
                value: talkTime(h.today.talkSeconds),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ListTile(
            onTap: () => context.push('/academy'),
            leading: const Icon(
              Icons.school_outlined,
              color: Color(0xFF6EE7B7),
            ),
            title: Text(
              'Companion academy',
              style: AppText.body(15, weight: FontWeight.w700),
            ),
            subtitle: Text(
              h.videoEnabled
                  ? 'Video calls unlocked'
                  : 'Finish 5 short lessons to unlock video calls',
              style: AppText.body(12.5, color: AppColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Recent calls',
          style: AppText.heading(17, weight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (h.recent.isEmpty)
          Text(
            'No calls yet. Go online and your first call will show up here.',
            style: AppText.body(13.5, color: AppColors.textSecondary),
          ),
        for (final c in h.recent)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Avatar(
                  name: c.callerName,
                  avatarId: c.callerAvatarId,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.callerName,
                        style: AppText.body(15, weight: FontWeight.w700),
                      ),
                      Text(
                        c.durationSeconds != null
                            ? '${c.type == CompanionHome200ResponseRecentInnerTypeEnum.video ? 'Video' : 'Voice'} · ${talkTime(c.durationSeconds!)}'
                            : c.status,
                        style: AppText.body(13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  c.earnedPaise > 0 ? '+${rupees(c.earnedPaise)}' : '—',
                  style: AppText.body(
                    15,
                    weight: FontWeight.w700,
                    color: c.earnedPaise > 0
                        ? const Color(0xFF6EE7B7)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Mode extends StatelessWidget {
  const _Mode({
    required this.icon,
    required this.label,
    required this.value,
    required this.on,
  });
  final IconData icon;
  final String label, value;
  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: on ? const Color(0xFF6EE7B7) : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppText.body(14, weight: FontWeight.w700)),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(
                  12,
                  color: on ? const Color(0xFF6EE7B7) : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label, value;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.body(12.5, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: AppText.heading(
              20,
              color: highlight ? const Color(0xFF6EE7B7) : Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
