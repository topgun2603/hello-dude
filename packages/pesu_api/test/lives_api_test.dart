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


/// tests for LivesApi
void main() {
  // final instance = LivesApi();

  group('tests for LivesApi', () {
    // Buy (or extend) a watch pass with coins. Safe to retry with the same clientRef.
    //
    //Future<BuyLivePass201Response> buyLivePass(String id, BuyLivePassRequest buyLivePassRequest) async
    test('test buyLivePass', () async {
      // TODO
    });

    // Host: end the live
    //
    //Future<String> endLive(String id) async
    test('test endLive', () async {
      // TODO
    });

    // A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)
    //
    //Future<FlagVideoFrame201Response> flagLiveFrame(String id, FlagLiveFrameRequest flagLiveFrameRequest) async
    test('test flagLiveFrame', () async {
      // TODO
    });

    // Watch: a free preview the first time, or your pass. 402 PASS_REQUIRED when both are used up.
    //
    //Future<LiveJoin> joinLive(String id) async
    test('test joinLive', () async {
      // TODO
    });

    // Viewer: stop watching
    //
    //Future<String> leaveLive(String id) async
    test('test leaveLive', () async {
      // TODO
    });

    // Live now (favourites first, then the busiest), with pass prices
    //
    //Future<ListLives200Response> listLives({ String language }) async
    test('test listLives', () async {
      // TODO
    });

    // Viewer: still watching (every 20 s). Returns your access.
    //
    //Future<LiveAccess> liveHeartbeat(String id) async
    test('test liveHeartbeat', () async {
      // TODO
    });

    // Host: still live (every 15 s). Returns viewers and what this live has earned.
    //
    //Future<LiveHostHeartbeat200Response> liveHostHeartbeat(String id) async
    test('test liveHostHeartbeat', () async {
      // TODO
    });

    // Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
    //
    //Future<SendRoomGift201Response> sendLiveGift(String id, SendGiftRequest sendGiftRequest) async
    test('test sendLiveGift', () async {
      // TODO
    });

    // Chat (pass holders and the host; safety-filtered; one message every 2 s)
    //
    //Future<String> sendLiveMessage(String id, SendRoomMessageRequest sendRoomMessageRequest) async
    test('test sendLiveMessage', () async {
      // TODO
    });

    // Send a reaction (anyone watching)
    //
    //Future<String> sendLiveReaction(String id, SendRoomReactionRequest sendRoomReactionRequest) async
    test('test sendLiveReaction', () async {
      // TODO
    });

    // Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.
    //
    //Future<LiveJoin> startLive(StartLiveRequest startLiveRequest) async
    test('test startLive', () async {
      // TODO
    });

  });
}
