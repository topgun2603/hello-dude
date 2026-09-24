//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CoinHistoryItem {
  /// Returns a new [CoinHistoryItem] instance.
  CoinHistoryItem({
    required this.key,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.at,
    required this.callId,
    required this.callType,
    required this.otherName,
    required this.otherAvatarId,
  });

  /// Stable id for the line
  String key;

  CoinHistoryItemKindEnum kind;

  String title;

  String? subtitle;

  /// Signed coins: negative = spent
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int amount;

  DateTime at;

  String? callId;

  CoinHistoryItemCallTypeEnum? callType;

  String? otherName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? otherAvatarId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CoinHistoryItem &&
    other.key == key &&
    other.kind == kind &&
    other.title == title &&
    other.subtitle == subtitle &&
    other.amount == amount &&
    other.at == at &&
    other.callId == callId &&
    other.callType == callType &&
    other.otherName == otherName &&
    other.otherAvatarId == otherAvatarId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (kind.hashCode) +
    (title.hashCode) +
    (subtitle == null ? 0 : subtitle!.hashCode) +
    (amount.hashCode) +
    (at.hashCode) +
    (callId == null ? 0 : callId!.hashCode) +
    (callType == null ? 0 : callType!.hashCode) +
    (otherName == null ? 0 : otherName!.hashCode) +
    (otherAvatarId == null ? 0 : otherAvatarId!.hashCode);

  @override
  String toString() => 'CoinHistoryItem[key=$key, kind=$kind, title=$title, subtitle=$subtitle, amount=$amount, at=$at, callId=$callId, callType=$callType, otherName=$otherName, otherAvatarId=$otherAvatarId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'kind'] = this.kind;
      json[r'title'] = this.title;
    if (this.subtitle != null) {
      json[r'subtitle'] = this.subtitle;
    } else {
      json[r'subtitle'] = null;
    }
      json[r'amount'] = this.amount;
      json[r'at'] = this.at.toUtc().toIso8601String();
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
    if (this.callType != null) {
      json[r'callType'] = this.callType;
    } else {
      json[r'callType'] = null;
    }
    if (this.otherName != null) {
      json[r'otherName'] = this.otherName;
    } else {
      json[r'otherName'] = null;
    }
    if (this.otherAvatarId != null) {
      json[r'otherAvatarId'] = this.otherAvatarId;
    } else {
      json[r'otherAvatarId'] = null;
    }
    return json;
  }

  /// Returns a new [CoinHistoryItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoinHistoryItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "CoinHistoryItem[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "CoinHistoryItem[key]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "CoinHistoryItem[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "CoinHistoryItem[kind]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "CoinHistoryItem[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "CoinHistoryItem[title]" has a null value in JSON.');
        assert(json.containsKey(r'subtitle'), 'Required key "CoinHistoryItem[subtitle]" is missing from JSON.');
        assert(json.containsKey(r'amount'), 'Required key "CoinHistoryItem[amount]" is missing from JSON.');
        assert(json[r'amount'] != null, 'Required key "CoinHistoryItem[amount]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "CoinHistoryItem[at]" is missing from JSON.');
        assert(json[r'at'] != null, 'Required key "CoinHistoryItem[at]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "CoinHistoryItem[callId]" is missing from JSON.');
        assert(json.containsKey(r'callType'), 'Required key "CoinHistoryItem[callType]" is missing from JSON.');
        assert(json.containsKey(r'otherName'), 'Required key "CoinHistoryItem[otherName]" is missing from JSON.');
        assert(json.containsKey(r'otherAvatarId'), 'Required key "CoinHistoryItem[otherAvatarId]" is missing from JSON.');
        return true;
      }());

      return CoinHistoryItem(
        key: mapValueOfType<String>(json, r'key')!,
        kind: CoinHistoryItemKindEnum.fromJson(json[r'kind'])!,
        title: mapValueOfType<String>(json, r'title')!,
        subtitle: mapValueOfType<String>(json, r'subtitle'),
        amount: mapValueOfType<int>(json, r'amount')!,
        at: mapDateTime(json, r'at', r'')!,
        callId: mapValueOfType<String>(json, r'callId'),
        callType: CoinHistoryItemCallTypeEnum.fromJson(json[r'callType']),
        otherName: mapValueOfType<String>(json, r'otherName'),
        otherAvatarId: mapValueOfType<int>(json, r'otherAvatarId'),
      );
    }
    return null;
  }

  static List<CoinHistoryItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoinHistoryItem> mapFromJson(dynamic json) {
    final map = <String, CoinHistoryItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoinHistoryItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoinHistoryItem-objects as value to a dart map
  static Map<String, List<CoinHistoryItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CoinHistoryItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoinHistoryItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'kind',
    'title',
    'subtitle',
    'amount',
    'at',
    'callId',
    'callType',
    'otherName',
    'otherAvatarId',
  };
}


enum CoinHistoryItemKindEnum {
  call._(r'call'),
  gift._(r'gift'),
  purchase._(r'purchase'),
  bonus._(r'bonus'),
  refund._(r'refund'),
  booking._(r'booking'),
  adjustment._(r'adjustment'),
  live._(r'live'),
  group._(r'group'),
  ;

  /// Instantiate a new enum with the provided value.
  const CoinHistoryItemKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CoinHistoryItemKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CoinHistoryItemKindEnum? fromJson(dynamic value) => CoinHistoryItemKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CoinHistoryItemKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CoinHistoryItemKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItemKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItemKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CoinHistoryItemKindEnum] to String,
/// and [decode] dynamic data back to [CoinHistoryItemKindEnum].
class CoinHistoryItemKindEnumTypeTransformer {
  factory CoinHistoryItemKindEnumTypeTransformer() => _instance ??= const CoinHistoryItemKindEnumTypeTransformer._();

  const CoinHistoryItemKindEnumTypeTransformer._();

  String encode(CoinHistoryItemKindEnum data) => data._value;

  /// Returns the instance of [CoinHistoryItemKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CoinHistoryItemKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CoinHistoryItemKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call': return CoinHistoryItemKindEnum.call;
        case r'gift': return CoinHistoryItemKindEnum.gift;
        case r'purchase': return CoinHistoryItemKindEnum.purchase;
        case r'bonus': return CoinHistoryItemKindEnum.bonus;
        case r'refund': return CoinHistoryItemKindEnum.refund;
        case r'booking': return CoinHistoryItemKindEnum.booking;
        case r'adjustment': return CoinHistoryItemKindEnum.adjustment;
        case r'live': return CoinHistoryItemKindEnum.live;
        case r'group': return CoinHistoryItemKindEnum.group;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CoinHistoryItemKindEnumTypeTransformer? _instance;
}



enum CoinHistoryItemCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CoinHistoryItemCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CoinHistoryItemCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CoinHistoryItemCallTypeEnum? fromJson(dynamic value) => CoinHistoryItemCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CoinHistoryItemCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CoinHistoryItemCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItemCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItemCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CoinHistoryItemCallTypeEnum] to String,
/// and [decode] dynamic data back to [CoinHistoryItemCallTypeEnum].
class CoinHistoryItemCallTypeEnumTypeTransformer {
  factory CoinHistoryItemCallTypeEnumTypeTransformer() => _instance ??= const CoinHistoryItemCallTypeEnumTypeTransformer._();

  const CoinHistoryItemCallTypeEnumTypeTransformer._();

  String encode(CoinHistoryItemCallTypeEnum data) => data._value;

  /// Returns the instance of [CoinHistoryItemCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CoinHistoryItemCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CoinHistoryItemCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CoinHistoryItemCallTypeEnum.audio;
        case r'video': return CoinHistoryItemCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CoinHistoryItemCallTypeEnumTypeTransformer? _instance;
}


