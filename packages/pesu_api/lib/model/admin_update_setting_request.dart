//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateSettingRequest {
  /// Returns a new [AdminUpdateSettingRequest] instance.
  AdminUpdateSettingRequest({
    required this.value,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateSettingRequest &&
    other.value == value;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (value.hashCode);

  @override
  String toString() => 'AdminUpdateSettingRequest[value=$value]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'value'] = this.value;
    return json;
  }

  /// Returns a new [AdminUpdateSettingRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateSettingRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'value'), 'Required key "AdminUpdateSettingRequest[value]" is missing from JSON.');
        assert(json[r'value'] != null, 'Required key "AdminUpdateSettingRequest[value]" has a null value in JSON.');
        return true;
      }());

      return AdminUpdateSettingRequest(
        value: mapValueOfType<int>(json, r'value')!,
      );
    }
    return null;
  }

  static List<AdminUpdateSettingRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateSettingRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateSettingRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateSettingRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateSettingRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateSettingRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateSettingRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateSettingRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateSettingRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateSettingRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'value',
  };
}

