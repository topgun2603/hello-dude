//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CoinHistoryItemInput {
  /// Returns a new [CoinHistoryItemInput] instance.
  CoinHistoryItemInput({
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

  CoinHistoryItemInputKindEnum kind;

  String title;

  String? subtitle;

  /// Signed coins: negative = spent
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int amount;

  Object? at;

  String? callId;

  CoinHistoryItemInputCallTypeEnum? callType;

  String? otherName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? otherAvatarId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CoinHistoryItemInput &&
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
    (at == null ? 0 : at!.hashCode) +
    (callId == null ? 0 : callId!.hashCode) +
    (callType == null ? 0 : callType!.hashCode) +
    (otherName == null ? 0 : otherName!.hashCode) +
    (otherAvatarId == null ? 0 : otherAvatarId!.hashCode);

  @override
  String toString() => 'CoinHistoryItemInput[key=$key, kind=$kind, title=$title, subtitle=$subtitle, amount=$amount, at=$at, callId=$callId, callType=$callType, otherName=$otherName, otherAvatarId=$otherAvatarId]';

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
    if (this.at != null) {
      json[r'at'] = this.at;
    } else {
      json[r'at'] = null;
    }
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

  /// Returns a new [CoinHistoryItemInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoinHistoryItemInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "CoinHistoryItemInput[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "CoinHistoryItemInput[key]" has a null value in JSON.');
        assert(json.containsKey(r'kind'), 'Required key "CoinHistoryItemInput[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "CoinHistoryItemInput[kind]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "CoinHistoryItemInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "CoinHistoryItemInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'subtitle'), 'Required key "CoinHistoryItemInput[subtitle]" is missing from JSON.');
        assert(json.containsKey(r'amount'), 'Required key "CoinHistoryItemInput[amount]" is missing from JSON.');
        assert(json[r'amount'] != null, 'Required key "CoinHistoryItemInput[amount]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "CoinHistoryItemInput[at]" is missing from JSON.');
        assert(json.containsKey(r'callId'), 'Required key "CoinHistoryItemInput[callId]" is missing from JSON.');
        assert(json.containsKey(r'callType'), 'Required key "CoinHistoryItemInput[callType]" is missing from JSON.');
        assert(json.containsKey(r'otherName'), 'Required key "CoinHistoryItemInput[otherName]" is missing from JSON.');
        assert(json.containsKey(r'otherAvatarId'), 'Required key "CoinHistoryItemInput[otherAvatarId]" is missing from JSON.');
        return true;
      }());

      return CoinHistoryItemInput(
        key: mapValueOfType<String>(json, r'key')!,
        kind: CoinHistoryItemInputKindEnum.fromJson(json[r'kind'])!,
        title: mapValueOfType<String>(json, r'title')!,
        subtitle: mapValueOfType<String>(json, r'subtitle'),
        amount: mapValueOfType<int>(json, r'amount')!,
        at: mapValueOfType<Object>(json, r'at'),
        callId: mapValueOfType<String>(json, r'callId'),
        callType: CoinHistoryItemInputCallTypeEnum.fromJson(json[r'callType']),
        otherName: mapValueOfType<String>(json, r'otherName'),
        otherAvatarId: mapValueOfType<int>(json, r'otherAvatarId'),
      );
    }
    return null;
  }

  static List<CoinHistoryItemInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItemInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItemInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoinHistoryItemInput> mapFromJson(dynamic json) {
    final map = <String, CoinHistoryItemInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoinHistoryItemInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoinHistoryItemInput-objects as value to a dart map
  static Map<String, List<CoinHistoryItemInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CoinHistoryItemInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoinHistoryItemInput.listFromJson(entry.value, growable: growable,);
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


enum CoinHistoryItemInputKindEnum {
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
  const CoinHistoryItemInputKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CoinHistoryItemInputKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CoinHistoryItemInputKindEnum? fromJson(dynamic value) => CoinHistoryItemInputKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CoinHistoryItemInputKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CoinHistoryItemInputKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItemInputKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItemInputKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CoinHistoryItemInputKindEnum] to String,
/// and [decode] dynamic data back to [CoinHistoryItemInputKindEnum].
class CoinHistoryItemInputKindEnumTypeTransformer {
  factory CoinHistoryItemInputKindEnumTypeTransformer() => _instance ??= const CoinHistoryItemInputKindEnumTypeTransformer._();

  const CoinHistoryItemInputKindEnumTypeTransformer._();

  String encode(CoinHistoryItemInputKindEnum data) => data._value;

  /// Returns the instance of [CoinHistoryItemInputKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CoinHistoryItemInputKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CoinHistoryItemInputKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call': return CoinHistoryItemInputKindEnum.call;
        case r'gift': return CoinHistoryItemInputKindEnum.gift;
        case r'purchase': return CoinHistoryItemInputKindEnum.purchase;
        case r'bonus': return CoinHistoryItemInputKindEnum.bonus;
        case r'refund': return CoinHistoryItemInputKindEnum.refund;
        case r'booking': return CoinHistoryItemInputKindEnum.booking;
        case r'adjustment': return CoinHistoryItemInputKindEnum.adjustment;
        case r'live': return CoinHistoryItemInputKindEnum.live;
        case r'group': return CoinHistoryItemInputKindEnum.group;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CoinHistoryItemInputKindEnumTypeTransformer? _instance;
}



enum CoinHistoryItemInputCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CoinHistoryItemInputCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CoinHistoryItemInputCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CoinHistoryItemInputCallTypeEnum? fromJson(dynamic value) => CoinHistoryItemInputCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CoinHistoryItemInputCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CoinHistoryItemInputCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistoryItemInputCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistoryItemInputCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CoinHistoryItemInputCallTypeEnum] to String,
/// and [decode] dynamic data back to [CoinHistoryItemInputCallTypeEnum].
class CoinHistoryItemInputCallTypeEnumTypeTransformer {
  factory CoinHistoryItemInputCallTypeEnumTypeTransformer() => _instance ??= const CoinHistoryItemInputCallTypeEnumTypeTransformer._();

  const CoinHistoryItemInputCallTypeEnumTypeTransformer._();

  String encode(CoinHistoryItemInputCallTypeEnum data) => data._value;

  /// Returns the instance of [CoinHistoryItemInputCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CoinHistoryItemInputCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CoinHistoryItemInputCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CoinHistoryItemInputCallTypeEnum.audio;
        case r'video': return CoinHistoryItemInputCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CoinHistoryItemInputCallTypeEnumTypeTransformer? _instance;
}


