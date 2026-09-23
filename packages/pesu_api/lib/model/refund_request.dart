//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RefundRequest {
  /// Returns a new [RefundRequest] instance.
  RefundRequest({
    required this.id,
    required this.status,
    required this.reason,
    required this.coinsEligible,
    required this.coinsRefunded,
    required this.note,
    required this.createdAt,
  });

  String id;

  RefundRequestStatusEnum status;

  RefundRequestReasonEnum reason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEligible;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  String? note;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RefundRequest &&
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
    (createdAt.hashCode);

  @override
  String toString() => 'RefundRequest[id=$id, status=$status, reason=$reason, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, note=$note, createdAt=$createdAt]';

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
    return json;
  }

  /// Returns a new [RefundRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RefundRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RefundRequest[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RefundRequest[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "RefundRequest[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "RefundRequest[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "RefundRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "RefundRequest[reason]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "RefundRequest[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "RefundRequest[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "RefundRequest[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "RefundRequest[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "RefundRequest[note]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "RefundRequest[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "RefundRequest[createdAt]" has a null value in JSON.');
        return true;
      }());

      return RefundRequest(
        id: mapValueOfType<String>(json, r'id')!,
        status: RefundRequestStatusEnum.fromJson(json[r'status'])!,
        reason: RefundRequestReasonEnum.fromJson(json[r'reason'])!,
        coinsEligible: mapValueOfType<int>(json, r'coinsEligible')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        note: mapValueOfType<String>(json, r'note'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<RefundRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RefundRequest> mapFromJson(dynamic json) {
    final map = <String, RefundRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RefundRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RefundRequest-objects as value to a dart map
  static Map<String, List<RefundRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RefundRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RefundRequest.listFromJson(entry.value, growable: growable,);
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


enum RefundRequestStatusEnum {
  requested._(r'requested'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const RefundRequestStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RefundRequestStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RefundRequestStatusEnum? fromJson(dynamic value) => RefundRequestStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RefundRequestStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RefundRequestStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequestStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequestStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RefundRequestStatusEnum] to String,
/// and [decode] dynamic data back to [RefundRequestStatusEnum].
class RefundRequestStatusEnumTypeTransformer {
  factory RefundRequestStatusEnumTypeTransformer() => _instance ??= const RefundRequestStatusEnumTypeTransformer._();

  const RefundRequestStatusEnumTypeTransformer._();

  String encode(RefundRequestStatusEnum data) => data._value;

  /// Returns the instance of [RefundRequestStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RefundRequestStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RefundRequestStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'requested': return RefundRequestStatusEnum.requested;
        case r'approved': return RefundRequestStatusEnum.approved;
        case r'rejected': return RefundRequestStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RefundRequestStatusEnumTypeTransformer? _instance;
}



enum RefundRequestReasonEnum {
  callDropped._(r'call_dropped'),
  couldntHear._(r'couldnt_hear'),
  wrongLanguage._(r'wrong_language'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const RefundRequestReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RefundRequestReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RefundRequestReasonEnum? fromJson(dynamic value) => RefundRequestReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RefundRequestReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RefundRequestReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefundRequestReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefundRequestReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RefundRequestReasonEnum] to String,
/// and [decode] dynamic data back to [RefundRequestReasonEnum].
class RefundRequestReasonEnumTypeTransformer {
  factory RefundRequestReasonEnumTypeTransformer() => _instance ??= const RefundRequestReasonEnumTypeTransformer._();

  const RefundRequestReasonEnumTypeTransformer._();

  String encode(RefundRequestReasonEnum data) => data._value;

  /// Returns the instance of [RefundRequestReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RefundRequestReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RefundRequestReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call_dropped': return RefundRequestReasonEnum.callDropped;
        case r'couldnt_hear': return RefundRequestReasonEnum.couldntHear;
        case r'wrong_language': return RefundRequestReasonEnum.wrongLanguage;
        case r'other': return RefundRequestReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RefundRequestReasonEnumTypeTransformer? _instance;
}


