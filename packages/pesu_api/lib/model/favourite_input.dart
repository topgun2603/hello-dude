//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class FavouriteInput {
  /// Returns a new [FavouriteInput] instance.
  FavouriteInput({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.photoUrl,
    this.languages = const [],
    required this.online,
    required this.busy,
    required this.lastOnlineAt,
    required this.notify,
    required this.audioEnabled,
    required this.videoEnabled,
    required this.rates,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Approved profile photo (signed URL path); null = show the avatar
  String? photoUrl;

  List<String> languages;

  bool online;

  bool busy;

  Object? lastOnlineAt;

  bool notify;

  bool audioEnabled;

  bool videoEnabled;

  CompanionRatesInput rates;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FavouriteInput &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.photoUrl == photoUrl &&
    _deepEquality.equals(other.languages, languages) &&
    other.online == online &&
    other.busy == busy &&
    other.lastOnlineAt == lastOnlineAt &&
    other.notify == notify &&
    other.audioEnabled == audioEnabled &&
    other.videoEnabled == videoEnabled &&
    other.rates == rates;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (languages.hashCode) +
    (online.hashCode) +
    (busy.hashCode) +
    (lastOnlineAt == null ? 0 : lastOnlineAt!.hashCode) +
    (notify.hashCode) +
    (audioEnabled.hashCode) +
    (videoEnabled.hashCode) +
    (rates.hashCode);

  @override
  String toString() => 'FavouriteInput[id=$id, displayName=$displayName, avatarId=$avatarId, photoUrl=$photoUrl, languages=$languages, online=$online, busy=$busy, lastOnlineAt=$lastOnlineAt, notify=$notify, audioEnabled=$audioEnabled, videoEnabled=$videoEnabled, rates=$rates]';

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
      json[r'languages'] = this.languages;
      json[r'online'] = this.online;
      json[r'busy'] = this.busy;
    if (this.lastOnlineAt != null) {
      json[r'lastOnlineAt'] = this.lastOnlineAt;
    } else {
      json[r'lastOnlineAt'] = null;
    }
      json[r'notify'] = this.notify;
      json[r'audioEnabled'] = this.audioEnabled;
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'rates'] = this.rates;
    return json;
  }

  /// Returns a new [FavouriteInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FavouriteInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "FavouriteInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "FavouriteInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "FavouriteInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "FavouriteInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "FavouriteInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "FavouriteInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'photoUrl'), 'Required key "FavouriteInput[photoUrl]" is missing from JSON.');
        assert(json.containsKey(r'languages'), 'Required key "FavouriteInput[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "FavouriteInput[languages]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "FavouriteInput[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "FavouriteInput[online]" has a null value in JSON.');
        assert(json.containsKey(r'busy'), 'Required key "FavouriteInput[busy]" is missing from JSON.');
        assert(json[r'busy'] != null, 'Required key "FavouriteInput[busy]" has a null value in JSON.');
        assert(json.containsKey(r'lastOnlineAt'), 'Required key "FavouriteInput[lastOnlineAt]" is missing from JSON.');
        assert(json.containsKey(r'notify'), 'Required key "FavouriteInput[notify]" is missing from JSON.');
        assert(json[r'notify'] != null, 'Required key "FavouriteInput[notify]" has a null value in JSON.');
        assert(json.containsKey(r'audioEnabled'), 'Required key "FavouriteInput[audioEnabled]" is missing from JSON.');
        assert(json[r'audioEnabled'] != null, 'Required key "FavouriteInput[audioEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "FavouriteInput[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "FavouriteInput[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'rates'), 'Required key "FavouriteInput[rates]" is missing from JSON.');
        assert(json[r'rates'] != null, 'Required key "FavouriteInput[rates]" has a null value in JSON.');
        return true;
      }());

      return FavouriteInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        photoUrl: mapValueOfType<String>(json, r'photoUrl'),
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        online: mapValueOfType<bool>(json, r'online')!,
        busy: mapValueOfType<bool>(json, r'busy')!,
        lastOnlineAt: mapValueOfType<Object>(json, r'lastOnlineAt'),
        notify: mapValueOfType<bool>(json, r'notify')!,
        audioEnabled: mapValueOfType<bool>(json, r'audioEnabled')!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        rates: CompanionRatesInput.fromJson(json[r'rates'])!,
      );
    }
    return null;
  }

  static List<FavouriteInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FavouriteInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FavouriteInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FavouriteInput> mapFromJson(dynamic json) {
    final map = <String, FavouriteInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FavouriteInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FavouriteInput-objects as value to a dart map
  static Map<String, List<FavouriteInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FavouriteInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FavouriteInput.listFromJson(entry.value, growable: growable,);
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
    'languages',
    'online',
    'busy',
    'lastOnlineAt',
    'notify',
    'audioEnabled',
    'videoEnabled',
    'rates',
  };
}

