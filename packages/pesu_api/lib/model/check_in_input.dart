//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CheckInInput {
  /// Returns a new [CheckInInput] instance.
  CheckInInput({
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

  List<CheckInInputDaysInner> days;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckInInput &&
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
  String toString() => 'CheckInInput[day=$day, claimedToday=$claimedToday, todayCoins=$todayCoins, streak=$streak, days=$days]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
      json[r'claimedToday'] = this.claimedToday;
      json[r'todayCoins'] = this.todayCoins;
      json[r'streak'] = this.streak;
      json[r'days'] = this.days;
    return json;
  }

  /// Returns a new [CheckInInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckInInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'day'), 'Required key "CheckInInput[day]" is missing from JSON.');
        assert(json[r'day'] != null, 'Required key "CheckInInput[day]" has a null value in JSON.');
        assert(json.containsKey(r'claimedToday'), 'Required key "CheckInInput[claimedToday]" is missing from JSON.');
        assert(json[r'claimedToday'] != null, 'Required key "CheckInInput[claimedToday]" has a null value in JSON.');
        assert(json.containsKey(r'todayCoins'), 'Required key "CheckInInput[todayCoins]" is missing from JSON.');
        assert(json[r'todayCoins'] != null, 'Required key "CheckInInput[todayCoins]" has a null value in JSON.');
        assert(json.containsKey(r'streak'), 'Required key "CheckInInput[streak]" is missing from JSON.');
        assert(json[r'streak'] != null, 'Required key "CheckInInput[streak]" has a null value in JSON.');
        assert(json.containsKey(r'days'), 'Required key "CheckInInput[days]" is missing from JSON.');
        assert(json[r'days'] != null, 'Required key "CheckInInput[days]" has a null value in JSON.');
        return true;
      }());

      return CheckInInput(
        day: mapValueOfType<int>(json, r'day')!,
        claimedToday: mapValueOfType<bool>(json, r'claimedToday')!,
        todayCoins: mapValueOfType<int>(json, r'todayCoins')!,
        streak: mapValueOfType<int>(json, r'streak')!,
        days: CheckInInputDaysInner.listFromJson(json[r'days']),
      );
    }
    return null;
  }

  static List<CheckInInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckInInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckInInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckInInput> mapFromJson(dynamic json) {
    final map = <String, CheckInInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckInInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckInInput-objects as value to a dart map
  static Map<String, List<CheckInInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckInInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckInInput.listFromJson(entry.value, growable: growable,);
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

