import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/features/home/coin_shop.dart';

CoinPack pack(
  String sku,
  int coins,
  int paise, {
  int bonus = 0,
  String? label,
  bool welcome = false,
}) => CoinPack(
  sku: sku,
  coins: coins,
  bonusCoins: bonus,
  pricePaise: paise,
  label: label,
  firstRecharge: welcome,
  offerEndsAt: welcome ? DateTime.now().add(const Duration(hours: 5)) : null,
);

// The default packs from db/migrations/0004_default_prices.sql.
final regular = [
  pack('coins_50', 50, 4900),
  pack('coins_120', 120, 9900),
  pack('coins_300', 300, 23900, label: 'Popular'),
  pack('coins_650', 650, 49900, bonus: 65, label: '+10% bonus'),
  pack('coins_1400', 1400, 99900),
  pack('coins_3000', 3000, 199900, label: 'Best value'),
];
final welcome = pack(
  'first_recharge_100',
  100,
  4900,
  bonus: 100,
  label: 'Welcome offer',
  welcome: true,
);

Future<List<String>> pump(
  WidgetTester t,
  List<CoinPack> packs,
  Size size,
) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = size.width / 360;
  addTearDown(t.view.reset);
  final bought = <String>[];
  await t.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: CoinShop(packs: packs, onBuy: (p) => bought.add(p.sku)),
        ),
      ),
    ),
  );
  await t.pump();
  return bought;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('prices use Indian grouping; bigger packs show their savings', () {
    expect(rupeesLabel(4900), '₹49');
    expect(rupeesLabel(199900), '₹1,999');
    expect(rupeesLabel(12345678), '₹1,23,456.78');
    expect(savingsPct(regular.last, regular), 32); // ₹0.67 vs ₹0.98 a coin
    expect(savingsPct(regular.first, regular), 0);
  });

  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('pick a pack, then buy it — no overflow at $size', (t) async {
      final bought = await pump(t, regular, size);
      expect(t.takeException(), isNull);
      // "Popular" is picked by default.
      expect(find.text('Add 300 coins · ₹239'), findsOneWidget);
      expect(find.text('Save 32%'), findsOneWidget);
      expect(find.text('+65 free'), findsOneWidget);

      await t.tap(find.text('3,000'));
      await t.pumpAndSettle();
      await t.tap(find.text('Add 3,000 coins · ₹1,999'));
      expect(bought, ['coins_3000']);
    });
  }

  testWidgets('the welcome offer is featured and picked first', (t) async {
    final bought = await pump(t, [welcome, ...regular], const Size(720, 1280));
    expect(t.takeException(), isNull);
    expect(find.textContaining('WELCOME OFFER'), findsOneWidget);
    expect(find.textContaining('Ends in'), findsOneWidget);
    await t.ensureVisible(find.text('Add 200 coins · ₹49'));
    await t.pumpAndSettle();
    await t.tap(find.text('Add 200 coins · ₹49'));
    expect(bought, ['first_recharge_100']);
  });
}
