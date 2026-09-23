import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/growth/checkin_screen.dart';
import 'package:pesu/features/growth/referral_screen.dart';
import 'package:pesu/features/growth/share_card_screen.dart';
import 'package:pesu_api/api.dart';

CheckIn checkIn({required int day, bool claimed = false}) {
  const coins = [2, 2, 3, 3, 5, 5, 10];
  return CheckIn(
    day: day,
    claimedToday: claimed,
    todayCoins: coins[day - 1],
    streak: day - 1,
    days: [
      for (var i = 1; i <= 7; i++)
        CheckInDaysInner(
          day: i,
          coins: coins[i - 1],
          state: i < day
              ? CheckInDaysInnerStateEnum.claimed
              : i == day
              ? (claimed ? CheckInDaysInnerStateEnum.claimed : CheckInDaysInnerStateEnum.today)
              : CheckInDaysInnerStateEnum.upcoming,
        ),
    ],
  );
}

Future<void> pumpAt(WidgetTester tester, Size size, Widget child, List<Override> overrides) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = size.width / 360;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(overrides: overrides, child: MaterialApp(home: child)));
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('daily bonus: 7-day ladder, Day 4 streak, claim button at $size', (tester) async {
      await pumpAt(tester, size, const CheckInScreen(), [checkInProvider.overrideWith((ref) async => checkIn(day: 4))]);
      expect(tester.takeException(), isNull);
      expect(find.text('3-day streak!'), findsOneWidget);
      expect(find.text('Claim 3 coins'), findsOneWidget);
      expect(find.text('+10'), findsOneWidget);
      expect(find.text('Day 7'), findsOneWidget);
    });

    testWidgets('invite friends shows the code, reward and steps at $size', (tester) async {
      await pumpAt(tester, size, const ReferralScreen(), [
        referralProvider.overrideWith((ref) async => GetReferral200Response(
            code: 'KARTHIK50', link: 'https://hellodude.app/r/KARTHIK50', referrerCoins: 50, refereeCoins: 50,
            joined: 3, rewarded: 2, coinsEarned: 100)),
      ]);
      expect(tester.takeException(), isNull);
      expect(find.text('KARTHIK50'), findsOneWidget);
      expect(find.text('Friends joined'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('After their first recharge'), findsOneWidget);
    });

    testWidgets('share card never shows who, only minutes, language and code at $size', (tester) async {
      await pumpAt(tester, size, const ShareCardScreen(), [
        shareCardProvider.overrideWith((ref) async => GetShareCard200Response(
            todayMinutes: 32, language: 'ta', code: 'KARTHIK50', link: 'https://hellodude.app/r/KARTHIK50', refereeCoins: 50)),
      ]);
      expect(tester.takeException(), isNull);
      expect(find.text('32 min'), findsOneWidget);
      expect(find.text('of good conversation in Tamil today'), findsOneWidget);
      expect(find.textContaining('KARTHIK50'), findsWidgets);
      expect(find.text('Copy link'), findsOneWidget);
    });
  }

  testWidgets('already claimed today disables the button', (tester) async {
    await pumpAt(tester, const Size(1080, 2412), const CheckInScreen(),
        [checkInProvider.overrideWith((ref) async => checkIn(day: 2, claimed: true))]);
    expect(find.text('Claimed today ✓'), findsOneWidget);
  });
}
