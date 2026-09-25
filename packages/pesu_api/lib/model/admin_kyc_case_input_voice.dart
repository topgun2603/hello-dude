//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycCaseInputVoice {
  /// Returns a new [AdminKycCaseInputVoice] instance.
  AdminKycCaseInputVoice({
    required this.needed,
    required this.sentence,
    required this.submittedAt,
    required this.checkedAt,
  });

  bool needed;

  String? sentence;

  Object? submittedAt;

  /// An admin already listened and it was fine (clip deleted)
  Object? checkedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycCaseInputVoice &&
    other.needed == needed &&
    other.sentence == sentence &&
    other.submittedAt == submittedAt &&
    other.checkedAt == checkedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (needed.hashCode) +
    (sentence == null ? 0 : sentence!.hashCode) +
    (submittedAt == null ? 0 : submittedAt!.hashCode) +
    (checkedAt == null ? 0 : checkedAt!.hashCode);

  @override
  String toString() => 'AdminKycCaseInputVoice[needed=$needed, sentence=$sentence, submittedAt=$submittedAt, checkedAt=$checkedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'needed'] = this.needed;
    if (this.sentence != null) {
      json[r'sentence'] = this.sentence;
    } else {
      json[r'sentence'] = null;
    }
    if (this.submittedAt != null) {
      json[r'submittedAt'] = this.submittedAt;
    } else {
      json[r'submittedAt'] = null;
    }
    if (this.checkedAt != null) {
      json[r'checkedAt'] = this.checkedAt;
    } else {
      json[r'checkedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminKycCaseInputVoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycCaseInputVoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'needed'), 'Required key "AdminKycCaseInputVoice[needed]" is missing from JSON.');
        assert(json[r'needed'] != null, 'Required key "AdminKycCaseInputVoice[needed]" has a null value in JSON.');
        assert(json.containsKey(r'sentence'), 'Required key "AdminKycCaseInputVoice[sentence]" is missing from JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "AdminKycCaseInputVoice[submittedAt]" is missing from JSON.');
        assert(json.containsKey(r'checkedAt'), 'Required key "AdminKycCaseInputVoice[checkedAt]" is missing from JSON.');
        return true;
      }());

      return AdminKycCaseInputVoice(
        needed: mapValueOfType<bool>(json, r'needed')!,
        sentence: mapValueOfType<String>(json, r'sentence'),
        submittedAt: mapValueOfType<Object>(json, r'submittedAt'),
        checkedAt: mapValueOfType<Object>(json, r'checkedAt'),
      );
    }
    return null;
  }

  static List<AdminKycCaseInputVoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseInputVoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseInputVoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycCaseInputVoice> mapFromJson(dynamic json) {
    final map = <String, AdminKycCaseInputVoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycCaseInputVoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycCaseInputVoice-objects as value to a dart map
  static Map<String, List<AdminKycCaseInputVoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycCaseInputVoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycCaseInputVoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'needed',
    'sentence',
    'submittedAt',
    'checkedAt',
  };
}

