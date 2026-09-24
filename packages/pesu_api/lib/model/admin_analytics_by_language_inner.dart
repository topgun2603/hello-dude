//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsByLanguageInner {
  /// Returns a new [AdminAnalyticsByLanguageInner] instance.
  AdminAnalyticsByLanguageInner({
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
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsByLanguageInner &&
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
  String toString() => 'AdminAnalyticsByLanguageInner[code=$code, name=$name, calls=$calls, minutes=$minutes, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [AdminAnalyticsByLanguageInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsByLanguageInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminAnalyticsByLanguageInner[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminAnalyticsByLanguageInner[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminAnalyticsByLanguageInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminAnalyticsByLanguageInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsByLanguageInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsByLanguageInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsByLanguageInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsByLanguageInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminAnalyticsByLanguageInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminAnalyticsByLanguageInner[coins]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsByLanguageInner(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsByLanguageInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsByLanguageInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsByLanguageInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsByLanguageInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsByLanguageInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsByLanguageInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsByLanguageInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsByLanguageInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsByLanguageInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsByLanguageInner.listFromJson(entry.value, growable: growable,);
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

