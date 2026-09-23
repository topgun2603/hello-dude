//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminReportInputReported {
  /// Returns a new [AdminReportInputReported] instance.
  AdminReportInputReported({
    required this.id,
    required this.displayName,
    required this.role,
    required this.status,
    required this.reportsAgainst,
  });

  String id;

  String displayName;

  String role;

  String status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reportsAgainst;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminReportInputReported &&
    other.id == id &&
    other.displayName == displayName &&
    other.role == role &&
    other.status == status &&
    other.reportsAgainst == reportsAgainst;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (reportsAgainst.hashCode);

  @override
  String toString() => 'AdminReportInputReported[id=$id, displayName=$displayName, role=$role, status=$status, reportsAgainst=$reportsAgainst]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'reportsAgainst'] = this.reportsAgainst;
    return json;
  }

  /// Returns a new [AdminReportInputReported] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminReportInputReported? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminReportInputReported[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminReportInputReported[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminReportInputReported[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminReportInputReported[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminReportInputReported[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminReportInputReported[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminReportInputReported[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminReportInputReported[status]" has a null value in JSON.');
        assert(json.containsKey(r'reportsAgainst'), 'Required key "AdminReportInputReported[reportsAgainst]" is missing from JSON.');
        assert(json[r'reportsAgainst'] != null, 'Required key "AdminReportInputReported[reportsAgainst]" has a null value in JSON.');
        return true;
      }());

      return AdminReportInputReported(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        role: mapValueOfType<String>(json, r'role')!,
        status: mapValueOfType<String>(json, r'status')!,
        reportsAgainst: mapValueOfType<int>(json, r'reportsAgainst')!,
      );
    }
    return null;
  }

  static List<AdminReportInputReported> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminReportInputReported>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminReportInputReported.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminReportInputReported> mapFromJson(dynamic json) {
    final map = <String, AdminReportInputReported>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminReportInputReported.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminReportInputReported-objects as value to a dart map
  static Map<String, List<AdminReportInputReported>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminReportInputReported>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminReportInputReported.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'role',
    'status',
    'reportsAgainst',
  };
}

