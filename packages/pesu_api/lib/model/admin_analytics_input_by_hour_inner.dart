//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputByHourInner {
  /// Returns a new [AdminAnalyticsInputByHourInner] instance.
  AdminAnalyticsInputByHourInner({
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
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputByHourInner &&
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
  String toString() => 'AdminAnalyticsInputByHourInner[hour=$hour, calls=$calls, minutes=$minutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'hour'] = this.hour;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputByHourInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputByHourInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'hour'), 'Required key "AdminAnalyticsInputByHourInner[hour]" is missing from JSON.');
        assert(json[r'hour'] != null, 'Required key "AdminAnalyticsInputByHourInner[hour]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsInputByHourInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsInputByHourInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsInputByHourInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsInputByHourInner[minutes]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputByHourInner(
        hour: mapValueOfType<int>(json, r'hour')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputByHourInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputByHourInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputByHourInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputByHourInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputByHourInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputByHourInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputByHourInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputByHourInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputByHourInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputByHourInner.listFromJson(entry.value, growable: growable,);
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

