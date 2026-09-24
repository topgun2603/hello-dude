//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupRoomInput {
  /// Returns a new [GroupRoomInput] instance.
  GroupRoomInput({
    required this.liveKitUrl,
    required this.livekitRoom,
    required this.token,
  });

  String liveKitUrl;

  String livekitRoom;

  String token;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupRoomInput &&
    other.liveKitUrl == liveKitUrl &&
    other.livekitRoom == livekitRoom &&
    other.token == token;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (liveKitUrl.hashCode) +
    (livekitRoom.hashCode) +
    (token.hashCode);

  @override
  String toString() => 'GroupRoomInput[liveKitUrl=$liveKitUrl, livekitRoom=$livekitRoom, token=$token]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'livekitRoom'] = this.livekitRoom;
      json[r'token'] = this.token;
    return json;
  }

  /// Returns a new [GroupRoomInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupRoomInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'liveKitUrl'), 'Required key "GroupRoomInput[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "GroupRoomInput[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'livekitRoom'), 'Required key "GroupRoomInput[livekitRoom]" is missing from JSON.');
        assert(json[r'livekitRoom'] != null, 'Required key "GroupRoomInput[livekitRoom]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "GroupRoomInput[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "GroupRoomInput[token]" has a null value in JSON.');
        return true;
      }());

      return GroupRoomInput(
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        livekitRoom: mapValueOfType<String>(json, r'livekitRoom')!,
        token: mapValueOfType<String>(json, r'token')!,
      );
    }
    return null;
  }

  static List<GroupRoomInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupRoomInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupRoomInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupRoomInput> mapFromJson(dynamic json) {
    final map = <String, GroupRoomInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupRoomInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupRoomInput-objects as value to a dart map
  static Map<String, List<GroupRoomInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupRoomInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupRoomInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'liveKitUrl',
    'livekitRoom',
    'token',
  };
}

