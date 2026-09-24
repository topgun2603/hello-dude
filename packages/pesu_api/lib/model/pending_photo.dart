//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PendingPhoto {
  /// Returns a new [PendingPhoto] instance.
  PendingPhoto({
    required this.user,
    required this.submittedAt,
    required this.pendingUrl,
    required this.currentUrl,
    required this.hasSelfie,
  });

  PendingPhotoUser user;

  DateTime submittedAt;

  String pendingUrl;

  String? currentUrl;

  /// KYC selfie to compare: GET /admin/kyc/:userId/files/selfie
  bool hasSelfie;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingPhoto &&
    other.user == user &&
    other.submittedAt == submittedAt &&
    other.pendingUrl == pendingUrl &&
    other.currentUrl == currentUrl &&
    other.hasSelfie == hasSelfie;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (user.hashCode) +
    (submittedAt.hashCode) +
    (pendingUrl.hashCode) +
    (currentUrl == null ? 0 : currentUrl!.hashCode) +
    (hasSelfie.hashCode);

  @override
  String toString() => 'PendingPhoto[user=$user, submittedAt=$submittedAt, pendingUrl=$pendingUrl, currentUrl=$currentUrl, hasSelfie=$hasSelfie]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'user'] = this.user;
      json[r'submittedAt'] = this.submittedAt.toUtc().toIso8601String();
      json[r'pendingUrl'] = this.pendingUrl;
    if (this.currentUrl != null) {
      json[r'currentUrl'] = this.currentUrl;
    } else {
      json[r'currentUrl'] = null;
    }
      json[r'hasSelfie'] = this.hasSelfie;
    return json;
  }

  /// Returns a new [PendingPhoto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PendingPhoto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'user'), 'Required key "PendingPhoto[user]" is missing from JSON.');
        assert(json[r'user'] != null, 'Required key "PendingPhoto[user]" has a null value in JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "PendingPhoto[submittedAt]" is missing from JSON.');
        assert(json[r'submittedAt'] != null, 'Required key "PendingPhoto[submittedAt]" has a null value in JSON.');
        assert(json.containsKey(r'pendingUrl'), 'Required key "PendingPhoto[pendingUrl]" is missing from JSON.');
        assert(json[r'pendingUrl'] != null, 'Required key "PendingPhoto[pendingUrl]" has a null value in JSON.');
        assert(json.containsKey(r'currentUrl'), 'Required key "PendingPhoto[currentUrl]" is missing from JSON.');
        assert(json.containsKey(r'hasSelfie'), 'Required key "PendingPhoto[hasSelfie]" is missing from JSON.');
        assert(json[r'hasSelfie'] != null, 'Required key "PendingPhoto[hasSelfie]" has a null value in JSON.');
        return true;
      }());

      return PendingPhoto(
        user: PendingPhotoUser.fromJson(json[r'user'])!,
        submittedAt: mapDateTime(json, r'submittedAt', r'')!,
        pendingUrl: mapValueOfType<String>(json, r'pendingUrl')!,
        currentUrl: mapValueOfType<String>(json, r'currentUrl'),
        hasSelfie: mapValueOfType<bool>(json, r'hasSelfie')!,
      );
    }
    return null;
  }

  static List<PendingPhoto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingPhoto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingPhoto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingPhoto> mapFromJson(dynamic json) {
    final map = <String, PendingPhoto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PendingPhoto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingPhoto-objects as value to a dart map
  static Map<String, List<PendingPhoto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingPhoto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingPhoto.listFromJson(entry.value, growable: growable,);
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

