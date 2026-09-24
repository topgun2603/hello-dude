//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendRoomGiftRequest {
  /// Returns a new [SendRoomGiftRequest] instance.
  SendRoomGiftRequest({
    required this.giftId,
    required this.toUserId,
    required this.clientRef,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftId;

  String toUserId;

  String clientRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendRoomGiftRequest &&
    other.giftId == giftId &&
    other.toUserId == toUserId &&
    other.clientRef == clientRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (giftId.hashCode) +
    (toUserId.hashCode) +
    (clientRef.hashCode);

  @override
  String toString() => 'SendRoomGiftRequest[giftId=$giftId, toUserId=$toUserId, clientRef=$clientRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'giftId'] = this.giftId;
      json[r'toUserId'] = this.toUserId;
      json[r'clientRef'] = this.clientRef;
    return json;
  }

  /// Returns a new [SendRoomGiftRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendRoomGiftRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'giftId'), 'Required key "SendRoomGiftRequest[giftId]" is missing from JSON.');
        assert(json[r'giftId'] != null, 'Required key "SendRoomGiftRequest[giftId]" has a null value in JSON.');
        assert(json.containsKey(r'toUserId'), 'Required key "SendRoomGiftRequest[toUserId]" is missing from JSON.');
        assert(json[r'toUserId'] != null, 'Required key "SendRoomGiftRequest[toUserId]" has a null value in JSON.');
        assert(json.containsKey(r'clientRef'), 'Required key "SendRoomGiftRequest[clientRef]" is missing from JSON.');
        assert(json[r'clientRef'] != null, 'Required key "SendRoomGiftRequest[clientRef]" has a null value in JSON.');
        return true;
      }());

      return SendRoomGiftRequest(
        giftId: mapValueOfType<int>(json, r'giftId')!,
        toUserId: mapValueOfType<String>(json, r'toUserId')!,
        clientRef: mapValueOfType<String>(json, r'clientRef')!,
      );
    }
    return null;
  }

  static List<SendRoomGiftRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendRoomGiftRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendRoomGiftRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendRoomGiftRequest> mapFromJson(dynamic json) {
    final map = <String, SendRoomGiftRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendRoomGiftRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendRoomGiftRequest-objects as value to a dart map
  static Map<String, List<SendRoomGiftRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendRoomGiftRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendRoomGiftRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'giftId',
    'toUserId',
    'clientRef',
  };
}

