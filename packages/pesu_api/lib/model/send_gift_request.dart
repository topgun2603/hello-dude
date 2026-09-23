//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendGiftRequest {
  /// Returns a new [SendGiftRequest] instance.
  SendGiftRequest({
    required this.giftId,
    required this.clientRef,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftId;

  String clientRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendGiftRequest &&
    other.giftId == giftId &&
    other.clientRef == clientRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (giftId.hashCode) +
    (clientRef.hashCode);

  @override
  String toString() => 'SendGiftRequest[giftId=$giftId, clientRef=$clientRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'giftId'] = this.giftId;
      json[r'clientRef'] = this.clientRef;
    return json;
  }

  /// Returns a new [SendGiftRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendGiftRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'giftId'), 'Required key "SendGiftRequest[giftId]" is missing from JSON.');
        assert(json[r'giftId'] != null, 'Required key "SendGiftRequest[giftId]" has a null value in JSON.');
        assert(json.containsKey(r'clientRef'), 'Required key "SendGiftRequest[clientRef]" is missing from JSON.');
        assert(json[r'clientRef'] != null, 'Required key "SendGiftRequest[clientRef]" has a null value in JSON.');
        return true;
      }());

      return SendGiftRequest(
        giftId: mapValueOfType<int>(json, r'giftId')!,
        clientRef: mapValueOfType<String>(json, r'clientRef')!,
      );
    }
    return null;
  }

  static List<SendGiftRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendGiftRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendGiftRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendGiftRequest> mapFromJson(dynamic json) {
    final map = <String, SendGiftRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendGiftRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendGiftRequest-objects as value to a dart map
  static Map<String, List<SendGiftRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendGiftRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendGiftRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'giftId',
    'clientRef',
  };
}

