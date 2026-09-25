//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PurchaseResult {
  /// Returns a new [PurchaseResult] instance.
  PurchaseResult({
    required this.status,
    required this.coins,
    required this.balance,
    required this.message,
  });

  PurchaseResultStatusEnum status;

  /// Coins added by this purchase (0 unless credited)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Coin balance after crediting
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? balance;

  String message;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PurchaseResult &&
    other.status == status &&
    other.coins == coins &&
    other.balance == balance &&
    other.message == message;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (coins.hashCode) +
    (balance == null ? 0 : balance!.hashCode) +
    (message.hashCode);

  @override
  String toString() => 'PurchaseResult[status=$status, coins=$coins, balance=$balance, message=$message]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
      json[r'coins'] = this.coins;
    if (this.balance != null) {
      json[r'balance'] = this.balance;
    } else {
      json[r'balance'] = null;
    }
      json[r'message'] = this.message;
    return json;
  }

  /// Returns a new [PurchaseResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PurchaseResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "PurchaseResult[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PurchaseResult[status]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "PurchaseResult[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "PurchaseResult[coins]" has a null value in JSON.');
        assert(json.containsKey(r'balance'), 'Required key "PurchaseResult[balance]" is missing from JSON.');
        assert(json.containsKey(r'message'), 'Required key "PurchaseResult[message]" is missing from JSON.');
        assert(json[r'message'] != null, 'Required key "PurchaseResult[message]" has a null value in JSON.');
        return true;
      }());

      return PurchaseResult(
        status: PurchaseResultStatusEnum.fromJson(json[r'status'])!,
        coins: mapValueOfType<int>(json, r'coins')!,
        balance: mapValueOfType<int>(json, r'balance'),
        message: mapValueOfType<String>(json, r'message')!,
      );
    }
    return null;
  }

  static List<PurchaseResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PurchaseResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PurchaseResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PurchaseResult> mapFromJson(dynamic json) {
    final map = <String, PurchaseResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PurchaseResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PurchaseResult-objects as value to a dart map
  static Map<String, List<PurchaseResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PurchaseResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PurchaseResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'coins',
    'balance',
    'message',
  };
}


enum PurchaseResultStatusEnum {
  credited._(r'credited'),
  pending._(r'pending'),
  failed._(r'failed'),
  ;

  /// Instantiate a new enum with the provided value.
  const PurchaseResultStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PurchaseResultStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PurchaseResultStatusEnum? fromJson(dynamic value) => PurchaseResultStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PurchaseResultStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PurchaseResultStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PurchaseResultStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PurchaseResultStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PurchaseResultStatusEnum] to String,
/// and [decode] dynamic data back to [PurchaseResultStatusEnum].
class PurchaseResultStatusEnumTypeTransformer {
  factory PurchaseResultStatusEnumTypeTransformer() => _instance ??= const PurchaseResultStatusEnumTypeTransformer._();

  const PurchaseResultStatusEnumTypeTransformer._();

  String encode(PurchaseResultStatusEnum data) => data._value;

  /// Returns the instance of [PurchaseResultStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PurchaseResultStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PurchaseResultStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'credited': return PurchaseResultStatusEnum.credited;
        case r'pending': return PurchaseResultStatusEnum.pending;
        case r'failed': return PurchaseResultStatusEnum.failed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PurchaseResultStatusEnumTypeTransformer? _instance;
}


