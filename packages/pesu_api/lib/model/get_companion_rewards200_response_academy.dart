//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCompanionRewards200ResponseAcademy {
  /// Returns a new [GetCompanionRewards200ResponseAcademy] instance.
  GetCompanionRewards200ResponseAcademy({
    required this.passed,
    required this.total,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int passed;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int total;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCompanionRewards200ResponseAcademy &&
    other.passed == passed &&
    other.total == total;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (passed.hashCode) +
    (total.hashCode);

  @override
  String toString() => 'GetCompanionRewards200ResponseAcademy[passed=$passed, total=$total]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'passed'] = this.passed;
      json[r'total'] = this.total;
    return json;
  }

  /// Returns a new [GetCompanionRewards200ResponseAcademy] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCompanionRewards200ResponseAcademy? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'passed'), 'Required key "GetCompanionRewards200ResponseAcademy[passed]" is missing from JSON.');
        assert(json[r'passed'] != null, 'Required key "GetCompanionRewards200ResponseAcademy[passed]" has a null value in JSON.');
        assert(json.containsKey(r'total'), 'Required key "GetCompanionRewards200ResponseAcademy[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "GetCompanionRewards200ResponseAcademy[total]" has a null value in JSON.');
        return true;
      }());

      return GetCompanionRewards200ResponseAcademy(
        passed: mapValueOfType<int>(json, r'passed')!,
        total: mapValueOfType<int>(json, r'total')!,
      );
    }
    return null;
  }

  static List<GetCompanionRewards200ResponseAcademy> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCompanionRewards200ResponseAcademy>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCompanionRewards200ResponseAcademy.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCompanionRewards200ResponseAcademy> mapFromJson(dynamic json) {
    final map = <String, GetCompanionRewards200ResponseAcademy>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCompanionRewards200ResponseAcademy.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCompanionRewards200ResponseAcademy-objects as value to a dart map
  static Map<String, List<GetCompanionRewards200ResponseAcademy>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCompanionRewards200ResponseAcademy>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCompanionRewards200ResponseAcademy.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'passed',
    'total',
  };
}

