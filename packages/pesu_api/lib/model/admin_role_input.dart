//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRoleInput {
  /// Returns a new [AdminRoleInput] instance.
  AdminRoleInput({
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

  List<AdminRoleInputPermissionsEnum> permissions;

  bool isSystem;

  /// The built-in Admin role: every permission, can't be edited
  bool isAdmin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int members;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRoleInput &&
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
  String toString() => 'AdminRoleInput[code=$code, name=$name, description=$description, permissions=$permissions, isSystem=$isSystem, isAdmin=$isAdmin, members=$members]';

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

  /// Returns a new [AdminRoleInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRoleInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminRoleInput[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminRoleInput[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminRoleInput[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminRoleInput[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "AdminRoleInput[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "AdminRoleInput[description]" has a null value in JSON.');
        assert(json.containsKey(r'permissions'), 'Required key "AdminRoleInput[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null, 'Required key "AdminRoleInput[permissions]" has a null value in JSON.');
        assert(json.containsKey(r'isSystem'), 'Required key "AdminRoleInput[isSystem]" is missing from JSON.');
        assert(json[r'isSystem'] != null, 'Required key "AdminRoleInput[isSystem]" has a null value in JSON.');
        assert(json.containsKey(r'isAdmin'), 'Required key "AdminRoleInput[isAdmin]" is missing from JSON.');
        assert(json[r'isAdmin'] != null, 'Required key "AdminRoleInput[isAdmin]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "AdminRoleInput[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "AdminRoleInput[members]" has a null value in JSON.');
        return true;
      }());

      return AdminRoleInput(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        permissions: AdminRoleInputPermissionsEnum.listFromJson(json[r'permissions']),
        isSystem: mapValueOfType<bool>(json, r'isSystem')!,
        isAdmin: mapValueOfType<bool>(json, r'isAdmin')!,
        members: mapValueOfType<int>(json, r'members')!,
      );
    }
    return null;
  }

  static List<AdminRoleInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRoleInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRoleInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRoleInput> mapFromJson(dynamic json) {
    final map = <String, AdminRoleInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRoleInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRoleInput-objects as value to a dart map
  static Map<String, List<AdminRoleInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRoleInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRoleInput.listFromJson(entry.value, growable: growable,);
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


enum AdminRoleInputPermissionsEnum {
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
  const AdminRoleInputPermissionsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRoleInputPermissionsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRoleInputPermissionsEnum? fromJson(dynamic value) => AdminRoleInputPermissionsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRoleInputPermissionsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRoleInputPermissionsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRoleInputPermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRoleInputPermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRoleInputPermissionsEnum] to String,
/// and [decode] dynamic data back to [AdminRoleInputPermissionsEnum].
class AdminRoleInputPermissionsEnumTypeTransformer {
  factory AdminRoleInputPermissionsEnumTypeTransformer() => _instance ??= const AdminRoleInputPermissionsEnumTypeTransformer._();

  const AdminRoleInputPermissionsEnumTypeTransformer._();

  String encode(AdminRoleInputPermissionsEnum data) => data._value;

  /// Returns the instance of [AdminRoleInputPermissionsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRoleInputPermissionsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRoleInputPermissionsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dashboard.view': return AdminRoleInputPermissionsEnum.dashboardPeriodView;
        case r'audit.view': return AdminRoleInputPermissionsEnum.auditPeriodView;
        case r'analytics.view': return AdminRoleInputPermissionsEnum.analyticsPeriodView;
        case r'users.view': return AdminRoleInputPermissionsEnum.usersPeriodView;
        case r'users.manage': return AdminRoleInputPermissionsEnum.usersPeriodManage;
        case r'users.coins': return AdminRoleInputPermissionsEnum.usersPeriodCoins;
        case r'users.vip': return AdminRoleInputPermissionsEnum.usersPeriodVip;
        case r'kyc.review': return AdminRoleInputPermissionsEnum.kycPeriodReview;
        case r'companions.video': return AdminRoleInputPermissionsEnum.companionsPeriodVideo;
        case r'reports.review': return AdminRoleInputPermissionsEnum.reportsPeriodReview;
        case r'moderation.review': return AdminRoleInputPermissionsEnum.moderationPeriodReview;
        case r'rooms.manage': return AdminRoleInputPermissionsEnum.roomsPeriodManage;
        case r'payouts.view': return AdminRoleInputPermissionsEnum.payoutsPeriodView;
        case r'payouts.decide': return AdminRoleInputPermissionsEnum.payoutsPeriodDecide;
        case r'refunds.review': return AdminRoleInputPermissionsEnum.refundsPeriodReview;
        case r'pricing.manage': return AdminRoleInputPermissionsEnum.pricingPeriodManage;
        case r'engagement.manage': return AdminRoleInputPermissionsEnum.engagementPeriodManage;
        case r'promotions.manage': return AdminRoleInputPermissionsEnum.promotionsPeriodManage;
        case r'staff.manage': return AdminRoleInputPermissionsEnum.staffPeriodManage;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRoleInputPermissionsEnumTypeTransformer? _instance;
}


