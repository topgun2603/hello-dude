import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesu/app/router.dart' show callerPaths, companionPaths, routeAllowed;
import 'package:pesu/features/group/group_data.dart';
import 'package:pesu_api/api.dart';

GroupCard card(GroupCardStatusEnum status, {GroupCardMySeatEnum seat = GroupCardMySeatEnum.none, int members = 2, DateTime? at}) =>
    GroupCard(
      id: 'g1',
      title: 'A really long evening hangout title in Tamil',
      language: 'ta',
      status: status,
      host: GroupCardHost(id: 'h1', displayName: 'Priyadharshini Ramasamy', avatarId: 1, photoUrl: null, rating: 4.8, isFavourite: false),
      scheduledAt: at,
      startedAt: null,
      members: members,
      minMembers: 3,
      maxMembers: 10,
      coinsPerMin: 12,
      mySeat: seat,
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('group routes are allowed for the right role', () {
    expect(routeAllowed(callerPaths, '/groups'), isTrue);
    expect(routeAllowed(callerPaths, '/group'), isTrue);
    expect(routeAllowed(companionPaths, '/group-host'), isTrue);
    expect(routeAllowed(companionPaths, '/group'), isFalse);
  });

  test('schedule labels', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 20, 30);
    expect(groupWhen(today), 'Today 8:30 PM');
    expect(groupWhen(today.add(const Duration(days: 1))), 'Tomorrow 8:30 PM');
  });

  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('group tiles fit and show the right action at $size', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = size.width / 360;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              GroupTile(g: card(GroupCardStatusEnum.live), busy: false, onJoin: () {}, onSeat: () {}),
              GroupTile(g: card(GroupCardStatusEnum.lobby, seat: GroupCardMySeatEnum.joined), busy: false, onJoin: () {}, onSeat: () {}),
              GroupTile(
                g: card(GroupCardStatusEnum.scheduled, at: DateTime.now().add(const Duration(days: 3))),
                busy: false,
                onJoin: () {},
                onSeat: () {},
              ),
              GroupTile(g: card(GroupCardStatusEnum.live, members: 10), busy: false, onJoin: () {}, onSeat: () {}),
            ],
          ),
        ),
      ));
      expect(t.takeException(), isNull);
      expect(find.text('Join'), findsOneWidget);
      expect(find.text('Back in'), findsOneWidget);
      expect(find.text('Book seat'), findsOneWidget);
      expect(find.text('Full'), findsOneWidget);
      expect(find.textContaining('12 coins/min', findRichText: true), findsNWidgets(4));
    });
  }
}
