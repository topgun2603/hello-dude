//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseActivityInnerUser {
  /// Returns a new [AdminDashboard200ResponseActivityInnerUser] instance.
  AdminDashboard200ResponseActivityInnerUser({
    required this.id,
    required this.displayName,
    required this.role,
    required this.avatarId,
  });

  String id;

  String displayName;

  String role;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseActivityInnerUser &&
    other.id == id &&
    other.displayName == displayName &&
    other.role == role &&
    other.avatarId == avatarId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (role.hashCode) +
    (avatarId.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseActivityInnerUser[id=$id, displayName=$displayName, role=$role, avatarId=$avatarId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'role'] = this.role;
      json[r'avatarId'] = this.avatarId;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseActivityInnerUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseActivityInnerUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminDashboard200ResponseActivityInnerUser[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminDashboard200ResponseActivityInnerUser[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminDashboard200ResponseActivityInnerUser[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminDashboard200ResponseActivityInnerUser[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminDashboard200ResponseActivityInnerUser[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminDashboard200ResponseActivityInnerUser[role]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminDashboard200ResponseActivityInnerUser[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminDashboard200ResponseActivityInnerUser[avatarId]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseActivityInnerUser(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        role: mapValueOfType<String>(json, r'role')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseActivityInnerUser> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseActivityInnerUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseActivityInnerUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseActivityInnerUser> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseActivityInnerUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseActivityInnerUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseActivityInnerUser-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseActivityInnerUser>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseActivityInnerUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseActivityInnerUser.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'role',
    'avatarId',
  };
}

