//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AnswerLessonQuizRequest {
  /// Returns a new [AnswerLessonQuizRequest] instance.
  AnswerLessonQuizRequest({
    this.answers = const [],
  });

  List<int> answers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnswerLessonQuizRequest &&
    _deepEquality.equals(other.answers, answers);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (answers.hashCode);

  @override
  String toString() => 'AnswerLessonQuizRequest[answers=$answers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'answers'] = this.answers;
    return json;
  }

  /// Returns a new [AnswerLessonQuizRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnswerLessonQuizRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'answers'), 'Required key "AnswerLessonQuizRequest[answers]" is missing from JSON.');
        assert(json[r'answers'] != null, 'Required key "AnswerLessonQuizRequest[answers]" has a null value in JSON.');
        return true;
      }());

      return AnswerLessonQuizRequest(
        answers: json[r'answers'] is Iterable
            ? (json[r'answers'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AnswerLessonQuizRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnswerLessonQuizRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnswerLessonQuizRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnswerLessonQuizRequest> mapFromJson(dynamic json) {
    final map = <String, AnswerLessonQuizRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnswerLessonQuizRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnswerLessonQuizRequest-objects as value to a dart map
  static Map<String, List<AnswerLessonQuizRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnswerLessonQuizRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnswerLessonQuizRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'answers',
  };
}

