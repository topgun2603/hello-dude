//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveCardHost {
  /// Returns a new [LiveCardHost] instance.
  LiveCardHost({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.photoUrl,
    required this.rating,
    this.languages = const [],
    required this.isFavourite,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Approved profile photo (signed URL path); null = show the avatar
  String? photoUrl;

  num? rating;

  List<String> languages;

  bool isFavourite;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveCardHost &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.photoUrl == photoUrl &&
    other.rating == rating &&
    _deepEquality.equals(other.languages, languages) &&
    other.isFavourite == isFavourite;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (languages.hashCode) +
    (isFavourite.hashCode);

  @override
  String toString() => 'LiveCardHost[id=$id, displayName=$displayName, avatarId=$avatarId, photoUrl=$photoUrl, rating=$rating, languages=$languages, isFavourite=$isFavourite]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
    if (this.photoUrl != null) {
      json[r'photoUrl'] = this.photoUrl;
    } else {
      json[r'photoUrl'] = null;
    }
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'languages'] = this.languages;
      json[r'isFavourite'] = this.isFavourite;
    return json;
  }

  /// Returns a new [LiveCardHost] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveCardHost? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "LiveCardHost[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "LiveCardHost[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "LiveCardHost[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "LiveCardHost[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "LiveCardHost[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "LiveCardHost[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'photoUrl'), 'Required key "LiveCardHost[photoUrl]" is missing from JSON.');
        assert(json.containsKey(r'rating'), 'Required key "LiveCardHost[rating]" is missing from JSON.');
        assert(json.containsKey(r'languages'), 'Required key "LiveCardHost[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "LiveCardHost[languages]" has a null value in JSON.');
        assert(json.containsKey(r'isFavourite'), 'Required key "LiveCardHost[isFavourite]" is missing from JSON.');
        assert(json[r'isFavourite'] != null, 'Required key "LiveCardHost[isFavourite]" has a null value in JSON.');
        return true;
      }());

      return LiveCardHost(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        photoUrl: mapValueOfType<String>(json, r'photoUrl'),
        rating: json[r'rating'] == null
            ? null
            : num.parse('${json[r'rating']}'),
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        isFavourite: mapValueOfType<bool>(json, r'isFavourite')!,
      );
    }
    return null;
  }

  static List<LiveCardHost> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveCardHost>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveCardHost.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveCardHost> mapFromJson(dynamic json) {
    final map = <String, LiveCardHost>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveCardHost.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveCardHost-objects as value to a dart map
  static Map<String, List<LiveCardHost>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveCardHost>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveCardHost.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'photoUrl',
    'rating',
    'languages',
    'isFavourite',
  };
}

