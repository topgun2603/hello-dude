//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Favourite {
  /// Returns a new [Favourite] instance.
  Favourite({
    required this.id,
    required this.displayName,
    required this.avatarId,
    this.languages = const [],
    required this.online,
    required this.busy,
    required this.lastOnlineAt,
    required this.notify,
    required this.videoEnabled,
    required this.rates,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  List<String> languages;

  bool online;

  bool busy;

  DateTime? lastOnlineAt;

  bool notify;

  bool videoEnabled;

  CompanionRates rates;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Favourite &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    _deepEquality.equals(other.languages, languages) &&
    other.online == online &&
    other.busy == busy &&
    other.lastOnlineAt == lastOnlineAt &&
    other.notify == notify &&
    other.videoEnabled == videoEnabled &&
    other.rates == rates;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (languages.hashCode) +
    (online.hashCode) +
    (busy.hashCode) +
    (lastOnlineAt == null ? 0 : lastOnlineAt!.hashCode) +
    (notify.hashCode) +
    (videoEnabled.hashCode) +
    (rates.hashCode);

  @override
  String toString() => 'Favourite[id=$id, displayName=$displayName, avatarId=$avatarId, languages=$languages, online=$online, busy=$busy, lastOnlineAt=$lastOnlineAt, notify=$notify, videoEnabled=$videoEnabled, rates=$rates]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'languages'] = this.languages;
      json[r'online'] = this.online;
      json[r'busy'] = this.busy;
    if (this.lastOnlineAt != null) {
      json[r'lastOnlineAt'] = this.lastOnlineAt!.toUtc().toIso8601String();
    } else {
      json[r'lastOnlineAt'] = null;
    }
      json[r'notify'] = this.notify;
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'rates'] = this.rates;
    return json;
  }

  /// Returns a new [Favourite] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Favourite? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Favourite[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Favourite[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "Favourite[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "Favourite[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "Favourite[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "Favourite[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "Favourite[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "Favourite[languages]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "Favourite[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "Favourite[online]" has a null value in JSON.');
        assert(json.containsKey(r'busy'), 'Required key "Favourite[busy]" is missing from JSON.');
        assert(json[r'busy'] != null, 'Required key "Favourite[busy]" has a null value in JSON.');
        assert(json.containsKey(r'lastOnlineAt'), 'Required key "Favourite[lastOnlineAt]" is missing from JSON.');
        assert(json.containsKey(r'notify'), 'Required key "Favourite[notify]" is missing from JSON.');
        assert(json[r'notify'] != null, 'Required key "Favourite[notify]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "Favourite[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "Favourite[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'rates'), 'Required key "Favourite[rates]" is missing from JSON.');
        assert(json[r'rates'] != null, 'Required key "Favourite[rates]" has a null value in JSON.');
        return true;
      }());

      return Favourite(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        online: mapValueOfType<bool>(json, r'online')!,
        busy: mapValueOfType<bool>(json, r'busy')!,
        lastOnlineAt: mapDateTime(json, r'lastOnlineAt', r''),
        notify: mapValueOfType<bool>(json, r'notify')!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        rates: CompanionRates.fromJson(json[r'rates'])!,
      );
    }
    return null;
  }

  static List<Favourite> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Favourite>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Favourite.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Favourite> mapFromJson(dynamic json) {
    final map = <String, Favourite>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Favourite.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Favourite-objects as value to a dart map
  static Map<String, List<Favourite>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Favourite>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Favourite.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'languages',
    'online',
    'busy',
    'lastOnlineAt',
    'notify',
    'videoEnabled',
    'rates',
  };
}

