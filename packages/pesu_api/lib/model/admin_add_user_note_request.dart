//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAddUserNoteRequest {
  /// Returns a new [AdminAddUserNoteRequest] instance.
  AdminAddUserNoteRequest({
    required this.body,
  });

  String body;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAddUserNoteRequest &&
    other.body == body;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (body.hashCode);

  @override
  String toString() => 'AdminAddUserNoteRequest[body=$body]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'body'] = this.body;
    return json;
  }

  /// Returns a new [AdminAddUserNoteRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAddUserNoteRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'body'), 'Required key "AdminAddUserNoteRequest[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminAddUserNoteRequest[body]" has a null value in JSON.');
        return true;
      }());

      return AdminAddUserNoteRequest(
        body: mapValueOfType<String>(json, r'body')!,
      );
    }
    return null;
  }

  static List<AdminAddUserNoteRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAddUserNoteRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAddUserNoteRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAddUserNoteRequest> mapFromJson(dynamic json) {
    final map = <String, AdminAddUserNoteRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAddUserNoteRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAddUserNoteRequest-objects as value to a dart map
  static Map<String, List<AdminAddUserNoteRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAddUserNoteRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAddUserNoteRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'body',
  };
}

