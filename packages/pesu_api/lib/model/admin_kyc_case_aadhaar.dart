//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycCaseAadhaar {
  /// Returns a new [AdminKycCaseAadhaar] instance.
  AdminKycCaseAadhaar({
    required this.name,
    required this.dob,
    required this.age,
    required this.gender,
    required this.last4,
    required this.generatedAt,
  });

  String? name;

  String? dob;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? age;

  String? gender;

  String? last4;

  DateTime? generatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycCaseAadhaar &&
    other.name == name &&
    other.dob == dob &&
    other.age == age &&
    other.gender == gender &&
    other.last4 == last4 &&
    other.generatedAt == generatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (age == null ? 0 : age!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (last4 == null ? 0 : last4!.hashCode) +
    (generatedAt == null ? 0 : generatedAt!.hashCode);

  @override
  String toString() => 'AdminKycCaseAadhaar[name=$name, dob=$dob, age=$age, gender=$gender, last4=$last4, generatedAt=$generatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.dob != null) {
      json[r'dob'] = this.dob;
    } else {
      json[r'dob'] = null;
    }
    if (this.age != null) {
      json[r'age'] = this.age;
    } else {
      json[r'age'] = null;
    }
    if (this.gender != null) {
      json[r'gender'] = this.gender;
    } else {
      json[r'gender'] = null;
    }
    if (this.last4 != null) {
      json[r'last4'] = this.last4;
    } else {
      json[r'last4'] = null;
    }
    if (this.generatedAt != null) {
      json[r'generatedAt'] = this.generatedAt!.toUtc().toIso8601String();
    } else {
      json[r'generatedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminKycCaseAadhaar] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycCaseAadhaar? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminKycCaseAadhaar[name]" is missing from JSON.');
        assert(json.containsKey(r'dob'), 'Required key "AdminKycCaseAadhaar[dob]" is missing from JSON.');
        assert(json.containsKey(r'age'), 'Required key "AdminKycCaseAadhaar[age]" is missing from JSON.');
        assert(json.containsKey(r'gender'), 'Required key "AdminKycCaseAadhaar[gender]" is missing from JSON.');
        assert(json.containsKey(r'last4'), 'Required key "AdminKycCaseAadhaar[last4]" is missing from JSON.');
        assert(json.containsKey(r'generatedAt'), 'Required key "AdminKycCaseAadhaar[generatedAt]" is missing from JSON.');
        return true;
      }());

      return AdminKycCaseAadhaar(
        name: mapValueOfType<String>(json, r'name'),
        dob: mapValueOfType<String>(json, r'dob'),
        age: mapValueOfType<int>(json, r'age'),
        gender: mapValueOfType<String>(json, r'gender'),
        last4: mapValueOfType<String>(json, r'last4'),
        generatedAt: mapDateTime(json, r'generatedAt', r''),
      );
    }
    return null;
  }

  static List<AdminKycCaseAadhaar> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseAadhaar>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseAadhaar.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycCaseAadhaar> mapFromJson(dynamic json) {
    final map = <String, AdminKycCaseAadhaar>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycCaseAadhaar.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycCaseAadhaar-objects as value to a dart map
  static Map<String, List<AdminKycCaseAadhaar>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycCaseAadhaar>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycCaseAadhaar.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'dob',
    'age',
    'gender',
    'last4',
    'generatedAt',
  };
}

