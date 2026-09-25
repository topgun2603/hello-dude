//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallerLevelInput {
  /// Returns a new [CallerLevelInput] instance.
  CallerLevelInput({
    required this.level,
    required this.name,
    required this.minCoins,
    required this.perk,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int level;

  String name;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minCoins;

  String? perk;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallerLevelInput &&
    other.level == level &&
    other.name == name &&
    other.minCoins == minCoins &&
    other.perk == perk;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level.hashCode) +
    (name.hashCode) +
    (minCoins.hashCode) +
    (perk == null ? 0 : perk!.hashCode);

  @override
  String toString() => 'CallerLevelInput[level=$level, name=$name, minCoins=$minCoins, perk=$perk]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'level'] = this.level;
      json[r'name'] = this.name;
      json[r'minCoins'] = this.minCoins;
    if (this.perk != null) {
      json[r'perk'] = this.perk;
    } else {
      json[r'perk'] = null;
    }
    return json;
  }

  /// Returns a new [CallerLevelInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallerLevelInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'), 'Required key "CallerLevelInput[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "CallerLevelInput[level]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "CallerLevelInput[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CallerLevelInput[name]" has a null value in JSON.');
        assert(json.containsKey(r'minCoins'), 'Required key "CallerLevelInput[minCoins]" is missing from JSON.');
        assert(json[r'minCoins'] != null, 'Required key "CallerLevelInput[minCoins]" has a null value in JSON.');
        assert(json.containsKey(r'perk'), 'Required key "CallerLevelInput[perk]" is missing from JSON.');
        return true;
      }());

      return CallerLevelInput(
        level: mapValueOfType<int>(json, r'level')!,
        name: mapValueOfType<String>(json, r'name')!,
        minCoins: mapValueOfType<int>(json, r'minCoins')!,
        perk: mapValueOfType<String>(json, r'perk'),
      );
    }
    return null;
  }

  static List<CallerLevelInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallerLevelInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallerLevelInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallerLevelInput> mapFromJson(dynamic json) {
    final map = <String, CallerLevelInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallerLevelInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallerLevelInput-objects as value to a dart map
  static Map<String, List<CallerLevelInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallerLevelInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallerLevelInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'name',
    'minCoins',
    'perk',
  };
}

