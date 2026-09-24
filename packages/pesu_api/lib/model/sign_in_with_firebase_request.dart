//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SignInWithFirebaseRequest {
  /// Returns a new [SignInWithFirebaseRequest] instance.
  SignInWithFirebaseRequest({
    required this.idToken,
  });

  String idToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SignInWithFirebaseRequest &&
    other.idToken == idToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (idToken.hashCode);

  @override
  String toString() => 'SignInWithFirebaseRequest[idToken=$idToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'idToken'] = this.idToken;
    return json;
  }

  /// Returns a new [SignInWithFirebaseRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SignInWithFirebaseRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'idToken'), 'Required key "SignInWithFirebaseRequest[idToken]" is missing from JSON.');
        assert(json[r'idToken'] != null, 'Required key "SignInWithFirebaseRequest[idToken]" has a null value in JSON.');
        return true;
      }());

      return SignInWithFirebaseRequest(
        idToken: mapValueOfType<String>(json, r'idToken')!,
      );
    }
    return null;
  }

  static List<SignInWithFirebaseRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SignInWithFirebaseRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SignInWithFirebaseRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SignInWithFirebaseRequest> mapFromJson(dynamic json) {
    final map = <String, SignInWithFirebaseRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SignInWithFirebaseRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SignInWithFirebaseRequest-objects as value to a dart map
  static Map<String, List<SignInWithFirebaseRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SignInWithFirebaseRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SignInWithFirebaseRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'idToken',
  };
}

