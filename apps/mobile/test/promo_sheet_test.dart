import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/promotions/promo_sheet.dart';
import 'package:pesu_api/api.dart';

Promotion promo({
  PromotionCtaActionEnum action = PromotionCtaActionEnum.wallet,
  DateTime? endsAt,
}) => Promotion(
  id: 1,
  title: 'Double coins weekend',
  body: 'Every pack gives 2× coins until Sunday.',
  highlight: '2× coins',
  badge: 'Weekend only',
  emoji: '🎉',
  ctaLabel: 'Grab it',
  ctaAction: action,
  theme: PromotionThemeEnum.brand,
  confetti: true,
  endsAt: endsAt,
);

/// Opens the sheet from a button and records what it popped with.
Future<List<bool?>> open(WidgetTester t, Promotion p) async {
  final results = <bool?>[];
  await t.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => results.add(
              await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => PromoSheet(promo: p),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await t.tap(find.text('open'));
  await t.pumpAndSettle();
  return results;
}

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets(
      'shows the offer, a countdown, and the button pops true at $size',
      (t) async {
        t.view.physicalSize = size;
        t.view.devicePixelRatio = 2.5;
        addTearDown(t.view.reset);
        final results = await open(
          t,
          promo(endsAt: DateTime.now().add(const Duration(hours: 5))),
        );
        expect(find.text('2× coins'), findsOneWidget);
        expect(find.text('Double coins weekend'), findsOneWidget);
        expect(find.text('WEEKEND ONLY'), findsOneWidget);
        expect(find.textContaining('left'), findsOneWidget);
        expect(t.takeException(), isNull); // no overflow
        await t.tap(find.text('Grab it'));
        await t.pumpAndSettle();
        expect(results, [true]);
      },
    );
  }

  testWidgets(
    '"Not now" pops false; a button with no destination just closes',
    (t) async {
      var results = await open(t, promo());
      await t.tap(find.text('Not now'));
      await t.pumpAndSettle();
      expect(results, [false]);

      results = await open(t, promo(action: PromotionCtaActionEnum.none));
      expect(find.text('Not now'), findsNothing);
      await t.tap(find.text('Grab it'));
      await t.pumpAndSettle();
      expect(results, [false]);
    },
  );
}
