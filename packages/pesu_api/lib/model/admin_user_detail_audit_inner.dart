//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailAuditInner {
  /// Returns a new [AdminUserDetailAuditInner] instance.
  AdminUserDetailAuditInner({
    required this.id,
    required this.createdAt,
    required this.actor,
    required this.action,
    this.details = const {},
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  DateTime createdAt;

  String actor;

  String action;

  Map<String, Object> details;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailAuditInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.actor == actor &&
    other.action == action &&
    _deepEquality.equals(other.details, details);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (actor.hashCode) +
    (action.hashCode) +
    (details.hashCode);

  @override
  String toString() => 'AdminUserDetailAuditInner[id=$id, createdAt=$createdAt, actor=$actor, action=$action, details=$details]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'actor'] = this.actor;
      json[r'action'] = this.action;
      json[r'details'] = this.details;
    return json;
  }

  /// Returns a new [AdminUserDetailAuditInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailAuditInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailAuditInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailAuditInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailAuditInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailAuditInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'actor'), 'Required key "AdminUserDetailAuditInner[actor]" is missing from JSON.');
        assert(json[r'actor'] != null, 'Required key "AdminUserDetailAuditInner[actor]" has a null value in JSON.');
        assert(json.containsKey(r'action'), 'Required key "AdminUserDetailAuditInner[action]" is missing from JSON.');
        assert(json[r'action'] != null, 'Required key "AdminUserDetailAuditInner[action]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminUserDetailAuditInner[details]" is missing from JSON.');
        assert(json[r'details'] != null, 'Required key "AdminUserDetailAuditInner[details]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailAuditInner(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        actor: mapValueOfType<String>(json, r'actor')!,
        action: mapValueOfType<String>(json, r'action')!,
        details: mapCastOfType<String, Object>(json, r'details')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailAuditInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailAuditInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailAuditInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailAuditInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailAuditInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailAuditInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailAuditInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailAuditInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailAuditInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailAuditInner.listFromJson(entry.value, growable: growable,);
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
    'details',
  };
}

