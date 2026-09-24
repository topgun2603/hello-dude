import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/companion/rewards_screen.dart';
import 'package:pesu_api/api.dart';

GetCompanionRewards200Response rewards() => GetCompanionRewards200Response(
  level: CompanionLevel(
    level: 3,
    name: 'Rising star',
    minHours: 30,
    minRating: 4.3,
    boostPct: 3,
  ),
  next: CompanionLevel(
    level: 4,
    name: 'Star',
    minHours: 60,
    minRating: 4.5,
    boostPct: 5,
  ),
  monthHours: 42,
  rating: 4.7,
  ratingCount: 30,
  todayEarnedPaise: 18600,
  dailyGoalPaise: 30000,
  streakDays: 5,
  bonuses: [
    CompanionBonus(
      id: 1,
      title: 'Evening bonus',
      rewardPaise: 5000,
      requiredMinutes: 180,
      windowStart: 1200,
      windowEnd: 1380,
      doneMinutes: 80,
      status: CompanionBonusStatusEnum.active,
    ),
  ],
  academy: GetCompanionRewards200ResponseAcademy(passed: 3, total: 5),
  videoEnabled: false,
);

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets(
      'rewards: level, goal ring, streak, bonus and training link at $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = size.width / 360;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [rewardsProvider.overrideWith((ref) async => rewards())],
            child: const MaterialApp(home: RewardsScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Level 3 · Rising star'), findsOneWidget);
        expect(find.text('42 / 60 h'), findsOneWidget);
        expect(find.text('₹186'), findsOneWidget);
        expect(find.text('5 days'), findsOneWidget);
        expect(find.text('+₹50'), findsOneWidget);
        expect(
          find.text('Stay online 3 h between 8 PM and 11 PM today.'),
          findsOneWidget,
        );
        expect(find.text('1 h 20 m done'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Finish training to unlock video calls'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(
          find.text('Finish training to unlock video calls'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
