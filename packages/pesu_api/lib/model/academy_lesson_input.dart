//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AcademyLessonInput {
  /// Returns a new [AcademyLessonInput] instance.
  AcademyLessonInput({
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

  AcademyLessonInputStatusEnum status;

  List<AcademyLessonInputQuizInner> quiz;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AcademyLessonInput &&
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
  String toString() => 'AcademyLessonInput[id=$id, position=$position, title=$title, minutes=$minutes, body=$body, videoUrl=$videoUrl, status=$status, quiz=$quiz]';

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

  /// Returns a new [AcademyLessonInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AcademyLessonInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AcademyLessonInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AcademyLessonInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'position'), 'Required key "AcademyLessonInput[position]" is missing from JSON.');
        assert(json[r'position'] != null, 'Required key "AcademyLessonInput[position]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AcademyLessonInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AcademyLessonInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AcademyLessonInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AcademyLessonInput[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AcademyLessonInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AcademyLessonInput[body]" has a null value in JSON.');
        assert(json.containsKey(r'videoUrl'), 'Required key "AcademyLessonInput[videoUrl]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AcademyLessonInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AcademyLessonInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'quiz'), 'Required key "AcademyLessonInput[quiz]" is missing from JSON.');
        assert(json[r'quiz'] != null, 'Required key "AcademyLessonInput[quiz]" has a null value in JSON.');
        return true;
      }());

      return AcademyLessonInput(
        id: mapValueOfType<int>(json, r'id')!,
        position: mapValueOfType<int>(json, r'position')!,
        title: mapValueOfType<String>(json, r'title')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        body: mapValueOfType<String>(json, r'body')!,
        videoUrl: mapValueOfType<String>(json, r'videoUrl'),
        status: AcademyLessonInputStatusEnum.fromJson(json[r'status'])!,
        quiz: AcademyLessonInputQuizInner.listFromJson(json[r'quiz']),
      );
    }
    return null;
  }

  static List<AcademyLessonInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AcademyLessonInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AcademyLessonInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AcademyLessonInput> mapFromJson(dynamic json) {
    final map = <String, AcademyLessonInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AcademyLessonInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AcademyLessonInput-objects as value to a dart map
  static Map<String, List<AcademyLessonInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AcademyLessonInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AcademyLessonInput.listFromJson(entry.value, growable: growable,);
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


enum AcademyLessonInputStatusEnum {
  done._(r'done'),
  available._(r'available'),
  locked._(r'locked'),
  ;

  /// Instantiate a new enum with the provided value.
  const AcademyLessonInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AcademyLessonInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AcademyLessonInputStatusEnum? fromJson(dynamic value) => AcademyLessonInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AcademyLessonInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AcademyLessonInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AcademyLessonInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AcademyLessonInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AcademyLessonInputStatusEnum] to String,
/// and [decode] dynamic data back to [AcademyLessonInputStatusEnum].
class AcademyLessonInputStatusEnumTypeTransformer {
  factory AcademyLessonInputStatusEnumTypeTransformer() => _instance ??= const AcademyLessonInputStatusEnumTypeTransformer._();

  const AcademyLessonInputStatusEnumTypeTransformer._();

  String encode(AcademyLessonInputStatusEnum data) => data._value;

  /// Returns the instance of [AcademyLessonInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AcademyLessonInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AcademyLessonInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'done': return AcademyLessonInputStatusEnum.done;
        case r'available': return AcademyLessonInputStatusEnum.available;
        case r'locked': return AcademyLessonInputStatusEnum.locked;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AcademyLessonInputStatusEnumTypeTransformer? _instance;
}


