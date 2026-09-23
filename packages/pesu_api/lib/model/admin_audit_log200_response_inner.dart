//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAuditLog200ResponseInner {
  /// Returns a new [AdminAuditLog200ResponseInner] instance.
  AdminAuditLog200ResponseInner({
    required this.id,
    required this.createdAt,
    required this.actor,
    required this.action,
    required this.targetType,
    required this.targetId,
    this.details = const {},
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  DateTime createdAt;

  String actor;

  String action;

  String targetType;

  String targetId;

  Map<String, Object> details;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAuditLog200ResponseInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.actor == actor &&
    other.action == action &&
    other.targetType == targetType &&
    other.targetId == targetId &&
    _deepEquality.equals(other.details, details);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (actor.hashCode) +
    (action.hashCode) +
    (targetType.hashCode) +
    (targetId.hashCode) +
    (details.hashCode);

  @override
  String toString() => 'AdminAuditLog200ResponseInner[id=$id, createdAt=$createdAt, actor=$actor, action=$action, targetType=$targetType, targetId=$targetId, details=$details]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'actor'] = this.actor;
      json[r'action'] = this.action;
      json[r'targetType'] = this.targetType;
      json[r'targetId'] = this.targetId;
      json[r'details'] = this.details;
    return json;
  }

  /// Returns a new [AdminAuditLog200ResponseInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAuditLog200ResponseInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAuditLog200ResponseInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAuditLog200ResponseInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminAuditLog200ResponseInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminAuditLog200ResponseInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'actor'), 'Required key "AdminAuditLog200ResponseInner[actor]" is missing from JSON.');
        assert(json[r'actor'] != null, 'Required key "AdminAuditLog200ResponseInner[actor]" has a null value in JSON.');
        assert(json.containsKey(r'action'), 'Required key "AdminAuditLog200ResponseInner[action]" is missing from JSON.');
        assert(json[r'action'] != null, 'Required key "AdminAuditLog200ResponseInner[action]" has a null value in JSON.');
        assert(json.containsKey(r'targetType'), 'Required key "AdminAuditLog200ResponseInner[targetType]" is missing from JSON.');
        assert(json[r'targetType'] != null, 'Required key "AdminAuditLog200ResponseInner[targetType]" has a null value in JSON.');
        assert(json.containsKey(r'targetId'), 'Required key "AdminAuditLog200ResponseInner[targetId]" is missing from JSON.');
        assert(json[r'targetId'] != null, 'Required key "AdminAuditLog200ResponseInner[targetId]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminAuditLog200ResponseInner[details]" is missing from JSON.');
        assert(json[r'details'] != null, 'Required key "AdminAuditLog200ResponseInner[details]" has a null value in JSON.');
        return true;
      }());

      return AdminAuditLog200ResponseInner(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        actor: mapValueOfType<String>(json, r'actor')!,
        action: mapValueOfType<String>(json, r'action')!,
        targetType: mapValueOfType<String>(json, r'targetType')!,
        targetId: mapValueOfType<String>(json, r'targetId')!,
        details: mapCastOfType<String, Object>(json, r'details')!,
      );
    }
    return null;
  }

  static List<AdminAuditLog200ResponseInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAuditLog200ResponseInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAuditLog200ResponseInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAuditLog200ResponseInner> mapFromJson(dynamic json) {
    final map = <String, AdminAuditLog200ResponseInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAuditLog200ResponseInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAuditLog200ResponseInner-objects as value to a dart map
  static Map<String, List<AdminAuditLog200ResponseInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAuditLog200ResponseInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAuditLog200ResponseInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'actor',
    'action',
    'targetType',
    'targetId',
    'details',
  };
}

