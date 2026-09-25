//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycCaseVoice {
  /// Returns a new [AdminKycCaseVoice] instance.
  AdminKycCaseVoice({
    required this.needed,
    required this.sentence,
    required this.submittedAt,
    required this.checkedAt,
  });

  bool needed;

  String? sentence;

  DateTime? submittedAt;

  /// An admin already listened and it was fine (clip deleted)
  DateTime? checkedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycCaseVoice &&
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
  String toString() => 'AdminKycCaseVoice[needed=$needed, sentence=$sentence, submittedAt=$submittedAt, checkedAt=$checkedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'needed'] = this.needed;
    if (this.sentence != null) {
      json[r'sentence'] = this.sentence;
    } else {
      json[r'sentence'] = null;
    }
    if (this.submittedAt != null) {
      json[r'submittedAt'] = this.submittedAt!.toUtc().toIso8601String();
    } else {
      json[r'submittedAt'] = null;
    }
    if (this.checkedAt != null) {
      json[r'checkedAt'] = this.checkedAt!.toUtc().toIso8601String();
    } else {
      json[r'checkedAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminKycCaseVoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycCaseVoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'needed'), 'Required key "AdminKycCaseVoice[needed]" is missing from JSON.');
        assert(json[r'needed'] != null, 'Required key "AdminKycCaseVoice[needed]" has a null value in JSON.');
        assert(json.containsKey(r'sentence'), 'Required key "AdminKycCaseVoice[sentence]" is missing from JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "AdminKycCaseVoice[submittedAt]" is missing from JSON.');
        assert(json.containsKey(r'checkedAt'), 'Required key "AdminKycCaseVoice[checkedAt]" is missing from JSON.');
        return true;
      }());

      return AdminKycCaseVoice(
        needed: mapValueOfType<bool>(json, r'needed')!,
        sentence: mapValueOfType<String>(json, r'sentence'),
        submittedAt: mapDateTime(json, r'submittedAt', r''),
        checkedAt: mapDateTime(json, r'checkedAt', r''),
      );
    }
    return null;
  }

  static List<AdminKycCaseVoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseVoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseVoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycCaseVoice> mapFromJson(dynamic json) {
    final map = <String, AdminKycCaseVoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycCaseVoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycCaseVoice-objects as value to a dart map
  static Map<String, List<AdminKycCaseVoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycCaseVoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycCaseVoice.listFromJson(entry.value, growable: growable,);
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

