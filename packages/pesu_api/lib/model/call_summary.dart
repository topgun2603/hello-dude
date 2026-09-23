//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallSummary {
  /// Returns a new [CallSummary] instance.
  CallSummary({
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

  CallSummaryTypeEnum type;

  CallSummaryStatusEnum status;

  /// outgoing = I was the caller
  CallSummaryDirectionEnum direction;

  Party other;

  String language;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? endedAt;

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
  bool operator ==(Object other) => identical(this, other) || other is CallSummary &&
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
    (createdAt.hashCode) +
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
  String toString() => 'CallSummary[id=$id, type=$type, status=$status, direction=$direction, other=$other, language=$language, coinsPerMin=$coinsPerMin, createdAt=$createdAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason, durationSeconds=$durationSeconds, minutesCharged=$minutesCharged, coinsCharged=$coinsCharged, coinsRefunded=$coinsRefunded, paiseEarned=$paiseEarned, myRating=$myRating]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'status'] = this.status;
      json[r'direction'] = this.direction;
      json[r'other'] = this.other;
      json[r'language'] = this.language;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt!.toUtc().toIso8601String();
    } else {
      json[r'startedAt'] = null;
    }
    if (this.endedAt != null) {
      json[r'endedAt'] = this.endedAt!.toUtc().toIso8601String();
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

  /// Returns a new [CallSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CallSummary[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CallSummary[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "CallSummary[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "CallSummary[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CallSummary[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CallSummary[status]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "CallSummary[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "CallSummary[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "CallSummary[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "CallSummary[other]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "CallSummary[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "CallSummary[language]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "CallSummary[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "CallSummary[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "CallSummary[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "CallSummary[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "CallSummary[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "CallSummary[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "CallSummary[endReason]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "CallSummary[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'minutesCharged'), 'Required key "CallSummary[minutesCharged]" is missing from JSON.');
        assert(json[r'minutesCharged'] != null, 'Required key "CallSummary[minutesCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsCharged'), 'Required key "CallSummary[coinsCharged]" is missing from JSON.');
        assert(json[r'coinsCharged'] != null, 'Required key "CallSummary[coinsCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "CallSummary[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "CallSummary[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "CallSummary[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "CallSummary[paiseEarned]" has a null value in JSON.');
        assert(json.containsKey(r'myRating'), 'Required key "CallSummary[myRating]" is missing from JSON.');
        return true;
      }());

      return CallSummary(
        id: mapValueOfType<String>(json, r'id')!,
        type: CallSummaryTypeEnum.fromJson(json[r'type'])!,
        status: CallSummaryStatusEnum.fromJson(json[r'status'])!,
        direction: CallSummaryDirectionEnum.fromJson(json[r'direction'])!,
        other: Party.fromJson(json[r'other'])!,
        language: mapValueOfType<String>(json, r'language')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        startedAt: mapDateTime(json, r'startedAt', r''),
        endedAt: mapDateTime(json, r'endedAt', r''),
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

  static List<CallSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSummary> mapFromJson(dynamic json) {
    final map = <String, CallSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSummary-objects as value to a dart map
  static Map<String, List<CallSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallSummary>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSummary.listFromJson(entry.value, growable: growable,);
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


enum CallSummaryTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryTypeEnum? fromJson(dynamic value) => CallSummaryTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryTypeEnum] to String,
/// and [decode] dynamic data back to [CallSummaryTypeEnum].
class CallSummaryTypeEnumTypeTransformer {
  factory CallSummaryTypeEnumTypeTransformer() => _instance ??= const CallSummaryTypeEnumTypeTransformer._();

  const CallSummaryTypeEnumTypeTransformer._();

  String encode(CallSummaryTypeEnum data) => data._value;

  /// Returns the instance of [CallSummaryTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CallSummaryTypeEnum.audio;
        case r'video': return CallSummaryTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryTypeEnumTypeTransformer? _instance;
}



enum CallSummaryStatusEnum {
  ringing._(r'ringing'),
  active._(r'active'),
  ended._(r'ended'),
  missed._(r'missed'),
  rejected._(r'rejected'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryStatusEnum? fromJson(dynamic value) => CallSummaryStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryStatusEnum] to String,
/// and [decode] dynamic data back to [CallSummaryStatusEnum].
class CallSummaryStatusEnumTypeTransformer {
  factory CallSummaryStatusEnumTypeTransformer() => _instance ??= const CallSummaryStatusEnumTypeTransformer._();

  const CallSummaryStatusEnumTypeTransformer._();

  String encode(CallSummaryStatusEnum data) => data._value;

  /// Returns the instance of [CallSummaryStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'ringing': return CallSummaryStatusEnum.ringing;
        case r'active': return CallSummaryStatusEnum.active;
        case r'ended': return CallSummaryStatusEnum.ended;
        case r'missed': return CallSummaryStatusEnum.missed;
        case r'rejected': return CallSummaryStatusEnum.rejected;
        case r'failed': return CallSummaryStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryStatusEnumTypeTransformer? _instance;
}


/// outgoing = I was the caller
enum CallSummaryDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallSummaryDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallSummaryDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallSummaryDirectionEnum? fromJson(dynamic value) => CallSummaryDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallSummaryDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallSummaryDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSummaryDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSummaryDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallSummaryDirectionEnum] to String,
/// and [decode] dynamic data back to [CallSummaryDirectionEnum].
class CallSummaryDirectionEnumTypeTransformer {
  factory CallSummaryDirectionEnumTypeTransformer() => _instance ??= const CallSummaryDirectionEnumTypeTransformer._();

  const CallSummaryDirectionEnumTypeTransformer._();

  String encode(CallSummaryDirectionEnum data) => data._value;

  /// Returns the instance of [CallSummaryDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallSummaryDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallSummaryDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return CallSummaryDirectionEnum.outgoing;
        case r'incoming': return CallSummaryDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallSummaryDirectionEnumTypeTransformer? _instance;
}


