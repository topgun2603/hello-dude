//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminPayout {
  /// Returns a new [AdminPayout] instance.
  AdminPayout({
    required this.id,
    required this.companion,
    required this.grossPaise,
    required this.tdsPaise,
    required this.netPaise,
    required this.upi,
    required this.status,
    this.flags = const [],
    required this.failureReason,
    required this.providerRef,
    required this.createdAt,
    required this.processedAt,
  });

  String id;

  AdminPayoutCompanion companion;

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

  AdminPayoutStatusEnum status;

  List<String> flags;

  String? failureReason;

  String? providerRef;

  DateTime createdAt;

  DateTime? processedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPayout &&
    other.id == id &&
    other.companion == companion &&
    other.grossPaise == grossPaise &&
    other.tdsPaise == tdsPaise &&
    other.netPaise == netPaise &&
    other.upi == upi &&
    other.status == status &&
    _deepEquality.equals(other.flags, flags) &&
    other.failureReason == failureReason &&
    other.providerRef == providerRef &&
    other.createdAt == createdAt &&
    other.processedAt == processedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (companion.hashCode) +
    (grossPaise.hashCode) +
    (tdsPaise.hashCode) +
    (netPaise.hashCode) +
    (upi.hashCode) +
    (status.hashCode) +
    (flags.hashCode) +
    (failureReason == null ? 0 : failureReason!.hashCode) +
    (providerRef == null ? 0 : providerRef!.hashCode) +
    (createdAt.hashCode) +
    (processedAt == null ? 0 : processedAt!.hashCode);

  @override
  String toString() => 'AdminPayout[id=$id, companion=$companion, grossPaise=$grossPaise, tdsPaise=$tdsPaise, netPaise=$netPaise, upi=$upi, status=$status, flags=$flags, failureReason=$failureReason, providerRef=$providerRef, createdAt=$createdAt, processedAt=$processedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'companion'] = this.companion;
      json[r'grossPaise'] = this.grossPaise;
      json[r'tdsPaise'] = this.tdsPaise;
      json[r'netPaise'] = this.netPaise;
      json[r'upi'] = this.upi;
      json[r'status'] = this.status;
      json[r'flags'] = this.flags;
    if (this.failureReason != null) {
      json[r'failureReason'] = this.failureReason;
    } else {
      json[r'failureReason'] = null;
    }
    if (this.providerRef != null) {
      json[r'providerRef'] = this.providerRef;
    } else {
      json[r'providerRef'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.processedAt != null) {
      json[r'processedAt'] = this.processedAt!.toUtc().toIso8601String();
    } else {
      json[r'processedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminPayout] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPayout? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminPayout[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminPayout[id]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "AdminPayout[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "AdminPayout[companion]" has a null value in JSON.');
        assert(json.containsKey(r'grossPaise'), 'Required key "AdminPayout[grossPaise]" is missing from JSON.');
        assert(json[r'grossPaise'] != null, 'Required key "AdminPayout[grossPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsPaise'), 'Required key "AdminPayout[tdsPaise]" is missing from JSON.');
        assert(json[r'tdsPaise'] != null, 'Required key "AdminPayout[tdsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'netPaise'), 'Required key "AdminPayout[netPaise]" is missing from JSON.');
        assert(json[r'netPaise'] != null, 'Required key "AdminPayout[netPaise]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "AdminPayout[upi]" is missing from JSON.');
        assert(json[r'upi'] != null, 'Required key "AdminPayout[upi]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminPayout[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminPayout[status]" has a null value in JSON.');
        assert(json.containsKey(r'flags'), 'Required key "AdminPayout[flags]" is missing from JSON.');
        assert(json[r'flags'] != null, 'Required key "AdminPayout[flags]" has a null value in JSON.');
        assert(json.containsKey(r'failureReason'), 'Required key "AdminPayout[failureReason]" is missing from JSON.');
        assert(json.containsKey(r'providerRef'), 'Required key "AdminPayout[providerRef]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminPayout[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminPayout[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'processedAt'), 'Required key "AdminPayout[processedAt]" is missing from JSON.');
        return true;
      }());

      return AdminPayout(
        id: mapValueOfType<String>(json, r'id')!,
        companion: AdminPayoutCompanion.fromJson(json[r'companion'])!,
        grossPaise: mapValueOfType<int>(json, r'grossPaise')!,
        tdsPaise: mapValueOfType<int>(json, r'tdsPaise')!,
        netPaise: mapValueOfType<int>(json, r'netPaise')!,
        upi: mapValueOfType<String>(json, r'upi')!,
        status: AdminPayoutStatusEnum.fromJson(json[r'status'])!,
        flags: json[r'flags'] is Iterable
            ? (json[r'flags'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        providerRef: mapValueOfType<String>(json, r'providerRef'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        processedAt: mapDateTime(json, r'processedAt', r''),
      );
    }
    return null;
  }

  static List<AdminPayout> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPayout>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPayout.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPayout> mapFromJson(dynamic json) {
    final map = <String, AdminPayout>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPayout.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPayout-objects as value to a dart map
  static Map<String, List<AdminPayout>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPayout>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPayout.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'companion',
    'grossPaise',
    'tdsPaise',
    'netPaise',
    'upi',
    'status',
    'flags',
    'failureReason',
    'providerRef',
    'createdAt',
    'processedAt',
  };
}


enum AdminPayoutStatusEnum {
  requested._(r'requested'),
  processing._(r'processing'),
  paid._(r'paid'),
  failed._(r'failed'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPayoutStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPayoutStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPayoutStatusEnum? fromJson(dynamic value) => AdminPayoutStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPayoutStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPayoutStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPayoutStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPayoutStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPayoutStatusEnum] to String,
/// and [decode] dynamic data back to [AdminPayoutStatusEnum].
class AdminPayoutStatusEnumTypeTransformer {
  factory AdminPayoutStatusEnumTypeTransformer() => _instance ??= const AdminPayoutStatusEnumTypeTransformer._();

  const AdminPayoutStatusEnumTypeTransformer._();

  String encode(AdminPayoutStatusEnum data) => data._value;

  /// Returns the instance of [AdminPayoutStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPayoutStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPayoutStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return AdminPayoutStatusEnum.requested;
        case r'processing': return AdminPayoutStatusEnum.processing;
        case r'paid': return AdminPayoutStatusEnum.paid;
        case r'failed': return AdminPayoutStatusEnum.failed;
        case r'rejected': return AdminPayoutStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPayoutStatusEnumTypeTransformer? _instance;
}


