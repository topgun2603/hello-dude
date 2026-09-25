import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/features/companion/callers_tab.dart';
import 'package:pesu_api/api.dart';

OnlineCaller caller({bool pay = true, bool vip = true, bool isNew = true, int calls = 3}) => OnlineCaller(
  id: 'c1',
  badge: null,
  level: 4,
  levelName: 'Chatter',
  displayName: 'Karthikeyan Subramaniam',
  avatarId: 2,
  language: 'ta',
  canPay: pay,
  isVip: vip,
  isNew: isNew,
  inCall: false,
  callsWithYou: calls,
  lastCallAt: DateTime.now().subtract(const Duration(days: 2)),
  favouritedYou: true,
  invitedRecently: false,
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('caller rows fit with every badge at $size', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = size.width / 360;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              CallerRow(caller: caller(), invited: false, busy: false, onInvite: () {}),
              CallerRow(caller: caller(pay: false, vip: false, isNew: false, calls: 0), invited: true, busy: false, onInvite: null),
            ],
          ),
        ),
      ));
      await t.pump();
      expect(t.takeException(), isNull);
      expect(find.text('Invite'), findsOneWidget);
      expect(find.text('Invited'), findsOneWidget);
      expect(find.text('Ready to call'), findsOneWidget);
      expect(find.textContaining('Talked 3×'), findsOneWidget);
      expect(find.text("Hasn't talked with you yet"), findsOneWidget);
    });
  }
}
