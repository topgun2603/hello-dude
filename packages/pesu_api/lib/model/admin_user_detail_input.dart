//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInput {
  /// Returns a new [AdminUserDetailInput] instance.
  AdminUserDetailInput({
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
    required this.takingCalls,
    required this.lastActiveAt,
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
    required this.vip,
  });

  String id;

  String displayName;

  /// Masked
  String phone;

  String gender;

  AdminUserDetailInputRoleEnum role;

  AdminUserDetailInputStatusEnum status;

  String primaryLanguage;

  List<String> languages;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  Object? createdAt;

  Object? termsAcceptedAt;

  /// Has the app open right now (or is taking calls)
  bool online;

  /// Companion switched Online and taking calls
  bool takingCalls;

  /// Last time the app was open
  Object? lastActiveAt;

  Object? lastSignInAt;

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

  AdminUserDetailInputStats stats;

  AdminUserDetailInputCompanion? companion;

  List<AdminUserDetailInputCallsInner> calls;

  List<AdminUserDetailInputLedgerInner> ledger;

  List<AdminUserDetailInputPurchasesInner> purchases;

  List<AdminUserDetailInputPayoutsInner> payouts;

  List<AdminUserDetailInputReportsInner> reports;

  List<AdminUserDetailInputRefundsInner> refunds;

  List<AdminUserDetailInputAuditInner> audit;

  List<AdminNoteInput> notes;

  AdminUserDetailInputVip? vip;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInput &&
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
    other.takingCalls == takingCalls &&
    other.lastActiveAt == lastActiveAt &&
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
    _deepEquality.equals(other.notes, notes) &&
    other.vip == vip;

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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (termsAcceptedAt == null ? 0 : termsAcceptedAt!.hashCode) +
    (online.hashCode) +
    (takingCalls.hashCode) +
    (lastActiveAt == null ? 0 : lastActiveAt!.hashCode) +
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
    (notes.hashCode) +
    (vip == null ? 0 : vip!.hashCode);

  @override
  String toString() => 'AdminUserDetailInput[id=$id, displayName=$displayName, phone=$phone, gender=$gender, role=$role, status=$status, primaryLanguage=$primaryLanguage, languages=$languages, avatarId=$avatarId, createdAt=$createdAt, termsAcceptedAt=$termsAcceptedAt, online=$online, takingCalls=$takingCalls, lastActiveAt=$lastActiveAt, lastSignInAt=$lastSignInAt, activeSessions=$activeSessions, devices=$devices, coins=$coins, earningsPaise=$earningsPaise, stats=$stats, companion=$companion, calls=$calls, ledger=$ledger, purchases=$purchases, payouts=$payouts, reports=$reports, refunds=$refunds, audit=$audit, notes=$notes, vip=$vip]';

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
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    if (this.termsAcceptedAt != null) {
      json[r'termsAcceptedAt'] = this.termsAcceptedAt;
    } else {
      json[r'termsAcceptedAt'] = null;
    }
      json[r'online'] = this.online;
      json[r'takingCalls'] = this.takingCalls;
    if (this.lastActiveAt != null) {
      json[r'lastActiveAt'] = this.lastActiveAt;
    } else {
      json[r'lastActiveAt'] = null;
    }
    if (this.lastSignInAt != null) {
      json[r'lastSignInAt'] = this.lastSignInAt;
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
    if (this.vip != null) {
      json[r'vip'] = this.vip;
    } else {
      json[r'vip'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUserDetailInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminUserDetailInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminUserDetailInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminUserDetailInput[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminUserDetailInput[phone]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "AdminUserDetailInput[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "AdminUserDetailInput[gender]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminUserDetailInput[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminUserDetailInput[role]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminUserDetailInput[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminUserDetailInput[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "AdminUserDetailInput[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "AdminUserDetailInput[languages]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminUserDetailInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminUserDetailInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'termsAcceptedAt'), 'Required key "AdminUserDetailInput[termsAcceptedAt]" is missing from JSON.');
        assert(json.containsKey(r'online'), 'Required key "AdminUserDetailInput[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "AdminUserDetailInput[online]" has a null value in JSON.');
        assert(json.containsKey(r'takingCalls'), 'Required key "AdminUserDetailInput[takingCalls]" is missing from JSON.');
        assert(json[r'takingCalls'] != null, 'Required key "AdminUserDetailInput[takingCalls]" has a null value in JSON.');
        assert(json.containsKey(r'lastActiveAt'), 'Required key "AdminUserDetailInput[lastActiveAt]" is missing from JSON.');
        assert(json.containsKey(r'lastSignInAt'), 'Required key "AdminUserDetailInput[lastSignInAt]" is missing from JSON.');
        assert(json.containsKey(r'activeSessions'), 'Required key "AdminUserDetailInput[activeSessions]" is missing from JSON.');
        assert(json[r'activeSessions'] != null, 'Required key "AdminUserDetailInput[activeSessions]" has a null value in JSON.');
        assert(json.containsKey(r'devices'), 'Required key "AdminUserDetailInput[devices]" is missing from JSON.');
        assert(json[r'devices'] != null, 'Required key "AdminUserDetailInput[devices]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetailInput[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetailInput[coins]" has a null value in JSON.');
        assert(json.containsKey(r'earningsPaise'), 'Required key "AdminUserDetailInput[earningsPaise]" is missing from JSON.');
        assert(json[r'earningsPaise'] != null, 'Required key "AdminUserDetailInput[earningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'stats'), 'Required key "AdminUserDetailInput[stats]" is missing from JSON.');
        assert(json[r'stats'] != null, 'Required key "AdminUserDetailInput[stats]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "AdminUserDetailInput[companion]" is missing from JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminUserDetailInput[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminUserDetailInput[calls]" has a null value in JSON.');
        assert(json.containsKey(r'ledger'), 'Required key "AdminUserDetailInput[ledger]" is missing from JSON.');
        assert(json[r'ledger'] != null, 'Required key "AdminUserDetailInput[ledger]" has a null value in JSON.');
        assert(json.containsKey(r'purchases'), 'Required key "AdminUserDetailInput[purchases]" is missing from JSON.');
        assert(json[r'purchases'] != null, 'Required key "AdminUserDetailInput[purchases]" has a null value in JSON.');
        assert(json.containsKey(r'payouts'), 'Required key "AdminUserDetailInput[payouts]" is missing from JSON.');
        assert(json[r'payouts'] != null, 'Required key "AdminUserDetailInput[payouts]" has a null value in JSON.');
        assert(json.containsKey(r'reports'), 'Required key "AdminUserDetailInput[reports]" is missing from JSON.');
        assert(json[r'reports'] != null, 'Required key "AdminUserDetailInput[reports]" has a null value in JSON.');
        assert(json.containsKey(r'refunds'), 'Required key "AdminUserDetailInput[refunds]" is missing from JSON.');
        assert(json[r'refunds'] != null, 'Required key "AdminUserDetailInput[refunds]" has a null value in JSON.');
        assert(json.containsKey(r'audit'), 'Required key "AdminUserDetailInput[audit]" is missing from JSON.');
        assert(json[r'audit'] != null, 'Required key "AdminUserDetailInput[audit]" has a null value in JSON.');
        assert(json.containsKey(r'notes'), 'Required key "AdminUserDetailInput[notes]" is missing from JSON.');
        assert(json[r'notes'] != null, 'Required key "AdminUserDetailInput[notes]" has a null value in JSON.');
        assert(json.containsKey(r'vip'), 'Required key "AdminUserDetailInput[vip]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        gender: mapValueOfType<String>(json, r'gender')!,
        role: AdminUserDetailInputRoleEnum.fromJson(json[r'role'])!,
        status: AdminUserDetailInputStatusEnum.fromJson(json[r'status'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        termsAcceptedAt: mapValueOfType<Object>(json, r'termsAcceptedAt'),
        online: mapValueOfType<bool>(json, r'online')!,
        takingCalls: mapValueOfType<bool>(json, r'takingCalls')!,
        lastActiveAt: mapValueOfType<Object>(json, r'lastActiveAt'),
        lastSignInAt: mapValueOfType<Object>(json, r'lastSignInAt'),
        activeSessions: mapValueOfType<int>(json, r'activeSessions')!,
        devices: mapValueOfType<int>(json, r'devices')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        earningsPaise: mapValueOfType<int>(json, r'earningsPaise')!,
        stats: AdminUserDetailInputStats.fromJson(json[r'stats'])!,
        companion: AdminUserDetailInputCompanion.fromJson(json[r'companion']),
        calls: AdminUserDetailInputCallsInner.listFromJson(json[r'calls']),
        ledger: AdminUserDetailInputLedgerInner.listFromJson(json[r'ledger']),
        purchases: AdminUserDetailInputPurchasesInner.listFromJson(json[r'purchases']),
        payouts: AdminUserDetailInputPayoutsInner.listFromJson(json[r'payouts']),
        reports: AdminUserDetailInputReportsInner.listFromJson(json[r'reports']),
        refunds: AdminUserDetailInputRefundsInner.listFromJson(json[r'refunds']),
        audit: AdminUserDetailInputAuditInner.listFromJson(json[r'audit']),
        notes: AdminNoteInput.listFromJson(json[r'notes']),
        vip: AdminUserDetailInputVip.fromJson(json[r'vip']),
      );
    }
    return null;
  }

  static List<AdminUserDetailInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInput> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInput-objects as value to a dart map
  static Map<String, List<AdminUserDetailInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInput.listFromJson(entry.value, growable: growable,);
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
    'takingCalls',
    'lastActiveAt',
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
    'vip',
  };
}


enum AdminUserDetailInputRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputRoleEnum? fromJson(dynamic value) => AdminUserDetailInputRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputRoleEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputRoleEnum].
class AdminUserDetailInputRoleEnumTypeTransformer {
  factory AdminUserDetailInputRoleEnumTypeTransformer() => _instance ??= const AdminUserDetailInputRoleEnumTypeTransformer._();

  const AdminUserDetailInputRoleEnumTypeTransformer._();

  String encode(AdminUserDetailInputRoleEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return AdminUserDetailInputRoleEnum.caller;
        case r'companion': return AdminUserDetailInputRoleEnum.companion;
        case r'admin': return AdminUserDetailInputRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputRoleEnumTypeTransformer? _instance;
}



enum AdminUserDetailInputStatusEnum {
  active._(r'active'),
  suspended._(r'suspended'),
  banned._(r'banned'),
  deleted._(r'deleted'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputStatusEnum? fromJson(dynamic value) => AdminUserDetailInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputStatusEnum].
class AdminUserDetailInputStatusEnumTypeTransformer {
  factory AdminUserDetailInputStatusEnumTypeTransformer() => _instance ??= const AdminUserDetailInputStatusEnumTypeTransformer._();

  const AdminUserDetailInputStatusEnumTypeTransformer._();

  String encode(AdminUserDetailInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'active': return AdminUserDetailInputStatusEnum.active;
        case r'suspended': return AdminUserDetailInputStatusEnum.suspended;
        case r'banned': return AdminUserDetailInputStatusEnum.banned;
        case r'deleted': return AdminUserDetailInputStatusEnum.deleted;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputStatusEnumTypeTransformer? _instance;
}


