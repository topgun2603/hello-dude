//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailReportsInnerOther {
  /// Returns a new [AdminUserDetailReportsInnerOther] instance.
  AdminUserDetailReportsInnerOther({
    required this.id,
    required this.displayName,
  });

  String? id;

  String displayName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailReportsInnerOther &&
    other.id == id &&
    other.displayName == displayName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (displayName.hashCode);

  @override
  String toString() => 'AdminUserDetailReportsInnerOther[id=$id, displayName=$displayName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'displayName'] = this.displayName;
    return json;
  }

  /// Returns a new [AdminUserDetailReportsInnerOther] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailReportsInnerOther? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailReportsInnerOther[id]" is missing from JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminUserDetailReportsInnerOther[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminUserDetailReportsInnerOther[displayName]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailReportsInnerOther(
        id: mapValueOfType<String>(json, r'id'),
        displayName: mapValueOfType<String>(json, r'displayName')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailReportsInnerOther> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailReportsInnerOther>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailReportsInnerOther.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailReportsInnerOther> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailReportsInnerOther>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailReportsInnerOther.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailReportsInnerOther-objects as value to a dart map
  static Map<String, List<AdminUserDetailReportsInnerOther>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailReportsInnerOther>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailReportsInnerOther.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
  };
}

