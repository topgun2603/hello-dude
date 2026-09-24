import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/vip/vip_screen.dart';
import 'package:pesu_api/api.dart';

GetVip200Response vip({required bool active}) => GetVip200Response(
  active: active,
  expiresAt: active ? DateTime(2026, 10, 23) : null,
  source_: null,
  discountPct: 10,
  weeklyGift: active
      ? GetVip200ResponseWeeklyGift(name: 'Rose', emoji: '🌹', used: false)
      : null,
  plans: [
    VipPlan(
      id: 1,
      sku: 'vip_monthly',
      months: 1,
      pricePaise: 29900,
      label: null,
      isActive: true,
      sortOrder: 1,
    ),
    VipPlan(
      id: 2,
      sku: 'vip_quarterly',
      months: 3,
      pricePaise: 69900,
      label: 'Best value',
      isActive: true,
      sortOrder: 2,
    ),
  ],
  purchasable: false,
);

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets(
      'VIP upsell: perks, two plans, purchase not open yet at $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = size.width / 360;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              vipProvider.overrideWith((ref) async => vip(active: false)),
            ],
            child: const MaterialApp(home: VipScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('10% off every call minute'), findsOneWidget);
        expect(find.text('Best value'), findsOneWidget);
        expect(find.text('₹299'), findsOneWidget);
        expect(find.text('VIP purchases open soon.'), findsOneWidget);
      },
    );
  }

  testWidgets('active VIP shows the end date and this week\'s Rose', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [vipProvider.overrideWith((ref) async => vip(active: true))],
        child: const MaterialApp(home: VipScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("You're VIP until 23 Oct 2026"), findsOneWidget);
    expect(find.textContaining('Your free Rose'), findsOneWidget);
    expect(find.text('Continue with Google Play'), findsNothing);
  });
}
