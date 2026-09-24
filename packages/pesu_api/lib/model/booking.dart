//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Booking {
  /// Returns a new [Booking] instance.
  Booking({
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

  BookingStatusEnum status;

  DateTime startAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  BookingCallTypeEnum callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int heldCoins;

  RoomCardHost caller;

  RoomCardHost companion;

  /// Caller: the \"Call now\" window is open
  bool canStart;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Booking &&
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
    (startAt.hashCode) +
    (minutes.hashCode) +
    (callType.hashCode) +
    (coinsPerMin.hashCode) +
    (heldCoins.hashCode) +
    (caller.hashCode) +
    (companion.hashCode) +
    (canStart.hashCode);

  @override
  String toString() => 'Booking[id=$id, status=$status, startAt=$startAt, minutes=$minutes, callType=$callType, coinsPerMin=$coinsPerMin, heldCoins=$heldCoins, caller=$caller, companion=$companion, canStart=$canStart]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
      json[r'startAt'] = this.startAt.toUtc().toIso8601String();
      json[r'minutes'] = this.minutes;
      json[r'callType'] = this.callType;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'heldCoins'] = this.heldCoins;
      json[r'caller'] = this.caller;
      json[r'companion'] = this.companion;
      json[r'canStart'] = this.canStart;
    return json;
  }

  /// Returns a new [Booking] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Booking? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Booking[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Booking[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Booking[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Booking[status]" has a null value in JSON.');
        assert(json.containsKey(r'startAt'), 'Required key "Booking[startAt]" is missing from JSON.');
        assert(json[r'startAt'] != null, 'Required key "Booking[startAt]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "Booking[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "Booking[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'callType'), 'Required key "Booking[callType]" is missing from JSON.');
        assert(json[r'callType'] != null, 'Required key "Booking[callType]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "Booking[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "Booking[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'heldCoins'), 'Required key "Booking[heldCoins]" is missing from JSON.');
        assert(json[r'heldCoins'] != null, 'Required key "Booking[heldCoins]" has a null value in JSON.');
        assert(json.containsKey(r'caller'), 'Required key "Booking[caller]" is missing from JSON.');
        assert(json[r'caller'] != null, 'Required key "Booking[caller]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "Booking[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "Booking[companion]" has a null value in JSON.');
        assert(json.containsKey(r'canStart'), 'Required key "Booking[canStart]" is missing from JSON.');
        assert(json[r'canStart'] != null, 'Required key "Booking[canStart]" has a null value in JSON.');
        return true;
      }());

      return Booking(
        id: mapValueOfType<String>(json, r'id')!,
        status: BookingStatusEnum.fromJson(json[r'status'])!,
        startAt: mapDateTime(json, r'startAt', r'')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        callType: BookingCallTypeEnum.fromJson(json[r'callType'])!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        heldCoins: mapValueOfType<int>(json, r'heldCoins')!,
        caller: RoomCardHost.fromJson(json[r'caller'])!,
        companion: RoomCardHost.fromJson(json[r'companion'])!,
        canStart: mapValueOfType<bool>(json, r'canStart')!,
      );
    }
    return null;
  }

  static List<Booking> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Booking>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Booking.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Booking> mapFromJson(dynamic json) {
    final map = <String, Booking>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Booking.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Booking-objects as value to a dart map
  static Map<String, List<Booking>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Booking>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Booking.listFromJson(entry.value, growable: growable,);
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


enum BookingStatusEnum {
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
  const BookingStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [BookingStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static BookingStatusEnum? fromJson(dynamic value) => BookingStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [BookingStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<BookingStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingStatusEnum] to String,
/// and [decode] dynamic data back to [BookingStatusEnum].
class BookingStatusEnumTypeTransformer {
  factory BookingStatusEnumTypeTransformer() => _instance ??= const BookingStatusEnumTypeTransformer._();

  const BookingStatusEnumTypeTransformer._();

  String encode(BookingStatusEnum data) => data._value;

  /// Returns the instance of [BookingStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is BookingStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return BookingStatusEnum.requested;
        case r'confirmed': return BookingStatusEnum.confirmed;
        case r'declined': return BookingStatusEnum.declined;
        case r'expired': return BookingStatusEnum.expired;
        case r'cancelled': return BookingStatusEnum.cancelled;
        case r'started': return BookingStatusEnum.started;
        case r'completed': return BookingStatusEnum.completed;
        case r'missed': return BookingStatusEnum.missed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static BookingStatusEnumTypeTransformer? _instance;
}



enum BookingCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const BookingCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [BookingCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static BookingCallTypeEnum? fromJson(dynamic value) => BookingCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [BookingCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<BookingCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingCallTypeEnum] to String,
/// and [decode] dynamic data back to [BookingCallTypeEnum].
class BookingCallTypeEnumTypeTransformer {
  factory BookingCallTypeEnumTypeTransformer() => _instance ??= const BookingCallTypeEnumTypeTransformer._();

  const BookingCallTypeEnumTypeTransformer._();

  String encode(BookingCallTypeEnum data) => data._value;

  /// Returns the instance of [BookingCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is BookingCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return BookingCallTypeEnum.audio;
        case r'video': return BookingCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static BookingCallTypeEnumTypeTransformer? _instance;
}


