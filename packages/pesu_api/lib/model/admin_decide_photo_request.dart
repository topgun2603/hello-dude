//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDecidePhotoRequest {
  /// Returns a new [AdminDecidePhotoRequest] instance.
  AdminDecidePhotoRequest({
    required this.decision,
    this.reason,
  });

  AdminDecidePhotoRequestDecisionEnum decision;

  String? reason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDecidePhotoRequest &&
    other.decision == decision &&
    other.reason == reason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (reason == null ? 0 : reason!.hashCode);

  @override
  String toString() => 'AdminDecidePhotoRequest[decision=$decision, reason=$reason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    return json;
  }

  /// Returns a new [AdminDecidePhotoRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDecidePhotoRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "AdminDecidePhotoRequest[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AdminDecidePhotoRequest[decision]" has a null value in JSON.');
        return true;
      }());

      return AdminDecidePhotoRequest(
        decision: AdminDecidePhotoRequestDecisionEnum.fromJson(json[r'decision'])!,
        reason: mapValueOfType<String>(json, r'reason'),
      );
    }
    return null;
  }

  static List<AdminDecidePhotoRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDecidePhotoRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDecidePhotoRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDecidePhotoRequest> mapFromJson(dynamic json) {
    final map = <String, AdminDecidePhotoRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDecidePhotoRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDecidePhotoRequest-objects as value to a dart map
  static Map<String, List<AdminDecidePhotoRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDecidePhotoRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDecidePhotoRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'decision',
  };
}


enum AdminDecidePhotoRequestDecisionEnum {
  approve._(r'approve'),
  reject._(r'reject'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminDecidePhotoRequestDecisionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminDecidePhotoRequestDecisionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminDecidePhotoRequestDecisionEnum? fromJson(dynamic value) => AdminDecidePhotoRequestDecisionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminDecidePhotoRequestDecisionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminDecidePhotoRequestDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDecidePhotoRequestDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDecidePhotoRequestDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDecidePhotoRequestDecisionEnum] to String,
/// and [decode] dynamic data back to [AdminDecidePhotoRequestDecisionEnum].
class AdminDecidePhotoRequestDecisionEnumTypeTransformer {
  factory AdminDecidePhotoRequestDecisionEnumTypeTransformer() => _instance ??= const AdminDecidePhotoRequestDecisionEnumTypeTransformer._();

  const AdminDecidePhotoRequestDecisionEnumTypeTransformer._();

  String encode(AdminDecidePhotoRequestDecisionEnum data) => data._value;

  /// Returns the instance of [AdminDecidePhotoRequestDecisionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDecidePhotoRequestDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminDecidePhotoRequestDecisionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'approve': return AdminDecidePhotoRequestDecisionEnum.approve;
        case r'reject': return AdminDecidePhotoRequestDecisionEnum.reject;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminDecidePhotoRequestDecisionEnumTypeTransformer? _instance;
}


