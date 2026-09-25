//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendLiveGiftRequest {
  /// Returns a new [SendLiveGiftRequest] instance.
  SendLiveGiftRequest({
    required this.giftId,
    required this.clientRef,
    this.toHostId,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftId;

  String clientRef;

  /// PK battle: gift the other side's host
  String? toHostId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendLiveGiftRequest &&
    other.giftId == giftId &&
    other.clientRef == clientRef &&
    other.toHostId == toHostId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (giftId.hashCode) +
    (clientRef.hashCode) +
    (toHostId == null ? 0 : toHostId!.hashCode);

  @override
  String toString() => 'SendLiveGiftRequest[giftId=$giftId, clientRef=$clientRef, toHostId=$toHostId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'giftId'] = this.giftId;
      json[r'clientRef'] = this.clientRef;
    if (this.toHostId != null) {
      json[r'toHostId'] = this.toHostId;
    } else {
      json[r'toHostId'] = null;
    }
    return json;
  }

  /// Returns a new [SendLiveGiftRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendLiveGiftRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'giftId'), 'Required key "SendLiveGiftRequest[giftId]" is missing from JSON.');
        assert(json[r'giftId'] != null, 'Required key "SendLiveGiftRequest[giftId]" has a null value in JSON.');
        assert(json.containsKey(r'clientRef'), 'Required key "SendLiveGiftRequest[clientRef]" is missing from JSON.');
        assert(json[r'clientRef'] != null, 'Required key "SendLiveGiftRequest[clientRef]" has a null value in JSON.');
        return true;
      }());

      return SendLiveGiftRequest(
        giftId: mapValueOfType<int>(json, r'giftId')!,
        clientRef: mapValueOfType<String>(json, r'clientRef')!,
        toHostId: mapValueOfType<String>(json, r'toHostId'),
      );
    }
    return null;
  }

  static List<SendLiveGiftRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendLiveGiftRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendLiveGiftRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendLiveGiftRequest> mapFromJson(dynamic json) {
    final map = <String, SendLiveGiftRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendLiveGiftRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendLiveGiftRequest-objects as value to a dart map
  static Map<String, List<SendLiveGiftRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendLiveGiftRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendLiveGiftRequest.listFromJson(entry.value, growable: growable,);
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

