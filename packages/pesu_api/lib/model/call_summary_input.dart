//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallSummaryInput {
  /// Returns a new [CallSummaryInput] instance.
  CallSummaryInput({
    required this.id,
    required this.type,
    required this.status,
    required this.direction,
    required this.other,
    required this.language,
    required this.coinsPerMin,
    required this.createdAt,
    required this.startedAt,
    required this.endedAt,
    required this.endReason,
    required this.durationSeconds,
    required this.minutesCharged,
    required this.coinsCharged,
    required this.coinsRefunded,
    required this.paiseEarned,
    required this.myRating,
  });

  String id;

  CallSummaryInputTypeEnum type;

  CallSummaryInputStatusEnum status;

  /// outgoing = I was the caller
  CallSummaryInputDirectionEnum direction;

  PartyInput other;

  String language;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  Object? createdAt;

  Object? startedAt;

  Object? endedAt;

  String? endReason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? durationSeconds;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutesCharged;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsCharged;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  /// Companion side: earnings after any reversal
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paiseEarned;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? myRating;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallSummaryInput &&
    other.id == id &&
    other.type == type &&
    other.status == status &&
    other.direction == direction &&
    other.other == other &&
    other.language == language &&
    other.coinsPerMin == coinsPerMin &&
    other.createdAt == createdAt &&
    other.startedAt == startedAt &&
    other.endedAt == endedAt &&
    other.endReason == endReason &&
    other.durationSeconds == durationSeconds &&
    other.minutesCharged == minutesCharged &&
    other.coinsCharged == coinsCharged &&
    other.coinsRefunded == coinsRefunded &&
    other.paiseEarned == paiseEarned &&
    other.myRating == myRating;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode) +
    (status.hashCode) +
    (direction.hashCode) +
    (other.hashCode) +
    (language.hashCode) +
    (coinsPerMin.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (endedAt == null ? 0 : endedAt!.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode) +
    (durationSeconds == null ? 0 : durationSeconds!.hashCode) +
    (minutesCharged.hashCode) +
    (coinsCharged.hashCode) +
    (coinsRefunded.hashCode) +
    (paiseEarned.hashCode) +
    (myRating == null ? 0 : myRating!.hashCode);

  @override
  String toString() => 'CallSummaryInput[id=$id, type=$type, status=$status, direction=$direction, other=$other, language=$language, coinsPerMin=$coinsPerMin, createdAt=$createdAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason, durationSeconds=$durationSeconds, minutesCharged=$minutesCharged, coinsCharged=$coinsCharged, coinsRefunded=$coinsRefunded, paiseEarned=$paiseEarned, myRating=$myRating]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'status'] = this.status;
      json[r'direction'] = this.direction;
      json[r'other'] = this.other;
      json[r'language'] = this.language;
      json[r'coinsPerMin'] = this.coinsPerMin;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt;
    } else {
      json[r'startedAt'] = null;
    }
    if (this.endedAt != null) {
      json[r'endedAt'] = this.endedAt;
    } else {
      json[r'endedAt'] = null;
    }
    if (this.endReason != null) {
      json[r'endReason'] = this.endReason;
    } else {
      json[r'endReason'] = null;
    }
    if (this.durationSeconds != null) {
      json[r'durationSeconds'] = this.durationSeconds;
    } else {
      json[r'durationSeconds'] = null;
    }
      json[r'minutesCharged'] = this.minutesCharged;
      json[r'coinsCharged'] = this.coinsCharged;
      json[r'coinsRefunded'] = this.coinsRefunded;
      json[r'paiseEarned'] = this.paiseEarned;
    if (this.myRating != null) {
      json[r'myRating'] = this.myRating;
    } else {
      json[r'myRating'] = null;
    }
    return json;
  }

  /// Returns a new [CallSummaryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSummaryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CallSummaryInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CallSummaryInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "CallSummaryInput[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "CallSummaryInput[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CallSummaryInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CallSummaryInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "CallSummaryInput[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "CallSummaryInput[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "CallSummaryInput[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "CallSummaryInput[other]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "CallSummaryInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "CallSummaryInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "CallSummaryInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "CallSummaryInput[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "CallSummaryInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "CallSummaryInput[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "CallSummaryInput[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "CallSummaryInput[endReason]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "CallSummaryInput[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'minutesCharged'), 'Required key "CallSummaryInput[minutesCharged]" is missing from JSON.');
        assert(json[r'minutesCharged'] != null, 'Required key "CallSummaryInput[minutesCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsCharged'), 'Required key "CallSummaryInput[coinsCharged]" is missing from JSON.');
        assert(json[r'coinsCharged'] != null, 'Required key "CallSummaryInput[coinsCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "CallSummaryInput[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "CallSummaryInput[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "CallSummaryInput[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "CallSummaryInput[paiseEarned]" has a null value in JSON.');
        assert(json.containsKey(r'myRating'), 'Required key "CallSummaryInput[myRating]" is missing from JSON.');
        return true;
      }());

      return CallSummaryInput(
        id: mapValueOfType<String>(json, r'id')!,
        type: CallSummaryInputTypeEnum.fromJson(json[r'type'])!,
        status: CallSummaryInputStatusEnum.fromJson(json[r'status'])!,
        direction: CallSummaryInputDirectionEnum.fromJson(json[r'direction'])!,
        other: PartyInput.fromJson(json[r'other'])!,
        language: mapValueOfType<String>(json, r'language')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
        endedAt: mapValueOfType<Object>(json, r'endedAt'),
        endReason: mapValueOfType<String>(json, r'endReason'),
        durationSeconds: mapValueOfType<int>(json, r'durationSeconds'),
        minutesCharged: mapValueOfType<int>(json, r'minutesCharged')!,
        coinsCharged: mapValueOfType<int>(json, r'coinsCharged')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        paiseEarned: mapValueOfType<int>(json, r'paiseEarned')!,
        myRating: mapValueOfType<int>(json, r'myRating'),
      );
    }
    return null;
  }

  static List<CallSummaryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSummaryInput> mapFromJson(dynamic json) {
    final map = <String, CallSummaryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSummaryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSummaryInput-objects as value to a dart map
  static Map<String, List<CallSummaryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallSummaryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSummaryInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
    'status',
    'direction',
    'other',
    'language',
    'coinsPerMin',
    'createdAt',
    'startedAt',
    'endedAt',
    'endReason',
    'durationSeconds',
    'minutesCharged',
    'coinsCharged',
    'coinsRefunded',
    'paiseEarned',
    'myRating',
  };
}


enum CallSummaryInputTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryInputTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryInputTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryInputTypeEnum? fromJson(dynamic value) => CallSummaryInputTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryInputTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryInputTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryInputTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryInputTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryInputTypeEnum] to String,
/// and [decode] dynamic data back to [CallSummaryInputTypeEnum].
class CallSummaryInputTypeEnumTypeTransformer {
  factory CallSummaryInputTypeEnumTypeTransformer() => _instance ??= const CallSummaryInputTypeEnumTypeTransformer._();

  const CallSummaryInputTypeEnumTypeTransformer._();

  String encode(CallSummaryInputTypeEnum data) => data._value;

  /// Returns the instance of [CallSummaryInputTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryInputTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryInputTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CallSummaryInputTypeEnum.audio;
        case r'video': return CallSummaryInputTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryInputTypeEnumTypeTransformer? _instance;
}



enum CallSummaryInputStatusEnum {
  ringing._(r'ringing'),
  active._(r'active'),
  ended._(r'ended'),
  missed._(r'missed'),
  rejected._(r'rejected'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryInputStatusEnum? fromJson(dynamic value) => CallSummaryInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryInputStatusEnum] to String,
/// and [decode] dynamic data back to [CallSummaryInputStatusEnum].
class CallSummaryInputStatusEnumTypeTransformer {
  factory CallSummaryInputStatusEnumTypeTransformer() => _instance ??= const CallSummaryInputStatusEnumTypeTransformer._();

  const CallSummaryInputStatusEnumTypeTransformer._();

  String encode(CallSummaryInputStatusEnum data) => data._value;

  /// Returns the instance of [CallSummaryInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'ringing': return CallSummaryInputStatusEnum.ringing;
        case r'active': return CallSummaryInputStatusEnum.active;
        case r'ended': return CallSummaryInputStatusEnum.ended;
        case r'missed': return CallSummaryInputStatusEnum.missed;
        case r'rejected': return CallSummaryInputStatusEnum.rejected;
        case r'failed': return CallSummaryInputStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryInputStatusEnumTypeTransformer? _instance;
}


/// outgoing = I was the caller
enum CallSummaryInputDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryInputDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryInputDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryInputDirectionEnum? fromJson(dynamic value) => CallSummaryInputDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryInputDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryInputDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryInputDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryInputDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryInputDirectionEnum] to String,
/// and [decode] dynamic data back to [CallSummaryInputDirectionEnum].
class CallSummaryInputDirectionEnumTypeTransformer {
  factory CallSummaryInputDirectionEnumTypeTransformer() => _instance ??= const CallSummaryInputDirectionEnumTypeTransformer._();

  const CallSummaryInputDirectionEnumTypeTransformer._();

  String encode(CallSummaryInputDirectionEnum data) => data._value;

  /// Returns the instance of [CallSummaryInputDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryInputDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryInputDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return CallSummaryInputDirectionEnum.outgoing;
        case r'incoming': return CallSummaryInputDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryInputDirectionEnumTypeTransformer? _instance;
}


