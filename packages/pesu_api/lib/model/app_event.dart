//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AppEvent {
  /// Returns a new [AppEvent] instance.
  AppEvent({
    required this.id,
    required this.name,
    required this.tagline,
    required this.theme,
    required this.startsAt,
    required this.endsAt,
    this.giftIds = const [],
  });

  String id;

  String name;

  String? tagline;

  String theme;

  DateTime startsAt;

  DateTime endsAt;

  List<int> giftIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppEvent &&
    other.id == id &&
    other.name == name &&
    other.tagline == tagline &&
    other.theme == theme &&
    other.startsAt == startsAt &&
    other.endsAt == endsAt &&
    _deepEquality.equals(other.giftIds, giftIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (tagline == null ? 0 : tagline!.hashCode) +
    (theme.hashCode) +
    (startsAt.hashCode) +
    (endsAt.hashCode) +
    (giftIds.hashCode);

  @override
  String toString() => 'AppEvent[id=$id, name=$name, tagline=$tagline, theme=$theme, startsAt=$startsAt, endsAt=$endsAt, giftIds=$giftIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
    if (this.tagline != null) {
      json[r'tagline'] = this.tagline;
    } else {
      json[r'tagline'] = null;
    }
      json[r'theme'] = this.theme;
      json[r'startsAt'] = this.startsAt.toUtc().toIso8601String();
      json[r'endsAt'] = this.endsAt.toUtc().toIso8601String();
      json[r'giftIds'] = this.giftIds;
    return json;
  }

  /// Returns a new [AppEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AppEvent[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AppEvent[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AppEvent[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AppEvent[name]" has a null value in JSON.');
        assert(json.containsKey(r'tagline'), 'Required key "AppEvent[tagline]" is missing from JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AppEvent[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AppEvent[theme]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AppEvent[startsAt]" is missing from JSON.');
        assert(json[r'startsAt'] != null, 'Required key "AppEvent[startsAt]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AppEvent[endsAt]" is missing from JSON.');
        assert(json[r'endsAt'] != null, 'Required key "AppEvent[endsAt]" has a null value in JSON.');
        assert(json.containsKey(r'giftIds'), 'Required key "AppEvent[giftIds]" is missing from JSON.');
        assert(json[r'giftIds'] != null, 'Required key "AppEvent[giftIds]" has a null value in JSON.');
        return true;
      }());

      return AppEvent(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        tagline: mapValueOfType<String>(json, r'tagline'),
        theme: mapValueOfType<String>(json, r'theme')!,
        startsAt: mapDateTime(json, r'startsAt', r'')!,
        endsAt: mapDateTime(json, r'endsAt', r'')!,
        giftIds: json[r'giftIds'] is Iterable
            ? (json[r'giftIds'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AppEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppEvent> mapFromJson(dynamic json) {
    final map = <String, AppEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppEvent-objects as value to a dart map
  static Map<String, List<AppEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AppEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'tagline',
    'theme',
    'startsAt',
    'endsAt',
    'giftIds',
  };
}

