//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class OnlineCompanion {
  /// Returns a new [OnlineCompanion] instance.
  OnlineCompanion({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.primaryLanguage,
    this.languages = const [],
    required this.rating,
    required this.ratingCount,
    required this.videoEnabled,
    required this.busy,
    required this.isFavourite,
    required this.rates,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  String primaryLanguage;

  List<String> languages;

  /// Average stars, null until rated
  num? rating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratingCount;

  bool videoEnabled;

  bool busy;

  bool isFavourite;

  CompanionRates rates;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineCompanion &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.primaryLanguage == primaryLanguage &&
    _deepEquality.equals(other.languages, languages) &&
    other.rating == rating &&
    other.ratingCount == ratingCount &&
    other.videoEnabled == videoEnabled &&
    other.busy == busy &&
    other.isFavourite == isFavourite &&
    other.rates == rates;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (primaryLanguage.hashCode) +
    (languages.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (ratingCount.hashCode) +
    (videoEnabled.hashCode) +
    (busy.hashCode) +
    (isFavourite.hashCode) +
    (rates.hashCode);

  @override
  String toString() => 'OnlineCompanion[id=$id, displayName=$displayName, avatarId=$avatarId, primaryLanguage=$primaryLanguage, languages=$languages, rating=$rating, ratingCount=$ratingCount, videoEnabled=$videoEnabled, busy=$busy, isFavourite=$isFavourite, rates=$rates]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'languages'] = this.languages;
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'ratingCount'] = this.ratingCount;
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'busy'] = this.busy;
      json[r'isFavourite'] = this.isFavourite;
      json[r'rates'] = this.rates;
    return json;
  }

  /// Returns a new [OnlineCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "OnlineCompanion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "OnlineCompanion[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "OnlineCompanion[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "OnlineCompanion[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "OnlineCompanion[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "OnlineCompanion[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "OnlineCompanion[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "OnlineCompanion[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "OnlineCompanion[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "OnlineCompanion[languages]" has a null value in JSON.');
        assert(json.containsKey(r'rating'), 'Required key "OnlineCompanion[rating]" is missing from JSON.');
        assert(json.containsKey(r'ratingCount'), 'Required key "OnlineCompanion[ratingCount]" is missing from JSON.');
        assert(json[r'ratingCount'] != null, 'Required key "OnlineCompanion[ratingCount]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "OnlineCompanion[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "OnlineCompanion[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'busy'), 'Required key "OnlineCompanion[busy]" is missing from JSON.');
        assert(json[r'busy'] != null, 'Required key "OnlineCompanion[busy]" has a null value in JSON.');
        assert(json.containsKey(r'isFavourite'), 'Required key "OnlineCompanion[isFavourite]" is missing from JSON.');
        assert(json[r'isFavourite'] != null, 'Required key "OnlineCompanion[isFavourite]" has a null value in JSON.');
        assert(json.containsKey(r'rates'), 'Required key "OnlineCompanion[rates]" is missing from JSON.');
        assert(json[r'rates'] != null, 'Required key "OnlineCompanion[rates]" has a null value in JSON.');
        return true;
      }());

      return OnlineCompanion(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        rating: json[r'rating'] == null
            ? null
            : num.parse('${json[r'rating']}'),
        ratingCount: mapValueOfType<int>(json, r'ratingCount')!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        busy: mapValueOfType<bool>(json, r'busy')!,
        isFavourite: mapValueOfType<bool>(json, r'isFavourite')!,
        rates: CompanionRates.fromJson(json[r'rates'])!,
      );
    }
    return null;
  }

  static List<OnlineCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineCompanion> mapFromJson(dynamic json) {
    final map = <String, OnlineCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineCompanion-objects as value to a dart map
  static Map<String, List<OnlineCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineCompanion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'primaryLanguage',
    'languages',
    'rating',
    'ratingCount',
    'videoEnabled',
    'busy',
    'isFavourite',
    'rates',
  };
}

