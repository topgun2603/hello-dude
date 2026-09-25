//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateInputAge {
  /// Returns a new [KycStateInputAge] instance.
  KycStateInputAge({
    required this.done,
    required this.birthDate,
    required this.age,
  });

  bool done;

  /// YYYY-MM-DD
  String? birthDate;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? age;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateInputAge &&
    other.done == done &&
    other.birthDate == birthDate &&
    other.age == age;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (done.hashCode) +
    (birthDate == null ? 0 : birthDate!.hashCode) +
    (age == null ? 0 : age!.hashCode);

  @override
  String toString() => 'KycStateInputAge[done=$done, birthDate=$birthDate, age=$age]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'done'] = this.done;
    if (this.birthDate != null) {
      json[r'birthDate'] = this.birthDate;
    } else {
      json[r'birthDate'] = null;
    }
    if (this.age != null) {
      json[r'age'] = this.age;
    } else {
      json[r'age'] = null;
    }
    return json;
  }

  /// Returns a new [KycStateInputAge] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateInputAge? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'done'), 'Required key "KycStateInputAge[done]" is missing from JSON.');
        assert(json[r'done'] != null, 'Required key "KycStateInputAge[done]" has a null value in JSON.');
        assert(json.containsKey(r'birthDate'), 'Required key "KycStateInputAge[birthDate]" is missing from JSON.');
        assert(json.containsKey(r'age'), 'Required key "KycStateInputAge[age]" is missing from JSON.');
        return true;
      }());

      return KycStateInputAge(
        done: mapValueOfType<bool>(json, r'done')!,
        birthDate: mapValueOfType<String>(json, r'birthDate'),
        age: mapValueOfType<int>(json, r'age'),
      );
    }
    return null;
  }

  static List<KycStateInputAge> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInputAge>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInputAge.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateInputAge> mapFromJson(dynamic json) {
    final map = <String, KycStateInputAge>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateInputAge.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateInputAge-objects as value to a dart map
  static Map<String, List<KycStateInputAge>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateInputAge>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateInputAge.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'done',
    'birthDate',
    'age',
  };
}

