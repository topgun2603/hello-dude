//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomJoinInput {
  /// Returns a new [RoomJoinInput] instance.
  RoomJoinInput({
    required this.room,
    required this.liveKitUrl,
    required this.token,
    required this.livekitRoom,
  });

  RoomStateInput room;

  String liveKitUrl;

  String token;

  String livekitRoom;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomJoinInput &&
    other.room == room &&
    other.liveKitUrl == liveKitUrl &&
    other.token == token &&
    other.livekitRoom == livekitRoom;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (room.hashCode) +
    (liveKitUrl.hashCode) +
    (token.hashCode) +
    (livekitRoom.hashCode);

  @override
  String toString() => 'RoomJoinInput[room=$room, liveKitUrl=$liveKitUrl, token=$token, livekitRoom=$livekitRoom]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'room'] = this.room;
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'token'] = this.token;
      json[r'livekitRoom'] = this.livekitRoom;
    return json;
  }

  /// Returns a new [RoomJoinInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomJoinInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'room'), 'Required key "RoomJoinInput[room]" is missing from JSON.');
        assert(json[r'room'] != null, 'Required key "RoomJoinInput[room]" has a null value in JSON.');
        assert(json.containsKey(r'liveKitUrl'), 'Required key "RoomJoinInput[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "RoomJoinInput[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "RoomJoinInput[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "RoomJoinInput[token]" has a null value in JSON.');
        assert(json.containsKey(r'livekitRoom'), 'Required key "RoomJoinInput[livekitRoom]" is missing from JSON.');
        assert(json[r'livekitRoom'] != null, 'Required key "RoomJoinInput[livekitRoom]" has a null value in JSON.');
        return true;
      }());

      return RoomJoinInput(
        room: RoomStateInput.fromJson(json[r'room'])!,
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        token: mapValueOfType<String>(json, r'token')!,
        livekitRoom: mapValueOfType<String>(json, r'livekitRoom')!,
      );
    }
    return null;
  }

  static List<RoomJoinInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomJoinInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomJoinInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomJoinInput> mapFromJson(dynamic json) {
    final map = <String, RoomJoinInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomJoinInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomJoinInput-objects as value to a dart map
  static Map<String, List<RoomJoinInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomJoinInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomJoinInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'room',
    'liveKitUrl',
    'token',
    'livekitRoom',
  };
}

