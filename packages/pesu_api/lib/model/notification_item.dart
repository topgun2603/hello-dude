//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class NotificationItem {
  /// Returns a new [NotificationItem] instance.
  NotificationItem({
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

  NotificationItemTypeEnum type;

  String title;

  String body;

  Map<String, String> data;

  bool read;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationItem &&
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
    (createdAt.hashCode);

  @override
  String toString() => 'NotificationItem[id=$id, type=$type, title=$title, body=$body, data=$data, read=$read, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
      json[r'data'] = this.data;
      json[r'read'] = this.read;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [NotificationItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "NotificationItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "NotificationItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "NotificationItem[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "NotificationItem[type]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "NotificationItem[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "NotificationItem[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "NotificationItem[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "NotificationItem[body]" has a null value in JSON.');
        assert(json.containsKey(r'data'), 'Required key "NotificationItem[data]" is missing from JSON.');
        assert(json[r'data'] != null, 'Required key "NotificationItem[data]" has a null value in JSON.');
        assert(json.containsKey(r'read'), 'Required key "NotificationItem[read]" is missing from JSON.');
        assert(json[r'read'] != null, 'Required key "NotificationItem[read]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "NotificationItem[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "NotificationItem[createdAt]" has a null value in JSON.');
        return true;
      }());

      return NotificationItem(
        id: mapValueOfType<int>(json, r'id')!,
        type: NotificationItemTypeEnum.fromJson(json[r'type'])!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        data: mapCastOfType<String, String>(json, r'data')!,
        read: mapValueOfType<bool>(json, r'read')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<NotificationItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationItem> mapFromJson(dynamic json) {
    final map = <String, NotificationItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationItem-objects as value to a dart map
  static Map<String, List<NotificationItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationItem.listFromJson(entry.value, growable: growable,);
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


enum NotificationItemTypeEnum {
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
  liveStarted._(r'live_started'),
  groupOpen._(r'group_open'),
  groupReminder._(r'group_reminder'),
  groupCancelled._(r'group_cancelled'),
  photoDecided._(r'photo_decided'),
  chatRequest._(r'chat_request'),
  chatRequestAccepted._(r'chat_request_accepted'),
  callInvite._(r'call_invite'),
  badgeWon._(r'badge_won'),
  levelUp._(r'level_up'),
  vip._(r'vip'),
  bonusEarned._(r'bonus_earned'),
  ;

  /// Instantiate a new enum with the provided value.
  const NotificationItemTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [NotificationItemTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static NotificationItemTypeEnum? fromJson(dynamic value) => NotificationItemTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [NotificationItemTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<NotificationItemTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationItemTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationItemTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [NotificationItemTypeEnum] to String,
/// and [decode] dynamic data back to [NotificationItemTypeEnum].
class NotificationItemTypeEnumTypeTransformer {
  factory NotificationItemTypeEnumTypeTransformer() => _instance ??= const NotificationItemTypeEnumTypeTransformer._();

  const NotificationItemTypeEnumTypeTransformer._();

  String encode(NotificationItemTypeEnum data) => data._value;

  /// Returns the instance of [NotificationItemTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  NotificationItemTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is NotificationItemTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'favourite_online': return NotificationItemTypeEnum.favouriteOnline;
        case r'booking_requested': return NotificationItemTypeEnum.bookingRequested;
        case r'booking_confirmed': return NotificationItemTypeEnum.bookingConfirmed;
        case r'booking_cancelled': return NotificationItemTypeEnum.bookingCancelled;
        case r'booking_reminder': return NotificationItemTypeEnum.bookingReminder;
        case r'refund_decided': return NotificationItemTypeEnum.refundDecided;
        case r'daily_bonus': return NotificationItemTypeEnum.dailyBonus;
        case r'rate_call': return NotificationItemTypeEnum.rateCall;
        case r'referral_joined': return NotificationItemTypeEnum.referralJoined;
        case r'referral_rewarded': return NotificationItemTypeEnum.referralRewarded;
        case r'report_actioned': return NotificationItemTypeEnum.reportActioned;
        case r'support_coins': return NotificationItemTypeEnum.supportCoins;
        case r'admin_message': return NotificationItemTypeEnum.adminMessage;
        case r'payout_paid': return NotificationItemTypeEnum.payoutPaid;
        case r'payout_failed': return NotificationItemTypeEnum.payoutFailed;
        case r'kyc_decided': return NotificationItemTypeEnum.kycDecided;
        case r'chat_message': return NotificationItemTypeEnum.chatMessage;
        case r'room_live': return NotificationItemTypeEnum.roomLive;
        case r'live_started': return NotificationItemTypeEnum.liveStarted;
        case r'group_open': return NotificationItemTypeEnum.groupOpen;
        case r'group_reminder': return NotificationItemTypeEnum.groupReminder;
        case r'group_cancelled': return NotificationItemTypeEnum.groupCancelled;
        case r'photo_decided': return NotificationItemTypeEnum.photoDecided;
        case r'chat_request': return NotificationItemTypeEnum.chatRequest;
        case r'chat_request_accepted': return NotificationItemTypeEnum.chatRequestAccepted;
        case r'call_invite': return NotificationItemTypeEnum.callInvite;
        case r'badge_won': return NotificationItemTypeEnum.badgeWon;
        case r'level_up': return NotificationItemTypeEnum.levelUp;
        case r'vip': return NotificationItemTypeEnum.vip;
        case r'bonus_earned': return NotificationItemTypeEnum.bonusEarned;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static NotificationItemTypeEnumTypeTransformer? _instance;
}


