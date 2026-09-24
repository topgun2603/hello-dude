import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/languages.dart';
import '../../data/api.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/start_call.dart';
import '../home/home_data.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
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

String clockLabel(DateTime t) {
  final l = t.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
}

String dayLabel(DateTime t) {
  final l = t.toLocal();
  return '${_weekdays[l.weekday - 1]} ${l.day} ${_months[l.month - 1]}';
}

class ScheduleData {
  ScheduleData(this.slots, this.companion);
  final GetBookingSlots200Response slots;
  final OnlineCompanion companion;
}

final scheduleProvider = FutureProvider.autoDispose
    .family<ScheduleData, String>((ref, companionId) async {
      final api = ref.read(apiProvider);
      final results = await Future.wait([
        api.call(() => api.bookings.getBookingSlots(companionId)),
        api.call(() => api.companions.getCompanion(companionId)),
      ]);
      return ScheduleData(
        results[0] as GetBookingSlots200Response,
        (results[1] as GetCompanion200Response).companion,
      );
    });

final bookingsProvider = FutureProvider.autoDispose<ListBookings200Response>((
  ref,
) {
  final api = ref.read(apiProvider);
  return api.call(() => api.bookings.listBookings());
});

/// Design: Schedule.dc.html — day chips, time slots (taken ones crossed out), length, coins held.
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key, required this.companionId});
  final String companionId;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  int _day = 0;
  DateTime? _slot;
  int _minutes = 20;
  bool _saving = false;

  Future<void> _book(ScheduleData d) async {
    final slot = _slot;
    if (slot == null) return;
    setState(() => _saving = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.bookings.createBooking(
          CreateBookingRequest(
            companionId: widget.companionId,
            startAt: slot,
            minutes: _minutes,
          ),
        ),
      );
      ref.invalidate(walletProvider);
      ref.invalidate(bookingsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Booked! We'll tell you when ${d.companion.displayName} confirms.",
          ),
        ),
      );
      context.pushReplacement('/bookings');
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      if (errorCode(e) == 'SLOT_TAKEN') {
        _slot = null;
        ref.invalidate(scheduleProvider(widget.companionId));
      }
      showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(scheduleProvider(widget.companionId));
    final coins = ref.watch(walletProvider).valueOrNull?.coins;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: data.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  friendlyError(e),
                  textAlign: TextAlign.center,
                  style: AppText.body(15),
                ),
              ),
            ),
            data: (d) {
              final c = d.companion;
              final rate = c.rates.audioCoinsPerMin ?? 0;
              final days = d.slots.days;
              final day = days[_day.clamp(0, days.length - 1)];
              final held = rate * _minutes;
              return FillScrollView(
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
                      Expanded(
                        child: Text(
                          'Schedule a call',
                          style: AppText.heading(22),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Avatar(name: c.displayName, avatarId: c.avatarId),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.displayName,
                                style: AppText.body(
                                  16,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${languageNames(c.languages)} · voice calls',
                                style: AppText.body(
                                  13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Day',
                    style: AppText.body(
                      14,
                      color: AppColors.textSecondary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final first = DateTime.parse(
                          '${days[i].date}T12:00:00',
                        );
                        final label = i == 0
                            ? 'Today ${first.day}'
                            : '${_weekdays[first.weekday - 1]} ${first.day}';
                        return _Chip(
                          label: label,
                          on: i == _day,
                          onTap: () => setState(() {
                            _day = i;
                            _slot = null;
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'Time',
                        style: AppText.body(
                          14,
                          color: AppColors.textSecondary,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Crossed out = already booked',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(12, color: AppColors.hint),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in day.slots)
                        _Chip(
                          key: ValueKey('slot-${s.startAt.toIso8601String()}'),
                          label: clockLabel(s.startAt),
                          on: _slot == s.startAt,
                          disabled: !s.available,
                          onTap: () => setState(() => _slot = s.startAt),
                        ),
                    ],
                  ),
                  if (!day.slots.any((s) => s.available)) ...[
                    const SizedBox(height: 8),
                    Text(
                      'No times left this day — try another day.',
                      style: AppText.body(13, color: AppColors.hint),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    'How long',
                    style: AppText.body(
                      14,
                      color: AppColors.textSecondary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in d.slots.durations)
                        _Chip(
                          label: '$m min',
                          on: _minutes == m,
                          onTap: () => setState(() => _minutes = m),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (_slot != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.pink.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${dayLabel(_slot!)} · ${clockLabel(_slot!)} · $_minutes min',
                            style: AppText.body(15, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$held coins held now, refunded if ${c.displayName} doesn't join",
                            style: AppText.body(
                              13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (coins != null && coins < held)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'You have $coins coins — recharge to book this.',
                                style: AppText.body(
                                  13,
                                  color: AppColors.warning,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  GradientButton(
                    label: 'Confirm booking',
                    icon: Icons.event_available_rounded,
                    loading: _saving,
                    onPressed: _slot == null ? null : () => _book(d),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
    required this.on,
    required this.onTap,
    this.disabled = false,
  });
  final String label;
  final bool on, disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: on,
      enabled: !disabled,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: on ? AppColors.brand : null,
            color: on ? null : AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: on ? Colors.transparent : AppColors.cardBorder,
            ),
          ),
          child: Text(
            label,
            style:
                AppText.body(
                  14,
                  weight: FontWeight.w600,
                  color: disabled ? AppColors.hint : Colors.white,
                ).copyWith(
                  decoration: disabled ? TextDecoration.lineThrough : null,
                  decorationColor: AppColors.hint,
                ),
          ),
        ),
      ),
    );
  }
}

/// Upcoming and past bookings, for callers and companions.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(bookingsProvider);
    final isCompanion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isCompanion ? 'Call requests' : 'My bookings',
                        style: AppText.heading(22),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.invalidate(bookingsProvider),
                  child: data.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => ListView(
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          friendlyError(e),
                          textAlign: TextAlign.center,
                          style: AppText.body(15),
                        ),
                      ],
                    ),
                    data: (d) => d.upcoming.isEmpty && d.past.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 90),
                              const Icon(
                                Icons.event_note_rounded,
                                size: 52,
                                color: AppColors.hint,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No bookings yet',
                                textAlign: TextAlign.center,
                                style: AppText.heading(18),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isCompanion
                                    ? 'When callers book a time with you, it shows up here.'
                                    : 'Book a time with a favourite from your Favourites list.',
                                textAlign: TextAlign.center,
                                style: AppText.body(
                                  14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                            children: [
                              if (d.upcoming.isNotEmpty) _Section('UPCOMING'),
                              for (final b in d.upcoming)
                                _BookingCard(
                                  booking: b,
                                  isCompanion: isCompanion,
                                ),
                              if (d.past.isNotEmpty) _Section('PAST'),
                              for (final b in d.past)
                                _BookingCard(
                                  booking: b,
                                  isCompanion: isCompanion,
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 8),
    child: Text(
      label,
      style: AppText.body(
        12,
        color: AppColors.hint,
        weight: FontWeight.w700,
      ).copyWith(letterSpacing: 1.2),
    ),
  );
}

(String, Color) statusLook(BookingStatusEnum s) => switch (s) {
  BookingStatusEnum.requested => (
    'Waiting for confirmation',
    AppColors.warning,
  ),
  BookingStatusEnum.confirmed => ('Confirmed', AppColors.success),
  BookingStatusEnum.started => ('In progress', AppColors.success),
  BookingStatusEnum.completed => ('Completed', AppColors.textSecondary),
  BookingStatusEnum.declined => (
    'Declined · coins returned',
    AppColors.textSecondary,
  ),
  BookingStatusEnum.expired => (
    'Not confirmed · coins returned',
    AppColors.textSecondary,
  ),
  BookingStatusEnum.cancelled => (
    'Cancelled · coins returned',
    AppColors.textSecondary,
  ),
  BookingStatusEnum.missed => (
    "Didn't happen · coins returned",
    AppColors.textSecondary,
  ),
  _ => (s.toString(), AppColors.textSecondary),
};

class _BookingCard extends ConsumerStatefulWidget {
  const _BookingCard({required this.booking, required this.isCompanion});
  final Booking booking;
  final bool isCompanion;

  @override
  ConsumerState<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<_BookingCard> {
  bool _busy = false;

  Future<void> _act(
    Future<Booking?> Function(PesuApi api) action, {
    String? done,
  }) async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(() => action(api));
      ref.invalidate(bookingsProvider);
      ref.invalidate(walletProvider);
      if (done != null && mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _callNow() async {
    final b = widget.booking;
    final api = ref.read(apiProvider);
    setState(() => _busy = true);
    try {
      await api.call(
        () => api.bookings.startBooking(b.id, ConfirmBookingRequest()),
      );
      ref.invalidate(walletProvider);
      final r = await api.call(
        () => api.companions.getCompanion(b.companion.id),
      );
      if (!mounted) return;
      await startCallFlow(
        context,
        ref,
        companion: r.companion,
        language: r.companion.primaryLanguage,
        video: b.callType == BookingCallTypeEnum.video,
      );
      ref.invalidate(bookingsProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final other = widget.isCompanion ? b.caller : b.companion;
    final (label, color) = statusLook(b.status);
    final live =
        b.status == BookingStatusEnum.requested ||
        b.status == BookingStatusEnum.confirmed;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                name: other.displayName,
                avatarId: other.avatarId,
                size: 42,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      other.displayName,
                      style: AppText.body(15.5, weight: FontWeight.w700),
                    ),
                    Text(
                      '${dayLabel(b.startAt)} · ${clockLabel(b.startAt)} · ${b.minutes} min',
                      style: AppText.body(13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.isCompanion
                ? label
                : '$label${live ? ' · ${b.heldCoins} coins held' : ''}',
            style: AppText.body(13, color: color, weight: FontWeight.w600),
          ),
          if (live || b.canStart) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (widget.isCompanion &&
                    b.status == BookingStatusEnum.requested) ...[
                  FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _act(
                            (api) => api.bookings.confirmBooking(
                              b.id,
                              ConfirmBookingRequest(),
                            ),
                            done: 'Confirmed',
                          ),
                    child: const Text('Confirm'),
                  ),
                  OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => _act(
                            (api) => api.bookings.declineBooking(
                              b.id,
                              ConfirmBookingRequest(),
                            ),
                            done: 'Declined',
                          ),
                    child: const Text("Can't make it"),
                  ),
                ],
                if (!widget.isCompanion && b.canStart)
                  FilledButton.icon(
                    onPressed: _busy ? null : _callNow,
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('Call now'),
                  ),
                if (!widget.isCompanion && live)
                  OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => _act(
                            (api) => api.bookings.cancelBooking(
                              b.id,
                              ConfirmBookingRequest(),
                            ),
                            done: 'Cancelled — your coins are back',
                          ),
                    child: const Text('Cancel booking'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
