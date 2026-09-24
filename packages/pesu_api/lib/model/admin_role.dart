//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRole {
  /// Returns a new [AdminRole] instance.
  AdminRole({
    required this.code,
    required this.name,
    required this.description,
    this.permissions = const [],
    required this.isSystem,
    required this.isAdmin,
    required this.members,
  });

  String code;

  String name;

  String description;

  List<AdminRolePermissionsEnum> permissions;

  bool isSystem;

  /// The built-in Admin role: every permission, can't be edited
  bool isAdmin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int members;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRole &&
    other.code == code &&
    other.name == name &&
    other.description == description &&
    _deepEquality.equals(other.permissions, permissions) &&
    other.isSystem == isSystem &&
    other.isAdmin == isAdmin &&
    other.members == members;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (name.hashCode) +
    (description.hashCode) +
    (permissions.hashCode) +
    (isSystem.hashCode) +
    (isAdmin.hashCode) +
    (members.hashCode);

  @override
  String toString() => 'AdminRole[code=$code, name=$name, description=$description, permissions=$permissions, isSystem=$isSystem, isAdmin=$isAdmin, members=$members]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'description'] = this.description;
      json[r'permissions'] = this.permissions;
      json[r'isSystem'] = this.isSystem;
      json[r'isAdmin'] = this.isAdmin;
      json[r'members'] = this.members;
    return json;
  }

  /// Returns a new [AdminRole] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRole? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminRole[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminRole[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminRole[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminRole[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "AdminRole[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "AdminRole[description]" has a null value in JSON.');
        assert(json.containsKey(r'permissions'), 'Required key "AdminRole[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null, 'Required key "AdminRole[permissions]" has a null value in JSON.');
        assert(json.containsKey(r'isSystem'), 'Required key "AdminRole[isSystem]" is missing from JSON.');
        assert(json[r'isSystem'] != null, 'Required key "AdminRole[isSystem]" has a null value in JSON.');
        assert(json.containsKey(r'isAdmin'), 'Required key "AdminRole[isAdmin]" is missing from JSON.');
        assert(json[r'isAdmin'] != null, 'Required key "AdminRole[isAdmin]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "AdminRole[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "AdminRole[members]" has a null value in JSON.');
        return true;
      }());

      return AdminRole(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        permissions: AdminRolePermissionsEnum.listFromJson(json[r'permissions']),
        isSystem: mapValueOfType<bool>(json, r'isSystem')!,
        isAdmin: mapValueOfType<bool>(json, r'isAdmin')!,
        members: mapValueOfType<int>(json, r'members')!,
      );
    }
    return null;
  }

  static List<AdminRole> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRole>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRole.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRole> mapFromJson(dynamic json) {
    final map = <String, AdminRole>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRole.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRole-objects as value to a dart map
  static Map<String, List<AdminRole>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRole>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRole.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'name',
    'description',
    'permissions',
    'isSystem',
    'isAdmin',
    'members',
  };
}


enum AdminRolePermissionsEnum {
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
  const AdminRolePermissionsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRolePermissionsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRolePermissionsEnum? fromJson(dynamic value) => AdminRolePermissionsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRolePermissionsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRolePermissionsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRolePermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRolePermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRolePermissionsEnum] to String,
/// and [decode] dynamic data back to [AdminRolePermissionsEnum].
class AdminRolePermissionsEnumTypeTransformer {
  factory AdminRolePermissionsEnumTypeTransformer() => _instance ??= const AdminRolePermissionsEnumTypeTransformer._();

  const AdminRolePermissionsEnumTypeTransformer._();

  String encode(AdminRolePermissionsEnum data) => data._value;

  /// Returns the instance of [AdminRolePermissionsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRolePermissionsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRolePermissionsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dashboard.view': return AdminRolePermissionsEnum.dashboardPeriodView;
        case r'audit.view': return AdminRolePermissionsEnum.auditPeriodView;
        case r'analytics.view': return AdminRolePermissionsEnum.analyticsPeriodView;
        case r'users.view': return AdminRolePermissionsEnum.usersPeriodView;
        case r'users.manage': return AdminRolePermissionsEnum.usersPeriodManage;
        case r'users.coins': return AdminRolePermissionsEnum.usersPeriodCoins;
        case r'users.vip': return AdminRolePermissionsEnum.usersPeriodVip;
        case r'kyc.review': return AdminRolePermissionsEnum.kycPeriodReview;
        case r'companions.video': return AdminRolePermissionsEnum.companionsPeriodVideo;
        case r'reports.review': return AdminRolePermissionsEnum.reportsPeriodReview;
        case r'moderation.review': return AdminRolePermissionsEnum.moderationPeriodReview;
        case r'rooms.manage': return AdminRolePermissionsEnum.roomsPeriodManage;
        case r'payouts.view': return AdminRolePermissionsEnum.payoutsPeriodView;
        case r'payouts.decide': return AdminRolePermissionsEnum.payoutsPeriodDecide;
        case r'refunds.review': return AdminRolePermissionsEnum.refundsPeriodReview;
        case r'pricing.manage': return AdminRolePermissionsEnum.pricingPeriodManage;
        case r'engagement.manage': return AdminRolePermissionsEnum.engagementPeriodManage;
        case r'promotions.manage': return AdminRolePermissionsEnum.promotionsPeriodManage;
        case r'staff.manage': return AdminRolePermissionsEnum.staffPeriodManage;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRolePermissionsEnumTypeTransformer? _instance;
}


