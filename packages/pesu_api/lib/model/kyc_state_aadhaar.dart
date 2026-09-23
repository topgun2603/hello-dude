//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateAadhaar {
  /// Returns a new [KycStateAadhaar] instance.
  KycStateAadhaar({
    required this.done,
    required this.name,
    required this.last4,
    required this.age,
  });

  bool done;

  String? name;

  String? last4;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? age;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateAadhaar &&
    other.done == done &&
    other.name == name &&
    other.last4 == last4 &&
    other.age == age;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (done.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (last4 == null ? 0 : last4!.hashCode) +
    (age == null ? 0 : age!.hashCode);

  @override
  String toString() => 'KycStateAadhaar[done=$done, name=$name, last4=$last4, age=$age]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'done'] = this.done;
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.last4 != null) {
      json[r'last4'] = this.last4;
    } else {
      json[r'last4'] = null;
    }
    if (this.age != null) {
      json[r'age'] = this.age;
    } else {
      json[r'age'] = null;
    }
    return json;
  }

  /// Returns a new [KycStateAadhaar] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateAadhaar? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'done'), 'Required key "KycStateAadhaar[done]" is missing from JSON.');
        assert(json[r'done'] != null, 'Required key "KycStateAadhaar[done]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "KycStateAadhaar[name]" is missing from JSON.');
        assert(json.containsKey(r'last4'), 'Required key "KycStateAadhaar[last4]" is missing from JSON.');
        assert(json.containsKey(r'age'), 'Required key "KycStateAadhaar[age]" is missing from JSON.');
        return true;
      }());

      return KycStateAadhaar(
        done: mapValueOfType<bool>(json, r'done')!,
        name: mapValueOfType<String>(json, r'name'),
        last4: mapValueOfType<String>(json, r'last4'),
        age: mapValueOfType<int>(json, r'age'),
      );
    }
    return null;
  }

  static List<KycStateAadhaar> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateAadhaar>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateAadhaar.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateAadhaar> mapFromJson(dynamic json) {
    final map = <String, KycStateAadhaar>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateAadhaar.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateAadhaar-objects as value to a dart map
  static Map<String, List<KycStateAadhaar>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateAadhaar>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateAadhaar.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'done',
    'name',
    'last4',
    'age',
  };
}

