import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../growth/leaderboard_screen.dart' show BadgeChip;
import '../home/online_tab.dart' show FilterPill, SearchField;
import 'companion_data.dart';

const _green = Color(0xFF10B981);

final onlineCallersProvider =
    FutureProvider.autoDispose<ListOnlineCallers200Response>((ref) {
      final api = ref.read(apiProvider);
      return api.call(() => api.companion.listOnlineCallers());
    });

/// Companion bottom-nav "Callers": callers with the app open now, fans and
/// regulars first. She can't call them — she invites, they call her.
class CallersTab extends ConsumerStatefulWidget {
  const CallersTab({super.key, required this.active});

  /// Only refresh on a timer while this tab is on screen.
  final bool active;

  @override
  ConsumerState<CallersTab> createState() => _CallersTabState();
}

class _CallersTabState extends ConsumerState<CallersTab> {
  final _search = TextEditingController();
  String _q = '';
  String? _language;
  bool _readyOnly = false;
  final _sending = <String>{};
  final _invited = <String>{};
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(CallersTab old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active) {
      if (widget.active) ref.invalidate(onlineCallersProvider);
      _sync();
    }
  }

  void _sync() {
    _poll?.cancel();
    _poll = widget.active
        ? Timer.periodic(
            const Duration(seconds: 20),
            (_) => ref.invalidate(onlineCallersProvider),
          )
        : null;
  }

  @override
  void dispose() {
    _poll?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _invite(OnlineCaller c) async {
    setState(() => _sending.add(c.id));
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.companion.inviteCaller(InviteCallerRequest(callerId: c.id)),
      );
      if (!mounted) return;
      setState(() => _invited.add(c.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invite sent to ${c.displayName}. Stay online so he can call you.',
          ),
        ),
      );
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _sending.remove(c.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(onlineCallersProvider);
    final online = ref.watch(presenceProvider);
    final all = async.valueOrNull?.callers ?? const <OnlineCaller>[];
    final myLang = ref.watch(sessionProvider).profile?.primaryLanguage;
    final langs = [
      ?myLang,
      for (final l in languages)
        if (l.code != myLang && all.any((c) => c.language == l.code)) l.code,
    ];
    final q = _q.trim().toLowerCase();
    final shown = all
        .where(
          (c) =>
              (q.isEmpty || c.displayName.toLowerCase().contains(q)) &&
              (_language == null || c.language == _language) &&
              (!_readyOnly || c.canPay),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Callers online',
                  style: AppText.heading(26, spacing: -0.6),
                ),
              ),
              if (async.hasValue)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _green.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    '${all.length} online · ${all.where((c) => c.canPay).length} ready',
                    style: AppText.body(
                      12.5,
                      weight: FontWeight.w700,
                      color: const Color(0xFF6EE7B7),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (!online)
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "You're offline. Go online to invite callers — they can only call you while you're online.",
                    style: AppText.body(13, height: 1.35),
                  ),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(presenceProvider.notifier)
                      .set(true)
                      .then((_) => ref.invalidate(onlineCallersProvider))
                      .catchError((Object e) {
                        if (context.mounted) {
                          showError(context, friendlyError(e));
                        }
                      }),
                  child: const Text('Go online'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            controller: _search,
            hint: 'Search by name',
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              FilterPill(
                icon: Icons.toll_rounded,
                label: 'Ready to call',
                selected: _readyOnly,
                onTap: () => setState(() => _readyOnly = !_readyOnly),
              ),
              FilterPill(
                label: 'All languages',
                selected: _language == null,
                onTap: () => setState(() => _language = null),
              ),
              for (final l in langs)
                FilterPill(
                  label: languageInfo(l).english,
                  selected: _language == l,
                  onTap: () =>
                      setState(() => _language = _language == l ? null : l),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator(
            color: _green,
            onRefresh: () async {
              ref.invalidate(onlineCallersProvider);
              await ref
                  .read(onlineCallersProvider.future)
                  .catchError(
                    (_) => ListOnlineCallers200Response(
                      callers: const [],
                      canInvite: false,
                    ),
                  );
            },
            child: async.isLoading && !async.hasValue
                ? const Center(child: CircularProgressIndicator(color: _green))
                : async.hasError && !async.hasValue
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          friendlyError(async.error!),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : shown.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 60),
                      const Icon(
                        Icons.people_outline_rounded,
                        size: 48,
                        color: AppColors.hint,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        all.isEmpty
                            ? 'No callers have the app open right now. Evenings are busiest.'
                            : 'Nobody matches these filters.',
                        textAlign: TextAlign.center,
                        style: AppText.body(14, color: AppColors.textSecondary),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: shown.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final c = shown[i];
                      final invited =
                          c.invitedRecently || _invited.contains(c.id);
                      return CallerRow(
                        caller: c,
                        invited: invited,
                        busy: _sending.contains(c.id),
                        onInvite: online && !invited && !c.inCall
                            ? () => _invite(c)
                            : null,
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

/// "Today" / "Tue" / "12 Sep" for the last call.
String _lastCall(DateTime at) {
  final t = at.toLocal(), now = DateTime.now();
  final days = DateTime(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime(t.year, t.month, t.day)).inDays;
  if (days == 0) return 'today';
  if (days == 1) return 'yesterday';
  if (days < 7) {
    return 'on ${const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][t.weekday - 1]}';
  }
  const mo = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return 'on ${t.day} ${mo[t.month - 1]}';
}

class CallerRow extends StatelessWidget {
  const CallerRow({
    super.key,
    required this.caller,
    required this.invited,
    required this.busy,
    required this.onInvite,
  });
  final OnlineCaller caller;
  final bool invited, busy;
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    final c = caller;
    final history = c.callsWithYou > 0
        ? 'Talked ${c.callsWithYou}×${c.lastCallAt != null ? ' · last ${_lastCall(c.lastCallAt!)}' : ''}'
        : 'Hasn\'t talked with you yet';
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: c.favouritedYou
              ? const Color(0x66F472B6)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Avatar(
            name: c.displayName,
            avatarId: c.avatarId,
            size: 48,
            statusColor: c.inCall ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        c.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.heading(15.5),
                      ),
                    ),
                    if (c.favouritedYou) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: Color(0xFFF472B6),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Badge(
                      languageInfo(c.language).english,
                      AppColors.textSecondary,
                    ),
                    if (c.canPay)
                      const _Badge('Ready to call', Color(0xFF6EE7B7)),
                    if (c.isVip) const _Badge('VIP', Color(0xFFFCD34D)),
                    if (c.isNew) const _Badge('New', Color(0xFF93C5FD)),
                    if (c.level >= 2)
                      _Badge('Lv ${c.level} ${c.levelName}', AppColors.lilac),
                    if (c.badge != null) BadgeChip(badge: c.badge!),
                    if (c.inCall) const _Badge('In a call', AppColors.warning),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  history,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(12, color: AppColors.hint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 38,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onPressed: busy ? null : onInvite,
              child: Text(invited ? 'Invited' : 'Invite'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: AppText.body(11, weight: FontWeight.w700, color: color),
    ),
  );
}
