//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionLevel {
  /// Returns a new [CompanionLevel] instance.
  CompanionLevel({
    required this.level,
    required this.name,
    required this.minHours,
    required this.minRating,
    required this.boostPct,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int level;

  String name;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minHours;

  num minRating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int boostPct;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionLevel &&
    other.level == level &&
    other.name == name &&
    other.minHours == minHours &&
    other.minRating == minRating &&
    other.boostPct == boostPct;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level.hashCode) +
    (name.hashCode) +
    (minHours.hashCode) +
    (minRating.hashCode) +
    (boostPct.hashCode);

  @override
  String toString() => 'CompanionLevel[level=$level, name=$name, minHours=$minHours, minRating=$minRating, boostPct=$boostPct]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'level'] = this.level;
      json[r'name'] = this.name;
      json[r'minHours'] = this.minHours;
      json[r'minRating'] = this.minRating;
      json[r'boostPct'] = this.boostPct;
    return json;
  }

  /// Returns a new [CompanionLevel] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionLevel? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'), 'Required key "CompanionLevel[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "CompanionLevel[level]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "CompanionLevel[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CompanionLevel[name]" has a null value in JSON.');
        assert(json.containsKey(r'minHours'), 'Required key "CompanionLevel[minHours]" is missing from JSON.');
        assert(json[r'minHours'] != null, 'Required key "CompanionLevel[minHours]" has a null value in JSON.');
        assert(json.containsKey(r'minRating'), 'Required key "CompanionLevel[minRating]" is missing from JSON.');
        assert(json[r'minRating'] != null, 'Required key "CompanionLevel[minRating]" has a null value in JSON.');
        assert(json.containsKey(r'boostPct'), 'Required key "CompanionLevel[boostPct]" is missing from JSON.');
        assert(json[r'boostPct'] != null, 'Required key "CompanionLevel[boostPct]" has a null value in JSON.');
        return true;
      }());

      return CompanionLevel(
        level: mapValueOfType<int>(json, r'level')!,
        name: mapValueOfType<String>(json, r'name')!,
        minHours: mapValueOfType<int>(json, r'minHours')!,
        minRating: num.parse('${json[r'minRating']}'),
        boostPct: mapValueOfType<int>(json, r'boostPct')!,
      );
    }
    return null;
  }

  static List<CompanionLevel> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionLevel>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionLevel.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionLevel> mapFromJson(dynamic json) {
    final map = <String, CompanionLevel>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionLevel.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionLevel-objects as value to a dart map
  static Map<String, List<CompanionLevel>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionLevel>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionLevel.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'name',
    'minHours',
    'minRating',
    'boostPct',
  };
}

