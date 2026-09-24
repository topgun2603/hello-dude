//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PendingPhotoInput {
  /// Returns a new [PendingPhotoInput] instance.
  PendingPhotoInput({
    required this.user,
    required this.submittedAt,
    required this.pendingUrl,
    required this.currentUrl,
    required this.hasSelfie,
  });

  PendingPhotoInputUser user;

  Object? submittedAt;

  String pendingUrl;

  String? currentUrl;

  /// KYC selfie to compare: GET /admin/kyc/:userId/files/selfie
  bool hasSelfie;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingPhotoInput &&
    other.user == user &&
    other.submittedAt == submittedAt &&
    other.pendingUrl == pendingUrl &&
    other.currentUrl == currentUrl &&
    other.hasSelfie == hasSelfie;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (user.hashCode) +
    (submittedAt == null ? 0 : submittedAt!.hashCode) +
    (pendingUrl.hashCode) +
    (currentUrl == null ? 0 : currentUrl!.hashCode) +
    (hasSelfie.hashCode);

  @override
  String toString() => 'PendingPhotoInput[user=$user, submittedAt=$submittedAt, pendingUrl=$pendingUrl, currentUrl=$currentUrl, hasSelfie=$hasSelfie]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'user'] = this.user;
    if (this.submittedAt != null) {
      json[r'submittedAt'] = this.submittedAt;
    } else {
      json[r'submittedAt'] = null;
    }
      json[r'pendingUrl'] = this.pendingUrl;
    if (this.currentUrl != null) {
      json[r'currentUrl'] = this.currentUrl;
    } else {
      json[r'currentUrl'] = null;
    }
      json[r'hasSelfie'] = this.hasSelfie;
    return json;
  }

  /// Returns a new [PendingPhotoInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PendingPhotoInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'user'), 'Required key "PendingPhotoInput[user]" is missing from JSON.');
        assert(json[r'user'] != null, 'Required key "PendingPhotoInput[user]" has a null value in JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "PendingPhotoInput[submittedAt]" is missing from JSON.');
        assert(json.containsKey(r'pendingUrl'), 'Required key "PendingPhotoInput[pendingUrl]" is missing from JSON.');
        assert(json[r'pendingUrl'] != null, 'Required key "PendingPhotoInput[pendingUrl]" has a null value in JSON.');
        assert(json.containsKey(r'currentUrl'), 'Required key "PendingPhotoInput[currentUrl]" is missing from JSON.');
        assert(json.containsKey(r'hasSelfie'), 'Required key "PendingPhotoInput[hasSelfie]" is missing from JSON.');
        assert(json[r'hasSelfie'] != null, 'Required key "PendingPhotoInput[hasSelfie]" has a null value in JSON.');
        return true;
      }());

      return PendingPhotoInput(
        user: PendingPhotoInputUser.fromJson(json[r'user'])!,
        submittedAt: mapValueOfType<Object>(json, r'submittedAt'),
        pendingUrl: mapValueOfType<String>(json, r'pendingUrl')!,
        currentUrl: mapValueOfType<String>(json, r'currentUrl'),
        hasSelfie: mapValueOfType<bool>(json, r'hasSelfie')!,
      );
    }
    return null;
  }

  static List<PendingPhotoInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingPhotoInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingPhotoInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingPhotoInput> mapFromJson(dynamic json) {
    final map = <String, PendingPhotoInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PendingPhotoInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingPhotoInput-objects as value to a dart map
  static Map<String, List<PendingPhotoInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingPhotoInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingPhotoInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user',
    'submittedAt',
    'pendingUrl',
    'currentUrl',
    'hasSelfie',
  };
}

