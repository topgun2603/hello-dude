//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetAcademy200Response {
  /// Returns a new [GetAcademy200Response] instance.
  GetAcademy200Response({
    required this.passed,
    required this.total,
    required this.videoUnlocked,
    this.lessons = const [],
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int passed;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int total;

  bool videoUnlocked;

  List<AcademyLesson> lessons;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetAcademy200Response &&
    other.passed == passed &&
    other.total == total &&
    other.videoUnlocked == videoUnlocked &&
    _deepEquality.equals(other.lessons, lessons);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (passed.hashCode) +
    (total.hashCode) +
    (videoUnlocked.hashCode) +
    (lessons.hashCode);

  @override
  String toString() => 'GetAcademy200Response[passed=$passed, total=$total, videoUnlocked=$videoUnlocked, lessons=$lessons]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'passed'] = this.passed;
      json[r'total'] = this.total;
      json[r'videoUnlocked'] = this.videoUnlocked;
      json[r'lessons'] = this.lessons;
    return json;
  }

  /// Returns a new [GetAcademy200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetAcademy200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'passed'), 'Required key "GetAcademy200Response[passed]" is missing from JSON.');
        assert(json[r'passed'] != null, 'Required key "GetAcademy200Response[passed]" has a null value in JSON.');
        assert(json.containsKey(r'total'), 'Required key "GetAcademy200Response[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "GetAcademy200Response[total]" has a null value in JSON.');
        assert(json.containsKey(r'videoUnlocked'), 'Required key "GetAcademy200Response[videoUnlocked]" is missing from JSON.');
        assert(json[r'videoUnlocked'] != null, 'Required key "GetAcademy200Response[videoUnlocked]" has a null value in JSON.');
        assert(json.containsKey(r'lessons'), 'Required key "GetAcademy200Response[lessons]" is missing from JSON.');
        assert(json[r'lessons'] != null, 'Required key "GetAcademy200Response[lessons]" has a null value in JSON.');
        return true;
      }());

      return GetAcademy200Response(
        passed: mapValueOfType<int>(json, r'passed')!,
        total: mapValueOfType<int>(json, r'total')!,
        videoUnlocked: mapValueOfType<bool>(json, r'videoUnlocked')!,
        lessons: AcademyLesson.listFromJson(json[r'lessons']),
      );
    }
    return null;
  }

  static List<GetAcademy200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetAcademy200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetAcademy200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetAcademy200Response> mapFromJson(dynamic json) {
    final map = <String, GetAcademy200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetAcademy200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetAcademy200Response-objects as value to a dart map
  static Map<String, List<GetAcademy200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetAcademy200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetAcademy200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'passed',
    'total',
    'videoUnlocked',
    'lessons',
  };
}

