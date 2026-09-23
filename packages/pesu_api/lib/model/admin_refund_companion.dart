//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRefundCompanion {
  /// Returns a new [AdminRefundCompanion] instance.
  AdminRefundCompanion({
    required this.id,
    required this.displayName,
  });

  String id;

  String displayName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRefundCompanion &&
    other.id == id &&
    other.displayName == displayName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode);

  @override
  String toString() => 'AdminRefundCompanion[id=$id, displayName=$displayName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
    return json;
  }

  /// Returns a new [AdminRefundCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRefundCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminRefundCompanion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminRefundCompanion[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminRefundCompanion[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminRefundCompanion[displayName]" has a null value in JSON.');
        return true;
      }());

      return AdminRefundCompanion(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
      );
    }
    return null;
  }

  static List<AdminRefundCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRefundCompanion> mapFromJson(dynamic json) {
    final map = <String, AdminRefundCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRefundCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRefundCompanion-objects as value to a dart map
  static Map<String, List<AdminRefundCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRefundCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRefundCompanion.listFromJson(entry.value, growable: growable,);
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

