//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseActivityInner {
  /// Returns a new [AdminDashboard200ResponseActivityInner] instance.
  AdminDashboard200ResponseActivityInner({
    required this.kind,
    required this.at,
    required this.user,
    required this.otherName,
    required this.callType,
    required this.minutes,
    required this.coins,
    required this.paise,
  });

  AdminDashboard200ResponseActivityInnerKindEnum kind;

  DateTime at;

  AdminDashboard200ResponseActivityInnerUser user;

  /// call: the caller; report: the reported user
  String? otherName;

  AdminDashboard200ResponseActivityInnerCallTypeEnum? callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? paise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseActivityInner &&
    other.kind == kind &&
    other.at == at &&
    other.user == user &&
    other.otherName == otherName &&
    other.callType == callType &&
    other.minutes == minutes &&
    other.coins == coins &&
    other.paise == paise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (at.hashCode) +
    (user.hashCode) +
    (otherName == null ? 0 : otherName!.hashCode) +
    (callType == null ? 0 : callType!.hashCode) +
    (minutes == null ? 0 : minutes!.hashCode) +
    (coins == null ? 0 : coins!.hashCode) +
    (paise == null ? 0 : paise!.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseActivityInner[kind=$kind, at=$at, user=$user, otherName=$otherName, callType=$callType, minutes=$minutes, coins=$coins, paise=$paise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
      json[r'at'] = this.at.toUtc().toIso8601String();
      json[r'user'] = this.user;
    if (this.otherName != null) {
      json[r'otherName'] = this.otherName;
    } else {
      json[r'otherName'] = null;
    }
    if (this.callType != null) {
      json[r'callType'] = this.callType;
    } else {
      json[r'callType'] = null;
    }
    if (this.minutes != null) {
      json[r'minutes'] = this.minutes;
    } else {
      json[r'minutes'] = null;
    }
    if (this.coins != null) {
      json[r'coins'] = this.coins;
    } else {
      json[r'coins'] = null;
    }
    if (this.paise != null) {
      json[r'paise'] = this.paise;
    } else {
      json[r'paise'] = null;
    }
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseActivityInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseActivityInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "AdminDashboard200ResponseActivityInner[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "AdminDashboard200ResponseActivityInner[kind]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "AdminDashboard200ResponseActivityInner[at]" is missing from JSON.');
        assert(json[r'at'] != null, 'Required key "AdminDashboard200ResponseActivityInner[at]" has a null value in JSON.');
        assert(json.containsKey(r'user'), 'Required key "AdminDashboard200ResponseActivityInner[user]" is missing from JSON.');
        assert(json[r'user'] != null, 'Required key "AdminDashboard200ResponseActivityInner[user]" has a null value in JSON.');
        assert(json.containsKey(r'otherName'), 'Required key "AdminDashboard200ResponseActivityInner[otherName]" is missing from JSON.');
        assert(json.containsKey(r'callType'), 'Required key "AdminDashboard200ResponseActivityInner[callType]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminDashboard200ResponseActivityInner[minutes]" is missing from JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminDashboard200ResponseActivityInner[coins]" is missing from JSON.');
        assert(json.containsKey(r'paise'), 'Required key "AdminDashboard200ResponseActivityInner[paise]" is missing from JSON.');
        return true;
      }());

      return AdminDashboard200ResponseActivityInner(
        kind: AdminDashboard200ResponseActivityInnerKindEnum.fromJson(json[r'kind'])!,
        at: mapDateTime(json, r'at', r'')!,
        user: AdminDashboard200ResponseActivityInnerUser.fromJson(json[r'user'])!,
        otherName: mapValueOfType<String>(json, r'otherName'),
        callType: AdminDashboard200ResponseActivityInnerCallTypeEnum.fromJson(json[r'callType']),
        minutes: mapValueOfType<int>(json, r'minutes'),
        coins: mapValueOfType<int>(json, r'coins'),
        paise: mapValueOfType<int>(json, r'paise'),
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseActivityInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseActivityInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseActivityInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseActivityInner> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseActivityInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseActivityInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseActivityInner-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseActivityInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseActivityInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseActivityInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'at',
    'user',
    'otherName',
    'callType',
    'minutes',
    'coins',
    'paise',
  };
}


enum AdminDashboard200ResponseActivityInnerKindEnum {
  call._(r'call'),
  signup._(r'signup'),
  kycSubmitted._(r'kyc_submitted'),
  kycApproved._(r'kyc_approved'),
  payout._(r'payout'),
  report._(r'report'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminDashboard200ResponseActivityInnerKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminDashboard200ResponseActivityInnerKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminDashboard200ResponseActivityInnerKindEnum? fromJson(dynamic value) => AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminDashboard200ResponseActivityInnerKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminDashboard200ResponseActivityInnerKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseActivityInnerKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseActivityInnerKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDashboard200ResponseActivityInnerKindEnum] to String,
/// and [decode] dynamic data back to [AdminDashboard200ResponseActivityInnerKindEnum].
class AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer {
  factory AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer() => _instance ??= const AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer._();

  const AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer._();

  String encode(AdminDashboard200ResponseActivityInnerKindEnum data) => data._value;

  /// Returns the instance of [AdminDashboard200ResponseActivityInnerKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDashboard200ResponseActivityInnerKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminDashboard200ResponseActivityInnerKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call': return AdminDashboard200ResponseActivityInnerKindEnum.call;
        case r'signup': return AdminDashboard200ResponseActivityInnerKindEnum.signup;
        case r'kyc_submitted': return AdminDashboard200ResponseActivityInnerKindEnum.kycSubmitted;
        case r'kyc_approved': return AdminDashboard200ResponseActivityInnerKindEnum.kycApproved;
        case r'payout': return AdminDashboard200ResponseActivityInnerKindEnum.payout;
        case r'report': return AdminDashboard200ResponseActivityInnerKindEnum.report;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminDashboard200ResponseActivityInnerKindEnumTypeTransformer? _instance;
}



enum AdminDashboard200ResponseActivityInnerCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminDashboard200ResponseActivityInnerCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminDashboard200ResponseActivityInnerCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminDashboard200ResponseActivityInnerCallTypeEnum? fromJson(dynamic value) => AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminDashboard200ResponseActivityInnerCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminDashboard200ResponseActivityInnerCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseActivityInnerCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseActivityInnerCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDashboard200ResponseActivityInnerCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminDashboard200ResponseActivityInnerCallTypeEnum].
class AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer {
  factory AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer() => _instance ??= const AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer._();

  const AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer._();

  String encode(AdminDashboard200ResponseActivityInnerCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminDashboard200ResponseActivityInnerCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDashboard200ResponseActivityInnerCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminDashboard200ResponseActivityInnerCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminDashboard200ResponseActivityInnerCallTypeEnum.audio;
        case r'video': return AdminDashboard200ResponseActivityInnerCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminDashboard200ResponseActivityInnerCallTypeEnumTypeTransformer? _instance;
}


