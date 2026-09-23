//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputAuditInner {
  /// Returns a new [AdminUserDetailInputAuditInner] instance.
  AdminUserDetailInputAuditInner({
    required this.id,
    required this.createdAt,
    required this.actor,
    required this.action,
    this.details = const {},
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  Object? createdAt;

  String actor;

  String action;

  Map<String, Object> details;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputAuditInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.actor == actor &&
    other.action == action &&
    _deepEquality.equals(other.details, details);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (actor.hashCode) +
    (action.hashCode) +
    (details.hashCode);

  @override
  String toString() => 'AdminUserDetailInputAuditInner[id=$id, createdAt=$createdAt, actor=$actor, action=$action, details=$details]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'actor'] = this.actor;
      json[r'action'] = this.action;
      json[r'details'] = this.details;
    return json;
  }

  /// Returns a new [AdminUserDetailInputAuditInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputAuditInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputAuditInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputAuditInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputAuditInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'actor'), 'Required key "AdminUserDetailInputAuditInner[actor]" is missing from JSON.');
        assert(json[r'actor'] != null, 'Required key "AdminUserDetailInputAuditInner[actor]" has a null value in JSON.');
        assert(json.containsKey(r'action'), 'Required key "AdminUserDetailInputAuditInner[action]" is missing from JSON.');
        assert(json[r'action'] != null, 'Required key "AdminUserDetailInputAuditInner[action]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminUserDetailInputAuditInner[details]" is missing from JSON.');
        assert(json[r'details'] != null, 'Required key "AdminUserDetailInputAuditInner[details]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputAuditInner(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        actor: mapValueOfType<String>(json, r'actor')!,
        action: mapValueOfType<String>(json, r'action')!,
        details: mapCastOfType<String, Object>(json, r'details')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailInputAuditInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputAuditInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputAuditInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputAuditInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputAuditInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputAuditInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputAuditInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputAuditInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputAuditInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputAuditInner.listFromJson(entry.value, growable: growable,);
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

