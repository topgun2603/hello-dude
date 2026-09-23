//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRefund {
  /// Returns a new [AdminRefund] instance.
  AdminRefund({
    required this.id,
    required this.status,
    required this.reason,
    required this.coinsEligible,
    required this.coinsRefunded,
    required this.note,
    required this.createdAt,
    required this.details,
    required this.call,
    required this.caller,
    required this.companion,
  });

  String id;

  AdminRefundStatusEnum status;

  AdminRefundReasonEnum reason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEligible;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  String? note;

  DateTime createdAt;

  String? details;

  AdminRefundCall call;

  AdminRefundCaller caller;

  AdminRefundCompanion companion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRefund &&
    other.id == id &&
    other.status == status &&
    other.reason == reason &&
    other.coinsEligible == coinsEligible &&
    other.coinsRefunded == coinsRefunded &&
    other.note == note &&
    other.createdAt == createdAt &&
    other.details == details &&
    other.call == call &&
    other.caller == caller &&
    other.companion == companion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (reason.hashCode) +
    (coinsEligible.hashCode) +
    (coinsRefunded.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (createdAt.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (call.hashCode) +
    (caller.hashCode) +
    (companion.hashCode);

  @override
  String toString() => 'AdminRefund[id=$id, status=$status, reason=$reason, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, note=$note, createdAt=$createdAt, details=$details, call=$call, caller=$caller, companion=$companion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
      json[r'reason'] = this.reason;
      json[r'coinsEligible'] = this.coinsEligible;
      json[r'coinsRefunded'] = this.coinsRefunded;
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
      json[r'call'] = this.call;
      json[r'caller'] = this.caller;
      json[r'companion'] = this.companion;
    return json;
  }

  /// Returns a new [AdminRefund] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRefund? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminRefund[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminRefund[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminRefund[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminRefund[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminRefund[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminRefund[reason]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "AdminRefund[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "AdminRefund[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "AdminRefund[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "AdminRefund[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminRefund[note]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminRefund[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminRefund[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminRefund[details]" is missing from JSON.');
        assert(json.containsKey(r'call'), 'Required key "AdminRefund[call]" is missing from JSON.');
        assert(json[r'call'] != null, 'Required key "AdminRefund[call]" has a null value in JSON.');
        assert(json.containsKey(r'caller'), 'Required key "AdminRefund[caller]" is missing from JSON.');
        assert(json[r'caller'] != null, 'Required key "AdminRefund[caller]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "AdminRefund[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "AdminRefund[companion]" has a null value in JSON.');
        return true;
      }());

      return AdminRefund(
        id: mapValueOfType<String>(json, r'id')!,
        status: AdminRefundStatusEnum.fromJson(json[r'status'])!,
        reason: AdminRefundReasonEnum.fromJson(json[r'reason'])!,
        coinsEligible: mapValueOfType<int>(json, r'coinsEligible')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        note: mapValueOfType<String>(json, r'note'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        details: mapValueOfType<String>(json, r'details'),
        call: AdminRefundCall.fromJson(json[r'call'])!,
        caller: AdminRefundCaller.fromJson(json[r'caller'])!,
        companion: AdminRefundCompanion.fromJson(json[r'companion'])!,
      );
    }
    return null;
  }

  static List<AdminRefund> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefund>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefund.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRefund> mapFromJson(dynamic json) {
    final map = <String, AdminRefund>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRefund.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRefund-objects as value to a dart map
  static Map<String, List<AdminRefund>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRefund>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRefund.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'reason',
    'coinsEligible',
    'coinsRefunded',
    'note',
    'createdAt',
    'details',
    'call',
    'caller',
    'companion',
  };
}


enum AdminRefundStatusEnum {
  requested._(r'requested'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminRefundStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRefundStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRefundStatusEnum? fromJson(dynamic value) => AdminRefundStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRefundStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRefundStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRefundStatusEnum] to String,
/// and [decode] dynamic data back to [AdminRefundStatusEnum].
class AdminRefundStatusEnumTypeTransformer {
  factory AdminRefundStatusEnumTypeTransformer() => _instance ??= const AdminRefundStatusEnumTypeTransformer._();

  const AdminRefundStatusEnumTypeTransformer._();

  String encode(AdminRefundStatusEnum data) => data._value;

  /// Returns the instance of [AdminRefundStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRefundStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRefundStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return AdminRefundStatusEnum.requested;
        case r'approved': return AdminRefundStatusEnum.approved;
        case r'rejected': return AdminRefundStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRefundStatusEnumTypeTransformer? _instance;
}



enum AdminRefundReasonEnum {
  callDropped._(r'call_dropped'),
  couldntHear._(r'couldnt_hear'),
  wrongLanguage._(r'wrong_language'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminRefundReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRefundReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRefundReasonEnum? fromJson(dynamic value) => AdminRefundReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRefundReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRefundReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRefundReasonEnum] to String,
/// and [decode] dynamic data back to [AdminRefundReasonEnum].
class AdminRefundReasonEnumTypeTransformer {
  factory AdminRefundReasonEnumTypeTransformer() => _instance ??= const AdminRefundReasonEnumTypeTransformer._();

  const AdminRefundReasonEnumTypeTransformer._();

  String encode(AdminRefundReasonEnum data) => data._value;

  /// Returns the instance of [AdminRefundReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRefundReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRefundReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call_dropped': return AdminRefundReasonEnum.callDropped;
        case r'couldnt_hear': return AdminRefundReasonEnum.couldntHear;
        case r'wrong_language': return AdminRefundReasonEnum.wrongLanguage;
        case r'other': return AdminRefundReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRefundReasonEnumTypeTransformer? _instance;
}


