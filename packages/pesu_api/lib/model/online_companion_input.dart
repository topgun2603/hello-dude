//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class OnlineCompanionInput {
  /// Returns a new [OnlineCompanionInput] instance.
  OnlineCompanionInput({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.photoUrl,
    required this.primaryLanguage,
    this.languages = const [],
    required this.rating,
    required this.ratingCount,
    required this.audioEnabled,
    required this.videoEnabled,
    required this.busy,
    required this.isFavourite,
    required this.rates,
    required this.badge,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Approved profile photo (signed URL path); null = show the avatar
  String? photoUrl;

  String primaryLanguage;

  List<String> languages;

  /// Average stars, null until rated
  num? rating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratingCount;

  /// Takes voice calls right now
  bool audioEnabled;

  /// Takes video calls right now (unlocked and switched on)
  bool videoEnabled;

  bool busy;

  bool isFavourite;

  CompanionRatesInput rates;

  /// Best active badge, e.g. '#1 companion this week'
  UserBadgeInput? badge;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineCompanionInput &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.photoUrl == photoUrl &&
    other.primaryLanguage == primaryLanguage &&
    _deepEquality.equals(other.languages, languages) &&
    other.rating == rating &&
    other.ratingCount == ratingCount &&
    other.audioEnabled == audioEnabled &&
    other.videoEnabled == videoEnabled &&
    other.busy == busy &&
    other.isFavourite == isFavourite &&
    other.rates == rates &&
    other.badge == badge;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (primaryLanguage.hashCode) +
    (languages.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (ratingCount.hashCode) +
    (audioEnabled.hashCode) +
    (videoEnabled.hashCode) +
    (busy.hashCode) +
    (isFavourite.hashCode) +
    (rates.hashCode) +
    (badge == null ? 0 : badge!.hashCode);

  @override
  String toString() => 'OnlineCompanionInput[id=$id, displayName=$displayName, avatarId=$avatarId, photoUrl=$photoUrl, primaryLanguage=$primaryLanguage, languages=$languages, rating=$rating, ratingCount=$ratingCount, audioEnabled=$audioEnabled, videoEnabled=$videoEnabled, busy=$busy, isFavourite=$isFavourite, rates=$rates, badge=$badge]';

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
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'languages'] = this.languages;
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'ratingCount'] = this.ratingCount;
      json[r'audioEnabled'] = this.audioEnabled;
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'busy'] = this.busy;
      json[r'isFavourite'] = this.isFavourite;
      json[r'rates'] = this.rates;
    if (this.badge != null) {
      json[r'badge'] = this.badge;
    } else {
      json[r'badge'] = null;
    }
    return json;
  }

  /// Returns a new [OnlineCompanionInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineCompanionInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "OnlineCompanionInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "OnlineCompanionInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "OnlineCompanionInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "OnlineCompanionInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "OnlineCompanionInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "OnlineCompanionInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'photoUrl'), 'Required key "OnlineCompanionInput[photoUrl]" is missing from JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "OnlineCompanionInput[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "OnlineCompanionInput[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "OnlineCompanionInput[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "OnlineCompanionInput[languages]" has a null value in JSON.');
        assert(json.containsKey(r'rating'), 'Required key "OnlineCompanionInput[rating]" is missing from JSON.');
        assert(json.containsKey(r'ratingCount'), 'Required key "OnlineCompanionInput[ratingCount]" is missing from JSON.');
        assert(json[r'ratingCount'] != null, 'Required key "OnlineCompanionInput[ratingCount]" has a null value in JSON.');
        assert(json.containsKey(r'audioEnabled'), 'Required key "OnlineCompanionInput[audioEnabled]" is missing from JSON.');
        assert(json[r'audioEnabled'] != null, 'Required key "OnlineCompanionInput[audioEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "OnlineCompanionInput[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "OnlineCompanionInput[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'busy'), 'Required key "OnlineCompanionInput[busy]" is missing from JSON.');
        assert(json[r'busy'] != null, 'Required key "OnlineCompanionInput[busy]" has a null value in JSON.');
        assert(json.containsKey(r'isFavourite'), 'Required key "OnlineCompanionInput[isFavourite]" is missing from JSON.');
        assert(json[r'isFavourite'] != null, 'Required key "OnlineCompanionInput[isFavourite]" has a null value in JSON.');
        assert(json.containsKey(r'rates'), 'Required key "OnlineCompanionInput[rates]" is missing from JSON.');
        assert(json[r'rates'] != null, 'Required key "OnlineCompanionInput[rates]" has a null value in JSON.');
        assert(json.containsKey(r'badge'), 'Required key "OnlineCompanionInput[badge]" is missing from JSON.');
        return true;
      }());

      return OnlineCompanionInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        photoUrl: mapValueOfType<String>(json, r'photoUrl'),
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        rating: json[r'rating'] == null
            ? null
            : num.parse('${json[r'rating']}'),
        ratingCount: mapValueOfType<int>(json, r'ratingCount')!,
        audioEnabled: mapValueOfType<bool>(json, r'audioEnabled')!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        busy: mapValueOfType<bool>(json, r'busy')!,
        isFavourite: mapValueOfType<bool>(json, r'isFavourite')!,
        rates: CompanionRatesInput.fromJson(json[r'rates'])!,
        badge: UserBadgeInput.fromJson(json[r'badge']),
      );
    }
    return null;
  }

  static List<OnlineCompanionInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineCompanionInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineCompanionInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineCompanionInput> mapFromJson(dynamic json) {
    final map = <String, OnlineCompanionInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineCompanionInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineCompanionInput-objects as value to a dart map
  static Map<String, List<OnlineCompanionInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineCompanionInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineCompanionInput.listFromJson(entry.value, growable: growable,);
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
    'primaryLanguage',
    'languages',
    'rating',
    'ratingCount',
    'audioEnabled',
    'videoEnabled',
    'busy',
    'isFavourite',
    'rates',
    'badge',
  };
}

