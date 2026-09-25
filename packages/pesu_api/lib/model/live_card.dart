//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveCard {
  /// Returns a new [LiveCard] instance.
  LiveCard({
    required this.id,
    required this.title,
    required this.language,
    required this.host,
    required this.viewers,
    required this.startedAt,
    required this.snapshotUrl,
    required this.pkBattleId,
  });

  String id;

  String title;

  String language;

  LiveCardHost host;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int viewers;

  DateTime startedAt;

  /// Recent still from the host's camera (signed path); null = use the host's photo/avatar
  String? snapshotUrl;

  /// An active PK battle this live is in (GET /pk/{id})
  String? pkBattleId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveCard &&
    other.id == id &&
    other.title == title &&
    other.language == language &&
    other.host == host &&
    other.viewers == viewers &&
    other.startedAt == startedAt &&
    other.snapshotUrl == snapshotUrl &&
    other.pkBattleId == pkBattleId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (language.hashCode) +
    (host.hashCode) +
    (viewers.hashCode) +
    (startedAt.hashCode) +
    (snapshotUrl == null ? 0 : snapshotUrl!.hashCode) +
    (pkBattleId == null ? 0 : pkBattleId!.hashCode);

  @override
  String toString() => 'LiveCard[id=$id, title=$title, language=$language, host=$host, viewers=$viewers, startedAt=$startedAt, snapshotUrl=$snapshotUrl, pkBattleId=$pkBattleId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'host'] = this.host;
      json[r'viewers'] = this.viewers;
      json[r'startedAt'] = this.startedAt.toUtc().toIso8601String();
    if (this.snapshotUrl != null) {
      json[r'snapshotUrl'] = this.snapshotUrl;
    } else {
      json[r'snapshotUrl'] = null;
    }
    if (this.pkBattleId != null) {
      json[r'pkBattleId'] = this.pkBattleId;
    } else {
      json[r'pkBattleId'] = null;
    }
    return json;
  }

  /// Returns a new [LiveCard] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveCard? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "LiveCard[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "LiveCard[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "LiveCard[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "LiveCard[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "LiveCard[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "LiveCard[language]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "LiveCard[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "LiveCard[host]" has a null value in JSON.');
        assert(json.containsKey(r'viewers'), 'Required key "LiveCard[viewers]" is missing from JSON.');
        assert(json[r'viewers'] != null, 'Required key "LiveCard[viewers]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "LiveCard[startedAt]" is missing from JSON.');
        assert(json[r'startedAt'] != null, 'Required key "LiveCard[startedAt]" has a null value in JSON.');
        assert(json.containsKey(r'snapshotUrl'), 'Required key "LiveCard[snapshotUrl]" is missing from JSON.');
        assert(json.containsKey(r'pkBattleId'), 'Required key "LiveCard[pkBattleId]" is missing from JSON.');
        return true;
      }());

      return LiveCard(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        host: LiveCardHost.fromJson(json[r'host'])!,
        viewers: mapValueOfType<int>(json, r'viewers')!,
        startedAt: mapDateTime(json, r'startedAt', r'')!,
        snapshotUrl: mapValueOfType<String>(json, r'snapshotUrl'),
        pkBattleId: mapValueOfType<String>(json, r'pkBattleId'),
      );
    }
    return null;
  }

  static List<LiveCard> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveCard>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveCard.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveCard> mapFromJson(dynamic json) {
    final map = <String, LiveCard>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveCard.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveCard-objects as value to a dart map
  static Map<String, List<LiveCard>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveCard>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveCard.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'language',
    'host',
    'viewers',
    'startedAt',
    'snapshotUrl',
    'pkBattleId',
  };
}

