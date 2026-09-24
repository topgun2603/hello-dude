//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class StartRoomRequest {
  /// Returns a new [StartRoomRequest] instance.
  StartRoomRequest({
    required this.title,
    required this.category,
    required this.language,
  });

  String title;

  String category;

  String language;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StartRoomRequest &&
    other.title == title &&
    other.category == category &&
    other.language == language;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (category.hashCode) +
    (language.hashCode);

  @override
  String toString() => 'StartRoomRequest[title=$title, category=$category, language=$language]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'category'] = this.category;
      json[r'language'] = this.language;
    return json;
  }

  /// Returns a new [StartRoomRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartRoomRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'title'), 'Required key "StartRoomRequest[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "StartRoomRequest[title]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "StartRoomRequest[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "StartRoomRequest[category]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "StartRoomRequest[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "StartRoomRequest[language]" has a null value in JSON.');
        return true;
      }());

      return StartRoomRequest(
        title: mapValueOfType<String>(json, r'title')!,
        category: mapValueOfType<String>(json, r'category')!,
        language: mapValueOfType<String>(json, r'language')!,
      );
    }
    return null;
  }

  static List<StartRoomRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartRoomRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartRoomRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartRoomRequest> mapFromJson(dynamic json) {
    final map = <String, StartRoomRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartRoomRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartRoomRequest-objects as value to a dart map
  static Map<String, List<StartRoomRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StartRoomRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartRoomRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'category',
    'language',
  };
}

