//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class UserBadge {
  /// Returns a new [UserBadge] instance.
  UserBadge({
    required this.label,
    required this.rank,
    required this.kind,
  });

  String label;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? rank;

  String kind;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserBadge &&
    other.label == label &&
    other.rank == rank &&
    other.kind == kind;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (rank == null ? 0 : rank!.hashCode) +
    (kind.hashCode);

  @override
  String toString() => 'UserBadge[label=$label, rank=$rank, kind=$kind]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
    if (this.rank != null) {
      json[r'rank'] = this.rank;
    } else {
      json[r'rank'] = null;
    }
      json[r'kind'] = this.kind;
    return json;
  }

  /// Returns a new [UserBadge] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserBadge? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'label'), 'Required key "UserBadge[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "UserBadge[label]" has a null value in JSON.');
        assert(json.containsKey(r'rank'), 'Required key "UserBadge[rank]" is missing from JSON.');
        assert(json.containsKey(r'kind'), 'Required key "UserBadge[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "UserBadge[kind]" has a null value in JSON.');
        return true;
      }());

      return UserBadge(
        label: mapValueOfType<String>(json, r'label')!,
        rank: mapValueOfType<int>(json, r'rank'),
        kind: mapValueOfType<String>(json, r'kind')!,
      );
    }
    return null;
  }

  static List<UserBadge> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserBadge>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserBadge.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserBadge> mapFromJson(dynamic json) {
    final map = <String, UserBadge>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserBadge.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserBadge-objects as value to a dart map
  static Map<String, List<UserBadge>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserBadge>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserBadge.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'rank',
    'kind',
  };
}

