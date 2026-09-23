//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AcademyLesson {
  /// Returns a new [AcademyLesson] instance.
  AcademyLesson({
    required this.id,
    required this.position,
    required this.title,
    required this.minutes,
    required this.body,
    required this.videoUrl,
    required this.status,
    this.quiz = const [],
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int position;

  String title;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  String body;

  String? videoUrl;

  AcademyLessonStatusEnum status;

  List<AcademyLessonQuizInner> quiz;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AcademyLesson &&
    other.id == id &&
    other.position == position &&
    other.title == title &&
    other.minutes == minutes &&
    other.body == body &&
    other.videoUrl == videoUrl &&
    other.status == status &&
    _deepEquality.equals(other.quiz, quiz);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (position.hashCode) +
    (title.hashCode) +
    (minutes.hashCode) +
    (body.hashCode) +
    (videoUrl == null ? 0 : videoUrl!.hashCode) +
    (status.hashCode) +
    (quiz.hashCode);

  @override
  String toString() => 'AcademyLesson[id=$id, position=$position, title=$title, minutes=$minutes, body=$body, videoUrl=$videoUrl, status=$status, quiz=$quiz]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'position'] = this.position;
      json[r'title'] = this.title;
      json[r'minutes'] = this.minutes;
      json[r'body'] = this.body;
    if (this.videoUrl != null) {
      json[r'videoUrl'] = this.videoUrl;
    } else {
      json[r'videoUrl'] = null;
    }
      json[r'status'] = this.status;
      json[r'quiz'] = this.quiz;
    return json;
  }

  /// Returns a new [AcademyLesson] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AcademyLesson? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AcademyLesson[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AcademyLesson[id]" has a null value in JSON.');
        assert(json.containsKey(r'position'), 'Required key "AcademyLesson[position]" is missing from JSON.');
        assert(json[r'position'] != null, 'Required key "AcademyLesson[position]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AcademyLesson[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AcademyLesson[title]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AcademyLesson[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AcademyLesson[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AcademyLesson[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AcademyLesson[body]" has a null value in JSON.');
        assert(json.containsKey(r'videoUrl'), 'Required key "AcademyLesson[videoUrl]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AcademyLesson[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AcademyLesson[status]" has a null value in JSON.');
        assert(json.containsKey(r'quiz'), 'Required key "AcademyLesson[quiz]" is missing from JSON.');
        assert(json[r'quiz'] != null, 'Required key "AcademyLesson[quiz]" has a null value in JSON.');
        return true;
      }());

      return AcademyLesson(
        id: mapValueOfType<int>(json, r'id')!,
        position: mapValueOfType<int>(json, r'position')!,
        title: mapValueOfType<String>(json, r'title')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        body: mapValueOfType<String>(json, r'body')!,
        videoUrl: mapValueOfType<String>(json, r'videoUrl'),
        status: AcademyLessonStatusEnum.fromJson(json[r'status'])!,
        quiz: AcademyLessonQuizInner.listFromJson(json[r'quiz']),
      );
    }
    return null;
  }

  static List<AcademyLesson> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AcademyLesson>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AcademyLesson.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AcademyLesson> mapFromJson(dynamic json) {
    final map = <String, AcademyLesson>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AcademyLesson.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AcademyLesson-objects as value to a dart map
  static Map<String, List<AcademyLesson>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AcademyLesson>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AcademyLesson.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'position',
    'title',
    'minutes',
    'body',
    'videoUrl',
    'status',
    'quiz',
  };
}


enum AcademyLessonStatusEnum {
  done._(r'done'),
  available._(r'available'),
  locked._(r'locked'),
  ;

  /// Instantiate a new enum with the provided value.
  const AcademyLessonStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AcademyLessonStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AcademyLessonStatusEnum? fromJson(dynamic value) => AcademyLessonStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AcademyLessonStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AcademyLessonStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AcademyLessonStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AcademyLessonStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AcademyLessonStatusEnum] to String,
/// and [decode] dynamic data back to [AcademyLessonStatusEnum].
class AcademyLessonStatusEnumTypeTransformer {
  factory AcademyLessonStatusEnumTypeTransformer() => _instance ??= const AcademyLessonStatusEnumTypeTransformer._();

  const AcademyLessonStatusEnumTypeTransformer._();

  String encode(AcademyLessonStatusEnum data) => data._value;

  /// Returns the instance of [AcademyLessonStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AcademyLessonStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AcademyLessonStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'done': return AcademyLessonStatusEnum.done;
        case r'available': return AcademyLessonStatusEnum.available;
        case r'locked': return AcademyLessonStatusEnum.locked;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AcademyLessonStatusEnumTypeTransformer? _instance;
}


