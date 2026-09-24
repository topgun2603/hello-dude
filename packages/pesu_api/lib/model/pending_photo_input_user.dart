//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PendingPhotoInputUser {
  /// Returns a new [PendingPhotoInputUser] instance.
  PendingPhotoInputUser({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.kycStatus,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  String? kycStatus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingPhotoInputUser &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.kycStatus == kycStatus;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (kycStatus == null ? 0 : kycStatus!.hashCode);

  @override
  String toString() => 'PendingPhotoInputUser[id=$id, displayName=$displayName, avatarId=$avatarId, kycStatus=$kycStatus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
    if (this.kycStatus != null) {
      json[r'kycStatus'] = this.kycStatus;
    } else {
      json[r'kycStatus'] = null;
    }
    return json;
  }

  /// Returns a new [PendingPhotoInputUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PendingPhotoInputUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PendingPhotoInputUser[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PendingPhotoInputUser[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "PendingPhotoInputUser[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "PendingPhotoInputUser[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "PendingPhotoInputUser[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "PendingPhotoInputUser[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'kycStatus'), 'Required key "PendingPhotoInputUser[kycStatus]" is missing from JSON.');
        return true;
      }());

      return PendingPhotoInputUser(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        kycStatus: mapValueOfType<String>(json, r'kycStatus'),
      );
    }
    return null;
  }

  static List<PendingPhotoInputUser> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingPhotoInputUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingPhotoInputUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingPhotoInputUser> mapFromJson(dynamic json) {
    final map = <String, PendingPhotoInputUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PendingPhotoInputUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingPhotoInputUser-objects as value to a dart map
  static Map<String, List<PendingPhotoInputUser>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingPhotoInputUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingPhotoInputUser.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'kycStatus',
  };
}

