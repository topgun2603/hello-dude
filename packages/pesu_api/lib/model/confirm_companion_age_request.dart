//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ConfirmCompanionAgeRequest {
  /// Returns a new [ConfirmCompanionAgeRequest] instance.
  ConfirmCompanionAgeRequest({
    required this.birthDate,
    required this.confirm18,
  });

  String birthDate;

  /// I confirm I am 18 or older
  bool confirm18;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConfirmCompanionAgeRequest &&
    other.birthDate == birthDate &&
    other.confirm18 == confirm18;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (birthDate.hashCode) +
    (confirm18.hashCode);

  @override
  String toString() => 'ConfirmCompanionAgeRequest[birthDate=$birthDate, confirm18=$confirm18]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'birthDate'] = this.birthDate;
      json[r'confirm18'] = this.confirm18;
    return json;
  }

  /// Returns a new [ConfirmCompanionAgeRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConfirmCompanionAgeRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'birthDate'), 'Required key "ConfirmCompanionAgeRequest[birthDate]" is missing from JSON.');
        assert(json[r'birthDate'] != null, 'Required key "ConfirmCompanionAgeRequest[birthDate]" has a null value in JSON.');
        assert(json.containsKey(r'confirm18'), 'Required key "ConfirmCompanionAgeRequest[confirm18]" is missing from JSON.');
        assert(json[r'confirm18'] != null, 'Required key "ConfirmCompanionAgeRequest[confirm18]" has a null value in JSON.');
        return true;
      }());

      return ConfirmCompanionAgeRequest(
        birthDate: mapValueOfType<String>(json, r'birthDate')!,
        confirm18: mapValueOfType<bool>(json, r'confirm18')!,
      );
    }
    return null;
  }

  static List<ConfirmCompanionAgeRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfirmCompanionAgeRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfirmCompanionAgeRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConfirmCompanionAgeRequest> mapFromJson(dynamic json) {
    final map = <String, ConfirmCompanionAgeRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConfirmCompanionAgeRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConfirmCompanionAgeRequest-objects as value to a dart map
  static Map<String, List<ConfirmCompanionAgeRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConfirmCompanionAgeRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConfirmCompanionAgeRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'birthDate',
    'confirm18',
  };
}

