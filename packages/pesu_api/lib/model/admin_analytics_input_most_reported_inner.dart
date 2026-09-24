//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputMostReportedInner {
  /// Returns a new [AdminAnalyticsInputMostReportedInner] instance.
  AdminAnalyticsInputMostReportedInner({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.role,
    required this.reports,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  String role;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reports;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputMostReportedInner &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.role == role &&
    other.reports == reports;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (role.hashCode) +
    (reports.hashCode);

  @override
  String toString() => 'AdminAnalyticsInputMostReportedInner[id=$id, displayName=$displayName, avatarId=$avatarId, role=$role, reports=$reports]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'role'] = this.role;
      json[r'reports'] = this.reports;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputMostReportedInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputMostReportedInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsInputMostReportedInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsInputMostReportedInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsInputMostReportedInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsInputMostReportedInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsInputMostReportedInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsInputMostReportedInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "AdminAnalyticsInputMostReportedInner[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "AdminAnalyticsInputMostReportedInner[role]" has a null value in JSON.');
        assert(json.containsKey(r'reports'), 'Required key "AdminAnalyticsInputMostReportedInner[reports]" is missing from JSON.');
        assert(json[r'reports'] != null, 'Required key "AdminAnalyticsInputMostReportedInner[reports]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputMostReportedInner(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        role: mapValueOfType<String>(json, r'role')!,
        reports: mapValueOfType<int>(json, r'reports')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputMostReportedInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputMostReportedInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputMostReportedInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputMostReportedInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputMostReportedInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputMostReportedInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputMostReportedInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputMostReportedInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputMostReportedInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputMostReportedInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'role',
    'reports',
  };
}

