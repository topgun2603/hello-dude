//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupHostState {
  /// Returns a new [GroupHostState] instance.
  GroupHostState({
    required this.group,
    required this.room,
    required this.waiting,
    required this.earnedPaise,
    required this.paidMinutes,
  });

  GroupCard group;

  GroupRoom? room;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int waiting;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earnedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paidMinutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupHostState &&
    other.group == group &&
    other.room == room &&
    other.waiting == waiting &&
    other.earnedPaise == earnedPaise &&
    other.paidMinutes == paidMinutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (group.hashCode) +
    (room == null ? 0 : room!.hashCode) +
    (waiting.hashCode) +
    (earnedPaise.hashCode) +
    (paidMinutes.hashCode);

  @override
  String toString() => 'GroupHostState[group=$group, room=$room, waiting=$waiting, earnedPaise=$earnedPaise, paidMinutes=$paidMinutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'group'] = this.group;
    if (this.room != null) {
      json[r'room'] = this.room;
    } else {
      json[r'room'] = null;
    }
      json[r'waiting'] = this.waiting;
      json[r'earnedPaise'] = this.earnedPaise;
      json[r'paidMinutes'] = this.paidMinutes;
    return json;
  }

  /// Returns a new [GroupHostState] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupHostState? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'group'), 'Required key "GroupHostState[group]" is missing from JSON.');
        assert(json[r'group'] != null, 'Required key "GroupHostState[group]" has a null value in JSON.');
        assert(json.containsKey(r'room'), 'Required key "GroupHostState[room]" is missing from JSON.');
        assert(json.containsKey(r'waiting'), 'Required key "GroupHostState[waiting]" is missing from JSON.');
        assert(json[r'waiting'] != null, 'Required key "GroupHostState[waiting]" has a null value in JSON.');
        assert(json.containsKey(r'earnedPaise'), 'Required key "GroupHostState[earnedPaise]" is missing from JSON.');
        assert(json[r'earnedPaise'] != null, 'Required key "GroupHostState[earnedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "GroupHostState[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "GroupHostState[paidMinutes]" has a null value in JSON.');
        return true;
      }());

      return GroupHostState(
        group: GroupCard.fromJson(json[r'group'])!,
        room: GroupRoom.fromJson(json[r'room']),
        waiting: mapValueOfType<int>(json, r'waiting')!,
        earnedPaise: mapValueOfType<int>(json, r'earnedPaise')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
      );
    }
    return null;
  }

  static List<GroupHostState> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupHostState>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupHostState.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupHostState> mapFromJson(dynamic json) {
    final map = <String, GroupHostState>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupHostState.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupHostState-objects as value to a dart map
  static Map<String, List<GroupHostState>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupHostState>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupHostState.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'group',
    'room',
    'waiting',
    'earnedPaise',
    'paidMinutes',
  };
}

