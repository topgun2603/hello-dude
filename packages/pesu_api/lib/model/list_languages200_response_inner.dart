//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListLanguages200ResponseInner {
  /// Returns a new [ListLanguages200ResponseInner] instance.
  ListLanguages200ResponseInner({
    required this.code,
    required this.name,
  });

  String code;

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListLanguages200ResponseInner &&
    other.code == code &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'ListLanguages200ResponseInner[code=$code, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [ListLanguages200ResponseInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListLanguages200ResponseInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "ListLanguages200ResponseInner[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "ListLanguages200ResponseInner[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "ListLanguages200ResponseInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "ListLanguages200ResponseInner[name]" has a null value in JSON.');
        return true;
      }());

      return ListLanguages200ResponseInner(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<ListLanguages200ResponseInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListLanguages200ResponseInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListLanguages200ResponseInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListLanguages200ResponseInner> mapFromJson(dynamic json) {
    final map = <String, ListLanguages200ResponseInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListLanguages200ResponseInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListLanguages200ResponseInner-objects as value to a dart map
  static Map<String, List<ListLanguages200ResponseInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListLanguages200ResponseInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListLanguages200ResponseInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'name',
  };
}

