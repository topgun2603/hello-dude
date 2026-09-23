//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RefundRequestInput {
  /// Returns a new [RefundRequestInput] instance.
  RefundRequestInput({
    required this.id,
    required this.status,
    required this.reason,
    required this.coinsEligible,
    required this.coinsRefunded,
    required this.note,
    required this.createdAt,
  });

  String id;

  RefundRequestInputStatusEnum status;

  RefundRequestInputReasonEnum reason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEligible;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  String? note;

  Object? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RefundRequestInput &&
    other.id == id &&
    other.status == status &&
    other.reason == reason &&
    other.coinsEligible == coinsEligible &&
    other.coinsRefunded == coinsRefunded &&
    other.note == note &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (reason.hashCode) +
    (coinsEligible.hashCode) +
    (coinsRefunded.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'RefundRequestInput[id=$id, status=$status, reason=$reason, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, note=$note, createdAt=$createdAt]';

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
    return json;
  }

  /// Returns a new [RefundRequestInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RefundRequestInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RefundRequestInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RefundRequestInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "RefundRequestInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "RefundRequestInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "RefundRequestInput[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "RefundRequestInput[reason]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "RefundRequestInput[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "RefundRequestInput[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "RefundRequestInput[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "RefundRequestInput[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "RefundRequestInput[note]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "RefundRequestInput[createdAt]" is missing from JSON.');
        return true;
      }());

      return RefundRequestInput(
        id: mapValueOfType<String>(json, r'id')!,
        status: RefundRequestInputStatusEnum.fromJson(json[r'status'])!,
        reason: RefundRequestInputReasonEnum.fromJson(json[r'reason'])!,
        coinsEligible: mapValueOfType<int>(json, r'coinsEligible')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        note: mapValueOfType<String>(json, r'note'),
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<RefundRequestInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequestInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequestInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RefundRequestInput> mapFromJson(dynamic json) {
    final map = <String, RefundRequestInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RefundRequestInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RefundRequestInput-objects as value to a dart map
  static Map<String, List<RefundRequestInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RefundRequestInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RefundRequestInput.listFromJson(entry.value, growable: growable,);
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
  };
}


enum RefundRequestInputStatusEnum {
  requested._(r'requested'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const RefundRequestInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RefundRequestInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RefundRequestInputStatusEnum? fromJson(dynamic value) => RefundRequestInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RefundRequestInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RefundRequestInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequestInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequestInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RefundRequestInputStatusEnum] to String,
/// and [decode] dynamic data back to [RefundRequestInputStatusEnum].
class RefundRequestInputStatusEnumTypeTransformer {
  factory RefundRequestInputStatusEnumTypeTransformer() => _instance ??= const RefundRequestInputStatusEnumTypeTransformer._();

  const RefundRequestInputStatusEnumTypeTransformer._();

  String encode(RefundRequestInputStatusEnum data) => data._value;

  /// Returns the instance of [RefundRequestInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RefundRequestInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RefundRequestInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return RefundRequestInputStatusEnum.requested;
        case r'approved': return RefundRequestInputStatusEnum.approved;
        case r'rejected': return RefundRequestInputStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RefundRequestInputStatusEnumTypeTransformer? _instance;
}



enum RefundRequestInputReasonEnum {
  callDropped._(r'call_dropped'),
  couldntHear._(r'couldnt_hear'),
  wrongLanguage._(r'wrong_language'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const RefundRequestInputReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RefundRequestInputReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RefundRequestInputReasonEnum? fromJson(dynamic value) => RefundRequestInputReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RefundRequestInputReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RefundRequestInputReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequestInputReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequestInputReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RefundRequestInputReasonEnum] to String,
/// and [decode] dynamic data back to [RefundRequestInputReasonEnum].
class RefundRequestInputReasonEnumTypeTransformer {
  factory RefundRequestInputReasonEnumTypeTransformer() => _instance ??= const RefundRequestInputReasonEnumTypeTransformer._();

  const RefundRequestInputReasonEnumTypeTransformer._();

  String encode(RefundRequestInputReasonEnum data) => data._value;

  /// Returns the instance of [RefundRequestInputReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RefundRequestInputReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RefundRequestInputReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call_dropped': return RefundRequestInputReasonEnum.callDropped;
        case r'couldnt_hear': return RefundRequestInputReasonEnum.couldntHear;
        case r'wrong_language': return RefundRequestInputReasonEnum.wrongLanguage;
        case r'other': return RefundRequestInputReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RefundRequestInputReasonEnumTypeTransformer? _instance;
}


