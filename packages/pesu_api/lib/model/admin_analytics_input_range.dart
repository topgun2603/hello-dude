//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputRange {
  /// Returns a new [AdminAnalyticsInputRange] instance.
  AdminAnalyticsInputRange({
    required this.from,
    required this.to,
    required this.days,
  });

  String from;

  String to;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int days;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputRange &&
    other.from == from &&
    other.to == to &&
    other.days == days;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (from.hashCode) +
    (to.hashCode) +
    (days.hashCode);

  @override
  String toString() => 'AdminAnalyticsInputRange[from=$from, to=$to, days=$days]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'from'] = this.from;
      json[r'to'] = this.to;
      json[r'days'] = this.days;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputRange] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputRange? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'from'), 'Required key "AdminAnalyticsInputRange[from]" is missing from JSON.');
        assert(json[r'from'] != null, 'Required key "AdminAnalyticsInputRange[from]" has a null value in JSON.');
        assert(json.containsKey(r'to'), 'Required key "AdminAnalyticsInputRange[to]" is missing from JSON.');
        assert(json[r'to'] != null, 'Required key "AdminAnalyticsInputRange[to]" has a null value in JSON.');
        assert(json.containsKey(r'days'), 'Required key "AdminAnalyticsInputRange[days]" is missing from JSON.');
        assert(json[r'days'] != null, 'Required key "AdminAnalyticsInputRange[days]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputRange(
        from: mapValueOfType<String>(json, r'from')!,
        to: mapValueOfType<String>(json, r'to')!,
        days: mapValueOfType<int>(json, r'days')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputRange> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputRange>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputRange.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputRange> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputRange>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputRange.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputRange-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputRange>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputRange>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputRange.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'from',
    'to',
    'days',
  };
}

