//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetail {
  /// Returns a new [AdminUserDetail] instance.
  AdminUserDetail({
    required this.id,
    required this.displayName,
    required this.phone,
    required this.gender,
    required this.role,
    required this.status,
    required this.primaryLanguage,
    this.languages = const [],
    required this.avatarId,
    required this.createdAt,
    required this.termsAcceptedAt,
    required this.online,
    required this.lastSignInAt,
    required this.activeSessions,
    required this.devices,
    required this.coins,
    required this.earningsPaise,
    required this.stats,
    required this.companion,
    this.calls = const [],
    this.ledger = const [],
    this.purchases = const [],
    this.payouts = const [],
    this.reports = const [],
    this.refunds = const [],
    this.audit = const [],
    this.notes = const [],
  });

  String id;

  String displayName;

  /// Masked
  String phone;

  String gender;

  AdminUserDetailRoleEnum role;

  AdminUserDetailStatusEnum status;

  String primaryLanguage;

  List<String> languages;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  DateTime createdAt;

  DateTime? termsAcceptedAt;

  bool online;

  DateTime? lastSignInAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int activeSessions;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int devices;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earningsPaise;

  AdminUserDetailStats stats;

  AdminUserDetailCompanion? companion;

  List<AdminUserDetailCallsInner> calls;

  List<AdminUserDetailLedgerInner> ledger;

  List<AdminUserDetailPurchasesInner> purchases;

  List<AdminUserDetailPayoutsInner> payouts;

  List<AdminUserDetailReportsInner> reports;

  List<AdminUserDetailRefundsInner> refunds;

  List<AdminUserDetailAuditInner> audit;

  List<AdminNote> notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetail &&
    other.id == id &&
    other.displayName == displayName &&
    other.phone == phone &&
    other.gender == gender &&
    other.role == role &&
    other.status == status &&
    other.primaryLanguage == primaryLanguage &&
    _deepEquality.equals(other.languages, languages) &&
    other.avatarId == avatarId &&
    other.createdAt == createdAt &&
    other.termsAcceptedAt == termsAcceptedAt &&
    other.online == online &&
    other.lastSignInAt == lastSignInAt &&
    other.activeSessions == activeSessions &&
    other.devices == devices &&
    other.coins == coins &&
    other.earningsPaise == earningsPaise &&
    other.stats == stats &&
    other.companion == companion &&
    _deepEquality.equals(other.calls, calls) &&
    _deepEquality.equals(other.ledger, ledger) &&
    _deepEquality.equals(other.purchases, purchases) &&
    _deepEquality.equals(other.payouts, payouts) &&
    _deepEquality.equals(other.reports, reports) &&
    _deepEquality.equals(other.refunds, refunds) &&
    _deepEquality.equals(other.audit, audit) &&
    _deepEquality.equals(other.notes, notes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (phone.hashCode) +
    (gender.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (primaryLanguage.hashCode) +
    (languages.hashCode) +
    (avatarId.hashCode) +
    (createdAt.hashCode) +
    (termsAcceptedAt == null ? 0 : termsAcceptedAt!.hashCode) +
    (online.hashCode) +
    (lastSignInAt == null ? 0 : lastSignInAt!.hashCode) +
    (activeSessions.hashCode) +
    (devices.hashCode) +
    (coins.hashCode) +
    (earningsPaise.hashCode) +
    (stats.hashCode) +
    (companion == null ? 0 : companion!.hashCode) +
    (calls.hashCode) +
    (ledger.hashCode) +
    (purchases.hashCode) +
    (payouts.hashCode) +
    (reports.hashCode) +
    (refunds.hashCode) +
    (audit.hashCode) +
    (notes.hashCode);

  @override
  String toString() => 'AdminUserDetail[id=$id, displayName=$displayName, phone=$phone, gender=$gender, role=$role, status=$status, primaryLanguage=$primaryLanguage, languages=$languages, avatarId=$avatarId, createdAt=$createdAt, termsAcceptedAt=$termsAcceptedAt, online=$online, lastSignInAt=$lastSignInAt, activeSessions=$activeSessions, devices=$devices, coins=$coins, earningsPaise=$earningsPaise, stats=$stats, companion=$companion, calls=$calls, ledger=$ledger, purchases=$purchases, payouts=$payouts, reports=$reports, refunds=$refunds, audit=$audit, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'gender'] = this.gender;
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'languages'] = this.languages;
      json[r'avatarId'] = this.avatarId;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.termsAcceptedAt != null) {
      json[r'termsAcceptedAt'] = this.termsAcceptedAt!.toUtc().toIso8601String();
    } else {
      json[r'termsAcceptedAt'] = null;
    }
      json[r'online'] = this.online;
    if (this.lastSignInAt != null) {
      json[r'lastSignInAt'] = this.lastSignInAt!.toUtc().toIso8601String();
    } else {
      json[r'lastSignInAt'] = null;
    }
      json[r'activeSessions'] = this.activeSessions;
      json[r'devices'] = this.devices;
      json[r'coins'] = this.coins;
      json[r'earningsPaise'] = this.earningsPaise;
      json[r'stats'] = this.stats;
    if (this.companion != null) {
      json[r'companion'] = this.companion;
    } else {
      json[r'companion'] = null;
    }
      json[r'calls'] = this.calls;
      json[r'ledger'] = this.ledger;
      json[r'purchases'] = this.purchases;
      json[r'payouts'] = this.payouts;
      json[r'reports'] = this.reports;
      json[r'refunds'] = this.refunds;
      json[r'audit'] = this.audit;
      json[r'notes'] = this.notes;
    return json;
  }

  /// Returns a new [AdminUserDetail] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetail? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetail[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetail[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminUserDetail[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminUserDetail[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminUserDetail[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminUserDetail[phone]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "AdminUserDetail[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "AdminUserDetail[gender]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminUserDetail[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminUserDetail[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetail[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetail[status]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminUserDetail[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminUserDetail[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "AdminUserDetail[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "AdminUserDetail[languages]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminUserDetail[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminUserDetail[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetail[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetail[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'termsAcceptedAt'), 'Required key "AdminUserDetail[termsAcceptedAt]" is missing from JSON.');
        assert(json.containsKey(r'online'), 'Required key "AdminUserDetail[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "AdminUserDetail[online]" has a null value in JSON.');
        assert(json.containsKey(r'lastSignInAt'), 'Required key "AdminUserDetail[lastSignInAt]" is missing from JSON.');
        assert(json.containsKey(r'activeSessions'), 'Required key "AdminUserDetail[activeSessions]" is missing from JSON.');
        assert(json[r'activeSessions'] != null, 'Required key "AdminUserDetail[activeSessions]" has a null value in JSON.');
        assert(json.containsKey(r'devices'), 'Required key "AdminUserDetail[devices]" is missing from JSON.');
        assert(json[r'devices'] != null, 'Required key "AdminUserDetail[devices]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetail[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetail[coins]" has a null value in JSON.');
        assert(json.containsKey(r'earningsPaise'), 'Required key "AdminUserDetail[earningsPaise]" is missing from JSON.');
        assert(json[r'earningsPaise'] != null, 'Required key "AdminUserDetail[earningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'stats'), 'Required key "AdminUserDetail[stats]" is missing from JSON.');
        assert(json[r'stats'] != null, 'Required key "AdminUserDetail[stats]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "AdminUserDetail[companion]" is missing from JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminUserDetail[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminUserDetail[calls]" has a null value in JSON.');
        assert(json.containsKey(r'ledger'), 'Required key "AdminUserDetail[ledger]" is missing from JSON.');
        assert(json[r'ledger'] != null, 'Required key "AdminUserDetail[ledger]" has a null value in JSON.');
        assert(json.containsKey(r'purchases'), 'Required key "AdminUserDetail[purchases]" is missing from JSON.');
        assert(json[r'purchases'] != null, 'Required key "AdminUserDetail[purchases]" has a null value in JSON.');
        assert(json.containsKey(r'payouts'), 'Required key "AdminUserDetail[payouts]" is missing from JSON.');
        assert(json[r'payouts'] != null, 'Required key "AdminUserDetail[payouts]" has a null value in JSON.');
        assert(json.containsKey(r'reports'), 'Required key "AdminUserDetail[reports]" is missing from JSON.');
        assert(json[r'reports'] != null, 'Required key "AdminUserDetail[reports]" has a null value in JSON.');
        assert(json.containsKey(r'refunds'), 'Required key "AdminUserDetail[refunds]" is missing from JSON.');
        assert(json[r'refunds'] != null, 'Required key "AdminUserDetail[refunds]" has a null value in JSON.');
        assert(json.containsKey(r'audit'), 'Required key "AdminUserDetail[audit]" is missing from JSON.');
        assert(json[r'audit'] != null, 'Required key "AdminUserDetail[audit]" has a null value in JSON.');
        assert(json.containsKey(r'notes'), 'Required key "AdminUserDetail[notes]" is missing from JSON.');
        assert(json[r'notes'] != null, 'Required key "AdminUserDetail[notes]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetail(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        gender: mapValueOfType<String>(json, r'gender')!,
        role: AdminUserDetailRoleEnum.fromJson(json[r'role'])!,
        status: AdminUserDetailStatusEnum.fromJson(json[r'status'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        termsAcceptedAt: mapDateTime(json, r'termsAcceptedAt', r''),
        online: mapValueOfType<bool>(json, r'online')!,
        lastSignInAt: mapDateTime(json, r'lastSignInAt', r''),
        activeSessions: mapValueOfType<int>(json, r'activeSessions')!,
        devices: mapValueOfType<int>(json, r'devices')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        earningsPaise: mapValueOfType<int>(json, r'earningsPaise')!,
        stats: AdminUserDetailStats.fromJson(json[r'stats'])!,
        companion: AdminUserDetailCompanion.fromJson(json[r'companion']),
        calls: AdminUserDetailCallsInner.listFromJson(json[r'calls']),
        ledger: AdminUserDetailLedgerInner.listFromJson(json[r'ledger']),
        purchases: AdminUserDetailPurchasesInner.listFromJson(json[r'purchases']),
        payouts: AdminUserDetailPayoutsInner.listFromJson(json[r'payouts']),
        reports: AdminUserDetailReportsInner.listFromJson(json[r'reports']),
        refunds: AdminUserDetailRefundsInner.listFromJson(json[r'refunds']),
        audit: AdminUserDetailAuditInner.listFromJson(json[r'audit']),
        notes: AdminNote.listFromJson(json[r'notes']),
      );
    }
    return null;
  }

  static List<AdminUserDetail> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetail>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetail.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetail> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetail>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetail.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetail-objects as value to a dart map
  static Map<String, List<AdminUserDetail>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetail>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetail.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'phone',
    'gender',
    'role',
    'status',
    'primaryLanguage',
    'languages',
    'avatarId',
    'createdAt',
    'termsAcceptedAt',
    'online',
    'lastSignInAt',
    'activeSessions',
    'devices',
    'coins',
    'earningsPaise',
    'stats',
    'companion',
    'calls',
    'ledger',
    'purchases',
    'payouts',
    'reports',
    'refunds',
    'audit',
    'notes',
  };
}


enum AdminUserDetailRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailRoleEnum? fromJson(dynamic value) => AdminUserDetailRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailRoleEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailRoleEnum].
class AdminUserDetailRoleEnumTypeTransformer {
  factory AdminUserDetailRoleEnumTypeTransformer() => _instance ??= const AdminUserDetailRoleEnumTypeTransformer._();

  const AdminUserDetailRoleEnumTypeTransformer._();

  String encode(AdminUserDetailRoleEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return AdminUserDetailRoleEnum.caller;
        case r'companion': return AdminUserDetailRoleEnum.companion;
        case r'admin': return AdminUserDetailRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailRoleEnumTypeTransformer? _instance;
}



enum AdminUserDetailStatusEnum {
  active._(r'active'),
  suspended._(r'suspended'),
  banned._(r'banned'),
  deleted._(r'deleted'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailStatusEnum? fromJson(dynamic value) => AdminUserDetailStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailStatusEnum].
class AdminUserDetailStatusEnumTypeTransformer {
  factory AdminUserDetailStatusEnumTypeTransformer() => _instance ??= const AdminUserDetailStatusEnumTypeTransformer._();

  const AdminUserDetailStatusEnumTypeTransformer._();

  String encode(AdminUserDetailStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'active': return AdminUserDetailStatusEnum.active;
        case r'suspended': return AdminUserDetailStatusEnum.suspended;
        case r'banned': return AdminUserDetailStatusEnum.banned;
        case r'deleted': return AdminUserDetailStatusEnum.deleted;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailStatusEnumTypeTransformer? _instance;
}


