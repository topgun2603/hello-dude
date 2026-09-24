//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateCompanionLevelRequest {
  /// Returns a new [AdminUpdateCompanionLevelRequest] instance.
  AdminUpdateCompanionLevelRequest({
    required this.name,
    required this.minHours,
    required this.minRating,
    required this.boostPct,
  });

  String name;

  /// Minimum value: 0
  /// Maximum value: 744
  int minHours;

  /// Minimum value: 0
  /// Maximum value: 5
  num minRating;

  /// Minimum value: 0
  /// Maximum value: 50
  int boostPct;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateCompanionLevelRequest &&
    other.name == name &&
    other.minHours == minHours &&
    other.minRating == minRating &&
    other.boostPct == boostPct;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (minHours.hashCode) +
    (minRating.hashCode) +
    (boostPct.hashCode);

  @override
  String toString() => 'AdminUpdateCompanionLevelRequest[name=$name, minHours=$minHours, minRating=$minRating, boostPct=$boostPct]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'minHours'] = this.minHours;
      json[r'minRating'] = this.minRating;
      json[r'boostPct'] = this.boostPct;
    return json;
  }

  /// Returns a new [AdminUpdateCompanionLevelRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateCompanionLevelRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminUpdateCompanionLevelRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminUpdateCompanionLevelRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'minHours'), 'Required key "AdminUpdateCompanionLevelRequest[minHours]" is missing from JSON.');
        assert(json[r'minHours'] != null, 'Required key "AdminUpdateCompanionLevelRequest[minHours]" has a null value in JSON.');
        assert(json.containsKey(r'minRating'), 'Required key "AdminUpdateCompanionLevelRequest[minRating]" is missing from JSON.');
        assert(json[r'minRating'] != null, 'Required key "AdminUpdateCompanionLevelRequest[minRating]" has a null value in JSON.');
        assert(json.containsKey(r'boostPct'), 'Required key "AdminUpdateCompanionLevelRequest[boostPct]" is missing from JSON.');
        assert(json[r'boostPct'] != null, 'Required key "AdminUpdateCompanionLevelRequest[boostPct]" has a null value in JSON.');
        return true;
      }());

      return AdminUpdateCompanionLevelRequest(
        name: mapValueOfType<String>(json, r'name')!,
        minHours: mapValueOfType<int>(json, r'minHours')!,
        minRating: num.parse('${json[r'minRating']}'),
        boostPct: mapValueOfType<int>(json, r'boostPct')!,
      );
    }
    return null;
  }

  static List<AdminUpdateCompanionLevelRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateCompanionLevelRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateCompanionLevelRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateCompanionLevelRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateCompanionLevelRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateCompanionLevelRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateCompanionLevelRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateCompanionLevelRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateCompanionLevelRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateCompanionLevelRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'minHours',
    'minRating',
    'boostPct',
  };
}

