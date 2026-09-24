//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CreateGroupRequest {
  /// Returns a new [CreateGroupRequest] instance.
  CreateGroupRequest({
    required this.title,
    this.language,
    this.scheduledAt,
  });

  String title;

  String? language;

  Object? scheduledAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateGroupRequest &&
    other.title == title &&
    other.language == language &&
    other.scheduledAt == scheduledAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (language == null ? 0 : language!.hashCode) +
    (scheduledAt == null ? 0 : scheduledAt!.hashCode);

  @override
  String toString() => 'CreateGroupRequest[title=$title, language=$language, scheduledAt=$scheduledAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    if (this.scheduledAt != null) {
      json[r'scheduledAt'] = this.scheduledAt;
    } else {
      json[r'scheduledAt'] = null;
    }
    return json;
  }

  /// Returns a new [CreateGroupRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateGroupRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'title'), 'Required key "CreateGroupRequest[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "CreateGroupRequest[title]" has a null value in JSON.');
        return true;
      }());

      return CreateGroupRequest(
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language'),
        scheduledAt: mapValueOfType<Object>(json, r'scheduledAt'),
      );
    }
    return null;
  }

  static List<CreateGroupRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateGroupRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateGroupRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateGroupRequest> mapFromJson(dynamic json) {
    final map = <String, CreateGroupRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateGroupRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateGroupRequest-objects as value to a dart map
  static Map<String, List<CreateGroupRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateGroupRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateGroupRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
  };
}

