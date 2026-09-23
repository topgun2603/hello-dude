//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminSetUserStatusRequest {
  /// Returns a new [AdminSetUserStatusRequest] instance.
  AdminSetUserStatusRequest({
    required this.status,
    required this.reason,
  });

  AdminSetUserStatusRequestStatusEnum status;

  String reason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminSetUserStatusRequest &&
    other.status == status &&
    other.reason == reason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (reason.hashCode);

  @override
  String toString() => 'AdminSetUserStatusRequest[status=$status, reason=$reason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
      json[r'reason'] = this.reason;
    return json;
  }

  /// Returns a new [AdminSetUserStatusRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminSetUserStatusRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "AdminSetUserStatusRequest[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminSetUserStatusRequest[status]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminSetUserStatusRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminSetUserStatusRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return AdminSetUserStatusRequest(
        status: AdminSetUserStatusRequestStatusEnum.fromJson(json[r'status'])!,
        reason: mapValueOfType<String>(json, r'reason')!,
      );
    }
    return null;
  }

  static List<AdminSetUserStatusRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminSetUserStatusRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminSetUserStatusRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminSetUserStatusRequest> mapFromJson(dynamic json) {
    final map = <String, AdminSetUserStatusRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminSetUserStatusRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminSetUserStatusRequest-objects as value to a dart map
  static Map<String, List<AdminSetUserStatusRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminSetUserStatusRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminSetUserStatusRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'reason',
  };
}


enum AdminSetUserStatusRequestStatusEnum {
  active._(r'active'),
  suspended._(r'suspended'),
  banned._(r'banned'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminSetUserStatusRequestStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminSetUserStatusRequestStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminSetUserStatusRequestStatusEnum? fromJson(dynamic value) => AdminSetUserStatusRequestStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminSetUserStatusRequestStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminSetUserStatusRequestStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminSetUserStatusRequestStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminSetUserStatusRequestStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminSetUserStatusRequestStatusEnum] to String,
/// and [decode] dynamic data back to [AdminSetUserStatusRequestStatusEnum].
class AdminSetUserStatusRequestStatusEnumTypeTransformer {
  factory AdminSetUserStatusRequestStatusEnumTypeTransformer() => _instance ??= const AdminSetUserStatusRequestStatusEnumTypeTransformer._();

  const AdminSetUserStatusRequestStatusEnumTypeTransformer._();

  String encode(AdminSetUserStatusRequestStatusEnum data) => data._value;

  /// Returns the instance of [AdminSetUserStatusRequestStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminSetUserStatusRequestStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminSetUserStatusRequestStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'active': return AdminSetUserStatusRequestStatusEnum.active;
        case r'suspended': return AdminSetUserStatusRequestStatusEnum.suspended;
        case r'banned': return AdminSetUserStatusRequestStatusEnum.banned;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminSetUserStatusRequestStatusEnumTypeTransformer? _instance;
}


