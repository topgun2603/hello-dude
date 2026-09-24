//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputVip {
  /// Returns a new [AdminUserDetailInputVip] instance.
  AdminUserDetailInputVip({
    required this.expiresAt,
    required this.source_,
  });

  Object? expiresAt;

  String source_;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputVip &&
    other.expiresAt == expiresAt &&
    other.source_ == source_;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (expiresAt == null ? 0 : expiresAt!.hashCode) +
    (source_.hashCode);

  @override
  String toString() => 'AdminUserDetailInputVip[expiresAt=$expiresAt, source_=$source_]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.expiresAt != null) {
      json[r'expiresAt'] = this.expiresAt;
    } else {
      json[r'expiresAt'] = null;
    }
      json[r'source'] = this.source_;
    return json;
  }

  /// Returns a new [AdminUserDetailInputVip] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputVip? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'expiresAt'), 'Required key "AdminUserDetailInputVip[expiresAt]" is missing from JSON.');
        assert(json.containsKey(r'source'), 'Required key "AdminUserDetailInputVip[source]" is missing from JSON.');
        assert(json[r'source'] != null, 'Required key "AdminUserDetailInputVip[source]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputVip(
        expiresAt: mapValueOfType<Object>(json, r'expiresAt'),
        source_: mapValueOfType<String>(json, r'source')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailInputVip> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputVip>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputVip.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputVip> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputVip>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputVip.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputVip-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputVip>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputVip>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputVip.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'expiresAt',
    'source',
  };
}

