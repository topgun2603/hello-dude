//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminSendMessageRequest {
  /// Returns a new [AdminSendMessageRequest] instance.
  AdminSendMessageRequest({
    required this.title,
    required this.body,
  });

  String title;

  String body;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminSendMessageRequest &&
    other.title == title &&
    other.body == body;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (body.hashCode);

  @override
  String toString() => 'AdminSendMessageRequest[title=$title, body=$body]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'body'] = this.body;
    return json;
  }

  /// Returns a new [AdminSendMessageRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminSendMessageRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'title'), 'Required key "AdminSendMessageRequest[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminSendMessageRequest[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AdminSendMessageRequest[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminSendMessageRequest[body]" has a null value in JSON.');
        return true;
      }());

      return AdminSendMessageRequest(
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
      );
    }
    return null;
  }

  static List<AdminSendMessageRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminSendMessageRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminSendMessageRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminSendMessageRequest> mapFromJson(dynamic json) {
    final map = <String, AdminSendMessageRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminSendMessageRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminSendMessageRequest-objects as value to a dart map
  static Map<String, List<AdminSendMessageRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminSendMessageRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminSendMessageRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'body',
  };
}

