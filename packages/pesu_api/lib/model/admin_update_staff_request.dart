//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateStaffRequest {
  /// Returns a new [AdminUpdateStaffRequest] instance.
  AdminUpdateStaffRequest({
    this.roleCode,
    this.active,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? roleCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? active;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateStaffRequest &&
    other.roleCode == roleCode &&
    other.active == active;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (roleCode == null ? 0 : roleCode!.hashCode) +
    (active == null ? 0 : active!.hashCode);

  @override
  String toString() => 'AdminUpdateStaffRequest[roleCode=$roleCode, active=$active]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.roleCode != null) {
      json[r'roleCode'] = this.roleCode;
    } else {
      json[r'roleCode'] = null;
    }
    if (this.active != null) {
      json[r'active'] = this.active;
    } else {
      json[r'active'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUpdateStaffRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateStaffRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return AdminUpdateStaffRequest(
        roleCode: mapValueOfType<String>(json, r'roleCode'),
        active: mapValueOfType<bool>(json, r'active'),
      );
    }
    return null;
  }

  static List<AdminUpdateStaffRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateStaffRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateStaffRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateStaffRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateStaffRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateStaffRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateStaffRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateStaffRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateStaffRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateStaffRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

