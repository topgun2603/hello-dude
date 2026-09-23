//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputLedgerInner {
  /// Returns a new [AdminUserDetailInputLedgerInner] instance.
  AdminUserDetailInputLedgerInner({
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

  Object? createdAt;

  AdminUserDetailInputLedgerInnerWalletEnum wallet;

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
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputLedgerInner &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (wallet.hashCode) +
    (type.hashCode) +
    (amount.hashCode) +
    (balanceAfter.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (callId == null ? 0 : callId!.hashCode);

  @override
  String toString() => 'AdminUserDetailInputLedgerInner[id=$id, createdAt=$createdAt, wallet=$wallet, type=$type, amount=$amount, balanceAfter=$balanceAfter, note=$note, callId=$callId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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

  /// Returns a new [AdminUserDetailInputLedgerInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputLedgerInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputLedgerInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputLedgerInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputLedgerInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'wallet'), 'Required key "AdminUserDetailInputLedgerInner[wallet]" is missing from JSON.');
        assert(json[r'wallet'] != null, 'Required key "AdminUserDetailInputLedgerInner[wallet]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminUserDetailInputLedgerInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminUserDetailInputLedgerInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'amount'), 'Required key "AdminUserDetailInputLedgerInner[amount]" is missing from JSON.');
        assert(json[r'amount'] != null, 'Required key "AdminUserDetailInputLedgerInner[amount]" has a null value in JSON.');
        assert(json.containsKey(r'balanceAfter'), 'Required key "AdminUserDetailInputLedgerInner[balanceAfter]" is missing from JSON.');
        assert(json[r'balanceAfter'] != null, 'Required key "AdminUserDetailInputLedgerInner[balanceAfter]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminUserDetailInputLedgerInner[note]" is missing from JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailInputLedgerInner[callId]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailInputLedgerInner(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        wallet: AdminUserDetailInputLedgerInnerWalletEnum.fromJson(json[r'wallet'])!,
        type: mapValueOfType<String>(json, r'type')!,
        amount: mapValueOfType<int>(json, r'amount')!,
        balanceAfter: mapValueOfType<int>(json, r'balanceAfter')!,
        note: mapValueOfType<String>(json, r'note'),
        callId: mapValueOfType<String>(json, r'callId'),
      );
    }
    return null;
  }

  static List<AdminUserDetailInputLedgerInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputLedgerInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputLedgerInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputLedgerInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputLedgerInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputLedgerInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputLedgerInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputLedgerInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputLedgerInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputLedgerInner.listFromJson(entry.value, growable: growable,);
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


enum AdminUserDetailInputLedgerInnerWalletEnum {
  coins._(r'coins'),
  earnings._(r'earnings'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputLedgerInnerWalletEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputLedgerInnerWalletEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputLedgerInnerWalletEnum? fromJson(dynamic value) => AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputLedgerInnerWalletEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputLedgerInnerWalletEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputLedgerInnerWalletEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputLedgerInnerWalletEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputLedgerInnerWalletEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputLedgerInnerWalletEnum].
class AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer {
  factory AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer() => _instance ??= const AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer._();

  const AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer._();

  String encode(AdminUserDetailInputLedgerInnerWalletEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputLedgerInnerWalletEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputLedgerInnerWalletEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputLedgerInnerWalletEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'coins': return AdminUserDetailInputLedgerInnerWalletEnum.coins;
        case r'earnings': return AdminUserDetailInputLedgerInnerWalletEnum.earnings;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputLedgerInnerWalletEnumTypeTransformer? _instance;
}


