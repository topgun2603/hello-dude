//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycDecisionRequest {
  /// Returns a new [AdminKycDecisionRequest] instance.
  AdminKycDecisionRequest({
    required this.decision,
    required this.reason,
    this.redo = const [],
  });

  AdminKycDecisionRequestDecisionEnum decision;

  String reason;

  /// Reject only: what they must send again (only these reset). Empty = they fix it and press Submit.
  List<AdminKycDecisionRequestRedoEnum>? redo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycDecisionRequest &&
    other.decision == decision &&
    other.reason == reason &&
    _deepEquality.equals(other.redo, redo);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (reason.hashCode) +
    (redo == null ? 0 : redo!.hashCode);

  @override
  String toString() => 'AdminKycDecisionRequest[decision=$decision, reason=$reason, redo=$redo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
      json[r'reason'] = this.reason;
    if (this.redo != null) {
      json[r'redo'] = this.redo;
    } else {
      json[r'redo'] = null;
    }
    return json;
  }

  /// Returns a new [AdminKycDecisionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycDecisionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "AdminKycDecisionRequest[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AdminKycDecisionRequest[decision]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminKycDecisionRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminKycDecisionRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return AdminKycDecisionRequest(
        decision: AdminKycDecisionRequestDecisionEnum.fromJson(json[r'decision'])!,
        reason: mapValueOfType<String>(json, r'reason')!,
        redo: AdminKycDecisionRequestRedoEnum.listFromJson(json[r'redo']),
      );
    }
    return null;
  }

  static List<AdminKycDecisionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycDecisionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycDecisionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycDecisionRequest> mapFromJson(dynamic json) {
    final map = <String, AdminKycDecisionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycDecisionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycDecisionRequest-objects as value to a dart map
  static Map<String, List<AdminKycDecisionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycDecisionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycDecisionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'decision',
    'reason',
  };
}


enum AdminKycDecisionRequestDecisionEnum {
  approve._(r'approve'),
  reject._(r'reject'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycDecisionRequestDecisionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycDecisionRequestDecisionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycDecisionRequestDecisionEnum? fromJson(dynamic value) => AdminKycDecisionRequestDecisionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycDecisionRequestDecisionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycDecisionRequestDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycDecisionRequestDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycDecisionRequestDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycDecisionRequestDecisionEnum] to String,
/// and [decode] dynamic data back to [AdminKycDecisionRequestDecisionEnum].
class AdminKycDecisionRequestDecisionEnumTypeTransformer {
  factory AdminKycDecisionRequestDecisionEnumTypeTransformer() => _instance ??= const AdminKycDecisionRequestDecisionEnumTypeTransformer._();

  const AdminKycDecisionRequestDecisionEnumTypeTransformer._();

  String encode(AdminKycDecisionRequestDecisionEnum data) => data._value;

  /// Returns the instance of [AdminKycDecisionRequestDecisionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycDecisionRequestDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycDecisionRequestDecisionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'approve': return AdminKycDecisionRequestDecisionEnum.approve;
        case r'reject': return AdminKycDecisionRequestDecisionEnum.reject;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycDecisionRequestDecisionEnumTypeTransformer? _instance;
}



enum AdminKycDecisionRequestRedoEnum {
  age._(r'age'),
  selfie._(r'selfie'),
  voice._(r'voice'),
  pan._(r'pan'),
  upi._(r'upi'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycDecisionRequestRedoEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycDecisionRequestRedoEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycDecisionRequestRedoEnum? fromJson(dynamic value) => AdminKycDecisionRequestRedoEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycDecisionRequestRedoEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycDecisionRequestRedoEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycDecisionRequestRedoEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycDecisionRequestRedoEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycDecisionRequestRedoEnum] to String,
/// and [decode] dynamic data back to [AdminKycDecisionRequestRedoEnum].
class AdminKycDecisionRequestRedoEnumTypeTransformer {
  factory AdminKycDecisionRequestRedoEnumTypeTransformer() => _instance ??= const AdminKycDecisionRequestRedoEnumTypeTransformer._();

  const AdminKycDecisionRequestRedoEnumTypeTransformer._();

  String encode(AdminKycDecisionRequestRedoEnum data) => data._value;

  /// Returns the instance of [AdminKycDecisionRequestRedoEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycDecisionRequestRedoEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycDecisionRequestRedoEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'age': return AdminKycDecisionRequestRedoEnum.age;
        case r'selfie': return AdminKycDecisionRequestRedoEnum.selfie;
        case r'voice': return AdminKycDecisionRequestRedoEnum.voice;
        case r'pan': return AdminKycDecisionRequestRedoEnum.pan;
        case r'upi': return AdminKycDecisionRequestRedoEnum.upi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycDecisionRequestRedoEnumTypeTransformer? _instance;
}


