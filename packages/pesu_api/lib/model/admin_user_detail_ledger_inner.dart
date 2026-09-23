//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailLedgerInner {
  /// Returns a new [AdminUserDetailLedgerInner] instance.
  AdminUserDetailLedgerInner({
    required this.id,
    required this.createdAt,
    required this.wallet,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.note,
    required this.callId,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  DateTime createdAt;

  AdminUserDetailLedgerInnerWalletEnum wallet;

  String type;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int amount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int balanceAfter;

  String? note;

  String? callId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailLedgerInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.wallet == wallet &&
    other.type == type &&
    other.amount == amount &&
    other.balanceAfter == balanceAfter &&
    other.note == note &&
    other.callId == callId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (wallet.hashCode) +
    (type.hashCode) +
    (amount.hashCode) +
    (balanceAfter.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (callId == null ? 0 : callId!.hashCode);

  @override
  String toString() => 'AdminUserDetailLedgerInner[id=$id, createdAt=$createdAt, wallet=$wallet, type=$type, amount=$amount, balanceAfter=$balanceAfter, note=$note, callId=$callId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'wallet'] = this.wallet;
      json[r'type'] = this.type;
      json[r'amount'] = this.amount;
      json[r'balanceAfter'] = this.balanceAfter;
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUserDetailLedgerInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailLedgerInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailLedgerInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailLedgerInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailLedgerInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailLedgerInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'wallet'), 'Required key "AdminUserDetailLedgerInner[wallet]" is missing from JSON.');
        assert(json[r'wallet'] != null, 'Required key "AdminUserDetailLedgerInner[wallet]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminUserDetailLedgerInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminUserDetailLedgerInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'amount'), 'Required key "AdminUserDetailLedgerInner[amount]" is missing from JSON.');
        assert(json[r'amount'] != null, 'Required key "AdminUserDetailLedgerInner[amount]" has a null value in JSON.');
        assert(json.containsKey(r'balanceAfter'), 'Required key "AdminUserDetailLedgerInner[balanceAfter]" is missing from JSON.');
        assert(json[r'balanceAfter'] != null, 'Required key "AdminUserDetailLedgerInner[balanceAfter]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminUserDetailLedgerInner[note]" is missing from JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailLedgerInner[callId]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailLedgerInner(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        wallet: AdminUserDetailLedgerInnerWalletEnum.fromJson(json[r'wallet'])!,
        type: mapValueOfType<String>(json, r'type')!,
        amount: mapValueOfType<int>(json, r'amount')!,
        balanceAfter: mapValueOfType<int>(json, r'balanceAfter')!,
        note: mapValueOfType<String>(json, r'note'),
        callId: mapValueOfType<String>(json, r'callId'),
      );
    }
    return null;
  }

  static List<AdminUserDetailLedgerInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailLedgerInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailLedgerInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailLedgerInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailLedgerInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailLedgerInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailLedgerInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailLedgerInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailLedgerInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailLedgerInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'wallet',
    'type',
    'amount',
    'balanceAfter',
    'note',
    'callId',
  };
}


enum AdminUserDetailLedgerInnerWalletEnum {
  coins._(r'coins'),
  earnings._(r'earnings'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailLedgerInnerWalletEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailLedgerInnerWalletEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailLedgerInnerWalletEnum? fromJson(dynamic value) => AdminUserDetailLedgerInnerWalletEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailLedgerInnerWalletEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailLedgerInnerWalletEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailLedgerInnerWalletEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailLedgerInnerWalletEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailLedgerInnerWalletEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailLedgerInnerWalletEnum].
class AdminUserDetailLedgerInnerWalletEnumTypeTransformer {
  factory AdminUserDetailLedgerInnerWalletEnumTypeTransformer() => _instance ??= const AdminUserDetailLedgerInnerWalletEnumTypeTransformer._();

  const AdminUserDetailLedgerInnerWalletEnumTypeTransformer._();

  String encode(AdminUserDetailLedgerInnerWalletEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailLedgerInnerWalletEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailLedgerInnerWalletEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailLedgerInnerWalletEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'coins': return AdminUserDetailLedgerInnerWalletEnum.coins;
        case r'earnings': return AdminUserDetailLedgerInnerWalletEnum.earnings;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailLedgerInnerWalletEnumTypeTransformer? _instance;
}


