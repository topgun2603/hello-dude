import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/features/history/call_history.dart' show callLength;
import 'package:pesu/features/history/coin_history.dart';
import 'package:pesu/features/history/history_common.dart';
import 'package:pesu_api/api.dart';

CoinHistoryItem item(String key, CoinHistoryItemKindEnum kind, String title, int amount, DateTime at, {String? sub}) =>
    CoinHistoryItem(
      key: key,
      kind: kind,
      title: title,
      subtitle: sub,
      amount: amount,
      at: at,
      callId: null,
      callType: kind == CoinHistoryItemKindEnum.call ? CoinHistoryItemCallTypeEnum.audio : null,
      otherName: null,
      otherAvatarId: null,
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final now = DateTime(2026, 9, 24, 21, 30); // a Thursday

  test('day headers and clock times', () {
    expect(dayHeader(DateTime(2026, 9, 24, 8), now), 'Today');
    expect(dayHeader(DateTime(2026, 9, 23, 23, 59), now), 'Yesterday');
    expect(dayHeader(DateTime(2026, 9, 21), now), 'Mon, 21 Sep');
    expect(dayHeader(DateTime(2025, 12, 31), now), '31 Dec 2025');
    expect(clock(DateTime(2026, 9, 24, 0, 5)), '12:05 AM');
    expect(clock(DateTime(2026, 9, 24, 20, 42)), '8:42 PM');
    expect(callLength(45), '45s');
    expect(callLength(200), '3m 20s');
  });

  test('ranges: presets from local midnight; custom dates include the whole last day', () {
    expect(const RangeFilter(HistoryRange.all).bounds(now), (null, null));
    expect(const RangeFilter(HistoryRange.today).bounds(now), (DateTime(2026, 9, 24), null));
    expect(const RangeFilter(HistoryRange.week).bounds(now), (DateTime(2026, 9, 18), null));
    final custom = RangeFilter(HistoryRange.custom, DateTimeRange(start: DateTime(2026, 9, 1), end: DateTime(2026, 9, 3)));
    expect(custom.bounds(now), (DateTime(2026, 9, 1), DateTime(2026, 9, 4)));
    expect(custom.label, '1 Sep – 3 Sep');
  });

  test('groups consecutive items by local day', () {
    final groups = groupByDay(
      [DateTime(2026, 9, 24, 20), DateTime(2026, 9, 24, 9), DateTime(2026, 9, 22, 18)],
      (d) => d,
    );
    expect(groups.map((g) => (g.$1, g.$2.length)).toList(), [(DateTime(2026, 9, 24), 2), (DateTime(2026, 9, 22), 1)]);
  });

  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('spending summary and history rows fit at $size', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = size.width / 360;
      addTearDown(t.view.reset);
      final summary = CoinHistorySummary(
        spent: 1250, added: 2000, calls: 1000, gifts: 200,
        lives: 0, groups: 0, bookings: 50, purchases: 1500, bonuses: 400, refunds: 100,
      );
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SpendSummaryCard(summary, caption: 'Last 30 days'),
              CoinHistoryRow(item('call:1', CoinHistoryItemKindEnum.call, 'Voice call with Priyadharshini Ramanathan', -130, now, sub: '13 min')),
              CoinHistoryRow(item('l:2', CoinHistoryItemKindEnum.bonus, 'Daily bonus, Day 3', 3, now), showDate: true),
            ],
          ),
        ),
      ));
      expect(t.takeException(), isNull);
      expect(find.text('−1250 coins'), findsOneWidget);
      expect(find.text('+2000 coins'), findsOneWidget);
      expect(find.text('Calls 1000'), findsOneWidget);
      expect(find.text('−130'), findsOneWidget);
      expect(find.text('+3'), findsOneWidget);
    });
  }
}
