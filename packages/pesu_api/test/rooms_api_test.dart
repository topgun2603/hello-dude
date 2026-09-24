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


/// tests for RoomsApi
void main() {
  // final instance = RoomsApi();

  group('tests for RoomsApi', () {
    // Current stage and members
    //
    //Future<RoomState> getRoom(String id) async
    test('test getRoom', () async {
      // TODO
    });

    // Join as a listener (free). Rejoining keeps your role.
    //
    //Future<RoomJoin> joinRoom(String id) async
    test('test joinRoom', () async {
      // TODO
    });

    // Leave. When the host leaves, the room ends.
    //
    //Future<String> leaveRoom(String id) async
    test('test leaveRoom', () async {
      // TODO
    });

    // Room categories (All + these)
    //
    //Future<List<ListLanguages200ResponseInner>> listRoomCategories() async
    test('test listRoomCategories', () async {
      // TODO
    });

    // Live rooms, biggest first (optionally one category / language)
    //
    //Future<List<RoomCard>> listRooms({ String category, String language }) async
    test('test listRooms', () async {
      // TODO
    });

    // Raise or lower your hand to speak
    //
    //Future<String> raiseHand(String id, RaiseHandRequest raiseHandRequest) async
    test('test raiseHand', () async {
      // TODO
    });

    // Still here (every 30 s)
    //
    //Future<String> roomHeartbeat(String id) async
    test('test roomHeartbeat', () async {
      // TODO
    });

    // A fresh LiveKit token for your current role (after moving on/off stage)
    //
    //Future<RoomToken200Response> roomToken(String id) async
    test('test roomToken', () async {
      // TODO
    });

    // Send a gift to a companion on stage (same prices and companion share as call gifts)
    //
    //Future<SendRoomGift201Response> sendRoomGift(String id, SendRoomGiftRequest sendRoomGiftRequest) async
    test('test sendRoomGift', () async {
      // TODO
    });

    // Say something in the room feed (safety-filtered; one message every 2 s)
    //
    //Future<String> sendRoomMessage(String id, SendRoomMessageRequest sendRoomMessageRequest) async
    test('test sendRoomMessage', () async {
      // TODO
    });

    // Send a reaction
    //
    //Future<String> sendRoomReaction(String id, SendRoomReactionRequest sendRoomReactionRequest) async
    test('test sendRoomReaction', () async {
      // TODO
    });

    // Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.
    //
    //Future<RoomState> setRoomStage(String id, String userId, SetRoomStageRequest setRoomStageRequest) async
    test('test setRoomStage', () async {
      // TODO
    });

    // Start a room (approved companions; one live room at a time)
    //
    //Future<RoomJoin> startRoom(StartRoomRequest startRoomRequest) async
    test('test startRoom', () async {
      // TODO
    });

  });
}
