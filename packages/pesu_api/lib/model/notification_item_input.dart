//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class NotificationItemInput {
  /// Returns a new [NotificationItemInput] instance.
  NotificationItemInput({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data = const {},
    required this.read,
    required this.createdAt,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  NotificationItemInputTypeEnum type;

  String title;

  String body;

  Map<String, String> data;

  bool read;

  Object? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationItemInput &&
    other.id == id &&
    other.type == type &&
    other.title == title &&
    other.body == body &&
    _deepEquality.equals(other.data, data) &&
    other.read == read &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (data.hashCode) +
    (read.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'NotificationItemInput[id=$id, type=$type, title=$title, body=$body, data=$data, read=$read, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
      json[r'data'] = this.data;
      json[r'read'] = this.read;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [NotificationItemInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationItemInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "NotificationItemInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "NotificationItemInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "NotificationItemInput[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "NotificationItemInput[type]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "NotificationItemInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "NotificationItemInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "NotificationItemInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "NotificationItemInput[body]" has a null value in JSON.');
        assert(json.containsKey(r'data'), 'Required key "NotificationItemInput[data]" is missing from JSON.');
        assert(json[r'data'] != null, 'Required key "NotificationItemInput[data]" has a null value in JSON.');
        assert(json.containsKey(r'read'), 'Required key "NotificationItemInput[read]" is missing from JSON.');
        assert(json[r'read'] != null, 'Required key "NotificationItemInput[read]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "NotificationItemInput[createdAt]" is missing from JSON.');
        return true;
      }());

      return NotificationItemInput(
        id: mapValueOfType<int>(json, r'id')!,
        type: NotificationItemInputTypeEnum.fromJson(json[r'type'])!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        data: mapCastOfType<String, String>(json, r'data')!,
        read: mapValueOfType<bool>(json, r'read')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<NotificationItemInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationItemInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationItemInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationItemInput> mapFromJson(dynamic json) {
    final map = <String, NotificationItemInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationItemInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationItemInput-objects as value to a dart map
  static Map<String, List<NotificationItemInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationItemInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationItemInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
    'title',
    'body',
    'data',
    'read',
    'createdAt',
  };
}


enum NotificationItemInputTypeEnum {
  favouriteOnline._(r'favourite_online'),
  bookingRequested._(r'booking_requested'),
  bookingConfirmed._(r'booking_confirmed'),
  bookingCancelled._(r'booking_cancelled'),
  bookingReminder._(r'booking_reminder'),
  refundDecided._(r'refund_decided'),
  dailyBonus._(r'daily_bonus'),
  rateCall._(r'rate_call'),
  referralJoined._(r'referral_joined'),
  referralRewarded._(r'referral_rewarded'),
  reportActioned._(r'report_actioned'),
  supportCoins._(r'support_coins'),
  adminMessage._(r'admin_message'),
  payoutPaid._(r'payout_paid'),
  payoutFailed._(r'payout_failed'),
  kycDecided._(r'kyc_decided'),
  chatMessage._(r'chat_message'),
  roomLive._(r'room_live'),
  vip._(r'vip'),
  bonusEarned._(r'bonus_earned'),
  ;

  /// Instantiate a new enum with the provided value.
  const NotificationItemInputTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [NotificationItemInputTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static NotificationItemInputTypeEnum? fromJson(dynamic value) => NotificationItemInputTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [NotificationItemInputTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<NotificationItemInputTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationItemInputTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationItemInputTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [NotificationItemInputTypeEnum] to String,
/// and [decode] dynamic data back to [NotificationItemInputTypeEnum].
class NotificationItemInputTypeEnumTypeTransformer {
  factory NotificationItemInputTypeEnumTypeTransformer() => _instance ??= const NotificationItemInputTypeEnumTypeTransformer._();

  const NotificationItemInputTypeEnumTypeTransformer._();

  String encode(NotificationItemInputTypeEnum data) => data._value;

  /// Returns the instance of [NotificationItemInputTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  NotificationItemInputTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is NotificationItemInputTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'favourite_online': return NotificationItemInputTypeEnum.favouriteOnline;
        case r'booking_requested': return NotificationItemInputTypeEnum.bookingRequested;
        case r'booking_confirmed': return NotificationItemInputTypeEnum.bookingConfirmed;
        case r'booking_cancelled': return NotificationItemInputTypeEnum.bookingCancelled;
        case r'booking_reminder': return NotificationItemInputTypeEnum.bookingReminder;
        case r'refund_decided': return NotificationItemInputTypeEnum.refundDecided;
        case r'daily_bonus': return NotificationItemInputTypeEnum.dailyBonus;
        case r'rate_call': return NotificationItemInputTypeEnum.rateCall;
        case r'referral_joined': return NotificationItemInputTypeEnum.referralJoined;
        case r'referral_rewarded': return NotificationItemInputTypeEnum.referralRewarded;
        case r'report_actioned': return NotificationItemInputTypeEnum.reportActioned;
        case r'support_coins': return NotificationItemInputTypeEnum.supportCoins;
        case r'admin_message': return NotificationItemInputTypeEnum.adminMessage;
        case r'payout_paid': return NotificationItemInputTypeEnum.payoutPaid;
        case r'payout_failed': return NotificationItemInputTypeEnum.payoutFailed;
        case r'kyc_decided': return NotificationItemInputTypeEnum.kycDecided;
        case r'chat_message': return NotificationItemInputTypeEnum.chatMessage;
        case r'room_live': return NotificationItemInputTypeEnum.roomLive;
        case r'vip': return NotificationItemInputTypeEnum.vip;
        case r'bonus_earned': return NotificationItemInputTypeEnum.bonusEarned;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static NotificationItemInputTypeEnumTypeTransformer? _instance;
}


