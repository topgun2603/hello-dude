//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:pesu_api/api.dart';
import 'package:test/test.dart';


/// tests for ChatApi
void main() {
  // final instance = ChatApi();

  group('tests for ChatApi', () {
    // The thread: messages and calls between you, newest first (page with ?before=<ISO time>)
    //
    //Future<GetChatMessages200Response> getChatMessages(String id, { Object before, int limit }) async
    test('test getChatMessages', () async {
      // TODO
    });

    // My conversations, most recent first, with unread counts
    //
    //Future<ListChats200Response> listChats() async
    test('test listChats', () async {
      // TODO
    });

    // Mark the conversation read up to now
    //
    //Future<String> markChatRead(String id) async
    test('test markChatRead', () async {
      // TODO
    });

    // Open the chat with someone (created on first use). Needs a connected call between you and no blocks.
    //
    //Future<Conversation> openChat(String userId) async
    test('test openChat', () async {
      // TODO
    });

    // Send a message. Phone numbers, UPI IDs and payment or contact-app requests are refused (MESSAGE_BLOCKED).
    //
    //Future<ChatItem> sendChatMessage(String id, SendChatMessageRequest sendChatMessageRequest) async
    test('test sendChatMessage', () async {
      // TODO
    });

  });
}
