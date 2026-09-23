//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Gift {
  /// Returns a new [Gift] instance.
  Gift({
    required this.id,
    required this.code,
    required this.name,
    required this.emoji,
    required this.coins,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String code;

  String name;

  String emoji;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Gift &&
    other.id == id &&
    other.code == code &&
    other.name == name &&
    other.emoji == emoji &&
    other.coins == coins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (code.hashCode) +
    (name.hashCode) +
    (emoji.hashCode) +
    (coins.hashCode);

  @override
  String toString() => 'Gift[id=$id, code=$code, name=$name, emoji=$emoji, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [Gift] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Gift? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Gift[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Gift[id]" has a null value in JSON.');
        assert(json.containsKey(r'code'), 'Required key "Gift[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "Gift[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "Gift[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "Gift[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "Gift[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "Gift[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "Gift[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "Gift[coins]" has a null value in JSON.');
        return true;
      }());

      return Gift(
        id: mapValueOfType<int>(json, r'id')!,
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<Gift> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Gift>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Gift.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Gift> mapFromJson(dynamic json) {
    final map = <String, Gift>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Gift.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Gift-objects as value to a dart map
  static Map<String, List<Gift>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Gift>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Gift.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'code',
    'name',
    'emoji',
    'coins',
  };
}

