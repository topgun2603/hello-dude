//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputDailyInner {
  /// Returns a new [AdminAnalyticsInputDailyInner] instance.
  AdminAnalyticsInputDailyInner({
    required this.date,
    required this.calls,
    required this.minutes,
    required this.coinsSpent,
    required this.salesPaise,
    required this.earningsPaise,
    required this.newCallers,
    required this.newCompanions,
    required this.activeCallers,
  });

  String date;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int salesPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earningsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCallers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCompanions;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int activeCallers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputDailyInner &&
    other.date == date &&
    other.calls == calls &&
    other.minutes == minutes &&
    other.coinsSpent == coinsSpent &&
    other.salesPaise == salesPaise &&
    other.earningsPaise == earningsPaise &&
    other.newCallers == newCallers &&
    other.newCompanions == newCompanions &&
    other.activeCallers == activeCallers;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (calls.hashCode) +
    (minutes.hashCode) +
    (coinsSpent.hashCode) +
    (salesPaise.hashCode) +
    (earningsPaise.hashCode) +
    (newCallers.hashCode) +
    (newCompanions.hashCode) +
    (activeCallers.hashCode);

  @override
  String toString() => 'AdminAnalyticsInputDailyInner[date=$date, calls=$calls, minutes=$minutes, coinsSpent=$coinsSpent, salesPaise=$salesPaise, earningsPaise=$earningsPaise, newCallers=$newCallers, newCompanions=$newCompanions, activeCallers=$activeCallers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'salesPaise'] = this.salesPaise;
      json[r'earningsPaise'] = this.earningsPaise;
      json[r'newCallers'] = this.newCallers;
      json[r'newCompanions'] = this.newCompanions;
      json[r'activeCallers'] = this.activeCallers;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputDailyInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputDailyInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "AdminAnalyticsInputDailyInner[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "AdminAnalyticsInputDailyInner[date]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsInputDailyInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsInputDailyInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsInputDailyInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsInputDailyInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminAnalyticsInputDailyInner[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminAnalyticsInputDailyInner[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'salesPaise'), 'Required key "AdminAnalyticsInputDailyInner[salesPaise]" is missing from JSON.');
        assert(json[r'salesPaise'] != null, 'Required key "AdminAnalyticsInputDailyInner[salesPaise]" has a null value in JSON.');
        assert(json.containsKey(r'earningsPaise'), 'Required key "AdminAnalyticsInputDailyInner[earningsPaise]" is missing from JSON.');
        assert(json[r'earningsPaise'] != null, 'Required key "AdminAnalyticsInputDailyInner[earningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'newCallers'), 'Required key "AdminAnalyticsInputDailyInner[newCallers]" is missing from JSON.');
        assert(json[r'newCallers'] != null, 'Required key "AdminAnalyticsInputDailyInner[newCallers]" has a null value in JSON.');
        assert(json.containsKey(r'newCompanions'), 'Required key "AdminAnalyticsInputDailyInner[newCompanions]" is missing from JSON.');
        assert(json[r'newCompanions'] != null, 'Required key "AdminAnalyticsInputDailyInner[newCompanions]" has a null value in JSON.');
        assert(json.containsKey(r'activeCallers'), 'Required key "AdminAnalyticsInputDailyInner[activeCallers]" is missing from JSON.');
        assert(json[r'activeCallers'] != null, 'Required key "AdminAnalyticsInputDailyInner[activeCallers]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputDailyInner(
        date: mapValueOfType<String>(json, r'date')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        salesPaise: mapValueOfType<int>(json, r'salesPaise')!,
        earningsPaise: mapValueOfType<int>(json, r'earningsPaise')!,
        newCallers: mapValueOfType<int>(json, r'newCallers')!,
        newCompanions: mapValueOfType<int>(json, r'newCompanions')!,
        activeCallers: mapValueOfType<int>(json, r'activeCallers')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputDailyInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputDailyInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputDailyInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputDailyInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputDailyInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputDailyInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputDailyInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputDailyInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputDailyInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputDailyInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'calls',
    'minutes',
    'coinsSpent',
    'salesPaise',
    'earningsPaise',
    'newCallers',
    'newCompanions',
    'activeCallers',
  };
}

