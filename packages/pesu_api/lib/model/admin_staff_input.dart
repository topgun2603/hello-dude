//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminStaffInput {
  /// Returns a new [AdminStaffInput] instance.
  AdminStaffInput({
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

  Object? createdAt;

  Object? lastSignInAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminStaffInput &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (lastSignInAt == null ? 0 : lastSignInAt!.hashCode);

  @override
  String toString() => 'AdminStaffInput[id=$id, displayName=$displayName, phone=$phone, roleCode=$roleCode, roleName=$roleName, active=$active, isMe=$isMe, createdAt=$createdAt, lastSignInAt=$lastSignInAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'roleCode'] = this.roleCode;
      json[r'roleName'] = this.roleName;
      json[r'active'] = this.active;
      json[r'isMe'] = this.isMe;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    if (this.lastSignInAt != null) {
      json[r'lastSignInAt'] = this.lastSignInAt;
    } else {
      json[r'lastSignInAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminStaffInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminStaffInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminStaffInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminStaffInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminStaffInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminStaffInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminStaffInput[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminStaffInput[phone]" has a null value in JSON.');
        assert(json.containsKey(r'roleCode'), 'Required key "AdminStaffInput[roleCode]" is missing from JSON.');
        assert(json[r'roleCode'] != null, 'Required key "AdminStaffInput[roleCode]" has a null value in JSON.');
        assert(json.containsKey(r'roleName'), 'Required key "AdminStaffInput[roleName]" is missing from JSON.');
        assert(json[r'roleName'] != null, 'Required key "AdminStaffInput[roleName]" has a null value in JSON.');
        assert(json.containsKey(r'active'), 'Required key "AdminStaffInput[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "AdminStaffInput[active]" has a null value in JSON.');
        assert(json.containsKey(r'isMe'), 'Required key "AdminStaffInput[isMe]" is missing from JSON.');
        assert(json[r'isMe'] != null, 'Required key "AdminStaffInput[isMe]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminStaffInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'lastSignInAt'), 'Required key "AdminStaffInput[lastSignInAt]" is missing from JSON.');
        return true;
      }());

      return AdminStaffInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        roleCode: mapValueOfType<String>(json, r'roleCode')!,
        roleName: mapValueOfType<String>(json, r'roleName')!,
        active: mapValueOfType<bool>(json, r'active')!,
        isMe: mapValueOfType<bool>(json, r'isMe')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        lastSignInAt: mapValueOfType<Object>(json, r'lastSignInAt'),
      );
    }
    return null;
  }

  static List<AdminStaffInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminStaffInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminStaffInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminStaffInput> mapFromJson(dynamic json) {
    final map = <String, AdminStaffInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminStaffInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminStaffInput-objects as value to a dart map
  static Map<String, List<AdminStaffInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminStaffInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminStaffInput.listFromJson(entry.value, growable: growable,);
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

