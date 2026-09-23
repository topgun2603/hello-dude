//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailReportsInner {
  /// Returns a new [AdminUserDetailReportsInner] instance.
  AdminUserDetailReportsInner({
    required this.id,
    required this.createdAt,
    required this.direction,
    required this.other,
    required this.reason,
    required this.details,
    required this.status,
    required this.callId,
  });

  String id;

  DateTime createdAt;

  AdminUserDetailReportsInnerDirectionEnum direction;

  AdminRefundCompanion other;

  String reason;

  String? details;

  String status;

  String? callId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailReportsInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.direction == direction &&
    other.other == other &&
    other.reason == reason &&
    other.details == details &&
    other.status == status &&
    other.callId == callId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (direction.hashCode) +
    (other.hashCode) +
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (status.hashCode) +
    (callId == null ? 0 : callId!.hashCode);

  @override
  String toString() => 'AdminUserDetailReportsInner[id=$id, createdAt=$createdAt, direction=$direction, other=$other, reason=$reason, details=$details, status=$status, callId=$callId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'direction'] = this.direction;
      json[r'other'] = this.other;
      json[r'reason'] = this.reason;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
      json[r'status'] = this.status;
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUserDetailReportsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailReportsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailReportsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailReportsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailReportsInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailReportsInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "AdminUserDetailReportsInner[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "AdminUserDetailReportsInner[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "AdminUserDetailReportsInner[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "AdminUserDetailReportsInner[other]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminUserDetailReportsInner[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminUserDetailReportsInner[reason]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminUserDetailReportsInner[details]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailReportsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailReportsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailReportsInner[callId]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailReportsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        direction: AdminUserDetailReportsInnerDirectionEnum.fromJson(json[r'direction'])!,
        other: AdminRefundCompanion.fromJson(json[r'other'])!,
        reason: mapValueOfType<String>(json, r'reason')!,
        details: mapValueOfType<String>(json, r'details'),
        status: mapValueOfType<String>(json, r'status')!,
        callId: mapValueOfType<String>(json, r'callId'),
      );
    }
    return null;
  }

  static List<AdminUserDetailReportsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailReportsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailReportsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailReportsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailReportsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailReportsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailReportsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailReportsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailReportsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailReportsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'direction',
    'other',
    'reason',
    'details',
    'status',
    'callId',
  };
}


enum AdminUserDetailReportsInnerDirectionEnum {
  against._(r'against'),
  by._(r'by'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailReportsInnerDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailReportsInnerDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailReportsInnerDirectionEnum? fromJson(dynamic value) => AdminUserDetailReportsInnerDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailReportsInnerDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailReportsInnerDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailReportsInnerDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailReportsInnerDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailReportsInnerDirectionEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailReportsInnerDirectionEnum].
class AdminUserDetailReportsInnerDirectionEnumTypeTransformer {
  factory AdminUserDetailReportsInnerDirectionEnumTypeTransformer() => _instance ??= const AdminUserDetailReportsInnerDirectionEnumTypeTransformer._();

  const AdminUserDetailReportsInnerDirectionEnumTypeTransformer._();

  String encode(AdminUserDetailReportsInnerDirectionEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailReportsInnerDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailReportsInnerDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailReportsInnerDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'against': return AdminUserDetailReportsInnerDirectionEnum.against;
        case r'by': return AdminUserDetailReportsInnerDirectionEnum.by;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailReportsInnerDirectionEnumTypeTransformer? _instance;
}


