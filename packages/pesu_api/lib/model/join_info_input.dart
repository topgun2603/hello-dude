//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class JoinInfoInput {
  /// Returns a new [JoinInfoInput] instance.
  JoinInfoInput({
    required this.callId,
    required this.liveKitUrl,
    required this.room,
    required this.token,
    required this.coinsPerMin,
  });

  String callId;

  String liveKitUrl;

  String room;

  /// LiveKit join token for this user only
  String token;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JoinInfoInput &&
    other.callId == callId &&
    other.liveKitUrl == liveKitUrl &&
    other.room == room &&
    other.token == token &&
    other.coinsPerMin == coinsPerMin;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callId.hashCode) +
    (liveKitUrl.hashCode) +
    (room.hashCode) +
    (token.hashCode) +
    (coinsPerMin.hashCode);

  @override
  String toString() => 'JoinInfoInput[callId=$callId, liveKitUrl=$liveKitUrl, room=$room, token=$token, coinsPerMin=$coinsPerMin]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'callId'] = this.callId;
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'room'] = this.room;
      json[r'token'] = this.token;
      json[r'coinsPerMin'] = this.coinsPerMin;
    return json;
  }

  /// Returns a new [JoinInfoInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static JoinInfoInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'callId'), 'Required key "JoinInfoInput[callId]" is missing from JSON.');
        assert(json[r'callId'] != null, 'Required key "JoinInfoInput[callId]" has a null value in JSON.');
        assert(json.containsKey(r'liveKitUrl'), 'Required key "JoinInfoInput[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "JoinInfoInput[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'room'), 'Required key "JoinInfoInput[room]" is missing from JSON.');
        assert(json[r'room'] != null, 'Required key "JoinInfoInput[room]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "JoinInfoInput[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "JoinInfoInput[token]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "JoinInfoInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "JoinInfoInput[coinsPerMin]" has a null value in JSON.');
        return true;
      }());

      return JoinInfoInput(
        callId: mapValueOfType<String>(json, r'callId')!,
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        room: mapValueOfType<String>(json, r'room')!,
        token: mapValueOfType<String>(json, r'token')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
      );
    }
    return null;
  }

  static List<JoinInfoInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JoinInfoInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JoinInfoInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, JoinInfoInput> mapFromJson(dynamic json) {
    final map = <String, JoinInfoInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JoinInfoInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of JoinInfoInput-objects as value to a dart map
  static Map<String, List<JoinInfoInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<JoinInfoInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = JoinInfoInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'callId',
    'liveKitUrl',
    'room',
    'token',
    'coinsPerMin',
  };
}

