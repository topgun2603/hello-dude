import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/rooms/rooms_screens.dart';
import 'package:pesu_api/api.dart';

RoomCard card(String id, String title, int listeners) => RoomCard(
  id: id,
  title: title,
  category: 'movies',
  categoryName: 'Movies',
  language: 'ta',
  host: RoomCardHost(id: 'h$id', displayName: 'Priya', avatarId: 1),
  listeners: listeners,
  faces: [
    RoomCardHost(id: 'h$id', displayName: 'Priya', avatarId: 1),
    RoomCardHost(id: 'a', displayName: 'Arun', avatarId: 2),
  ],
  createdAt: DateTime.now(),
);

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets('voice rooms list: categories, featured card, Join at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = size.width / 360;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            roomCategoriesProvider.overrideWith(
              (ref) async => [
                ListLanguages200ResponseInner(code: 'movies', name: 'Movies'),
                ListLanguages200ResponseInner(code: 'music', name: 'Music'),
              ],
            ),
            roomsProvider(null).overrideWith(
              (ref) async => [
                card('1', 'Tamil movie talk', 86),
                card('2', "Can't sleep? Just talk", 27),
              ],
            ),
          ],
          child: const MaterialApp(home: RoomsScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Voice rooms'), findsOneWidget);
      expect(find.text('Tamil movie talk'), findsOneWidget);
      expect(find.text('86 listening'), findsOneWidget);
      expect(find.text('Join'), findsNWidgets(2));
      expect(find.text('Music'), findsOneWidget);
    });
  }
}
