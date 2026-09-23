//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Payout {
  /// Returns a new [Payout] instance.
  Payout({
    required this.id,
    required this.grossPaise,
    required this.tdsPaise,
    required this.netPaise,
    required this.upi,
    required this.status,
    required this.failureReason,
    required this.createdAt,
    required this.processedAt,
  });

  String id;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int grossPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int netPaise;

  String upi;

  PayoutStatusEnum status;

  String? failureReason;

  DateTime createdAt;

  DateTime? processedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Payout &&
    other.id == id &&
    other.grossPaise == grossPaise &&
    other.tdsPaise == tdsPaise &&
    other.netPaise == netPaise &&
    other.upi == upi &&
    other.status == status &&
    other.failureReason == failureReason &&
    other.createdAt == createdAt &&
    other.processedAt == processedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (grossPaise.hashCode) +
    (tdsPaise.hashCode) +
    (netPaise.hashCode) +
    (upi.hashCode) +
    (status.hashCode) +
    (failureReason == null ? 0 : failureReason!.hashCode) +
    (createdAt.hashCode) +
    (processedAt == null ? 0 : processedAt!.hashCode);

  @override
  String toString() => 'Payout[id=$id, grossPaise=$grossPaise, tdsPaise=$tdsPaise, netPaise=$netPaise, upi=$upi, status=$status, failureReason=$failureReason, createdAt=$createdAt, processedAt=$processedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'grossPaise'] = this.grossPaise;
      json[r'tdsPaise'] = this.tdsPaise;
      json[r'netPaise'] = this.netPaise;
      json[r'upi'] = this.upi;
      json[r'status'] = this.status;
    if (this.failureReason != null) {
      json[r'failureReason'] = this.failureReason;
    } else {
      json[r'failureReason'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.processedAt != null) {
      json[r'processedAt'] = this.processedAt!.toUtc().toIso8601String();
    } else {
      json[r'processedAt'] = null;
    }
    return json;
  }

  /// Returns a new [Payout] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Payout? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Payout[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Payout[id]" has a null value in JSON.');
        assert(json.containsKey(r'grossPaise'), 'Required key "Payout[grossPaise]" is missing from JSON.');
        assert(json[r'grossPaise'] != null, 'Required key "Payout[grossPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsPaise'), 'Required key "Payout[tdsPaise]" is missing from JSON.');
        assert(json[r'tdsPaise'] != null, 'Required key "Payout[tdsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'netPaise'), 'Required key "Payout[netPaise]" is missing from JSON.');
        assert(json[r'netPaise'] != null, 'Required key "Payout[netPaise]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "Payout[upi]" is missing from JSON.');
        assert(json[r'upi'] != null, 'Required key "Payout[upi]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "Payout[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "Payout[status]" has a null value in JSON.');
        assert(json.containsKey(r'failureReason'), 'Required key "Payout[failureReason]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "Payout[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "Payout[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'processedAt'), 'Required key "Payout[processedAt]" is missing from JSON.');
        return true;
      }());

      return Payout(
        id: mapValueOfType<String>(json, r'id')!,
        grossPaise: mapValueOfType<int>(json, r'grossPaise')!,
        tdsPaise: mapValueOfType<int>(json, r'tdsPaise')!,
        netPaise: mapValueOfType<int>(json, r'netPaise')!,
        upi: mapValueOfType<String>(json, r'upi')!,
        status: PayoutStatusEnum.fromJson(json[r'status'])!,
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        processedAt: mapDateTime(json, r'processedAt', r''),
      );
    }
    return null;
  }

  static List<Payout> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Payout>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Payout.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Payout> mapFromJson(dynamic json) {
    final map = <String, Payout>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Payout.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Payout-objects as value to a dart map
  static Map<String, List<Payout>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Payout>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Payout.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'grossPaise',
    'tdsPaise',
    'netPaise',
    'upi',
    'status',
    'failureReason',
    'createdAt',
    'processedAt',
  };
}


enum PayoutStatusEnum {
  requested._(r'requested'),
  processing._(r'processing'),
  paid._(r'paid'),
  failed._(r'failed'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const PayoutStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PayoutStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PayoutStatusEnum? fromJson(dynamic value) => PayoutStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PayoutStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PayoutStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PayoutStatusEnum] to String,
/// and [decode] dynamic data back to [PayoutStatusEnum].
class PayoutStatusEnumTypeTransformer {
  factory PayoutStatusEnumTypeTransformer() => _instance ??= const PayoutStatusEnumTypeTransformer._();

  const PayoutStatusEnumTypeTransformer._();

  String encode(PayoutStatusEnum data) => data._value;

  /// Returns the instance of [PayoutStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PayoutStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PayoutStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return PayoutStatusEnum.requested;
        case r'processing': return PayoutStatusEnum.processing;
        case r'paid': return PayoutStatusEnum.paid;
        case r'failed': return PayoutStatusEnum.failed;
        case r'rejected': return PayoutStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PayoutStatusEnumTypeTransformer? _instance;
}


