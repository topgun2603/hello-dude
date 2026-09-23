//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallDetails {
  /// Returns a new [CallDetails] instance.
  CallDetails({
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

  CallDetailsTypeEnum type;

  CallDetailsStatusEnum status;

  /// outgoing = I was the caller
  CallDetailsDirectionEnum direction;

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

  List<CallDetailsGiftsInner> gifts;

  RefundRequest? refundRequest;

  List<CallDetailsMinutesInner> minutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallDetails &&
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
    (createdAt.hashCode) +
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
  String toString() => 'CallDetails[id=$id, type=$type, status=$status, direction=$direction, other=$other, language=$language, coinsPerMin=$coinsPerMin, createdAt=$createdAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason, durationSeconds=$durationSeconds, minutesCharged=$minutesCharged, coinsCharged=$coinsCharged, coinsRefunded=$coinsRefunded, paiseEarned=$paiseEarned, myRating=$myRating, gifts=$gifts, refundRequest=$refundRequest, minutes=$minutes]';

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
      json[r'gifts'] = this.gifts;
    if (this.refundRequest != null) {
      json[r'refundRequest'] = this.refundRequest;
    } else {
      json[r'refundRequest'] = null;
    }
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [CallDetails] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDetails? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CallDetails[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CallDetails[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "CallDetails[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "CallDetails[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CallDetails[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CallDetails[status]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "CallDetails[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "CallDetails[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "CallDetails[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "CallDetails[other]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "CallDetails[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "CallDetails[language]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "CallDetails[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "CallDetails[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "CallDetails[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "CallDetails[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "CallDetails[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "CallDetails[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "CallDetails[endReason]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "CallDetails[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'minutesCharged'), 'Required key "CallDetails[minutesCharged]" is missing from JSON.');
        assert(json[r'minutesCharged'] != null, 'Required key "CallDetails[minutesCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsCharged'), 'Required key "CallDetails[coinsCharged]" is missing from JSON.');
        assert(json[r'coinsCharged'] != null, 'Required key "CallDetails[coinsCharged]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "CallDetails[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "CallDetails[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "CallDetails[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "CallDetails[paiseEarned]" has a null value in JSON.');
        assert(json.containsKey(r'myRating'), 'Required key "CallDetails[myRating]" is missing from JSON.');
        assert(json.containsKey(r'gifts'), 'Required key "CallDetails[gifts]" is missing from JSON.');
        assert(json[r'gifts'] != null, 'Required key "CallDetails[gifts]" has a null value in JSON.');
        assert(json.containsKey(r'refundRequest'), 'Required key "CallDetails[refundRequest]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "CallDetails[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "CallDetails[minutes]" has a null value in JSON.');
        return true;
      }());

      return CallDetails(
        id: mapValueOfType<String>(json, r'id')!,
        type: CallDetailsTypeEnum.fromJson(json[r'type'])!,
        status: CallDetailsStatusEnum.fromJson(json[r'status'])!,
        direction: CallDetailsDirectionEnum.fromJson(json[r'direction'])!,
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
        gifts: CallDetailsGiftsInner.listFromJson(json[r'gifts']),
        refundRequest: RefundRequest.fromJson(json[r'refundRequest']),
        minutes: CallDetailsMinutesInner.listFromJson(json[r'minutes']),
      );
    }
    return null;
  }

  static List<CallDetails> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetails>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetails.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDetails> mapFromJson(dynamic json) {
    final map = <String, CallDetails>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDetails.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDetails-objects as value to a dart map
  static Map<String, List<CallDetails>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallDetails>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDetails.listFromJson(entry.value, growable: growable,);
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


enum CallDetailsTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsTypeEnum? fromJson(dynamic value) => CallDetailsTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsTypeEnum] to String,
/// and [decode] dynamic data back to [CallDetailsTypeEnum].
class CallDetailsTypeEnumTypeTransformer {
  factory CallDetailsTypeEnumTypeTransformer() => _instance ??= const CallDetailsTypeEnumTypeTransformer._();

  const CallDetailsTypeEnumTypeTransformer._();

  String encode(CallDetailsTypeEnum data) => data._value;

  /// Returns the instance of [CallDetailsTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CallDetailsTypeEnum.audio;
        case r'video': return CallDetailsTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsTypeEnumTypeTransformer? _instance;
}



enum CallDetailsStatusEnum {
  ringing._(r'ringing'),
  active._(r'active'),
  ended._(r'ended'),
  missed._(r'missed'),
  rejected._(r'rejected'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsStatusEnum? fromJson(dynamic value) => CallDetailsStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsStatusEnum] to String,
/// and [decode] dynamic data back to [CallDetailsStatusEnum].
class CallDetailsStatusEnumTypeTransformer {
  factory CallDetailsStatusEnumTypeTransformer() => _instance ??= const CallDetailsStatusEnumTypeTransformer._();

  const CallDetailsStatusEnumTypeTransformer._();

  String encode(CallDetailsStatusEnum data) => data._value;

  /// Returns the instance of [CallDetailsStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'ringing': return CallDetailsStatusEnum.ringing;
        case r'active': return CallDetailsStatusEnum.active;
        case r'ended': return CallDetailsStatusEnum.ended;
        case r'missed': return CallDetailsStatusEnum.missed;
        case r'rejected': return CallDetailsStatusEnum.rejected;
        case r'failed': return CallDetailsStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsStatusEnumTypeTransformer? _instance;
}


/// outgoing = I was the caller
enum CallDetailsDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CallDetailsDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CallDetailsDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CallDetailsDirectionEnum? fromJson(dynamic value) => CallDetailsDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CallDetailsDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CallDetailsDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CallDetailsDirectionEnum] to String,
/// and [decode] dynamic data back to [CallDetailsDirectionEnum].
class CallDetailsDirectionEnumTypeTransformer {
  factory CallDetailsDirectionEnumTypeTransformer() => _instance ??= const CallDetailsDirectionEnumTypeTransformer._();

  const CallDetailsDirectionEnumTypeTransformer._();

  String encode(CallDetailsDirectionEnum data) => data._value;

  /// Returns the instance of [CallDetailsDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CallDetailsDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CallDetailsDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return CallDetailsDirectionEnum.outgoing;
        case r'incoming': return CallDetailsDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CallDetailsDirectionEnumTypeTransformer? _instance;
}


