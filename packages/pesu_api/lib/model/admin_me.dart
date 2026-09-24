//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminMe {
  /// Returns a new [AdminMe] instance.
  AdminMe({
    required this.id,
    required this.displayName,
    required this.roleCode,
    required this.roleName,
    this.permissions = const [],
  });

  String id;

  String displayName;

  String roleCode;

  String roleName;

  List<AdminMePermissionsEnum> permissions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminMe &&
    other.id == id &&
    other.displayName == displayName &&
    other.roleCode == roleCode &&
    other.roleName == roleName &&
    _deepEquality.equals(other.permissions, permissions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (roleCode.hashCode) +
    (roleName.hashCode) +
    (permissions.hashCode);

  @override
  String toString() => 'AdminMe[id=$id, displayName=$displayName, roleCode=$roleCode, roleName=$roleName, permissions=$permissions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'roleCode'] = this.roleCode;
      json[r'roleName'] = this.roleName;
      json[r'permissions'] = this.permissions;
    return json;
  }

  /// Returns a new [AdminMe] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminMe? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminMe[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminMe[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminMe[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminMe[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'roleCode'), 'Required key "AdminMe[roleCode]" is missing from JSON.');
        assert(json[r'roleCode'] != null, 'Required key "AdminMe[roleCode]" has a null value in JSON.');
        assert(json.containsKey(r'roleName'), 'Required key "AdminMe[roleName]" is missing from JSON.');
        assert(json[r'roleName'] != null, 'Required key "AdminMe[roleName]" has a null value in JSON.');
        assert(json.containsKey(r'permissions'), 'Required key "AdminMe[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null, 'Required key "AdminMe[permissions]" has a null value in JSON.');
        return true;
      }());

      return AdminMe(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        roleCode: mapValueOfType<String>(json, r'roleCode')!,
        roleName: mapValueOfType<String>(json, r'roleName')!,
        permissions: AdminMePermissionsEnum.listFromJson(json[r'permissions']),
      );
    }
    return null;
  }

  static List<AdminMe> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminMe>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminMe.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminMe> mapFromJson(dynamic json) {
    final map = <String, AdminMe>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminMe.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminMe-objects as value to a dart map
  static Map<String, List<AdminMe>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminMe>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminMe.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'roleCode',
    'roleName',
    'permissions',
  };
}


enum AdminMePermissionsEnum {
  dashboardPeriodView._(r'dashboard.view'),
  auditPeriodView._(r'audit.view'),
  analyticsPeriodView._(r'analytics.view'),
  usersPeriodView._(r'users.view'),
  usersPeriodManage._(r'users.manage'),
  usersPeriodCoins._(r'users.coins'),
  usersPeriodVip._(r'users.vip'),
  kycPeriodReview._(r'kyc.review'),
  companionsPeriodVideo._(r'companions.video'),
  reportsPeriodReview._(r'reports.review'),
  moderationPeriodReview._(r'moderation.review'),
  roomsPeriodManage._(r'rooms.manage'),
  payoutsPeriodView._(r'payouts.view'),
  payoutsPeriodDecide._(r'payouts.decide'),
  refundsPeriodReview._(r'refunds.review'),
  pricingPeriodManage._(r'pricing.manage'),
  engagementPeriodManage._(r'engagement.manage'),
  promotionsPeriodManage._(r'promotions.manage'),
  staffPeriodManage._(r'staff.manage'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminMePermissionsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminMePermissionsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminMePermissionsEnum? fromJson(dynamic value) => AdminMePermissionsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminMePermissionsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminMePermissionsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminMePermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminMePermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminMePermissionsEnum] to String,
/// and [decode] dynamic data back to [AdminMePermissionsEnum].
class AdminMePermissionsEnumTypeTransformer {
  factory AdminMePermissionsEnumTypeTransformer() => _instance ??= const AdminMePermissionsEnumTypeTransformer._();

  const AdminMePermissionsEnumTypeTransformer._();

  String encode(AdminMePermissionsEnum data) => data._value;

  /// Returns the instance of [AdminMePermissionsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminMePermissionsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminMePermissionsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dashboard.view': return AdminMePermissionsEnum.dashboardPeriodView;
        case r'audit.view': return AdminMePermissionsEnum.auditPeriodView;
        case r'analytics.view': return AdminMePermissionsEnum.analyticsPeriodView;
        case r'users.view': return AdminMePermissionsEnum.usersPeriodView;
        case r'users.manage': return AdminMePermissionsEnum.usersPeriodManage;
        case r'users.coins': return AdminMePermissionsEnum.usersPeriodCoins;
        case r'users.vip': return AdminMePermissionsEnum.usersPeriodVip;
        case r'kyc.review': return AdminMePermissionsEnum.kycPeriodReview;
        case r'companions.video': return AdminMePermissionsEnum.companionsPeriodVideo;
        case r'reports.review': return AdminMePermissionsEnum.reportsPeriodReview;
        case r'moderation.review': return AdminMePermissionsEnum.moderationPeriodReview;
        case r'rooms.manage': return AdminMePermissionsEnum.roomsPeriodManage;
        case r'payouts.view': return AdminMePermissionsEnum.payoutsPeriodView;
        case r'payouts.decide': return AdminMePermissionsEnum.payoutsPeriodDecide;
        case r'refunds.review': return AdminMePermissionsEnum.refundsPeriodReview;
        case r'pricing.manage': return AdminMePermissionsEnum.pricingPeriodManage;
        case r'engagement.manage': return AdminMePermissionsEnum.engagementPeriodManage;
        case r'promotions.manage': return AdminMePermissionsEnum.promotionsPeriodManage;
        case r'staff.manage': return AdminMePermissionsEnum.staffPeriodManage;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminMePermissionsEnumTypeTransformer? _instance;
}


