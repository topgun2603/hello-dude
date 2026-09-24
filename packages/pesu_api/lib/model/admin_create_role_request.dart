//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreateRoleRequest {
  /// Returns a new [AdminCreateRoleRequest] instance.
  AdminCreateRoleRequest({
    required this.name,
    this.description = '',
    this.permissions = const [],
  });

  String name;

  String description;

  List<AdminCreateRoleRequestPermissionsEnum> permissions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreateRoleRequest &&
    other.name == name &&
    other.description == description &&
    _deepEquality.equals(other.permissions, permissions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (description.hashCode) +
    (permissions.hashCode);

  @override
  String toString() => 'AdminCreateRoleRequest[name=$name, description=$description, permissions=$permissions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'description'] = this.description;
      json[r'permissions'] = this.permissions;
    return json;
  }

  /// Returns a new [AdminCreateRoleRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreateRoleRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminCreateRoleRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminCreateRoleRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'permissions'), 'Required key "AdminCreateRoleRequest[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null, 'Required key "AdminCreateRoleRequest[permissions]" has a null value in JSON.');
        return true;
      }());

      return AdminCreateRoleRequest(
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description') ?? '',
        permissions: AdminCreateRoleRequestPermissionsEnum.listFromJson(json[r'permissions']),
      );
    }
    return null;
  }

  static List<AdminCreateRoleRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateRoleRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateRoleRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreateRoleRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreateRoleRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreateRoleRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreateRoleRequest-objects as value to a dart map
  static Map<String, List<AdminCreateRoleRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreateRoleRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreateRoleRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'permissions',
  };
}


enum AdminCreateRoleRequestPermissionsEnum {
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
  const AdminCreateRoleRequestPermissionsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreateRoleRequestPermissionsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreateRoleRequestPermissionsEnum? fromJson(dynamic value) => AdminCreateRoleRequestPermissionsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreateRoleRequestPermissionsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreateRoleRequestPermissionsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateRoleRequestPermissionsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateRoleRequestPermissionsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreateRoleRequestPermissionsEnum] to String,
/// and [decode] dynamic data back to [AdminCreateRoleRequestPermissionsEnum].
class AdminCreateRoleRequestPermissionsEnumTypeTransformer {
  factory AdminCreateRoleRequestPermissionsEnumTypeTransformer() => _instance ??= const AdminCreateRoleRequestPermissionsEnumTypeTransformer._();

  const AdminCreateRoleRequestPermissionsEnumTypeTransformer._();

  String encode(AdminCreateRoleRequestPermissionsEnum data) => data._value;

  /// Returns the instance of [AdminCreateRoleRequestPermissionsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreateRoleRequestPermissionsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreateRoleRequestPermissionsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dashboard.view': return AdminCreateRoleRequestPermissionsEnum.dashboardPeriodView;
        case r'audit.view': return AdminCreateRoleRequestPermissionsEnum.auditPeriodView;
        case r'analytics.view': return AdminCreateRoleRequestPermissionsEnum.analyticsPeriodView;
        case r'users.view': return AdminCreateRoleRequestPermissionsEnum.usersPeriodView;
        case r'users.manage': return AdminCreateRoleRequestPermissionsEnum.usersPeriodManage;
        case r'users.coins': return AdminCreateRoleRequestPermissionsEnum.usersPeriodCoins;
        case r'users.vip': return AdminCreateRoleRequestPermissionsEnum.usersPeriodVip;
        case r'kyc.review': return AdminCreateRoleRequestPermissionsEnum.kycPeriodReview;
        case r'companions.video': return AdminCreateRoleRequestPermissionsEnum.companionsPeriodVideo;
        case r'reports.review': return AdminCreateRoleRequestPermissionsEnum.reportsPeriodReview;
        case r'moderation.review': return AdminCreateRoleRequestPermissionsEnum.moderationPeriodReview;
        case r'rooms.manage': return AdminCreateRoleRequestPermissionsEnum.roomsPeriodManage;
        case r'payouts.view': return AdminCreateRoleRequestPermissionsEnum.payoutsPeriodView;
        case r'payouts.decide': return AdminCreateRoleRequestPermissionsEnum.payoutsPeriodDecide;
        case r'refunds.review': return AdminCreateRoleRequestPermissionsEnum.refundsPeriodReview;
        case r'pricing.manage': return AdminCreateRoleRequestPermissionsEnum.pricingPeriodManage;
        case r'engagement.manage': return AdminCreateRoleRequestPermissionsEnum.engagementPeriodManage;
        case r'promotions.manage': return AdminCreateRoleRequestPermissionsEnum.promotionsPeriodManage;
        case r'staff.manage': return AdminCreateRoleRequestPermissionsEnum.staffPeriodManage;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreateRoleRequestPermissionsEnumTypeTransformer? _instance;
}


