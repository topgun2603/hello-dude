//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AcademyLessonQuizInner {
  /// Returns a new [AcademyLessonQuizInner] instance.
  AcademyLessonQuizInner({
    required this.q,
    this.options = const [],
  });

  String q;

  List<String> options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AcademyLessonQuizInner &&
    other.q == q &&
    _deepEquality.equals(other.options, options);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (q.hashCode) +
    (options.hashCode);

  @override
  String toString() => 'AcademyLessonQuizInner[q=$q, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'q'] = this.q;
      json[r'options'] = this.options;
    return json;
  }

  /// Returns a new [AcademyLessonQuizInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AcademyLessonQuizInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'q'), 'Required key "AcademyLessonQuizInner[q]" is missing from JSON.');
        assert(json[r'q'] != null, 'Required key "AcademyLessonQuizInner[q]" has a null value in JSON.');
        assert(json.containsKey(r'options'), 'Required key "AcademyLessonQuizInner[options]" is missing from JSON.');
        assert(json[r'options'] != null, 'Required key "AcademyLessonQuizInner[options]" has a null value in JSON.');
        return true;
      }());

      return AcademyLessonQuizInner(
        q: mapValueOfType<String>(json, r'q')!,
        options: json[r'options'] is Iterable
            ? (json[r'options'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AcademyLessonQuizInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AcademyLessonQuizInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AcademyLessonQuizInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AcademyLessonQuizInner> mapFromJson(dynamic json) {
    final map = <String, AcademyLessonQuizInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AcademyLessonQuizInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AcademyLessonQuizInner-objects as value to a dart map
  static Map<String, List<AcademyLessonQuizInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AcademyLessonQuizInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AcademyLessonQuizInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'q',
    'options',
  };
}

