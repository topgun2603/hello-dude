//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserInput {
  /// Returns a new [AdminUserInput] instance.
  AdminUserInput({
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
    required this.takingCalls,
    required this.lastSeenAt,
    required this.avatarId,
  });

  String id;

  String displayName;

  /// Masked
  String phone;

  AdminUserInputRoleEnum role;

  AdminUserInputStatusEnum status;

  String primaryLanguage;

  Object? createdAt;

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

  AdminUserInputKycStatusEnum? kycStatus;

  /// Has the app open right now (or is taking calls)
  bool online;

  /// Companion switched Online and taking calls
  bool takingCalls;

  /// Latest of: app open, last online (companions), last sign-in, last call
  Object? lastSeenAt;

  /// 1 female, 2 male, 3 transgender illustrations; other ids are letter circles
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserInput &&
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
    other.takingCalls == takingCalls &&
    other.lastSeenAt == lastSeenAt &&
    other.avatarId == avatarId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (phone.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (primaryLanguage.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (coins.hashCode) +
    (earningsPaise.hashCode) +
    (calls.hashCode) +
    (reportsAgainst.hashCode) +
    (kycStatus == null ? 0 : kycStatus!.hashCode) +
    (online.hashCode) +
    (takingCalls.hashCode) +
    (lastSeenAt == null ? 0 : lastSeenAt!.hashCode) +
    (avatarId.hashCode);

  @override
  String toString() => 'AdminUserInput[id=$id, displayName=$displayName, phone=$phone, role=$role, status=$status, primaryLanguage=$primaryLanguage, createdAt=$createdAt, coins=$coins, earningsPaise=$earningsPaise, calls=$calls, reportsAgainst=$reportsAgainst, kycStatus=$kycStatus, online=$online, takingCalls=$takingCalls, lastSeenAt=$lastSeenAt, avatarId=$avatarId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'primaryLanguage'] = this.primaryLanguage;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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
      json[r'takingCalls'] = this.takingCalls;
    if (this.lastSeenAt != null) {
      json[r'lastSeenAt'] = this.lastSeenAt;
    } else {
      json[r'lastSeenAt'] = null;
    }
      json[r'avatarId'] = this.avatarId;
    return json;
  }

  /// Returns a new [AdminUserInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminUserInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminUserInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminUserInput[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminUserInput[phone]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminUserInput[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminUserInput[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminUserInput[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminUserInput[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserInput[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserInput[coins]" has a null value in JSON.');
        assert(json.containsKey(r'earningsPaise'), 'Required key "AdminUserInput[earningsPaise]" is missing from JSON.');
        assert(json[r'earningsPaise'] != null, 'Required key "AdminUserInput[earningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminUserInput[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminUserInput[calls]" has a null value in JSON.');
        assert(json.containsKey(r'reportsAgainst'), 'Required key "AdminUserInput[reportsAgainst]" is missing from JSON.');
        assert(json[r'reportsAgainst'] != null, 'Required key "AdminUserInput[reportsAgainst]" has a null value in JSON.');
        assert(json.containsKey(r'kycStatus'), 'Required key "AdminUserInput[kycStatus]" is missing from JSON.');
        assert(json.containsKey(r'online'), 'Required key "AdminUserInput[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "AdminUserInput[online]" has a null value in JSON.');
        assert(json.containsKey(r'takingCalls'), 'Required key "AdminUserInput[takingCalls]" is missing from JSON.');
        assert(json[r'takingCalls'] != null, 'Required key "AdminUserInput[takingCalls]" has a null value in JSON.');
        assert(json.containsKey(r'lastSeenAt'), 'Required key "AdminUserInput[lastSeenAt]" is missing from JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminUserInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminUserInput[avatarId]" has a null value in JSON.');
        return true;
      }());

      return AdminUserInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        role: AdminUserInputRoleEnum.fromJson(json[r'role'])!,
        status: AdminUserInputStatusEnum.fromJson(json[r'status'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        coins: mapValueOfType<int>(json, r'coins')!,
        earningsPaise: mapValueOfType<int>(json, r'earningsPaise')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        reportsAgainst: mapValueOfType<int>(json, r'reportsAgainst')!,
        kycStatus: AdminUserInputKycStatusEnum.fromJson(json[r'kycStatus']),
        online: mapValueOfType<bool>(json, r'online')!,
        takingCalls: mapValueOfType<bool>(json, r'takingCalls')!,
        lastSeenAt: mapValueOfType<Object>(json, r'lastSeenAt'),
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
      );
    }
    return null;
  }

  static List<AdminUserInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserInput> mapFromJson(dynamic json) {
    final map = <String, AdminUserInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserInput-objects as value to a dart map
  static Map<String, List<AdminUserInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserInput.listFromJson(entry.value, growable: growable,);
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
    'takingCalls',
    'lastSeenAt',
    'avatarId',
  };
}


enum AdminUserInputRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserInputRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserInputRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserInputRoleEnum? fromJson(dynamic value) => AdminUserInputRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserInputRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserInputRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserInputRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserInputRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserInputRoleEnum] to String,
/// and [decode] dynamic data back to [AdminUserInputRoleEnum].
class AdminUserInputRoleEnumTypeTransformer {
  factory AdminUserInputRoleEnumTypeTransformer() => _instance ??= const AdminUserInputRoleEnumTypeTransformer._();

  const AdminUserInputRoleEnumTypeTransformer._();

  String encode(AdminUserInputRoleEnum data) => data._value;

  /// Returns the instance of [AdminUserInputRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserInputRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserInputRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return AdminUserInputRoleEnum.caller;
        case r'companion': return AdminUserInputRoleEnum.companion;
        case r'admin': return AdminUserInputRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserInputRoleEnumTypeTransformer? _instance;
}



enum AdminUserInputStatusEnum {
  active._(r'active'),
  suspended._(r'suspended'),
  banned._(r'banned'),
  deleted._(r'deleted'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserInputStatusEnum? fromJson(dynamic value) => AdminUserInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserInputStatusEnum].
class AdminUserInputStatusEnumTypeTransformer {
  factory AdminUserInputStatusEnumTypeTransformer() => _instance ??= const AdminUserInputStatusEnumTypeTransformer._();

  const AdminUserInputStatusEnumTypeTransformer._();

  String encode(AdminUserInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'active': return AdminUserInputStatusEnum.active;
        case r'suspended': return AdminUserInputStatusEnum.suspended;
        case r'banned': return AdminUserInputStatusEnum.banned;
        case r'deleted': return AdminUserInputStatusEnum.deleted;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserInputStatusEnumTypeTransformer? _instance;
}



enum AdminUserInputKycStatusEnum {
  pending._(r'pending'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserInputKycStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserInputKycStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserInputKycStatusEnum? fromJson(dynamic value) => AdminUserInputKycStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserInputKycStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserInputKycStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserInputKycStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserInputKycStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserInputKycStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserInputKycStatusEnum].
class AdminUserInputKycStatusEnumTypeTransformer {
  factory AdminUserInputKycStatusEnumTypeTransformer() => _instance ??= const AdminUserInputKycStatusEnumTypeTransformer._();

  const AdminUserInputKycStatusEnumTypeTransformer._();

  String encode(AdminUserInputKycStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserInputKycStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserInputKycStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserInputKycStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return AdminUserInputKycStatusEnum.pending;
        case r'approved': return AdminUserInputKycStatusEnum.approved;
        case r'rejected': return AdminUserInputKycStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserInputKycStatusEnumTypeTransformer? _instance;
}


