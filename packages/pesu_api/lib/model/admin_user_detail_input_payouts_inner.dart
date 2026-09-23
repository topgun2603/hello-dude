//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputPayoutsInner {
  /// Returns a new [AdminUserDetailInputPayoutsInner] instance.
  AdminUserDetailInputPayoutsInner({
    required this.id,
    required this.createdAt,
    required this.grossPaise,
    required this.tdsPaise,
    required this.netPaise,
    required this.upiId,
    required this.status,
    required this.failureReason,
    required this.processedAt,
  });

  String id;

  Object? createdAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int grossPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int netPaise;

  /// Masked
  String upiId;

  String status;

  String? failureReason;

  Object? processedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputPayoutsInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.grossPaise == grossPaise &&
    other.tdsPaise == tdsPaise &&
    other.netPaise == netPaise &&
    other.upiId == upiId &&
    other.status == status &&
    other.failureReason == failureReason &&
    other.processedAt == processedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (grossPaise.hashCode) +
    (tdsPaise.hashCode) +
    (netPaise.hashCode) +
    (upiId.hashCode) +
    (status.hashCode) +
    (failureReason == null ? 0 : failureReason!.hashCode) +
    (processedAt == null ? 0 : processedAt!.hashCode);

  @override
  String toString() => 'AdminUserDetailInputPayoutsInner[id=$id, createdAt=$createdAt, grossPaise=$grossPaise, tdsPaise=$tdsPaise, netPaise=$netPaise, upiId=$upiId, status=$status, failureReason=$failureReason, processedAt=$processedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'grossPaise'] = this.grossPaise;
      json[r'tdsPaise'] = this.tdsPaise;
      json[r'netPaise'] = this.netPaise;
      json[r'upiId'] = this.upiId;
      json[r'status'] = this.status;
    if (this.failureReason != null) {
      json[r'failureReason'] = this.failureReason;
    } else {
      json[r'failureReason'] = null;
    }
    if (this.processedAt != null) {
      json[r'processedAt'] = this.processedAt;
    } else {
      json[r'processedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUserDetailInputPayoutsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputPayoutsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputPayoutsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputPayoutsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputPayoutsInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'grossPaise'), 'Required key "AdminUserDetailInputPayoutsInner[grossPaise]" is missing from JSON.');
        assert(json[r'grossPaise'] != null, 'Required key "AdminUserDetailInputPayoutsInner[grossPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsPaise'), 'Required key "AdminUserDetailInputPayoutsInner[tdsPaise]" is missing from JSON.');
        assert(json[r'tdsPaise'] != null, 'Required key "AdminUserDetailInputPayoutsInner[tdsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'netPaise'), 'Required key "AdminUserDetailInputPayoutsInner[netPaise]" is missing from JSON.');
        assert(json[r'netPaise'] != null, 'Required key "AdminUserDetailInputPayoutsInner[netPaise]" has a null value in JSON.');
        assert(json.containsKey(r'upiId'), 'Required key "AdminUserDetailInputPayoutsInner[upiId]" is missing from JSON.');
        assert(json[r'upiId'] != null, 'Required key "AdminUserDetailInputPayoutsInner[upiId]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInputPayoutsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInputPayoutsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'failureReason'), 'Required key "AdminUserDetailInputPayoutsInner[failureReason]" is missing from JSON.');
        assert(json.containsKey(r'processedAt'), 'Required key "AdminUserDetailInputPayoutsInner[processedAt]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailInputPayoutsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        grossPaise: mapValueOfType<int>(json, r'grossPaise')!,
        tdsPaise: mapValueOfType<int>(json, r'tdsPaise')!,
        netPaise: mapValueOfType<int>(json, r'netPaise')!,
        upiId: mapValueOfType<String>(json, r'upiId')!,
        status: mapValueOfType<String>(json, r'status')!,
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        processedAt: mapValueOfType<Object>(json, r'processedAt'),
      );
    }
    return null;
  }

  static List<AdminUserDetailInputPayoutsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputPayoutsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputPayoutsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputPayoutsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputPayoutsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputPayoutsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputPayoutsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputPayoutsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputPayoutsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputPayoutsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'grossPaise',
    'tdsPaise',
    'netPaise',
    'upiId',
    'status',
    'failureReason',
    'processedAt',
  };
}

