//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class BookingInput {
  /// Returns a new [BookingInput] instance.
  BookingInput({
    required this.id,
    required this.status,
    required this.startAt,
    required this.minutes,
    required this.callType,
    required this.coinsPerMin,
    required this.heldCoins,
    required this.caller,
    required this.companion,
    required this.canStart,
  });

  String id;

  BookingInputStatusEnum status;

  Object? startAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  BookingInputCallTypeEnum callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int heldCoins;

  RoomCardInputHost caller;

  RoomCardInputHost companion;

  /// Caller: the \"Call now\" window is open
  bool canStart;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingInput &&
    other.id == id &&
    other.status == status &&
    other.startAt == startAt &&
    other.minutes == minutes &&
    other.callType == callType &&
    other.coinsPerMin == coinsPerMin &&
    other.heldCoins == heldCoins &&
    other.caller == caller &&
    other.companion == companion &&
    other.canStart == canStart;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (startAt == null ? 0 : startAt!.hashCode) +
    (minutes.hashCode) +
    (callType.hashCode) +
    (coinsPerMin.hashCode) +
    (heldCoins.hashCode) +
    (caller.hashCode) +
    (companion.hashCode) +
    (canStart.hashCode);

  @override
  String toString() => 'BookingInput[id=$id, status=$status, startAt=$startAt, minutes=$minutes, callType=$callType, coinsPerMin=$coinsPerMin, heldCoins=$heldCoins, caller=$caller, companion=$companion, canStart=$canStart]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
    if (this.startAt != null) {
      json[r'startAt'] = this.startAt;
    } else {
      json[r'startAt'] = null;
    }
      json[r'minutes'] = this.minutes;
      json[r'callType'] = this.callType;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'heldCoins'] = this.heldCoins;
      json[r'caller'] = this.caller;
      json[r'companion'] = this.companion;
      json[r'canStart'] = this.canStart;
    return json;
  }

  /// Returns a new [BookingInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "BookingInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "BookingInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "BookingInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "BookingInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'startAt'), 'Required key "BookingInput[startAt]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "BookingInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "BookingInput[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'callType'), 'Required key "BookingInput[callType]" is missing from JSON.');
        assert(json[r'callType'] != null, 'Required key "BookingInput[callType]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "BookingInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "BookingInput[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'heldCoins'), 'Required key "BookingInput[heldCoins]" is missing from JSON.');
        assert(json[r'heldCoins'] != null, 'Required key "BookingInput[heldCoins]" has a null value in JSON.');
        assert(json.containsKey(r'caller'), 'Required key "BookingInput[caller]" is missing from JSON.');
        assert(json[r'caller'] != null, 'Required key "BookingInput[caller]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "BookingInput[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "BookingInput[companion]" has a null value in JSON.');
        assert(json.containsKey(r'canStart'), 'Required key "BookingInput[canStart]" is missing from JSON.');
        assert(json[r'canStart'] != null, 'Required key "BookingInput[canStart]" has a null value in JSON.');
        return true;
      }());

      return BookingInput(
        id: mapValueOfType<String>(json, r'id')!,
        status: BookingInputStatusEnum.fromJson(json[r'status'])!,
        startAt: mapValueOfType<Object>(json, r'startAt'),
        minutes: mapValueOfType<int>(json, r'minutes')!,
        callType: BookingInputCallTypeEnum.fromJson(json[r'callType'])!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        heldCoins: mapValueOfType<int>(json, r'heldCoins')!,
        caller: RoomCardInputHost.fromJson(json[r'caller'])!,
        companion: RoomCardInputHost.fromJson(json[r'companion'])!,
        canStart: mapValueOfType<bool>(json, r'canStart')!,
      );
    }
    return null;
  }

  static List<BookingInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingInput> mapFromJson(dynamic json) {
    final map = <String, BookingInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingInput-objects as value to a dart map
  static Map<String, List<BookingInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'startAt',
    'minutes',
    'callType',
    'coinsPerMin',
    'heldCoins',
    'caller',
    'companion',
    'canStart',
  };
}


enum BookingInputStatusEnum {
  requested._(r'requested'),
  confirmed._(r'confirmed'),
  declined._(r'declined'),
  expired._(r'expired'),
  cancelled._(r'cancelled'),
  started._(r'started'),
  completed._(r'completed'),
  missed._(r'missed'),
  ;

  /// Instantiate a new enum with the provided value.
  const BookingInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [BookingInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static BookingInputStatusEnum? fromJson(dynamic value) => BookingInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [BookingInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<BookingInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingInputStatusEnum] to String,
/// and [decode] dynamic data back to [BookingInputStatusEnum].
class BookingInputStatusEnumTypeTransformer {
  factory BookingInputStatusEnumTypeTransformer() => _instance ??= const BookingInputStatusEnumTypeTransformer._();

  const BookingInputStatusEnumTypeTransformer._();

  String encode(BookingInputStatusEnum data) => data._value;

  /// Returns the instance of [BookingInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is BookingInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return BookingInputStatusEnum.requested;
        case r'confirmed': return BookingInputStatusEnum.confirmed;
        case r'declined': return BookingInputStatusEnum.declined;
        case r'expired': return BookingInputStatusEnum.expired;
        case r'cancelled': return BookingInputStatusEnum.cancelled;
        case r'started': return BookingInputStatusEnum.started;
        case r'completed': return BookingInputStatusEnum.completed;
        case r'missed': return BookingInputStatusEnum.missed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static BookingInputStatusEnumTypeTransformer? _instance;
}



enum BookingInputCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const BookingInputCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [BookingInputCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static BookingInputCallTypeEnum? fromJson(dynamic value) => BookingInputCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [BookingInputCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<BookingInputCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingInputCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingInputCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingInputCallTypeEnum] to String,
/// and [decode] dynamic data back to [BookingInputCallTypeEnum].
class BookingInputCallTypeEnumTypeTransformer {
  factory BookingInputCallTypeEnumTypeTransformer() => _instance ??= const BookingInputCallTypeEnumTypeTransformer._();

  const BookingInputCallTypeEnumTypeTransformer._();

  String encode(BookingInputCallTypeEnum data) => data._value;

  /// Returns the instance of [BookingInputCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingInputCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is BookingInputCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return BookingInputCallTypeEnum.audio;
        case r'video': return BookingInputCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static BookingInputCallTypeEnumTypeTransformer? _instance;
}


