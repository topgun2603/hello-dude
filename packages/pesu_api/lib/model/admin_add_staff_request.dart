//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAddStaffRequest {
  /// Returns a new [AdminAddStaffRequest] instance.
  AdminAddStaffRequest({
    required this.phone,
    required this.name,
    required this.roleCode,
  });

  String phone;

  String name;

  String roleCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAddStaffRequest &&
    other.phone == phone &&
    other.name == name &&
    other.roleCode == roleCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (phone.hashCode) +
    (name.hashCode) +
    (roleCode.hashCode);

  @override
  String toString() => 'AdminAddStaffRequest[phone=$phone, name=$name, roleCode=$roleCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'phone'] = this.phone;
      json[r'name'] = this.name;
      json[r'roleCode'] = this.roleCode;
    return json;
  }

  /// Returns a new [AdminAddStaffRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAddStaffRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'phone'), 'Required key "AdminAddStaffRequest[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminAddStaffRequest[phone]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminAddStaffRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminAddStaffRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'roleCode'), 'Required key "AdminAddStaffRequest[roleCode]" is missing from JSON.');
        assert(json[r'roleCode'] != null, 'Required key "AdminAddStaffRequest[roleCode]" has a null value in JSON.');
        return true;
      }());

      return AdminAddStaffRequest(
        phone: mapValueOfType<String>(json, r'phone')!,
        name: mapValueOfType<String>(json, r'name')!,
        roleCode: mapValueOfType<String>(json, r'roleCode')!,
      );
    }
    return null;
  }

  static List<AdminAddStaffRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAddStaffRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAddStaffRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAddStaffRequest> mapFromJson(dynamic json) {
    final map = <String, AdminAddStaffRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAddStaffRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAddStaffRequest-objects as value to a dart map
  static Map<String, List<AdminAddStaffRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAddStaffRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAddStaffRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'phone',
    'name',
    'roleCode',
  };
}

