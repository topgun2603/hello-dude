//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRefundInput {
  /// Returns a new [AdminRefundInput] instance.
  AdminRefundInput({
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

  AdminRefundInputStatusEnum status;

  AdminRefundInputReasonEnum reason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEligible;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  String? note;

  Object? createdAt;

  String? details;

  AdminRefundInputCall call;

  AdminRefundInputCaller caller;

  AdminRefundInputCompanion companion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRefundInput &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (call.hashCode) +
    (caller.hashCode) +
    (companion.hashCode);

  @override
  String toString() => 'AdminRefundInput[id=$id, status=$status, reason=$reason, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, note=$note, createdAt=$createdAt, details=$details, call=$call, caller=$caller, companion=$companion]';

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
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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

  /// Returns a new [AdminRefundInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRefundInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminRefundInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminRefundInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminRefundInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminRefundInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminRefundInput[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminRefundInput[reason]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "AdminRefundInput[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "AdminRefundInput[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "AdminRefundInput[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "AdminRefundInput[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminRefundInput[note]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminRefundInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminRefundInput[details]" is missing from JSON.');
        assert(json.containsKey(r'call'), 'Required key "AdminRefundInput[call]" is missing from JSON.');
        assert(json[r'call'] != null, 'Required key "AdminRefundInput[call]" has a null value in JSON.');
        assert(json.containsKey(r'caller'), 'Required key "AdminRefundInput[caller]" is missing from JSON.');
        assert(json[r'caller'] != null, 'Required key "AdminRefundInput[caller]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "AdminRefundInput[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "AdminRefundInput[companion]" has a null value in JSON.');
        return true;
      }());

      return AdminRefundInput(
        id: mapValueOfType<String>(json, r'id')!,
        status: AdminRefundInputStatusEnum.fromJson(json[r'status'])!,
        reason: AdminRefundInputReasonEnum.fromJson(json[r'reason'])!,
        coinsEligible: mapValueOfType<int>(json, r'coinsEligible')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        note: mapValueOfType<String>(json, r'note'),
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        details: mapValueOfType<String>(json, r'details'),
        call: AdminRefundInputCall.fromJson(json[r'call'])!,
        caller: AdminRefundInputCaller.fromJson(json[r'caller'])!,
        companion: AdminRefundInputCompanion.fromJson(json[r'companion'])!,
      );
    }
    return null;
  }

  static List<AdminRefundInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRefundInput> mapFromJson(dynamic json) {
    final map = <String, AdminRefundInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRefundInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRefundInput-objects as value to a dart map
  static Map<String, List<AdminRefundInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRefundInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRefundInput.listFromJson(entry.value, growable: growable,);
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


enum AdminRefundInputStatusEnum {
  requested._(r'requested'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminRefundInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRefundInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRefundInputStatusEnum? fromJson(dynamic value) => AdminRefundInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRefundInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRefundInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRefundInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminRefundInputStatusEnum].
class AdminRefundInputStatusEnumTypeTransformer {
  factory AdminRefundInputStatusEnumTypeTransformer() => _instance ??= const AdminRefundInputStatusEnumTypeTransformer._();

  const AdminRefundInputStatusEnumTypeTransformer._();

  String encode(AdminRefundInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminRefundInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRefundInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRefundInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return AdminRefundInputStatusEnum.requested;
        case r'approved': return AdminRefundInputStatusEnum.approved;
        case r'rejected': return AdminRefundInputStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRefundInputStatusEnumTypeTransformer? _instance;
}



enum AdminRefundInputReasonEnum {
  callDropped._(r'call_dropped'),
  couldntHear._(r'couldnt_hear'),
  wrongLanguage._(r'wrong_language'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminRefundInputReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminRefundInputReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminRefundInputReasonEnum? fromJson(dynamic value) => AdminRefundInputReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminRefundInputReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminRefundInputReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundInputReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundInputReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminRefundInputReasonEnum] to String,
/// and [decode] dynamic data back to [AdminRefundInputReasonEnum].
class AdminRefundInputReasonEnumTypeTransformer {
  factory AdminRefundInputReasonEnumTypeTransformer() => _instance ??= const AdminRefundInputReasonEnumTypeTransformer._();

  const AdminRefundInputReasonEnumTypeTransformer._();

  String encode(AdminRefundInputReasonEnum data) => data._value;

  /// Returns the instance of [AdminRefundInputReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminRefundInputReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminRefundInputReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call_dropped': return AdminRefundInputReasonEnum.callDropped;
        case r'couldnt_hear': return AdminRefundInputReasonEnum.couldntHear;
        case r'wrong_language': return AdminRefundInputReasonEnum.wrongLanguage;
        case r'other': return AdminRefundInputReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminRefundInputReasonEnumTypeTransformer? _instance;
}


