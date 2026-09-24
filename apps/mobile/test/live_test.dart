import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/features/live/live_data.dart';
import 'package:pesu_api/api.dart';

LiveCard live(String id, String name) => LiveCard(
  id: id,
  title: 'Evening chat',
  language: 'ta',
  host: LiveCardHost(id: 'h$id', displayName: name, avatarId: 1, photoUrl: null, rating: 4.8, languages: const ['ta'], isFavourite: false),
  viewers: 12,
  startedAt: DateTime(2026, 9, 24, 20),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('countdown text', () {
    expect(clockLeft(const Duration(seconds: 7)), '0:07');
    expect(clockLeft(const Duration(minutes: 14, seconds: 32)), '14:32');
    expect(clockLeft(const Duration(hours: 1, minutes: 2, seconds: 3)), '1:02:03');
    expect(clockLeft(const Duration(seconds: -5)), '0:00');
  });

  Future<void> pumpRow(WidgetTester t, List<LiveCard> lives) async {
    t.view.physicalSize = const Size(720, 1280);
    t.view.devicePixelRatio = 2;
    addTearDown(t.view.reset);
    await t.pumpWidget(ProviderScope(
      overrides: [
        livesProvider.overrideWith((ref) async => ListLives200Response(
              lives: lives,
              pricing: LivePricing(previewSeconds: 10, coinsPerMin: 3),
            )),
      ],
      child: const MaterialApp(home: Scaffold(body: LiveNowRow())),
    ));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));
  }

  testWidgets('Live now row lists who is live, without overflow', (t) async {
    await pumpRow(t, [live('1', 'Priya'), live('2', 'Divya Lakshmi Narayanan')]);
    expect(find.text('Live now'), findsOneWidget);
    expect(find.text('Priya'), findsOneWidget);
    expect(find.text('LIVE'), findsWidgets);
    expect(t.takeException(), isNull);
  });

  testWidgets('when nobody is live, a small card says so (Live stays discoverable)', (t) async {
    await pumpRow(t, []);
    expect(find.text('Live now'), findsNothing);
    expect(find.textContaining('Nobody is live right now'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
