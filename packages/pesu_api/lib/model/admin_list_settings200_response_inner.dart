//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminListSettings200ResponseInner {
  /// Returns a new [AdminListSettings200ResponseInner] instance.
  AdminListSettings200ResponseInner({
    required this.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
  });

  String key;

  String label;

  num value;

  num min;

  num max;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminListSettings200ResponseInner &&
    other.key == key &&
    other.label == label &&
    other.value == value &&
    other.min == min &&
    other.max == max;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (label.hashCode) +
    (value.hashCode) +
    (min.hashCode) +
    (max.hashCode);

  @override
  String toString() => 'AdminListSettings200ResponseInner[key=$key, label=$label, value=$value, min=$min, max=$max]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'label'] = this.label;
      json[r'value'] = this.value;
      json[r'min'] = this.min;
      json[r'max'] = this.max;
    return json;
  }

  /// Returns a new [AdminListSettings200ResponseInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminListSettings200ResponseInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'key'), 'Required key "AdminListSettings200ResponseInner[key]" is missing from JSON.');
        assert(json[r'key'] != null, 'Required key "AdminListSettings200ResponseInner[key]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "AdminListSettings200ResponseInner[label]" is missing from JSON.');
        assert(json[r'label'] != null, 'Required key "AdminListSettings200ResponseInner[label]" has a null value in JSON.');
        assert(json.containsKey(r'value'), 'Required key "AdminListSettings200ResponseInner[value]" is missing from JSON.');
        assert(json[r'value'] != null, 'Required key "AdminListSettings200ResponseInner[value]" has a null value in JSON.');
        assert(json.containsKey(r'min'), 'Required key "AdminListSettings200ResponseInner[min]" is missing from JSON.');
        assert(json[r'min'] != null, 'Required key "AdminListSettings200ResponseInner[min]" has a null value in JSON.');
        assert(json.containsKey(r'max'), 'Required key "AdminListSettings200ResponseInner[max]" is missing from JSON.');
        assert(json[r'max'] != null, 'Required key "AdminListSettings200ResponseInner[max]" has a null value in JSON.');
        return true;
      }());

      return AdminListSettings200ResponseInner(
        key: mapValueOfType<String>(json, r'key')!,
        label: mapValueOfType<String>(json, r'label')!,
        value: num.parse('${json[r'value']}'),
        min: num.parse('${json[r'min']}'),
        max: num.parse('${json[r'max']}'),
      );
    }
    return null;
  }

  static List<AdminListSettings200ResponseInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminListSettings200ResponseInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminListSettings200ResponseInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminListSettings200ResponseInner> mapFromJson(dynamic json) {
    final map = <String, AdminListSettings200ResponseInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminListSettings200ResponseInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminListSettings200ResponseInner-objects as value to a dart map
  static Map<String, List<AdminListSettings200ResponseInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminListSettings200ResponseInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminListSettings200ResponseInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'label',
    'value',
    'min',
    'max',
  };
}

