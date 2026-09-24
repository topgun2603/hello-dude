//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsByHourInner {
  /// Returns a new [AdminAnalyticsByHourInner] instance.
  AdminAnalyticsByHourInner({
    required this.hour,
    required this.calls,
    required this.minutes,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int hour;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsByHourInner &&
    other.hour == hour &&
    other.calls == calls &&
    other.minutes == minutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (hour.hashCode) +
    (calls.hashCode) +
    (minutes.hashCode);

  @override
  String toString() => 'AdminAnalyticsByHourInner[hour=$hour, calls=$calls, minutes=$minutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'hour'] = this.hour;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [AdminAnalyticsByHourInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsByHourInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'hour'), 'Required key "AdminAnalyticsByHourInner[hour]" is missing from JSON.');
        assert(json[r'hour'] != null, 'Required key "AdminAnalyticsByHourInner[hour]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsByHourInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsByHourInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsByHourInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsByHourInner[minutes]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsByHourInner(
        hour: mapValueOfType<int>(json, r'hour')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsByHourInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsByHourInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsByHourInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsByHourInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsByHourInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsByHourInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsByHourInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsByHourInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsByHourInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsByHourInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'hour',
    'calls',
    'minutes',
  };
}

