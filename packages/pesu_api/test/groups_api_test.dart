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


/// tests for GroupsApi
void main() {
  // final instance = GroupsApi();

  group('tests for GroupsApi', () {
    // Book a free seat in a scheduled group (reminder 10 min before)
    //
    //Future<GroupCard> bookGroupSeat(String id) async
    test('test bookGroupSeat', () async {
      // TODO
    });

    // Give up a booked seat
    //
    //Future<String> cancelGroupSeat(String id) async
    test('test cancelGroupSeat', () async {
      // TODO
    });

    // Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; set it (within 7 days) to take seat bookings.
    //
    //Future<GroupHostState> createGroup(CreateGroupRequest createGroupRequest) async
    test('test createGroup', () async {
      // TODO
    });

    // Host: end (or cancel) the group
    //
    //Future<String> endGroup(String id) async
    test('test endGroup', () async {
      // TODO
    });

    // A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.
    //
    //Future<FlagVideoFrame201Response> flagGroupFrame(String id, FlagGroupFrameRequest flagGroupFrameRequest) async
    test('test flagGroupFrame', () async {
      // TODO
    });

    // Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.
    //
    //Future<GroupHeartbeat200Response> groupHeartbeat(String id) async
    test('test groupHeartbeat', () async {
      // TODO
    });

    // Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.
    //
    //Future<GroupHostState> groupHostHeartbeat(String id) async
    test('test groupHostHeartbeat', () async {
      // TODO
    });

    // Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.
    //
    //Future<GroupJoin> joinGroup(String id, JoinGroupRequest joinGroupRequest) async
    test('test joinGroup', () async {
      // TODO
    });

    // Member: leave (stops the per-minute charge)
    //
    //Future<String> leaveGroup(String id) async
    test('test leaveGroup', () async {
      // TODO
    });

    // Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.
    //
    //Future<ListGroups200Response> listGroups({ String language }) async
    test('test listGroups', () async {
      // TODO
    });

    // Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.
    //
    //Future<GroupHostState> openGroup(String id) async
    test('test openGroup', () async {
      // TODO
    });

    // Report someone in the group. The host can also remove them.
    //
    //Future<String> reportInGroup(String id, ReportInGroupRequest reportInGroupRequest) async
    test('test reportInGroup', () async {
      // TODO
    });

    // Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
    //
    //Future<SendRoomGift201Response> sendGroupGift(String id, SendGiftRequest sendGiftRequest) async
    test('test sendGroupGift', () async {
      // TODO
    });

    // Chat (members and the host; safety-filtered; one message every 2 s)
    //
    //Future<String> sendGroupMessage(String id, SendRoomMessageRequest sendRoomMessageRequest) async
    test('test sendGroupMessage', () async {
      // TODO
    });

    // Send a reaction
    //
    //Future<String> sendGroupReaction(String id, SendRoomReactionRequest sendRoomReactionRequest) async
    test('test sendGroupReaction', () async {
      // TODO
    });

  });
}
