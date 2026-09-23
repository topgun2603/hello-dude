//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailPayoutsInner {
  /// Returns a new [AdminUserDetailPayoutsInner] instance.
  AdminUserDetailPayoutsInner({
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

  DateTime createdAt;

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

  DateTime? processedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailPayoutsInner &&
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
    (createdAt.hashCode) +
    (grossPaise.hashCode) +
    (tdsPaise.hashCode) +
    (netPaise.hashCode) +
    (upiId.hashCode) +
    (status.hashCode) +
    (failureReason == null ? 0 : failureReason!.hashCode) +
    (processedAt == null ? 0 : processedAt!.hashCode);

  @override
  String toString() => 'AdminUserDetailPayoutsInner[id=$id, createdAt=$createdAt, grossPaise=$grossPaise, tdsPaise=$tdsPaise, netPaise=$netPaise, upiId=$upiId, status=$status, failureReason=$failureReason, processedAt=$processedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
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
      json[r'processedAt'] = this.processedAt!.toUtc().toIso8601String();
    } else {
      json[r'processedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUserDetailPayoutsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailPayoutsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailPayoutsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailPayoutsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailPayoutsInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailPayoutsInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'grossPaise'), 'Required key "AdminUserDetailPayoutsInner[grossPaise]" is missing from JSON.');
        assert(json[r'grossPaise'] != null, 'Required key "AdminUserDetailPayoutsInner[grossPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsPaise'), 'Required key "AdminUserDetailPayoutsInner[tdsPaise]" is missing from JSON.');
        assert(json[r'tdsPaise'] != null, 'Required key "AdminUserDetailPayoutsInner[tdsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'netPaise'), 'Required key "AdminUserDetailPayoutsInner[netPaise]" is missing from JSON.');
        assert(json[r'netPaise'] != null, 'Required key "AdminUserDetailPayoutsInner[netPaise]" has a null value in JSON.');
        assert(json.containsKey(r'upiId'), 'Required key "AdminUserDetailPayoutsInner[upiId]" is missing from JSON.');
        assert(json[r'upiId'] != null, 'Required key "AdminUserDetailPayoutsInner[upiId]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailPayoutsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailPayoutsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'failureReason'), 'Required key "AdminUserDetailPayoutsInner[failureReason]" is missing from JSON.');
        assert(json.containsKey(r'processedAt'), 'Required key "AdminUserDetailPayoutsInner[processedAt]" is missing from JSON.');
        return true;
      }());

      return AdminUserDetailPayoutsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        grossPaise: mapValueOfType<int>(json, r'grossPaise')!,
        tdsPaise: mapValueOfType<int>(json, r'tdsPaise')!,
        netPaise: mapValueOfType<int>(json, r'netPaise')!,
        upiId: mapValueOfType<String>(json, r'upiId')!,
        status: mapValueOfType<String>(json, r'status')!,
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        processedAt: mapDateTime(json, r'processedAt', r''),
      );
    }
    return null;
  }

  static List<AdminUserDetailPayoutsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailPayoutsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailPayoutsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailPayoutsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailPayoutsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailPayoutsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailPayoutsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailPayoutsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailPayoutsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailPayoutsInner.listFromJson(entry.value, growable: growable,);
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

