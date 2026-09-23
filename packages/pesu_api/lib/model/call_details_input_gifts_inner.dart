//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallDetailsInputGiftsInner {
  /// Returns a new [CallDetailsInputGiftsInner] instance.
  CallDetailsInputGiftsInner({
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

  Object? at;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallDetailsInputGiftsInner &&
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
    (at == null ? 0 : at!.hashCode);

  @override
  String toString() => 'CallDetailsInputGiftsInner[name=$name, emoji=$emoji, coins=$coins, paise=$paise, at=$at]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
      json[r'paise'] = this.paise;
    if (this.at != null) {
      json[r'at'] = this.at;
    } else {
      json[r'at'] = null;
    }
    return json;
  }

  /// Returns a new [CallDetailsInputGiftsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDetailsInputGiftsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "CallDetailsInputGiftsInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CallDetailsInputGiftsInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "CallDetailsInputGiftsInner[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "CallDetailsInputGiftsInner[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "CallDetailsInputGiftsInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "CallDetailsInputGiftsInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "CallDetailsInputGiftsInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "CallDetailsInputGiftsInner[paise]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "CallDetailsInputGiftsInner[at]" is missing from JSON.');
        return true;
      }());

      return CallDetailsInputGiftsInner(
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        paise: mapValueOfType<int>(json, r'paise')!,
        at: mapValueOfType<Object>(json, r'at'),
      );
    }
    return null;
  }

  static List<CallDetailsInputGiftsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInputGiftsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInputGiftsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDetailsInputGiftsInner> mapFromJson(dynamic json) {
    final map = <String, CallDetailsInputGiftsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDetailsInputGiftsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDetailsInputGiftsInner-objects as value to a dart map
  static Map<String, List<CallDetailsInputGiftsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallDetailsInputGiftsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDetailsInputGiftsInner.listFromJson(entry.value, growable: growable,);
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

