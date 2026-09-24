//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LivePricingPassesInner {
  /// Returns a new [LivePricingPassesInner] instance.
  LivePricingPassesInner({
    required this.minutes,
    required this.coins,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LivePricingPassesInner &&
    other.minutes == minutes &&
    other.coins == coins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minutes.hashCode) +
    (coins.hashCode);

  @override
  String toString() => 'LivePricingPassesInner[minutes=$minutes, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'minutes'] = this.minutes;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [LivePricingPassesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LivePricingPassesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'minutes'), 'Required key "LivePricingPassesInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "LivePricingPassesInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "LivePricingPassesInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "LivePricingPassesInner[coins]" has a null value in JSON.');
        return true;
      }());

      return LivePricingPassesInner(
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<LivePricingPassesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LivePricingPassesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LivePricingPassesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LivePricingPassesInner> mapFromJson(dynamic json) {
    final map = <String, LivePricingPassesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LivePricingPassesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LivePricingPassesInner-objects as value to a dart map
  static Map<String, List<LivePricingPassesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LivePricingPassesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LivePricingPassesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'minutes',
    'coins',
  };
}

