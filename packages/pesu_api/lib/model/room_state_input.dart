//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomStateInput {
  /// Returns a new [RoomStateInput] instance.
  RoomStateInput({
    required this.id,
    required this.title,
    required this.category,
    required this.language,
    required this.status,
    required this.maxSpeakers,
    this.members = const [],
    required this.me,
  });

  String id;

  String title;

  String category;

  String language;

  RoomStateInputStatusEnum status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int maxSpeakers;

  List<RoomMemberInput> members;

  RoomStateInputMeEnum? me;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomStateInput &&
    other.id == id &&
    other.title == title &&
    other.category == category &&
    other.language == language &&
    other.status == status &&
    other.maxSpeakers == maxSpeakers &&
    _deepEquality.equals(other.members, members) &&
    other.me == me;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (category.hashCode) +
    (language.hashCode) +
    (status.hashCode) +
    (maxSpeakers.hashCode) +
    (members.hashCode) +
    (me == null ? 0 : me!.hashCode);

  @override
  String toString() => 'RoomStateInput[id=$id, title=$title, category=$category, language=$language, status=$status, maxSpeakers=$maxSpeakers, members=$members, me=$me]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'category'] = this.category;
      json[r'language'] = this.language;
      json[r'status'] = this.status;
      json[r'maxSpeakers'] = this.maxSpeakers;
      json[r'members'] = this.members;
    if (this.me != null) {
      json[r'me'] = this.me;
    } else {
      json[r'me'] = null;
    }
    return json;
  }

  /// Returns a new [RoomStateInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomStateInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RoomStateInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RoomStateInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "RoomStateInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "RoomStateInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "RoomStateInput[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "RoomStateInput[category]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "RoomStateInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "RoomStateInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "RoomStateInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "RoomStateInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'maxSpeakers'), 'Required key "RoomStateInput[maxSpeakers]" is missing from JSON.');
        assert(json[r'maxSpeakers'] != null, 'Required key "RoomStateInput[maxSpeakers]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "RoomStateInput[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "RoomStateInput[members]" has a null value in JSON.');
        assert(json.containsKey(r'me'), 'Required key "RoomStateInput[me]" is missing from JSON.');
        return true;
      }());

      return RoomStateInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        category: mapValueOfType<String>(json, r'category')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: RoomStateInputStatusEnum.fromJson(json[r'status'])!,
        maxSpeakers: mapValueOfType<int>(json, r'maxSpeakers')!,
        members: RoomMemberInput.listFromJson(json[r'members']),
        me: RoomStateInputMeEnum.fromJson(json[r'me']),
      );
    }
    return null;
  }

  static List<RoomStateInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomStateInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomStateInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomStateInput> mapFromJson(dynamic json) {
    final map = <String, RoomStateInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomStateInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomStateInput-objects as value to a dart map
  static Map<String, List<RoomStateInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomStateInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomStateInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'category',
    'language',
    'status',
    'maxSpeakers',
    'members',
    'me',
  };
}


enum RoomStateInputStatusEnum {
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomStateInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomStateInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomStateInputStatusEnum? fromJson(dynamic value) => RoomStateInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomStateInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomStateInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomStateInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomStateInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomStateInputStatusEnum] to String,
/// and [decode] dynamic data back to [RoomStateInputStatusEnum].
class RoomStateInputStatusEnumTypeTransformer {
  factory RoomStateInputStatusEnumTypeTransformer() => _instance ??= const RoomStateInputStatusEnumTypeTransformer._();

  const RoomStateInputStatusEnumTypeTransformer._();

  String encode(RoomStateInputStatusEnum data) => data._value;

  /// Returns the instance of [RoomStateInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomStateInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomStateInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return RoomStateInputStatusEnum.live;
        case r'ended': return RoomStateInputStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomStateInputStatusEnumTypeTransformer? _instance;
}



enum RoomStateInputMeEnum {
  host._(r'host'),
  speaker._(r'speaker'),
  listener._(r'listener'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomStateInputMeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomStateInputMeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomStateInputMeEnum? fromJson(dynamic value) => RoomStateInputMeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomStateInputMeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomStateInputMeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomStateInputMeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomStateInputMeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomStateInputMeEnum] to String,
/// and [decode] dynamic data back to [RoomStateInputMeEnum].
class RoomStateInputMeEnumTypeTransformer {
  factory RoomStateInputMeEnumTypeTransformer() => _instance ??= const RoomStateInputMeEnumTypeTransformer._();

  const RoomStateInputMeEnumTypeTransformer._();

  String encode(RoomStateInputMeEnum data) => data._value;

  /// Returns the instance of [RoomStateInputMeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomStateInputMeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomStateInputMeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return RoomStateInputMeEnum.host;
        case r'speaker': return RoomStateInputMeEnum.speaker;
        case r'listener': return RoomStateInputMeEnum.listener;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomStateInputMeEnumTypeTransformer? _instance;
}


