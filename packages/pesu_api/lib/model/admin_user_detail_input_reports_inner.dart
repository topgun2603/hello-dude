//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputReportsInner {
  /// Returns a new [AdminUserDetailInputReportsInner] instance.
  AdminUserDetailInputReportsInner({
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

  Object? createdAt;

  AdminUserDetailInputReportsInnerDirectionEnum direction;

  AdminUserDetailInputReportsInnerOther other;

  String reason;

  String? details;

  String status;

  String? callId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputReportsInner &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (direction.hashCode) +
    (other.hashCode) +
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (status.hashCode) +
    (callId == null ? 0 : callId!.hashCode);

  @override
  String toString() => 'AdminUserDetailInputReportsInner[id=$id, createdAt=$createdAt, direction=$direction, other=$other, reason=$reason, details=$details, status=$status, callId=$callId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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

  /// Returns a new [AdminUserDetailInputReportsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputReportsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputReportsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputReportsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputReportsInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'direction'), 'Required key "AdminUserDetailInputReportsInner[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "AdminUserDetailInputReportsInner[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "AdminUserDetailInputReportsInner[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "AdminUserDetailInputReportsInner[other]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminUserDetailInputReportsInner[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminUserDetailInputReportsInner[reason]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminUserDetailInputReportsInner[details]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInputReportsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInputReportsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailInputReportsInner[callId]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailInputReportsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        direction: AdminUserDetailInputReportsInnerDirectionEnum.fromJson(json[r'direction'])!,
        other: AdminUserDetailInputReportsInnerOther.fromJson(json[r'other'])!,
        reason: mapValueOfType<String>(json, r'reason')!,
        details: mapValueOfType<String>(json, r'details'),
        status: mapValueOfType<String>(json, r'status')!,
        callId: mapValueOfType<String>(json, r'callId'),
      );
    }
    return null;
  }

  static List<AdminUserDetailInputReportsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputReportsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputReportsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputReportsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputReportsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputReportsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputReportsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputReportsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputReportsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputReportsInner.listFromJson(entry.value, growable: growable,);
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


enum AdminUserDetailInputReportsInnerDirectionEnum {
  against._(r'against'),
  by._(r'by'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputReportsInnerDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputReportsInnerDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputReportsInnerDirectionEnum? fromJson(dynamic value) => AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputReportsInnerDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputReportsInnerDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputReportsInnerDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputReportsInnerDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputReportsInnerDirectionEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputReportsInnerDirectionEnum].
class AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer {
  factory AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer() => _instance ??= const AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer._();

  const AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer._();

  String encode(AdminUserDetailInputReportsInnerDirectionEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputReportsInnerDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputReportsInnerDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputReportsInnerDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'against': return AdminUserDetailInputReportsInnerDirectionEnum.against;
        case r'by': return AdminUserDetailInputReportsInnerDirectionEnum.by;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputReportsInnerDirectionEnumTypeTransformer? _instance;
}


