//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminStaff {
  /// Returns a new [AdminStaff] instance.
  AdminStaff({
    required this.id,
    required this.displayName,
    required this.phone,
    required this.roleCode,
    required this.roleName,
    required this.active,
    required this.isMe,
    required this.createdAt,
    required this.lastSignInAt,
  });

  String id;

  String displayName;

  /// Masked
  String phone;

  String roleCode;

  String roleName;

  bool active;

  bool isMe;

  DateTime createdAt;

  DateTime? lastSignInAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminStaff &&
    other.id == id &&
    other.displayName == displayName &&
    other.phone == phone &&
    other.roleCode == roleCode &&
    other.roleName == roleName &&
    other.active == active &&
    other.isMe == isMe &&
    other.createdAt == createdAt &&
    other.lastSignInAt == lastSignInAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (phone.hashCode) +
    (roleCode.hashCode) +
    (roleName.hashCode) +
    (active.hashCode) +
    (isMe.hashCode) +
    (createdAt.hashCode) +
    (lastSignInAt == null ? 0 : lastSignInAt!.hashCode);

  @override
  String toString() => 'AdminStaff[id=$id, displayName=$displayName, phone=$phone, roleCode=$roleCode, roleName=$roleName, active=$active, isMe=$isMe, createdAt=$createdAt, lastSignInAt=$lastSignInAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'roleCode'] = this.roleCode;
      json[r'roleName'] = this.roleName;
      json[r'active'] = this.active;
      json[r'isMe'] = this.isMe;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.lastSignInAt != null) {
      json[r'lastSignInAt'] = this.lastSignInAt!.toUtc().toIso8601String();
    } else {
      json[r'lastSignInAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminStaff] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminStaff? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminStaff[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminStaff[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminStaff[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminStaff[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminStaff[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminStaff[phone]" has a null value in JSON.');
        assert(json.containsKey(r'roleCode'), 'Required key "AdminStaff[roleCode]" is missing from JSON.');
        assert(json[r'roleCode'] != null, 'Required key "AdminStaff[roleCode]" has a null value in JSON.');
        assert(json.containsKey(r'roleName'), 'Required key "AdminStaff[roleName]" is missing from JSON.');
        assert(json[r'roleName'] != null, 'Required key "AdminStaff[roleName]" has a null value in JSON.');
        assert(json.containsKey(r'active'), 'Required key "AdminStaff[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "AdminStaff[active]" has a null value in JSON.');
        assert(json.containsKey(r'isMe'), 'Required key "AdminStaff[isMe]" is missing from JSON.');
        assert(json[r'isMe'] != null, 'Required key "AdminStaff[isMe]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminStaff[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminStaff[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'lastSignInAt'), 'Required key "AdminStaff[lastSignInAt]" is missing from JSON.');
        return true;
      }());

      return AdminStaff(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        roleCode: mapValueOfType<String>(json, r'roleCode')!,
        roleName: mapValueOfType<String>(json, r'roleName')!,
        active: mapValueOfType<bool>(json, r'active')!,
        isMe: mapValueOfType<bool>(json, r'isMe')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        lastSignInAt: mapDateTime(json, r'lastSignInAt', r''),
      );
    }
    return null;
  }

  static List<AdminStaff> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminStaff>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminStaff.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminStaff> mapFromJson(dynamic json) {
    final map = <String, AdminStaff>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminStaff.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminStaff-objects as value to a dart map
  static Map<String, List<AdminStaff>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminStaff>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminStaff.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'phone',
    'roleCode',
    'roleName',
    'active',
    'isMe',
    'createdAt',
    'lastSignInAt',
  };
}

