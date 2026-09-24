//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputByLanguageInner {
  /// Returns a new [AdminAnalyticsInputByLanguageInner] instance.
  AdminAnalyticsInputByLanguageInner({
    required this.code,
    required this.name,
    required this.calls,
    required this.minutes,
    required this.coins,
  });

  String code;

  String name;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputByLanguageInner &&
    other.code == code &&
    other.name == name &&
    other.calls == calls &&
    other.minutes == minutes &&
    other.coins == coins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (name.hashCode) +
    (calls.hashCode) +
    (minutes.hashCode) +
    (coins.hashCode);

  @override
  String toString() => 'AdminAnalyticsInputByLanguageInner[code=$code, name=$name, calls=$calls, minutes=$minutes, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputByLanguageInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputByLanguageInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminAnalyticsInputByLanguageInner[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminAnalyticsInputByLanguageInner[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminAnalyticsInputByLanguageInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminAnalyticsInputByLanguageInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsInputByLanguageInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsInputByLanguageInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsInputByLanguageInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsInputByLanguageInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminAnalyticsInputByLanguageInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminAnalyticsInputByLanguageInner[coins]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputByLanguageInner(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputByLanguageInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputByLanguageInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputByLanguageInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputByLanguageInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputByLanguageInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputByLanguageInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputByLanguageInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputByLanguageInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputByLanguageInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputByLanguageInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'name',
    'calls',
    'minutes',
    'coins',
  };
}

