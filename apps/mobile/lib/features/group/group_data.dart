import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// Callers: groups live now, lobbies filling up and upcoming ones.
/// Companions: their own open and scheduled groups.
final groupsProvider = FutureProvider.autoDispose<List<GroupCard>>((ref) async {
  final api = ref.watch(apiProvider);
  return (await api.call(() => api.groups.listGroups())).groups;
});

/// `group_event`s for one group, as sent by routes/groups.ts.
extension GroupEvents on Realtime {
  Stream<Map<String, dynamic>> forGroup(String groupId) => events
      .where((e) => e['t'] == 'group_event' && e['groupId'] == groupId)
      .map((e) => (e['event'] as Map).cast<String, dynamic>());
}

const groupGreen = Color(0xFF10B981);

/// A friendly (non-error) toast.
void groupSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF064E3B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(message, style: AppText.body(14)),
      ),
    );
}

/// "Today 8:30 PM" / "Tomorrow 7:00 PM" / "Fri 26 Sep, 9:00 PM" (phone's local time).
String groupWhen(DateTime at) {
  final t = at.toLocal(), now = DateTime.now();
  final day = DateTime(t.year, t.month, t.day),
      today = DateTime(now.year, now.month, now.day);
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12,
      m = t.minute.toString().padLeft(2, '0');
  final time = '$h:$m ${t.hour < 12 ? 'AM' : 'PM'}';
  final diff = day.difference(today).inDays;
  if (diff == 0) return 'Today $time';
  if (diff == 1) return 'Tomorrow $time';
  const wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
  return '${wd[t.weekday - 1]} ${t.day} ${mo[t.month - 1]}, $time';
}

/// Small status pill: LIVE / FILLING / time.
class GroupStatusPill extends StatelessWidget {
  const GroupStatusPill(this.g, {super.key});
  final GroupCard g;

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (g.status) {
      GroupCardStatusEnum.live => ('LIVE', const Color(0xFFE11D48)),
      GroupCardStatusEnum.lobby => ('FILLING UP', const Color(0xFFF59E0B)),
      _ => (
        g.scheduledAt == null ? 'SOON' : groupWhen(g.scheduledAt!),
        const Color(0xFF7C3AED),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppText.body(
          10.5,
          weight: FontWeight.w800,
        ).copyWith(letterSpacing: 0.4),
      ),
    );
  }
}

/// Home: entry card to group video, with a count of what's on.
class GroupVideoCard extends ConsumerWidget {
  const GroupVideoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider).valueOrNull ?? const <GroupCard>[];
    final open = groups
        .where((g) => g.status != GroupCardStatusEnum.scheduled)
        .length;
    final soon = groups.length - open;
    final sub = groups.isEmpty
        ? 'Hang out on camera with a companion and up to 9 others.'
        : [
            if (open > 0) '$open on now',
            if (soon > 0) '$soon coming up',
          ].join(' · ');
    return Semantics(
      button: true,
      label: 'Group video. $sub',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/groups'),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF065F46), Color(0xFF0E7490)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                child: const Icon(Icons.groups_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Group video', style: AppText.heading(17)),
                    const SizedBox(height: 2),
                    Text(sub, style: AppText.body(12.5, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

/// Caller: every group on now or coming up, with join / book.
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  Timer? _poll;
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(
      const Duration(seconds: 15),
      (_) => ref.invalidate(groupsProvider),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _seat(GroupCard g) async {
    setState(() => _busy.add(g.id));
    final api = ref.read(apiProvider);
    try {
      if (g.mySeat == GroupCardMySeatEnum.booked) {
        await api.send(() => api.groups.cancelGroupSeat(g.id));
      } else {
        await api.call(() => api.groups.bookGroupSeat(g.id));
        if (mounted)
          groupSnack(
            context,
            "Seat booked — we'll remind you 10 minutes before. It's free until the group starts.",
          );
      }
      ref.invalidate(groupsProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy.remove(g.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(groupsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Group video')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(groupsProvider.future),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(friendlyError(e)),
              ),
            ],
          ),
          data: (groups) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _HowItWorks(),
              const SizedBox(height: 14),
              if (groups.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No groups right now. Companions open groups in the evenings — check back soon.',
                    textAlign: TextAlign.center,
                    style: AppText.body(14, color: AppColors.textSecondary),
                  ),
                ),
              for (final g in groups)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GroupTile(
                    g: g,
                    busy: _busy.contains(g.id),
                    onJoin: () => context.push('/group', extra: g.id),
                    onSeat: () => _seat(g),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: groupGreen.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: groupGreen.withValues(alpha: 0.3)),
    ),
    child: Text(
      'Everyone is on camera. A group starts when 3 people are in, and you pay per minute only once it starts. '
      'Leave anytime. Uses more mobile data than a 1:1 call — Wi-Fi is best.',
      style: AppText.body(13, color: AppColors.textSecondary, height: 1.4),
    ),
  );
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.g,
    required this.busy,
    required this.onJoin,
    required this.onSeat,
  });
  final GroupCard g;
  final bool busy;
  final VoidCallback onJoin, onSeat;

  @override
  Widget build(BuildContext context) {
    final scheduled = g.status == GroupCardStatusEnum.scheduled;
    final full =
        g.members >= g.maxMembers && g.mySeat == GroupCardMySeatEnum.none;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                name: g.host.displayName,
                avatarId: g.host.avatarId,
                photoUrl: g.host.photoUrl,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.heading(15.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${g.host.displayName} · ${g.language.toUpperCase()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GroupStatusPill(g),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _Stat(
                      icon: Icons.people_alt_outlined,
                      color: AppColors.textSecondary,
                      text: '${g.members}/${g.maxMembers}',
                    ),
                    _Stat(
                      icon: Icons.toll_rounded,
                      color: const Color(0xFFFCD34D),
                      text: '${g.coinsPerMin} coins/min',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: scheduled
                    ? OutlinedButton(
                        onPressed: busy || full ? null : onSeat,
                        child: Text(
                          g.mySeat == GroupCardMySeatEnum.booked
                              ? 'Cancel seat'
                              : (full ? 'Full' : 'Book seat'),
                        ),
                      )
                    : FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: groupGreen,
                        ),
                        onPressed: full ? null : onJoin,
                        child: Text(
                          full
                              ? 'Full'
                              : (g.mySeat == GroupCardMySeatEnum.joined
                                    ? 'Back in'
                                    : 'Join'),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
        TextSpan(text: text),
      ],
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppText.body(13, weight: FontWeight.w700),
  );
}
