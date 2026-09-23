//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AnswerLessonQuiz200Response {
  /// Returns a new [AnswerLessonQuiz200Response] instance.
  AnswerLessonQuiz200Response({
    required this.passed,
    this.correct = const [],
  });

  bool passed;

  List<bool> correct;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnswerLessonQuiz200Response &&
    other.passed == passed &&
    _deepEquality.equals(other.correct, correct);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (passed.hashCode) +
    (correct.hashCode);

  @override
  String toString() => 'AnswerLessonQuiz200Response[passed=$passed, correct=$correct]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'passed'] = this.passed;
      json[r'correct'] = this.correct;
    return json;
  }

  /// Returns a new [AnswerLessonQuiz200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnswerLessonQuiz200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'passed'), 'Required key "AnswerLessonQuiz200Response[passed]" is missing from JSON.');
        assert(json[r'passed'] != null, 'Required key "AnswerLessonQuiz200Response[passed]" has a null value in JSON.');
        assert(json.containsKey(r'correct'), 'Required key "AnswerLessonQuiz200Response[correct]" is missing from JSON.');
        assert(json[r'correct'] != null, 'Required key "AnswerLessonQuiz200Response[correct]" has a null value in JSON.');
        return true;
      }());

      return AnswerLessonQuiz200Response(
        passed: mapValueOfType<bool>(json, r'passed')!,
        correct: json[r'correct'] is Iterable
            ? (json[r'correct'] as Iterable).cast<bool>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AnswerLessonQuiz200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnswerLessonQuiz200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnswerLessonQuiz200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnswerLessonQuiz200Response> mapFromJson(dynamic json) {
    final map = <String, AnswerLessonQuiz200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnswerLessonQuiz200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnswerLessonQuiz200Response-objects as value to a dart map
  static Map<String, List<AnswerLessonQuiz200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnswerLessonQuiz200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnswerLessonQuiz200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'passed',
    'correct',
  };
}

