//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class MatchCall201Response {
  /// Returns a new [MatchCall201Response] instance.
  MatchCall201Response({
    required this.callId,
    required this.liveKitUrl,
    required this.room,
    required this.token,
    required this.coinsPerMin,
    required this.companion,
  });

  String callId;

  String liveKitUrl;

  String room;

  /// LiveKit join token for this user only
  String token;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  Party companion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MatchCall201Response &&
    other.callId == callId &&
    other.liveKitUrl == liveKitUrl &&
    other.room == room &&
    other.token == token &&
    other.coinsPerMin == coinsPerMin &&
    other.companion == companion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callId.hashCode) +
    (liveKitUrl.hashCode) +
    (room.hashCode) +
    (token.hashCode) +
    (coinsPerMin.hashCode) +
    (companion.hashCode);

  @override
  String toString() => 'MatchCall201Response[callId=$callId, liveKitUrl=$liveKitUrl, room=$room, token=$token, coinsPerMin=$coinsPerMin, companion=$companion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'callId'] = this.callId;
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'room'] = this.room;
      json[r'token'] = this.token;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'companion'] = this.companion;
    return json;
  }

  /// Returns a new [MatchCall201Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MatchCall201Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'callId'), 'Required key "MatchCall201Response[callId]" is missing from JSON.');
        assert(json[r'callId'] != null, 'Required key "MatchCall201Response[callId]" has a null value in JSON.');
        assert(json.containsKey(r'liveKitUrl'), 'Required key "MatchCall201Response[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "MatchCall201Response[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'room'), 'Required key "MatchCall201Response[room]" is missing from JSON.');
        assert(json[r'room'] != null, 'Required key "MatchCall201Response[room]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "MatchCall201Response[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "MatchCall201Response[token]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "MatchCall201Response[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "MatchCall201Response[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "MatchCall201Response[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "MatchCall201Response[companion]" has a null value in JSON.');
        return true;
      }());

      return MatchCall201Response(
        callId: mapValueOfType<String>(json, r'callId')!,
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        room: mapValueOfType<String>(json, r'room')!,
        token: mapValueOfType<String>(json, r'token')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        companion: Party.fromJson(json[r'companion'])!,
      );
    }
    return null;
  }

  static List<MatchCall201Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MatchCall201Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MatchCall201Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MatchCall201Response> mapFromJson(dynamic json) {
    final map = <String, MatchCall201Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MatchCall201Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MatchCall201Response-objects as value to a dart map
  static Map<String, List<MatchCall201Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MatchCall201Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MatchCall201Response.listFromJson(entry.value, growable: growable,);
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
    'companion',
  };
}

