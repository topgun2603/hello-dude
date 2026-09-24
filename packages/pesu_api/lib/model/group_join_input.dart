//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupJoinInput {
  /// Returns a new [GroupJoinInput] instance.
  GroupJoinInput({
    required this.group,
    required this.room,
    required this.minutes,
    required this.coinsLeft,
  });

  GroupCardInput group;

  /// Set once the group is live — connect with camera and mic on
  GroupRoomInput? room;

  /// Minutes you've paid for in this group
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsLeft;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupJoinInput &&
    other.group == group &&
    other.room == room &&
    other.minutes == minutes &&
    other.coinsLeft == coinsLeft;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (group.hashCode) +
    (room == null ? 0 : room!.hashCode) +
    (minutes.hashCode) +
    (coinsLeft.hashCode);

  @override
  String toString() => 'GroupJoinInput[group=$group, room=$room, minutes=$minutes, coinsLeft=$coinsLeft]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'group'] = this.group;
    if (this.room != null) {
      json[r'room'] = this.room;
    } else {
      json[r'room'] = null;
    }
      json[r'minutes'] = this.minutes;
      json[r'coinsLeft'] = this.coinsLeft;
    return json;
  }

  /// Returns a new [GroupJoinInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupJoinInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'group'), 'Required key "GroupJoinInput[group]" is missing from JSON.');
        assert(json[r'group'] != null, 'Required key "GroupJoinInput[group]" has a null value in JSON.');
        assert(json.containsKey(r'room'), 'Required key "GroupJoinInput[room]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "GroupJoinInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "GroupJoinInput[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coinsLeft'), 'Required key "GroupJoinInput[coinsLeft]" is missing from JSON.');
        assert(json[r'coinsLeft'] != null, 'Required key "GroupJoinInput[coinsLeft]" has a null value in JSON.');
        return true;
      }());

      return GroupJoinInput(
        group: GroupCardInput.fromJson(json[r'group'])!,
        room: GroupRoomInput.fromJson(json[r'room']),
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coinsLeft: mapValueOfType<int>(json, r'coinsLeft')!,
      );
    }
    return null;
  }

  static List<GroupJoinInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupJoinInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupJoinInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupJoinInput> mapFromJson(dynamic json) {
    final map = <String, GroupJoinInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupJoinInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupJoinInput-objects as value to a dart map
  static Map<String, List<GroupJoinInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupJoinInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupJoinInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'group',
    'room',
    'minutes',
    'coinsLeft',
  };
}

