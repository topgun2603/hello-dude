//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomJoin {
  /// Returns a new [RoomJoin] instance.
  RoomJoin({
    required this.room,
    required this.liveKitUrl,
    required this.token,
    required this.livekitRoom,
  });

  RoomState room;

  String liveKitUrl;

  String token;

  String livekitRoom;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomJoin &&
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
  String toString() => 'RoomJoin[room=$room, liveKitUrl=$liveKitUrl, token=$token, livekitRoom=$livekitRoom]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'room'] = this.room;
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'token'] = this.token;
      json[r'livekitRoom'] = this.livekitRoom;
    return json;
  }

  /// Returns a new [RoomJoin] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomJoin? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'room'), 'Required key "RoomJoin[room]" is missing from JSON.');
        assert(json[r'room'] != null, 'Required key "RoomJoin[room]" has a null value in JSON.');
        assert(json.containsKey(r'liveKitUrl'), 'Required key "RoomJoin[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "RoomJoin[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "RoomJoin[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "RoomJoin[token]" has a null value in JSON.');
        assert(json.containsKey(r'livekitRoom'), 'Required key "RoomJoin[livekitRoom]" is missing from JSON.');
        assert(json[r'livekitRoom'] != null, 'Required key "RoomJoin[livekitRoom]" has a null value in JSON.');
        return true;
      }());

      return RoomJoin(
        room: RoomState.fromJson(json[r'room'])!,
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        token: mapValueOfType<String>(json, r'token')!,
        livekitRoom: mapValueOfType<String>(json, r'livekitRoom')!,
      );
    }
    return null;
  }

  static List<RoomJoin> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomJoin>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomJoin.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomJoin> mapFromJson(dynamic json) {
    final map = <String, RoomJoin>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomJoin.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomJoin-objects as value to a dart map
  static Map<String, List<RoomJoin>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomJoin>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomJoin.listFromJson(entry.value, growable: growable,);
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

