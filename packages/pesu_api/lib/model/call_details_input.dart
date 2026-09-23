//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallDetailsInput {
  /// Returns a new [CallDetailsInput] instance.
  CallDetailsInput({
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
    this.gifts = const [],
    required this.refundRequest,
    this.minutes = const [],
  });

  String id;

  CallDetailsInputTypeEnum type;

  CallDetailsInputStatusEnum status;

  /// outgoing = I was the caller
  CallDetailsInputDirectionEnum direction;

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

  List<CallDetailsInputGiftsInner> gifts;

  RefundRequestInput? refundRequest;

  List<CallDetailsInputMinutesInner> minutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallDetailsInput &&
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
    other.myRating == myRating &&
    _deepEquality.equals(other.gifts, gifts) &&
    other.refundRequest == refundRequest &&
    _deepEquality.equals(other.minutes, minutes);

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
    (myRating == null ? 0 : myRating!.hashCode) +
    (gifts.hashCode) +
    (refundRequest == null ? 0 : refundRequest!.hashCode) +
    (minutes.hashCode);

  @override
  String toString() => 'CallDetailsInput[id=$id, type=$type, status=$status, direction=$direction, other=$other, language=$language, coinsPerMin=$coinsPerMin, createdAt=$createdAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason, durationSeconds=$durationSeconds, minutesCharged=$minutesCharged, coinsCharged=$coinsCharged, coinsRefunded=$coinsRefunded, paiseEarned=$paiseEarned, myRating=$myRating, gifts=$gifts, refundRequest=$refundRequest, minutes=$minutes]';

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
      json[r'gifts'] = this.gifts;
    if (this.refundRequest != null) {
      json[r'refundRequest'] = this.refundRequest;
    } else {
      json[r'refundRequest'] = null;
    }
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [CallDetailsInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDetailsInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CallDetailsInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CallDetailsInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "CallDetailsInput[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "CallDetailsInput[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CallDetailsInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CallDetailsInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "CallDetailsInput[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "CallDetailsInput[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "CallDetailsInput[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "CallDetailsInput[other]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "CallDetailsInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "CallDetailsInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "CallDetailsInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "CallDetailsInput[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "CallDetailsInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "CallDetailsInput[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "CallDetailsInput[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "CallDetailsInput[endReason]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "CallDetailsInput[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'minutesCharged'), 'Required key "CallDetailsInput[minutesCharged]" is missing from JSON.');
        assert(json[r'minutesCharged'] != null, 'Required key "CallDetailsInput[minutesCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsCharged'), 'Required key "CallDetailsInput[coinsCharged]" is missing from JSON.');
        assert(json[r'coinsCharged'] != null, 'Required key "CallDetailsInput[coinsCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "CallDetailsInput[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "CallDetailsInput[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "CallDetailsInput[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "CallDetailsInput[paiseEarned]" has a null value in JSON.');
        assert(json.containsKey(r'myRating'), 'Required key "CallDetailsInput[myRating]" is missing from JSON.');
        assert(json.containsKey(r'gifts'), 'Required key "CallDetailsInput[gifts]" is missing from JSON.');
        assert(json[r'gifts'] != null, 'Required key "CallDetailsInput[gifts]" has a null value in JSON.');
        assert(json.containsKey(r'refundRequest'), 'Required key "CallDetailsInput[refundRequest]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "CallDetailsInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "CallDetailsInput[minutes]" has a null value in JSON.');
        return true;
      }());

      return CallDetailsInput(
        id: mapValueOfType<String>(json, r'id')!,
        type: CallDetailsInputTypeEnum.fromJson(json[r'type'])!,
        status: CallDetailsInputStatusEnum.fromJson(json[r'status'])!,
        direction: CallDetailsInputDirectionEnum.fromJson(json[r'direction'])!,
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
        gifts: CallDetailsInputGiftsInner.listFromJson(json[r'gifts']),
        refundRequest: RefundRequestInput.fromJson(json[r'refundRequest']),
        minutes: CallDetailsInputMinutesInner.listFromJson(json[r'minutes']),
      );
    }
    return null;
  }

  static List<CallDetailsInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDetailsInput> mapFromJson(dynamic json) {
    final map = <String, CallDetailsInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDetailsInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDetailsInput-objects as value to a dart map
  static Map<String, List<CallDetailsInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallDetailsInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDetailsInput.listFromJson(entry.value, growable: growable,);
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
    'gifts',
    'refundRequest',
    'minutes',
  };
}


enum CallDetailsInputTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsInputTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsInputTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsInputTypeEnum? fromJson(dynamic value) => CallDetailsInputTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsInputTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsInputTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInputTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInputTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsInputTypeEnum] to String,
/// and [decode] dynamic data back to [CallDetailsInputTypeEnum].
class CallDetailsInputTypeEnumTypeTransformer {
  factory CallDetailsInputTypeEnumTypeTransformer() => _instance ??= const CallDetailsInputTypeEnumTypeTransformer._();

  const CallDetailsInputTypeEnumTypeTransformer._();

  String encode(CallDetailsInputTypeEnum data) => data._value;

  /// Returns the instance of [CallDetailsInputTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsInputTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsInputTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CallDetailsInputTypeEnum.audio;
        case r'video': return CallDetailsInputTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsInputTypeEnumTypeTransformer? _instance;
}



enum CallDetailsInputStatusEnum {
  ringing._(r'ringing'),
  active._(r'active'),
  ended._(r'ended'),
  missed._(r'missed'),
  rejected._(r'rejected'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsInputStatusEnum? fromJson(dynamic value) => CallDetailsInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsInputStatusEnum] to String,
/// and [decode] dynamic data back to [CallDetailsInputStatusEnum].
class CallDetailsInputStatusEnumTypeTransformer {
  factory CallDetailsInputStatusEnumTypeTransformer() => _instance ??= const CallDetailsInputStatusEnumTypeTransformer._();

  const CallDetailsInputStatusEnumTypeTransformer._();

  String encode(CallDetailsInputStatusEnum data) => data._value;

  /// Returns the instance of [CallDetailsInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'ringing': return CallDetailsInputStatusEnum.ringing;
        case r'active': return CallDetailsInputStatusEnum.active;
        case r'ended': return CallDetailsInputStatusEnum.ended;
        case r'missed': return CallDetailsInputStatusEnum.missed;
        case r'rejected': return CallDetailsInputStatusEnum.rejected;
        case r'failed': return CallDetailsInputStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsInputStatusEnumTypeTransformer? _instance;
}


/// outgoing = I was the caller
enum CallDetailsInputDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsInputDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsInputDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsInputDirectionEnum? fromJson(dynamic value) => CallDetailsInputDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsInputDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsInputDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInputDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInputDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsInputDirectionEnum] to String,
/// and [decode] dynamic data back to [CallDetailsInputDirectionEnum].
class CallDetailsInputDirectionEnumTypeTransformer {
  factory CallDetailsInputDirectionEnumTypeTransformer() => _instance ??= const CallDetailsInputDirectionEnumTypeTransformer._();

  const CallDetailsInputDirectionEnumTypeTransformer._();

  String encode(CallDetailsInputDirectionEnum data) => data._value;

  /// Returns the instance of [CallDetailsInputDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsInputDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsInputDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return CallDetailsInputDirectionEnum.outgoing;
        case r'incoming': return CallDetailsInputDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsInputDirectionEnumTypeTransformer? _instance;
}


