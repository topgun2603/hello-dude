//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionHome200ResponseToday {
  /// Returns a new [CompanionHome200ResponseToday] instance.
  CompanionHome200ResponseToday({
    required this.earnedPaise,
    required this.calls,
    required this.talkSeconds,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earnedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int talkSeconds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionHome200ResponseToday &&
    other.earnedPaise == earnedPaise &&
    other.calls == calls &&
    other.talkSeconds == talkSeconds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (earnedPaise.hashCode) +
    (calls.hashCode) +
    (talkSeconds.hashCode);

  @override
  String toString() => 'CompanionHome200ResponseToday[earnedPaise=$earnedPaise, calls=$calls, talkSeconds=$talkSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'earnedPaise'] = this.earnedPaise;
      json[r'calls'] = this.calls;
      json[r'talkSeconds'] = this.talkSeconds;
    return json;
  }

  /// Returns a new [CompanionHome200ResponseToday] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionHome200ResponseToday? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'earnedPaise'), 'Required key "CompanionHome200ResponseToday[earnedPaise]" is missing from JSON.');
        assert(json[r'earnedPaise'] != null, 'Required key "CompanionHome200ResponseToday[earnedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "CompanionHome200ResponseToday[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "CompanionHome200ResponseToday[calls]" has a null value in JSON.');
        assert(json.containsKey(r'talkSeconds'), 'Required key "CompanionHome200ResponseToday[talkSeconds]" is missing from JSON.');
        assert(json[r'talkSeconds'] != null, 'Required key "CompanionHome200ResponseToday[talkSeconds]" has a null value in JSON.');
        return true;
      }());

      return CompanionHome200ResponseToday(
        earnedPaise: mapValueOfType<int>(json, r'earnedPaise')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        talkSeconds: mapValueOfType<int>(json, r'talkSeconds')!,
      );
    }
    return null;
  }

  static List<CompanionHome200ResponseToday> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionHome200ResponseToday>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionHome200ResponseToday.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionHome200ResponseToday> mapFromJson(dynamic json) {
    final map = <String, CompanionHome200ResponseToday>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionHome200ResponseToday.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionHome200ResponseToday-objects as value to a dart map
  static Map<String, List<CompanionHome200ResponseToday>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionHome200ResponseToday>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionHome200ResponseToday.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'earnedPaise',
    'calls',
    'talkSeconds',
  };
}

