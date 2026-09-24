import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'group_data.dart';

/// Companion home: host a group video now or schedule one; lists their own
/// open and upcoming groups. Needs video unlocked.
class HostGroupsCard extends ConsumerStatefulWidget {
  const HostGroupsCard({super.key, required this.unlocked});
  final bool unlocked;

  @override
  ConsumerState<HostGroupsCard> createState() => _HostGroupsCardState();
}

class _HostGroupsCardState extends ConsumerState<HostGroupsCard> {
  String? _busy;

  Future<void> _open(GroupCard g) async {
    setState(() => _busy = g.id);
    final api = ref.read(apiProvider);
    try {
      await api.call(() => api.groups.openGroup(g.id));
      ref.invalidate(groupsProvider);
      if (mounted) await context.push('/group-host', extra: g.id);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _cancel(GroupCard g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this group?'),
        content: Text(
          g.members > 0
              ? '${g.members} people booked a seat. They will be told.'
              : 'Nobody has booked yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel group'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(() => api.groups.endGroup(g.id));
      ref.invalidate(groupsProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mine = widget.unlocked
        ? (ref.watch(groupsProvider).valueOrNull ?? const <GroupCard>[])
        : const <GroupCard>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: widget.unlocked
              ? 'Host a group video'
              : 'Group video is locked until video calls unlock',
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.unlocked
                ? () => showHostGroupSheet(context, ref)
                : () => context.push('/academy'),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: widget.unlocked
                    ? const LinearGradient(
                        colors: [Color(0xFF065F46), Color(0xFF0E7490)],
                      )
                    : null,
                color: widget.unlocked ? null : AppColors.card,
                border: Border.all(
                  color: widget.unlocked
                      ? Colors.transparent
                      : AppColors.cardBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: widget.unlocked ? 0.18 : 0.08,
                      ),
                    ),
                    child: Icon(
                      widget.unlocked
                          ? Icons.groups_rounded
                          : Icons.lock_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Group video', style: AppText.heading(17)),
                        const SizedBox(height: 2),
                        Text(
                          widget.unlocked
                              ? 'Host up to 10 people on camera. Earn from every member-minute.'
                              : 'Unlocks with video calls — finish the academy.',
                          style: AppText.body(
                            12.5,
                            color: widget.unlocked
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),
        ),
        for (final g in mine)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.heading(14.5),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          GroupStatusPill(g),
                          const SizedBox(width: 8),
                          Text(
                            '${g.members} ${g.status == GroupCardStatusEnum.scheduled ? 'booked' : 'in'}',
                            style: AppText.body(
                              12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (g.status == GroupCardStatusEnum.scheduled) ...[
                  IconButton(
                    tooltip: 'Cancel group',
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => _cancel(g),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: groupGreen),
                    onPressed: _busy == g.id ? null : () => _open(g),
                    child: const Text('Open lobby'),
                  ),
                ] else
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: groupGreen),
                    onPressed: () => context.push('/group-host', extra: g.id),
                    child: const Text('Back in'),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Title, then "Start now" or "Schedule" (next 7 days).
Future<void> showHostGroupSheet(BuildContext context, WidgetRef ref) async {
  final started = await showModalBottomSheet<GroupHostState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF16142C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _HostSheet(),
  );
  ref.invalidate(groupsProvider);
  if (started == null || !context.mounted) return;
  if (started.group.status == GroupCardStatusEnum.lobby) {
    await context.push('/group-host', extra: started.group.id);
  } else {
    groupSnack(
      context,
      "Scheduled for ${groupWhen(started.group.scheduledAt!)}. Callers can book seats now — we'll remind you.",
    );
  }
}

class _HostSheet extends ConsumerStatefulWidget {
  const _HostSheet();

  @override
  ConsumerState<_HostSheet> createState() => _HostSheetState();
}

class _HostSheetState extends ConsumerState<_HostSheet> {
  final _title = TextEditingController(text: 'Evening hangout');
  bool _later = false, _busy = false;
  DateTime? _at;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final day = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 6)),
      initialDate: _at ?? now,
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _at ?? now.add(const Duration(hours: 1)),
      ),
    );
    if (time == null) return;
    setState(
      () =>
          _at = DateTime(day.year, day.month, day.day, time.hour, time.minute),
    );
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      final s = await api.call(
        () => api.groups.createGroup(
          CreateGroupRequest(
            title: _title.text.trim(),
            scheduledAt: _later ? _at!.toUtc().toIso8601String() : null,
          ),
        ),
      );
      if (mounted) Navigator.pop(context, s);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = _title.text.trim().length >= 3 && (!_later || _at != null);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Host a group video', style: AppText.heading(20)),
            const SizedBox(height: 8),
            Text(
              'Up to 10 callers, everyone on camera. It starts when 3 are in; each pays per minute and you earn from every member-minute and gift. '
              "No 1:1 calls while you host. Lobbies that don't fill in 10 minutes close. Keep it friendly — cameras are safety-checked.",
              style: AppText.body(
                13.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              maxLength: 60,
              style: AppText.body(15),
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'What will you talk about?',
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Start now'),
                  icon: Icon(Icons.bolt_rounded),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Schedule'),
                  icon: Icon(Icons.event_rounded),
                ),
              ],
              selected: {_later},
              onSelectionChanged: (s) => setState(() => _later = s.first),
            ),
            if (_later) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.schedule_rounded),
                label: Text(
                  _at == null ? 'Pick a day and time' : groupWhen(_at!),
                ),
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              height: 54,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: groupGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: _busy || !ready ? null : _create,
                child: Text(
                  _busy
                      ? 'Setting up…'
                      : (_later ? 'Schedule group' : 'Open lobby'),
                  style: AppText.heading(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
