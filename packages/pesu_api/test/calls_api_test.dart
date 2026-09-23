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


/// tests for CallsApi
void main() {
  // final instance = CallsApi();

  group('tests for CallsApi', () {
    // Companion answers a ringing call and gets their join token
    //
    //Future<JoinInfo> acceptCall(String id) async
    test('test acceptCall', () async {
      // TODO
    });

    // Hang up (either side). Safe to repeat.
    //
    //Future<CallSummary> endCall(String id) async
    test('test endCall', () async {
      // TODO
    });

    // Call details: every billed minute, refunds included
    //
    //Future<CallDetails> getCall(String id) async
    test('test getCall', () async {
      // TODO
    });

    // Call history, newest first. Page with `before` = createdAt of the last call seen.
    //
    //Future<ListCalls200Response> listCalls({ Object before, int limit }) async
    test('test listCalls', () async {
      // TODO
    });

    // Instant match: ring a free online companion who speaks the language
    //
    //Future<MatchCall201Response> matchCall(MatchCallRequest matchCallRequest) async
    test('test matchCall', () async {
      // TODO
    });

    // Rate a finished call (once)
    //
    //Future<String> rateCall(String id, RateCallRequest rateCallRequest) async
    test('test rateCall', () async {
      // TODO
    });

    //Future<String> rejectCall(String id) async
    test('test rejectCall', () async {
      // TODO
    });

    // Call a specific companion. Nothing is charged until both sides join.
    //
    //Future<JoinInfo> startCall(StartCallRequest startCallRequest) async
    test('test startCall', () async {
      // TODO
    });

  });
}
