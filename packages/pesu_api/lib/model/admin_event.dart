//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminEvent {
  /// Returns a new [AdminEvent] instance.
  AdminEvent({
    required this.id,
    required this.name,
    required this.tagline,
    required this.theme,
    required this.startsAt,
    required this.endsAt,
    this.giftIds = const [],
    required this.active,
    required this.badgesAwarded,
  });

  String id;

  String name;

  String? tagline;

  String theme;

  DateTime startsAt;

  DateTime endsAt;

  List<int> giftIds;

  bool active;

  bool badgesAwarded;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminEvent &&
    other.id == id &&
    other.name == name &&
    other.tagline == tagline &&
    other.theme == theme &&
    other.startsAt == startsAt &&
    other.endsAt == endsAt &&
    _deepEquality.equals(other.giftIds, giftIds) &&
    other.active == active &&
    other.badgesAwarded == badgesAwarded;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (tagline == null ? 0 : tagline!.hashCode) +
    (theme.hashCode) +
    (startsAt.hashCode) +
    (endsAt.hashCode) +
    (giftIds.hashCode) +
    (active.hashCode) +
    (badgesAwarded.hashCode);

  @override
  String toString() => 'AdminEvent[id=$id, name=$name, tagline=$tagline, theme=$theme, startsAt=$startsAt, endsAt=$endsAt, giftIds=$giftIds, active=$active, badgesAwarded=$badgesAwarded]';

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
      json[r'active'] = this.active;
      json[r'badgesAwarded'] = this.badgesAwarded;
    return json;
  }

  /// Returns a new [AdminEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminEvent[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminEvent[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminEvent[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminEvent[name]" has a null value in JSON.');
        assert(json.containsKey(r'tagline'), 'Required key "AdminEvent[tagline]" is missing from JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminEvent[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminEvent[theme]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminEvent[startsAt]" is missing from JSON.');
        assert(json[r'startsAt'] != null, 'Required key "AdminEvent[startsAt]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AdminEvent[endsAt]" is missing from JSON.');
        assert(json[r'endsAt'] != null, 'Required key "AdminEvent[endsAt]" has a null value in JSON.');
        assert(json.containsKey(r'giftIds'), 'Required key "AdminEvent[giftIds]" is missing from JSON.');
        assert(json[r'giftIds'] != null, 'Required key "AdminEvent[giftIds]" has a null value in JSON.');
        assert(json.containsKey(r'active'), 'Required key "AdminEvent[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "AdminEvent[active]" has a null value in JSON.');
        assert(json.containsKey(r'badgesAwarded'), 'Required key "AdminEvent[badgesAwarded]" is missing from JSON.');
        assert(json[r'badgesAwarded'] != null, 'Required key "AdminEvent[badgesAwarded]" has a null value in JSON.');
        return true;
      }());

      return AdminEvent(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        tagline: mapValueOfType<String>(json, r'tagline'),
        theme: mapValueOfType<String>(json, r'theme')!,
        startsAt: mapDateTime(json, r'startsAt', r'')!,
        endsAt: mapDateTime(json, r'endsAt', r'')!,
        giftIds: json[r'giftIds'] is Iterable
            ? (json[r'giftIds'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        active: mapValueOfType<bool>(json, r'active')!,
        badgesAwarded: mapValueOfType<bool>(json, r'badgesAwarded')!,
      );
    }
    return null;
  }

  static List<AdminEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminEvent> mapFromJson(dynamic json) {
    final map = <String, AdminEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminEvent-objects as value to a dart map
  static Map<String, List<AdminEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminEvent.listFromJson(entry.value, growable: growable,);
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
    'active',
    'badgesAwarded',
  };
}

