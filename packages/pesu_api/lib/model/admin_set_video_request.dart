//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminSetVideoRequest {
  /// Returns a new [AdminSetVideoRequest] instance.
  AdminSetVideoRequest({
    required this.enabled,
    required this.reason,
  });

  bool enabled;

  String reason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminSetVideoRequest &&
    other.enabled == enabled &&
    other.reason == reason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (reason.hashCode);

  @override
  String toString() => 'AdminSetVideoRequest[enabled=$enabled, reason=$reason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
      json[r'reason'] = this.reason;
    return json;
  }

  /// Returns a new [AdminSetVideoRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminSetVideoRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'enabled'), 'Required key "AdminSetVideoRequest[enabled]" is missing from JSON.');
        assert(json[r'enabled'] != null, 'Required key "AdminSetVideoRequest[enabled]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminSetVideoRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminSetVideoRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return AdminSetVideoRequest(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        reason: mapValueOfType<String>(json, r'reason')!,
      );
    }
    return null;
  }

  static List<AdminSetVideoRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminSetVideoRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminSetVideoRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminSetVideoRequest> mapFromJson(dynamic json) {
    final map = <String, AdminSetVideoRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminSetVideoRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminSetVideoRequest-objects as value to a dart map
  static Map<String, List<AdminSetVideoRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminSetVideoRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminSetVideoRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
    'reason',
  };
}

