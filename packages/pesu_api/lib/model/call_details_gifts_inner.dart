//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallDetailsGiftsInner {
  /// Returns a new [CallDetailsGiftsInner] instance.
  CallDetailsGiftsInner({
    required this.name,
    required this.emoji,
    required this.coins,
    required this.paise,
    required this.at,
  });

  String name;

  String emoji;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paise;

  DateTime at;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallDetailsGiftsInner &&
    other.name == name &&
    other.emoji == emoji &&
    other.coins == coins &&
    other.paise == paise &&
    other.at == at;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (emoji.hashCode) +
    (coins.hashCode) +
    (paise.hashCode) +
    (at.hashCode);

  @override
  String toString() => 'CallDetailsGiftsInner[name=$name, emoji=$emoji, coins=$coins, paise=$paise, at=$at]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
      json[r'paise'] = this.paise;
      json[r'at'] = this.at.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CallDetailsGiftsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDetailsGiftsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "CallDetailsGiftsInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CallDetailsGiftsInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "CallDetailsGiftsInner[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "CallDetailsGiftsInner[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "CallDetailsGiftsInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "CallDetailsGiftsInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "CallDetailsGiftsInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "CallDetailsGiftsInner[paise]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "CallDetailsGiftsInner[at]" is missing from JSON.');
        assert(json[r'at'] != null, 'Required key "CallDetailsGiftsInner[at]" has a null value in JSON.');
        return true;
      }());

      return CallDetailsGiftsInner(
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        paise: mapValueOfType<int>(json, r'paise')!,
        at: mapDateTime(json, r'at', r'')!,
      );
    }
    return null;
  }

  static List<CallDetailsGiftsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsGiftsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsGiftsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDetailsGiftsInner> mapFromJson(dynamic json) {
    final map = <String, CallDetailsGiftsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDetailsGiftsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDetailsGiftsInner-objects as value to a dart map
  static Map<String, List<CallDetailsGiftsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallDetailsGiftsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDetailsGiftsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'emoji',
    'coins',
    'paise',
    'at',
  };
}

