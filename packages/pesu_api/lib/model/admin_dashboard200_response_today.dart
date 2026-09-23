//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseToday {
  /// Returns a new [AdminDashboard200ResponseToday] instance.
  AdminDashboard200ResponseToday({
    required this.connectedCalls,
    required this.minutesBilled,
    required this.coinsSpent,
    required this.companionEarningsPaise,
    required this.purchasesPaise,
    required this.newUsers,
    required this.newCallers,
    required this.newCompanions,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int connectedCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutesBilled;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionEarningsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int purchasesPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newUsers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCallers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCompanions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseToday &&
    other.connectedCalls == connectedCalls &&
    other.minutesBilled == minutesBilled &&
    other.coinsSpent == coinsSpent &&
    other.companionEarningsPaise == companionEarningsPaise &&
    other.purchasesPaise == purchasesPaise &&
    other.newUsers == newUsers &&
    other.newCallers == newCallers &&
    other.newCompanions == newCompanions;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectedCalls.hashCode) +
    (minutesBilled.hashCode) +
    (coinsSpent.hashCode) +
    (companionEarningsPaise.hashCode) +
    (purchasesPaise.hashCode) +
    (newUsers.hashCode) +
    (newCallers.hashCode) +
    (newCompanions.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseToday[connectedCalls=$connectedCalls, minutesBilled=$minutesBilled, coinsSpent=$coinsSpent, companionEarningsPaise=$companionEarningsPaise, purchasesPaise=$purchasesPaise, newUsers=$newUsers, newCallers=$newCallers, newCompanions=$newCompanions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'connectedCalls'] = this.connectedCalls;
      json[r'minutesBilled'] = this.minutesBilled;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'companionEarningsPaise'] = this.companionEarningsPaise;
      json[r'purchasesPaise'] = this.purchasesPaise;
      json[r'newUsers'] = this.newUsers;
      json[r'newCallers'] = this.newCallers;
      json[r'newCompanions'] = this.newCompanions;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseToday] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseToday? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'connectedCalls'), 'Required key "AdminDashboard200ResponseToday[connectedCalls]" is missing from JSON.');
        assert(json[r'connectedCalls'] != null, 'Required key "AdminDashboard200ResponseToday[connectedCalls]" has a null value in JSON.');
        assert(json.containsKey(r'minutesBilled'), 'Required key "AdminDashboard200ResponseToday[minutesBilled]" is missing from JSON.');
        assert(json[r'minutesBilled'] != null, 'Required key "AdminDashboard200ResponseToday[minutesBilled]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminDashboard200ResponseToday[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminDashboard200ResponseToday[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'companionEarningsPaise'), 'Required key "AdminDashboard200ResponseToday[companionEarningsPaise]" is missing from JSON.');
        assert(json[r'companionEarningsPaise'] != null, 'Required key "AdminDashboard200ResponseToday[companionEarningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'purchasesPaise'), 'Required key "AdminDashboard200ResponseToday[purchasesPaise]" is missing from JSON.');
        assert(json[r'purchasesPaise'] != null, 'Required key "AdminDashboard200ResponseToday[purchasesPaise]" has a null value in JSON.');
        assert(json.containsKey(r'newUsers'), 'Required key "AdminDashboard200ResponseToday[newUsers]" is missing from JSON.');
        assert(json[r'newUsers'] != null, 'Required key "AdminDashboard200ResponseToday[newUsers]" has a null value in JSON.');
        assert(json.containsKey(r'newCallers'), 'Required key "AdminDashboard200ResponseToday[newCallers]" is missing from JSON.');
        assert(json[r'newCallers'] != null, 'Required key "AdminDashboard200ResponseToday[newCallers]" has a null value in JSON.');
        assert(json.containsKey(r'newCompanions'), 'Required key "AdminDashboard200ResponseToday[newCompanions]" is missing from JSON.');
        assert(json[r'newCompanions'] != null, 'Required key "AdminDashboard200ResponseToday[newCompanions]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseToday(
        connectedCalls: mapValueOfType<int>(json, r'connectedCalls')!,
        minutesBilled: mapValueOfType<int>(json, r'minutesBilled')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        companionEarningsPaise: mapValueOfType<int>(json, r'companionEarningsPaise')!,
        purchasesPaise: mapValueOfType<int>(json, r'purchasesPaise')!,
        newUsers: mapValueOfType<int>(json, r'newUsers')!,
        newCallers: mapValueOfType<int>(json, r'newCallers')!,
        newCompanions: mapValueOfType<int>(json, r'newCompanions')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseToday> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseToday>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseToday.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseToday> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseToday>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseToday.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseToday-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseToday>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseToday>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseToday.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connectedCalls',
    'minutesBilled',
    'coinsSpent',
    'companionEarningsPaise',
    'purchasesPaise',
    'newUsers',
    'newCallers',
    'newCompanions',
  };
}

