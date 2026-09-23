//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ApplyAsCompanionRequest {
  /// Returns a new [ApplyAsCompanionRequest] instance.
  ApplyAsCompanionRequest({
    required this.firstName,
    this.bio,
  });

  String firstName;

  String? bio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApplyAsCompanionRequest &&
    other.firstName == firstName &&
    other.bio == bio;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (firstName.hashCode) +
    (bio == null ? 0 : bio!.hashCode);

  @override
  String toString() => 'ApplyAsCompanionRequest[firstName=$firstName, bio=$bio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'firstName'] = this.firstName;
    if (this.bio != null) {
      json[r'bio'] = this.bio;
    } else {
      json[r'bio'] = null;
    }
    return json;
  }

  /// Returns a new [ApplyAsCompanionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApplyAsCompanionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'firstName'), 'Required key "ApplyAsCompanionRequest[firstName]" is missing from JSON.');
        assert(json[r'firstName'] != null, 'Required key "ApplyAsCompanionRequest[firstName]" has a null value in JSON.');
        return true;
      }());

      return ApplyAsCompanionRequest(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        bio: mapValueOfType<String>(json, r'bio'),
      );
    }
    return null;
  }

  static List<ApplyAsCompanionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApplyAsCompanionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApplyAsCompanionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApplyAsCompanionRequest> mapFromJson(dynamic json) {
    final map = <String, ApplyAsCompanionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApplyAsCompanionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApplyAsCompanionRequest-objects as value to a dart map
  static Map<String, List<ApplyAsCompanionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApplyAsCompanionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApplyAsCompanionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'firstName',
  };
}

