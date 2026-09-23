//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUser {
  /// Returns a new [AdminUser] instance.
  AdminUser({
    required this.id,
    required this.displayName,
    required this.phone,
    required this.role,
    required this.status,
    required this.primaryLanguage,
    required this.createdAt,
    required this.coins,
    required this.earningsPaise,
    required this.calls,
    required this.reportsAgainst,
    required this.kycStatus,
    required this.online,
    required this.lastSeenAt,
  });

  String id;

  String displayName;

  /// Masked
  String phone;

  AdminUserRoleEnum role;

  AdminUserStatusEnum status;

  String primaryLanguage;

  DateTime createdAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earningsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reportsAgainst;

  AdminUserKycStatusEnum? kycStatus;

  bool online;

  /// Latest of: last online (companions), last sign-in or token refresh, last call
  DateTime? lastSeenAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUser &&
    other.id == id &&
    other.displayName == displayName &&
    other.phone == phone &&
    other.role == role &&
    other.status == status &&
    other.primaryLanguage == primaryLanguage &&
    other.createdAt == createdAt &&
    other.coins == coins &&
    other.earningsPaise == earningsPaise &&
    other.calls == calls &&
    other.reportsAgainst == reportsAgainst &&
    other.kycStatus == kycStatus &&
    other.online == online &&
    other.lastSeenAt == lastSeenAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (phone.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (primaryLanguage.hashCode) +
    (createdAt.hashCode) +
    (coins.hashCode) +
    (earningsPaise.hashCode) +
    (calls.hashCode) +
    (reportsAgainst.hashCode) +
    (kycStatus == null ? 0 : kycStatus!.hashCode) +
    (online.hashCode) +
    (lastSeenAt == null ? 0 : lastSeenAt!.hashCode);

  @override
  String toString() => 'AdminUser[id=$id, displayName=$displayName, phone=$phone, role=$role, status=$status, primaryLanguage=$primaryLanguage, createdAt=$createdAt, coins=$coins, earningsPaise=$earningsPaise, calls=$calls, reportsAgainst=$reportsAgainst, kycStatus=$kycStatus, online=$online, lastSeenAt=$lastSeenAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'coins'] = this.coins;
      json[r'earningsPaise'] = this.earningsPaise;
      json[r'calls'] = this.calls;
      json[r'reportsAgainst'] = this.reportsAgainst;
    if (this.kycStatus != null) {
      json[r'kycStatus'] = this.kycStatus;
    } else {
      json[r'kycStatus'] = null;
    }
      json[r'online'] = this.online;
    if (this.lastSeenAt != null) {
      json[r'lastSeenAt'] = this.lastSeenAt!.toUtc().toIso8601String();
    } else {
      json[r'lastSeenAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUser[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUser[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminUser[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminUser[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminUser[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminUser[phone]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminUser[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminUser[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUser[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUser[status]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminUser[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminUser[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUser[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUser[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUser[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUser[coins]" has a null value in JSON.');
        assert(json.containsKey(r'earningsPaise'), 'Required key "AdminUser[earningsPaise]" is missing from JSON.');
        assert(json[r'earningsPaise'] != null, 'Required key "AdminUser[earningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminUser[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminUser[calls]" has a null value in JSON.');
        assert(json.containsKey(r'reportsAgainst'), 'Required key "AdminUser[reportsAgainst]" is missing from JSON.');
        assert(json[r'reportsAgainst'] != null, 'Required key "AdminUser[reportsAgainst]" has a null value in JSON.');
        assert(json.containsKey(r'kycStatus'), 'Required key "AdminUser[kycStatus]" is missing from JSON.');
        assert(json.containsKey(r'online'), 'Required key "AdminUser[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "AdminUser[online]" has a null value in JSON.');
        assert(json.containsKey(r'lastSeenAt'), 'Required key "AdminUser[lastSeenAt]" is missing from JSON.');
        return true;
      }());

      return AdminUser(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        role: AdminUserRoleEnum.fromJson(json[r'role'])!,
        status: AdminUserStatusEnum.fromJson(json[r'status'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        earningsPaise: mapValueOfType<int>(json, r'earningsPaise')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        reportsAgainst: mapValueOfType<int>(json, r'reportsAgainst')!,
        kycStatus: AdminUserKycStatusEnum.fromJson(json[r'kycStatus']),
        online: mapValueOfType<bool>(json, r'online')!,
        lastSeenAt: mapDateTime(json, r'lastSeenAt', r''),
      );
    }
    return null;
  }

  static List<AdminUser> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUser> mapFromJson(dynamic json) {
    final map = <String, AdminUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUser-objects as value to a dart map
  static Map<String, List<AdminUser>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUser.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'phone',
    'role',
    'status',
    'primaryLanguage',
    'createdAt',
    'coins',
    'earningsPaise',
    'calls',
    'reportsAgainst',
    'kycStatus',
    'online',
    'lastSeenAt',
  };
}


enum AdminUserRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserRoleEnum? fromJson(dynamic value) => AdminUserRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserRoleEnum] to String,
/// and [decode] dynamic data back to [AdminUserRoleEnum].
class AdminUserRoleEnumTypeTransformer {
  factory AdminUserRoleEnumTypeTransformer() => _instance ??= const AdminUserRoleEnumTypeTransformer._();

  const AdminUserRoleEnumTypeTransformer._();

  String encode(AdminUserRoleEnum data) => data._value;

  /// Returns the instance of [AdminUserRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return AdminUserRoleEnum.caller;
        case r'companion': return AdminUserRoleEnum.companion;
        case r'admin': return AdminUserRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserRoleEnumTypeTransformer? _instance;
}



enum AdminUserStatusEnum {
  active._(r'active'),
  suspended._(r'suspended'),
  banned._(r'banned'),
  deleted._(r'deleted'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserStatusEnum? fromJson(dynamic value) => AdminUserStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserStatusEnum].
class AdminUserStatusEnumTypeTransformer {
  factory AdminUserStatusEnumTypeTransformer() => _instance ??= const AdminUserStatusEnumTypeTransformer._();

  const AdminUserStatusEnumTypeTransformer._();

  String encode(AdminUserStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'active': return AdminUserStatusEnum.active;
        case r'suspended': return AdminUserStatusEnum.suspended;
        case r'banned': return AdminUserStatusEnum.banned;
        case r'deleted': return AdminUserStatusEnum.deleted;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserStatusEnumTypeTransformer? _instance;
}



enum AdminUserKycStatusEnum {
  pending._(r'pending'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserKycStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserKycStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserKycStatusEnum? fromJson(dynamic value) => AdminUserKycStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserKycStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserKycStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserKycStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserKycStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserKycStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserKycStatusEnum].
class AdminUserKycStatusEnumTypeTransformer {
  factory AdminUserKycStatusEnumTypeTransformer() => _instance ??= const AdminUserKycStatusEnumTypeTransformer._();

  const AdminUserKycStatusEnumTypeTransformer._();

  String encode(AdminUserKycStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserKycStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserKycStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserKycStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return AdminUserKycStatusEnum.pending;
        case r'approved': return AdminUserKycStatusEnum.approved;
        case r'rejected': return AdminUserKycStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserKycStatusEnumTypeTransformer? _instance;
}


