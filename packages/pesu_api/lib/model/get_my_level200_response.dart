//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetMyLevel200Response {
  /// Returns a new [GetMyLevel200Response] instance.
  GetMyLevel200Response({
    required this.level,
    required this.name,
    required this.perk,
    required this.coinsSpent,
    required this.next,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int level;

  String name;

  String? perk;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  GetMyLevel200ResponseNext? next;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetMyLevel200Response &&
    other.level == level &&
    other.name == name &&
    other.perk == perk &&
    other.coinsSpent == coinsSpent &&
    other.next == next;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level.hashCode) +
    (name.hashCode) +
    (perk == null ? 0 : perk!.hashCode) +
    (coinsSpent.hashCode) +
    (next == null ? 0 : next!.hashCode);

  @override
  String toString() => 'GetMyLevel200Response[level=$level, name=$name, perk=$perk, coinsSpent=$coinsSpent, next=$next]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'level'] = this.level;
      json[r'name'] = this.name;
    if (this.perk != null) {
      json[r'perk'] = this.perk;
    } else {
      json[r'perk'] = null;
    }
      json[r'coinsSpent'] = this.coinsSpent;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
    return json;
  }

  /// Returns a new [GetMyLevel200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetMyLevel200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'), 'Required key "GetMyLevel200Response[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "GetMyLevel200Response[level]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "GetMyLevel200Response[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "GetMyLevel200Response[name]" has a null value in JSON.');
        assert(json.containsKey(r'perk'), 'Required key "GetMyLevel200Response[perk]" is missing from JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "GetMyLevel200Response[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "GetMyLevel200Response[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'next'), 'Required key "GetMyLevel200Response[next]" is missing from JSON.');
        return true;
      }());

      return GetMyLevel200Response(
        level: mapValueOfType<int>(json, r'level')!,
        name: mapValueOfType<String>(json, r'name')!,
        perk: mapValueOfType<String>(json, r'perk'),
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        next: GetMyLevel200ResponseNext.fromJson(json[r'next']),
      );
    }
    return null;
  }

  static List<GetMyLevel200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetMyLevel200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetMyLevel200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetMyLevel200Response> mapFromJson(dynamic json) {
    final map = <String, GetMyLevel200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetMyLevel200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetMyLevel200Response-objects as value to a dart map
  static Map<String, List<GetMyLevel200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetMyLevel200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetMyLevel200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'name',
    'perk',
    'coinsSpent',
    'next',
  };
}

