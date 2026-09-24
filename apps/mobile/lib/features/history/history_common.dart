import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Date ranges offered by the history filters.
enum HistoryRange {
  all('Any time'),
  today('Today'),
  week('Last 7 days'),
  month('Last 30 days'),
  custom('Pick dates…');

  const HistoryRange(this.label);
  final String label;
}

/// The chosen range as [from, to) instants (null = open ended).
class RangeFilter {
  const RangeFilter(this.range, [this.custom]);
  final HistoryRange range;
  final DateTimeRange? custom;

  (DateTime?, DateTime?) bounds([DateTime? now]) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return switch (range) {
      HistoryRange.all => (null, null),
      HistoryRange.today => (today, null),
      HistoryRange.week => (today.subtract(const Duration(days: 6)), null),
      HistoryRange.month => (today.subtract(const Duration(days: 29)), null),
      HistoryRange.custom => (
        custom == null
            ? null
            : DateTime(
                custom!.start.year,
                custom!.start.month,
                custom!.start.day,
              ),
        custom == null
            ? null
            : DateTime(
                custom!.end.year,
                custom!.end.month,
                custom!.end.day + 1,
              ),
      ),
    };
  }

  String get label {
    if (range != HistoryRange.custom || custom == null) return range.label;
    final s = custom!.start, e = custom!.end;
    return s == e ? shortDate(s) : '${shortDate(s)} – ${shortDate(e)}';
  }

  @override
  bool operator ==(Object other) =>
      other is RangeFilter && other.range == range && other.custom == custom;

  @override
  int get hashCode => Object.hash(range, custom);
}

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
const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

/// "Today", "Yesterday", "Mon, 22 Sep", or "22 Sep 2025" for other years.
String dayHeader(DateTime t, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final d = DateTime(t.year, t.month, t.day);
  final today = DateTime(n.year, n.month, n.day);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (d.year != n.year) return '${shortDate(d)} ${d.year}';
  return '${_days[d.weekday - 1]}, ${shortDate(d)}';
}

/// "8:42 PM"
String clock(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  return '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'AM' : 'PM'}';
}

/// Consecutive items grouped under their local day.
List<(DateTime day, List<T> items)> groupByDay<T>(
  List<T> items,
  DateTime Function(T) at,
) {
  final out = <(DateTime, List<T>)>[];
  for (final it in items) {
    final t = at(it).toLocal();
    final day = DateTime(t.year, t.month, t.day);
    if (out.isEmpty || out.last.$1 != day) out.add((day, <T>[]));
    out.last.$2.add(it);
  }
  return out;
}

/// A pill that opens a bottom sheet of choices; pink when not on its default.
class FilterPill<T> extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: active ? AppColors.brand : null,
            color: active ? null : AppColors.card,
            border: Border.all(
              color: active ? Colors.transparent : AppColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.body(
                  13.5,
                  weight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 18,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Bottom sheet with one choice per row; returns the picked value.
Future<T?> pickOne<T>(
  BuildContext context, {
  required String title,
  required List<(T value, String label, IconData icon)> options,
  required T current,
}) => showModalBottomSheet<T>(
  context: context,
  backgroundColor: const Color(0xFF16142C),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (ctx) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(title, style: AppText.heading(18)),
          const SizedBox(height: 6),
          for (final (value, label, icon) in options)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                icon,
                color: value == current
                    ? AppColors.pinkSoft
                    : AppColors.textSecondary,
              ),
              title: Text(
                label,
                style: AppText.body(
                  15.5,
                  weight: FontWeight.w600,
                  color: value == current ? AppColors.pinkSoft : Colors.white,
                ),
              ),
              trailing: value == current
                  ? const Icon(Icons.check_rounded, color: AppColors.pinkSoft)
                  : null,
              onTap: () => Navigator.pop(ctx, value),
            ),
        ],
      ),
    ),
  ),
);

/// Range chooser: presets, or a calendar for custom dates.
Future<RangeFilter?> pickRange(
  BuildContext context,
  RangeFilter current,
) async {
  final picked = await pickOne<HistoryRange>(
    context,
    title: 'Show',
    current: current.range,
    options: const [
      (HistoryRange.all, 'Any time', Icons.all_inclusive_rounded),
      (HistoryRange.today, 'Today', Icons.today_rounded),
      (HistoryRange.week, 'Last 7 days', Icons.date_range_rounded),
      (HistoryRange.month, 'Last 30 days', Icons.calendar_month_rounded),
      (HistoryRange.custom, 'Pick dates…', Icons.edit_calendar_rounded),
    ],
  );
  if (picked == null || !context.mounted) return null;
  if (picked != HistoryRange.custom) return RangeFilter(picked);
  final now = DateTime.now();
  final dates = await showDateRangePicker(
    context: context,
    firstDate: DateTime(now.year - 2),
    lastDate: now,
    initialDateRange: current.custom,
    helpText: 'Pick dates',
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.pink,
          onPrimary: Colors.white,
          surface: Color(0xFF16142C),
          onSurface: Colors.white,
        ),
      ),
      child: child!,
    ),
  );
  return dates == null ? null : RangeFilter(HistoryRange.custom, dates);
}

/// "Today" · 3 calls
class DayHeader extends StatelessWidget {
  const DayHeader(this.day, {super.key, this.trailing});
  final DateTime day;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
    child: Row(
      children: [
        Text(
          dayHeader(day),
          style: AppText.body(
            13.5,
            weight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(trailing!, style: AppText.body(12.5, color: AppColors.hint)),
      ],
    ),
  );
}

/// Empty / error card used by both histories.
class HistoryMessage extends StatelessWidget {
  const HistoryMessage({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.action,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String? body, action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      children: [
        Icon(icon, color: AppColors.lilac, size: 36),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppText.body(15, weight: FontWeight.w700),
        ),
        if (body != null) ...[
          const SizedBox(height: 4),
          Text(
            body!,
            textAlign: TextAlign.center,
            style: AppText.body(13, color: AppColors.textSecondary),
          ),
        ],
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

/// "Show more" at the end of a page.
class ShowMore extends StatelessWidget {
  const ShowMore({super.key, required this.loading, required this.onTap});
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Center(
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.pink,
                ),
              ),
            )
          : TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.expand_more_rounded),
              label: const Text('Show more'),
            ),
    ),
  );
}
