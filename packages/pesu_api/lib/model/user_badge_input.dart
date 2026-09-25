//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class UserBadgeInput {
  /// Returns a new [UserBadgeInput] instance.
  UserBadgeInput({
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
  bool operator ==(Object other) => identical(this, other) || other is UserBadgeInput &&
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
  String toString() => 'UserBadgeInput[label=$label, rank=$rank, kind=$kind]';

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

  /// Returns a new [UserBadgeInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserBadgeInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'label'), 'Required key "UserBadgeInput[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "UserBadgeInput[label]" has a null value in JSON.');
        assert(json.containsKey(r'rank'), 'Required key "UserBadgeInput[rank]" is missing from JSON.');
        assert(json.containsKey(r'kind'), 'Required key "UserBadgeInput[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "UserBadgeInput[kind]" has a null value in JSON.');
        return true;
      }());

      return UserBadgeInput(
        label: mapValueOfType<String>(json, r'label')!,
        rank: mapValueOfType<int>(json, r'rank'),
        kind: mapValueOfType<String>(json, r'kind')!,
      );
    }
    return null;
  }

  static List<UserBadgeInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserBadgeInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserBadgeInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserBadgeInput> mapFromJson(dynamic json) {
    final map = <String, UserBadgeInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserBadgeInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserBadgeInput-objects as value to a dart map
  static Map<String, List<UserBadgeInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserBadgeInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserBadgeInput.listFromJson(entry.value, growable: growable,);
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

