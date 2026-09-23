//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CheckIn {
  /// Returns a new [CheckIn] instance.
  CheckIn({
    required this.day,
    required this.claimedToday,
    required this.todayCoins,
    required this.streak,
    this.days = const [],
  });

  /// Streak day of today's claim, 1–7
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int day;

  bool claimedToday;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int todayCoins;

  /// Consecutive days claimed
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int streak;

  List<CheckInDaysInner> days;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckIn &&
    other.day == day &&
    other.claimedToday == claimedToday &&
    other.todayCoins == todayCoins &&
    other.streak == streak &&
    _deepEquality.equals(other.days, days);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (day.hashCode) +
    (claimedToday.hashCode) +
    (todayCoins.hashCode) +
    (streak.hashCode) +
    (days.hashCode);

  @override
  String toString() => 'CheckIn[day=$day, claimedToday=$claimedToday, todayCoins=$todayCoins, streak=$streak, days=$days]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
      json[r'claimedToday'] = this.claimedToday;
      json[r'todayCoins'] = this.todayCoins;
      json[r'streak'] = this.streak;
      json[r'days'] = this.days;
    return json;
  }

  /// Returns a new [CheckIn] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckIn? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'day'), 'Required key "CheckIn[day]" is missing from JSON.');
        assert(json[r'day'] != null, 'Required key "CheckIn[day]" has a null value in JSON.');
        assert(json.containsKey(r'claimedToday'), 'Required key "CheckIn[claimedToday]" is missing from JSON.');
        assert(json[r'claimedToday'] != null, 'Required key "CheckIn[claimedToday]" has a null value in JSON.');
        assert(json.containsKey(r'todayCoins'), 'Required key "CheckIn[todayCoins]" is missing from JSON.');
        assert(json[r'todayCoins'] != null, 'Required key "CheckIn[todayCoins]" has a null value in JSON.');
        assert(json.containsKey(r'streak'), 'Required key "CheckIn[streak]" is missing from JSON.');
        assert(json[r'streak'] != null, 'Required key "CheckIn[streak]" has a null value in JSON.');
        assert(json.containsKey(r'days'), 'Required key "CheckIn[days]" is missing from JSON.');
        assert(json[r'days'] != null, 'Required key "CheckIn[days]" has a null value in JSON.');
        return true;
      }());

      return CheckIn(
        day: mapValueOfType<int>(json, r'day')!,
        claimedToday: mapValueOfType<bool>(json, r'claimedToday')!,
        todayCoins: mapValueOfType<int>(json, r'todayCoins')!,
        streak: mapValueOfType<int>(json, r'streak')!,
        days: CheckInDaysInner.listFromJson(json[r'days']),
      );
    }
    return null;
  }

  static List<CheckIn> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckIn>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckIn.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckIn> mapFromJson(dynamic json) {
    final map = <String, CheckIn>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckIn.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckIn-objects as value to a dart map
  static Map<String, List<CheckIn>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckIn>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckIn.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'day',
    'claimedToday',
    'todayCoins',
    'streak',
    'days',
  };
}

