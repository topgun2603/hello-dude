//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminModerationFlagInputSubject {
  /// Returns a new [AdminModerationFlagInputSubject] instance.
  AdminModerationFlagInputSubject({
    required this.id,
    required this.displayName,
    required this.role,
    required this.status,
    required this.flags,
  });

  String id;

  String displayName;

  String role;

  String status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int flags;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminModerationFlagInputSubject &&
    other.id == id &&
    other.displayName == displayName &&
    other.role == role &&
    other.status == status &&
    other.flags == flags;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (flags.hashCode);

  @override
  String toString() => 'AdminModerationFlagInputSubject[id=$id, displayName=$displayName, role=$role, status=$status, flags=$flags]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'flags'] = this.flags;
    return json;
  }

  /// Returns a new [AdminModerationFlagInputSubject] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminModerationFlagInputSubject? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminModerationFlagInputSubject[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminModerationFlagInputSubject[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminModerationFlagInputSubject[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminModerationFlagInputSubject[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminModerationFlagInputSubject[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminModerationFlagInputSubject[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminModerationFlagInputSubject[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminModerationFlagInputSubject[status]" has a null value in JSON.');
        assert(json.containsKey(r'flags'), 'Required key "AdminModerationFlagInputSubject[flags]" is missing from JSON.');
        assert(json[r'flags'] != null, 'Required key "AdminModerationFlagInputSubject[flags]" has a null value in JSON.');
        return true;
      }());

      return AdminModerationFlagInputSubject(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        role: mapValueOfType<String>(json, r'role')!,
        status: mapValueOfType<String>(json, r'status')!,
        flags: mapValueOfType<int>(json, r'flags')!,
      );
    }
    return null;
  }

  static List<AdminModerationFlagInputSubject> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagInputSubject>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagInputSubject.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminModerationFlagInputSubject> mapFromJson(dynamic json) {
    final map = <String, AdminModerationFlagInputSubject>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminModerationFlagInputSubject.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminModerationFlagInputSubject-objects as value to a dart map
  static Map<String, List<AdminModerationFlagInputSubject>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminModerationFlagInputSubject>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminModerationFlagInputSubject.listFromJson(entry.value, growable: growable,);
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
    'flags',
  };
}

