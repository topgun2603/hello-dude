import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/chat/chat_screens.dart';
import 'package:pesu_api/api.dart';

void main() {
  for (final size in const [Size(1080, 2412), Size(720, 1280)]) {
    testWidgets(
      'messages list shows people, previews and unread counts at $size',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = size.width / 360;
        addTearDown(tester.view.reset);
        final data = ListChats200Response(
          unread: 2,
          items: [
            Conversation(
              id: 'c1',
              other: ConversationOther(
                id: 'u1',
                displayName: 'Priya',
                avatarId: 1,
                role: ConversationOtherRoleEnum.companion,
                online: true,
              ),
              lastMessage: 'Anytime! Take care and sleep well',
              lastMessageAt: DateTime.now(),
              unread: 2,
              canMessage: true,
            ),
          ],
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [chatsProvider.overrideWith((ref) async => data)],
            child: const MaterialApp(home: ChatsScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Priya'), findsOneWidget);
        expect(find.text('Anytime! Take care and sleep well'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      },
    );
  }

  testWidgets('empty messages explains when chat opens up', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatsProvider.overrideWith(
            (ref) async => ListChats200Response(unread: 0, items: []),
          ),
        ],
        child: const MaterialApp(home: ChatsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('After a call, you can keep talking here.'),
      findsOneWidget,
    );
  });
}
