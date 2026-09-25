//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetMyLevel200ResponseNext {
  /// Returns a new [GetMyLevel200ResponseNext] instance.
  GetMyLevel200ResponseNext({
    required this.level,
    required this.name,
    required this.minCoins,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int level;

  String name;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minCoins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetMyLevel200ResponseNext &&
    other.level == level &&
    other.name == name &&
    other.minCoins == minCoins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level.hashCode) +
    (name.hashCode) +
    (minCoins.hashCode);

  @override
  String toString() => 'GetMyLevel200ResponseNext[level=$level, name=$name, minCoins=$minCoins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'level'] = this.level;
      json[r'name'] = this.name;
      json[r'minCoins'] = this.minCoins;
    return json;
  }

  /// Returns a new [GetMyLevel200ResponseNext] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetMyLevel200ResponseNext? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'), 'Required key "GetMyLevel200ResponseNext[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "GetMyLevel200ResponseNext[level]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "GetMyLevel200ResponseNext[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "GetMyLevel200ResponseNext[name]" has a null value in JSON.');
        assert(json.containsKey(r'minCoins'), 'Required key "GetMyLevel200ResponseNext[minCoins]" is missing from JSON.');
        assert(json[r'minCoins'] != null, 'Required key "GetMyLevel200ResponseNext[minCoins]" has a null value in JSON.');
        return true;
      }());

      return GetMyLevel200ResponseNext(
        level: mapValueOfType<int>(json, r'level')!,
        name: mapValueOfType<String>(json, r'name')!,
        minCoins: mapValueOfType<int>(json, r'minCoins')!,
      );
    }
    return null;
  }

  static List<GetMyLevel200ResponseNext> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetMyLevel200ResponseNext>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetMyLevel200ResponseNext.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetMyLevel200ResponseNext> mapFromJson(dynamic json) {
    final map = <String, GetMyLevel200ResponseNext>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetMyLevel200ResponseNext.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetMyLevel200ResponseNext-objects as value to a dart map
  static Map<String, List<GetMyLevel200ResponseNext>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetMyLevel200ResponseNext>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetMyLevel200ResponseNext.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'name',
    'minCoins',
  };
}

