//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseYesterday {
  /// Returns a new [AdminDashboard200ResponseYesterday] instance.
  AdminDashboard200ResponseYesterday({
    required this.connectedCalls,
    required this.coinsSpent,
    required this.newUsers,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int connectedCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newUsers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseYesterday &&
    other.connectedCalls == connectedCalls &&
    other.coinsSpent == coinsSpent &&
    other.newUsers == newUsers;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectedCalls.hashCode) +
    (coinsSpent.hashCode) +
    (newUsers.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseYesterday[connectedCalls=$connectedCalls, coinsSpent=$coinsSpent, newUsers=$newUsers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'connectedCalls'] = this.connectedCalls;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'newUsers'] = this.newUsers;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseYesterday] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseYesterday? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'connectedCalls'), 'Required key "AdminDashboard200ResponseYesterday[connectedCalls]" is missing from JSON.');
        assert(json[r'connectedCalls'] != null, 'Required key "AdminDashboard200ResponseYesterday[connectedCalls]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminDashboard200ResponseYesterday[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminDashboard200ResponseYesterday[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'newUsers'), 'Required key "AdminDashboard200ResponseYesterday[newUsers]" is missing from JSON.');
        assert(json[r'newUsers'] != null, 'Required key "AdminDashboard200ResponseYesterday[newUsers]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseYesterday(
        connectedCalls: mapValueOfType<int>(json, r'connectedCalls')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        newUsers: mapValueOfType<int>(json, r'newUsers')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseYesterday> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseYesterday>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseYesterday.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseYesterday> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseYesterday>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseYesterday.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseYesterday-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseYesterday>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseYesterday>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseYesterday.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connectedCalls',
    'coinsSpent',
    'newUsers',
  };
}

