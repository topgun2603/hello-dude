//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupHeartbeat200Response {
  /// Returns a new [GroupHeartbeat200Response] instance.
  GroupHeartbeat200Response({
    required this.group,
    required this.minutes,
  });

  GroupCard group;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupHeartbeat200Response &&
    other.group == group &&
    other.minutes == minutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (group.hashCode) +
    (minutes.hashCode);

  @override
  String toString() => 'GroupHeartbeat200Response[group=$group, minutes=$minutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'group'] = this.group;
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [GroupHeartbeat200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupHeartbeat200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'group'), 'Required key "GroupHeartbeat200Response[group]" is missing from JSON.');
        assert(json[r'group'] != null, 'Required key "GroupHeartbeat200Response[group]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "GroupHeartbeat200Response[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "GroupHeartbeat200Response[minutes]" has a null value in JSON.');
        return true;
      }());

      return GroupHeartbeat200Response(
        group: GroupCard.fromJson(json[r'group'])!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
      );
    }
    return null;
  }

  static List<GroupHeartbeat200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupHeartbeat200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupHeartbeat200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupHeartbeat200Response> mapFromJson(dynamic json) {
    final map = <String, GroupHeartbeat200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupHeartbeat200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupHeartbeat200Response-objects as value to a dart map
  static Map<String, List<GroupHeartbeat200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupHeartbeat200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupHeartbeat200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'group',
    'minutes',
  };
}

