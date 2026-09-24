//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminListRoles200ResponsePermissionsInner {
  /// Returns a new [AdminListRoles200ResponsePermissionsInner] instance.
  AdminListRoles200ResponsePermissionsInner({
    required this.code,
    required this.group,
    required this.label,
  });

  AdminListRoles200ResponsePermissionsInnerCodeEnum code;

  String group;

  String label;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminListRoles200ResponsePermissionsInner &&
    other.code == code &&
    other.group == group &&
    other.label == label;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (group.hashCode) +
    (label.hashCode);

  @override
  String toString() => 'AdminListRoles200ResponsePermissionsInner[code=$code, group=$group, label=$label]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'group'] = this.group;
      json[r'label'] = this.label;
    return json;
  }

  /// Returns a new [AdminListRoles200ResponsePermissionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminListRoles200ResponsePermissionsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminListRoles200ResponsePermissionsInner[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminListRoles200ResponsePermissionsInner[code]" has a null value in JSON.');
        assert(json.containsKey(r'group'), 'Required key "AdminListRoles200ResponsePermissionsInner[group]" is missing from JSON.');
        assert(json[r'group'] != null, 'Required key "AdminListRoles200ResponsePermissionsInner[group]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "AdminListRoles200ResponsePermissionsInner[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "AdminListRoles200ResponsePermissionsInner[label]" has a null value in JSON.');
        return true;
      }());

      return AdminListRoles200ResponsePermissionsInner(
        code: AdminListRoles200ResponsePermissionsInnerCodeEnum.fromJson(json[r'code'])!,
        group: mapValueOfType<String>(json, r'group')!,
        label: mapValueOfType<String>(json, r'label')!,
      );
    }
    return null;
  }

  static List<AdminListRoles200ResponsePermissionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminListRoles200ResponsePermissionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminListRoles200ResponsePermissionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminListRoles200ResponsePermissionsInner> mapFromJson(dynamic json) {
    final map = <String, AdminListRoles200ResponsePermissionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminListRoles200ResponsePermissionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminListRoles200ResponsePermissionsInner-objects as value to a dart map
  static Map<String, List<AdminListRoles200ResponsePermissionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminListRoles200ResponsePermissionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminListRoles200ResponsePermissionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'group',
    'label',
  };
}


enum AdminListRoles200ResponsePermissionsInnerCodeEnum {
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
  const AdminListRoles200ResponsePermissionsInnerCodeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminListRoles200ResponsePermissionsInnerCodeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminListRoles200ResponsePermissionsInnerCodeEnum? fromJson(dynamic value) => AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminListRoles200ResponsePermissionsInnerCodeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminListRoles200ResponsePermissionsInnerCodeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminListRoles200ResponsePermissionsInnerCodeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminListRoles200ResponsePermissionsInnerCodeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminListRoles200ResponsePermissionsInnerCodeEnum] to String,
/// and [decode] dynamic data back to [AdminListRoles200ResponsePermissionsInnerCodeEnum].
class AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer {
  factory AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer() => _instance ??= const AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer._();

  const AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer._();

  String encode(AdminListRoles200ResponsePermissionsInnerCodeEnum data) => data._value;

  /// Returns the instance of [AdminListRoles200ResponsePermissionsInnerCodeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminListRoles200ResponsePermissionsInnerCodeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminListRoles200ResponsePermissionsInnerCodeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dashboard.view': return AdminListRoles200ResponsePermissionsInnerCodeEnum.dashboardPeriodView;
        case r'audit.view': return AdminListRoles200ResponsePermissionsInnerCodeEnum.auditPeriodView;
        case r'analytics.view': return AdminListRoles200ResponsePermissionsInnerCodeEnum.analyticsPeriodView;
        case r'users.view': return AdminListRoles200ResponsePermissionsInnerCodeEnum.usersPeriodView;
        case r'users.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.usersPeriodManage;
        case r'users.coins': return AdminListRoles200ResponsePermissionsInnerCodeEnum.usersPeriodCoins;
        case r'users.vip': return AdminListRoles200ResponsePermissionsInnerCodeEnum.usersPeriodVip;
        case r'kyc.review': return AdminListRoles200ResponsePermissionsInnerCodeEnum.kycPeriodReview;
        case r'companions.video': return AdminListRoles200ResponsePermissionsInnerCodeEnum.companionsPeriodVideo;
        case r'reports.review': return AdminListRoles200ResponsePermissionsInnerCodeEnum.reportsPeriodReview;
        case r'moderation.review': return AdminListRoles200ResponsePermissionsInnerCodeEnum.moderationPeriodReview;
        case r'rooms.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.roomsPeriodManage;
        case r'payouts.view': return AdminListRoles200ResponsePermissionsInnerCodeEnum.payoutsPeriodView;
        case r'payouts.decide': return AdminListRoles200ResponsePermissionsInnerCodeEnum.payoutsPeriodDecide;
        case r'refunds.review': return AdminListRoles200ResponsePermissionsInnerCodeEnum.refundsPeriodReview;
        case r'pricing.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.pricingPeriodManage;
        case r'engagement.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.engagementPeriodManage;
        case r'promotions.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.promotionsPeriodManage;
        case r'staff.manage': return AdminListRoles200ResponsePermissionsInnerCodeEnum.staffPeriodManage;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminListRoles200ResponsePermissionsInnerCodeEnumTypeTransformer? _instance;
}


