import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/notifications/notifications_screen.dart';
import 'package:pesu_api/api.dart';

NotificationItem item(int id, NotificationItemTypeEnum type, String title, DateTime at, {bool read = false}) =>
    NotificationItem(id: id, type: type, title: title, body: 'body $id', data: const {}, read: read, createdAt: at);

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, 12);

  test('groups into Today / Yesterday / Earlier and labels times like the design', () {
    final items = [
      item(3, NotificationItemTypeEnum.favouriteOnline, 'a', now.subtract(const Duration(minutes: 2))),
      item(2, NotificationItemTypeEnum.rateCall, 'b', today.subtract(const Duration(days: 1))),
      item(1, NotificationItemTypeEnum.refundDecided, 'c', today.subtract(const Duration(days: 5))),
    ];
    expect(groupByDay(items, now).map((g) => (g.$1, g.$2.length)).toList(), [('Today', 1), ('Yesterday', 1), ('Earlier', 1)]);
    expect(timeLabel(now.subtract(const Duration(minutes: 2)), now), '2 min');
    expect(timeLabel(DateTime(now.year, now.month, now.day).subtract(const Duration(hours: 2, minutes: 20)), now), '9:40 PM');
  });

  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('inbox renders rows, Call button and unread dots at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = size.width / 360;
      addTearDown(tester.view.reset);
      final data = ListNotifications200Response(unread: 1, items: [
        item(2, NotificationItemTypeEnum.favouriteOnline, 'Priya is online now', now),
        item(1, NotificationItemTypeEnum.refundDecided, 'Refund approved', today.subtract(const Duration(days: 1)), read: true),
      ]);
      await tester.pumpWidget(ProviderScope(
        overrides: [notificationsProvider.overrideWith((ref) async => data)],
        child: const MaterialApp(home: NotificationsScreen()),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('YESTERDAY'), findsOneWidget);
      expect(find.text('Priya is online now'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Read all'), findsOneWidget);
    });
  }

  testWidgets('empty inbox explains what will show up', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [notificationsProvider.overrideWith((ref) async => ListNotifications200Response(unread: 0, items: []))],
      child: const MaterialApp(home: NotificationsScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('No notifications yet'), findsOneWidget);
    expect(find.text('Read all'), findsNothing);
  });
}
