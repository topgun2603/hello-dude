//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PayoutInput {
  /// Returns a new [PayoutInput] instance.
  PayoutInput({
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

  PayoutInputStatusEnum status;

  String? failureReason;

  Object? createdAt;

  Object? processedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PayoutInput &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (processedAt == null ? 0 : processedAt!.hashCode);

  @override
  String toString() => 'PayoutInput[id=$id, grossPaise=$grossPaise, tdsPaise=$tdsPaise, netPaise=$netPaise, upi=$upi, status=$status, failureReason=$failureReason, createdAt=$createdAt, processedAt=$processedAt]';

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
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    if (this.processedAt != null) {
      json[r'processedAt'] = this.processedAt;
    } else {
      json[r'processedAt'] = null;
    }
    return json;
  }

  /// Returns a new [PayoutInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PayoutInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PayoutInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PayoutInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'grossPaise'), 'Required key "PayoutInput[grossPaise]" is missing from JSON.');
        assert(json[r'grossPaise'] != null, 'Required key "PayoutInput[grossPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsPaise'), 'Required key "PayoutInput[tdsPaise]" is missing from JSON.');
        assert(json[r'tdsPaise'] != null, 'Required key "PayoutInput[tdsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'netPaise'), 'Required key "PayoutInput[netPaise]" is missing from JSON.');
        assert(json[r'netPaise'] != null, 'Required key "PayoutInput[netPaise]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "PayoutInput[upi]" is missing from JSON.');
        assert(json[r'upi'] != null, 'Required key "PayoutInput[upi]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PayoutInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PayoutInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'failureReason'), 'Required key "PayoutInput[failureReason]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "PayoutInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'processedAt'), 'Required key "PayoutInput[processedAt]" is missing from JSON.');
        return true;
      }());

      return PayoutInput(
        id: mapValueOfType<String>(json, r'id')!,
        grossPaise: mapValueOfType<int>(json, r'grossPaise')!,
        tdsPaise: mapValueOfType<int>(json, r'tdsPaise')!,
        netPaise: mapValueOfType<int>(json, r'netPaise')!,
        upi: mapValueOfType<String>(json, r'upi')!,
        status: PayoutInputStatusEnum.fromJson(json[r'status'])!,
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        processedAt: mapValueOfType<Object>(json, r'processedAt'),
      );
    }
    return null;
  }

  static List<PayoutInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PayoutInput> mapFromJson(dynamic json) {
    final map = <String, PayoutInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PayoutInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PayoutInput-objects as value to a dart map
  static Map<String, List<PayoutInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PayoutInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PayoutInput.listFromJson(entry.value, growable: growable,);
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


enum PayoutInputStatusEnum {
  requested._(r'requested'),
  processing._(r'processing'),
  paid._(r'paid'),
  failed._(r'failed'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const PayoutInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PayoutInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PayoutInputStatusEnum? fromJson(dynamic value) => PayoutInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PayoutInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PayoutInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PayoutInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PayoutInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PayoutInputStatusEnum] to String,
/// and [decode] dynamic data back to [PayoutInputStatusEnum].
class PayoutInputStatusEnumTypeTransformer {
  factory PayoutInputStatusEnumTypeTransformer() => _instance ??= const PayoutInputStatusEnumTypeTransformer._();

  const PayoutInputStatusEnumTypeTransformer._();

  String encode(PayoutInputStatusEnum data) => data._value;

  /// Returns the instance of [PayoutInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PayoutInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PayoutInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return PayoutInputStatusEnum.requested;
        case r'processing': return PayoutInputStatusEnum.processing;
        case r'paid': return PayoutInputStatusEnum.paid;
        case r'failed': return PayoutInputStatusEnum.failed;
        case r'rejected': return PayoutInputStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PayoutInputStatusEnumTypeTransformer? _instance;
}


