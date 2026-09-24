//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomState {
  /// Returns a new [RoomState] instance.
  RoomState({
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

  RoomStateStatusEnum status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int maxSpeakers;

  List<RoomMember> members;

  RoomStateMeEnum? me;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomState &&
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
  String toString() => 'RoomState[id=$id, title=$title, category=$category, language=$language, status=$status, maxSpeakers=$maxSpeakers, members=$members, me=$me]';

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

  /// Returns a new [RoomState] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomState? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RoomState[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RoomState[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "RoomState[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "RoomState[title]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "RoomState[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "RoomState[category]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "RoomState[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "RoomState[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "RoomState[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "RoomState[status]" has a null value in JSON.');
        assert(json.containsKey(r'maxSpeakers'), 'Required key "RoomState[maxSpeakers]" is missing from JSON.');
        assert(json[r'maxSpeakers'] != null, 'Required key "RoomState[maxSpeakers]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "RoomState[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "RoomState[members]" has a null value in JSON.');
        assert(json.containsKey(r'me'), 'Required key "RoomState[me]" is missing from JSON.');
        return true;
      }());

      return RoomState(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        category: mapValueOfType<String>(json, r'category')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: RoomStateStatusEnum.fromJson(json[r'status'])!,
        maxSpeakers: mapValueOfType<int>(json, r'maxSpeakers')!,
        members: RoomMember.listFromJson(json[r'members']),
        me: RoomStateMeEnum.fromJson(json[r'me']),
      );
    }
    return null;
  }

  static List<RoomState> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomState>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomState.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomState> mapFromJson(dynamic json) {
    final map = <String, RoomState>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomState.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomState-objects as value to a dart map
  static Map<String, List<RoomState>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomState>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomState.listFromJson(entry.value, growable: growable,);
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


enum RoomStateStatusEnum {
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomStateStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomStateStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomStateStatusEnum? fromJson(dynamic value) => RoomStateStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomStateStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomStateStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomStateStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomStateStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomStateStatusEnum] to String,
/// and [decode] dynamic data back to [RoomStateStatusEnum].
class RoomStateStatusEnumTypeTransformer {
  factory RoomStateStatusEnumTypeTransformer() => _instance ??= const RoomStateStatusEnumTypeTransformer._();

  const RoomStateStatusEnumTypeTransformer._();

  String encode(RoomStateStatusEnum data) => data._value;

  /// Returns the instance of [RoomStateStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomStateStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomStateStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return RoomStateStatusEnum.live;
        case r'ended': return RoomStateStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomStateStatusEnumTypeTransformer? _instance;
}



enum RoomStateMeEnum {
  host._(r'host'),
  speaker._(r'speaker'),
  listener._(r'listener'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomStateMeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomStateMeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomStateMeEnum? fromJson(dynamic value) => RoomStateMeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomStateMeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomStateMeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomStateMeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomStateMeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomStateMeEnum] to String,
/// and [decode] dynamic data back to [RoomStateMeEnum].
class RoomStateMeEnumTypeTransformer {
  factory RoomStateMeEnumTypeTransformer() => _instance ??= const RoomStateMeEnumTypeTransformer._();

  const RoomStateMeEnumTypeTransformer._();

  String encode(RoomStateMeEnum data) => data._value;

  /// Returns the instance of [RoomStateMeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomStateMeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomStateMeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return RoomStateMeEnum.host;
        case r'speaker': return RoomStateMeEnum.speaker;
        case r'listener': return RoomStateMeEnum.listener;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomStateMeEnumTypeTransformer? _instance;
}


