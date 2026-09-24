//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetVip200ResponseWeeklyGift {
  /// Returns a new [GetVip200ResponseWeeklyGift] instance.
  GetVip200ResponseWeeklyGift({
    required this.name,
    required this.emoji,
    required this.used,
  });

  String name;

  String emoji;

  bool used;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetVip200ResponseWeeklyGift &&
    other.name == name &&
    other.emoji == emoji &&
    other.used == used;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (emoji.hashCode) +
    (used.hashCode);

  @override
  String toString() => 'GetVip200ResponseWeeklyGift[name=$name, emoji=$emoji, used=$used]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'used'] = this.used;
    return json;
  }

  /// Returns a new [GetVip200ResponseWeeklyGift] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetVip200ResponseWeeklyGift? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "GetVip200ResponseWeeklyGift[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "GetVip200ResponseWeeklyGift[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "GetVip200ResponseWeeklyGift[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "GetVip200ResponseWeeklyGift[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'used'), 'Required key "GetVip200ResponseWeeklyGift[used]" is missing from JSON.');
        assert(json[r'used'] != null, 'Required key "GetVip200ResponseWeeklyGift[used]" has a null value in JSON.');
        return true;
      }());

      return GetVip200ResponseWeeklyGift(
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        used: mapValueOfType<bool>(json, r'used')!,
      );
    }
    return null;
  }

  static List<GetVip200ResponseWeeklyGift> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetVip200ResponseWeeklyGift>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetVip200ResponseWeeklyGift.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetVip200ResponseWeeklyGift> mapFromJson(dynamic json) {
    final map = <String, GetVip200ResponseWeeklyGift>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetVip200ResponseWeeklyGift.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetVip200ResponseWeeklyGift-objects as value to a dart map
  static Map<String, List<GetVip200ResponseWeeklyGift>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetVip200ResponseWeeklyGift>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetVip200ResponseWeeklyGift.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'emoji',
    'used',
  };
}

