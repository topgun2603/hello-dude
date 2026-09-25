//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminEventInput {
  /// Returns a new [AdminEventInput] instance.
  AdminEventInput({
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

  Object? startsAt;

  Object? endsAt;

  List<int> giftIds;

  bool active;

  bool badgesAwarded;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminEventInput &&
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
    (startsAt == null ? 0 : startsAt!.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (giftIds.hashCode) +
    (active.hashCode) +
    (badgesAwarded.hashCode);

  @override
  String toString() => 'AdminEventInput[id=$id, name=$name, tagline=$tagline, theme=$theme, startsAt=$startsAt, endsAt=$endsAt, giftIds=$giftIds, active=$active, badgesAwarded=$badgesAwarded]';

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
    if (this.startsAt != null) {
      json[r'startsAt'] = this.startsAt;
    } else {
      json[r'startsAt'] = null;
    }
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
      json[r'giftIds'] = this.giftIds;
      json[r'active'] = this.active;
      json[r'badgesAwarded'] = this.badgesAwarded;
    return json;
  }

  /// Returns a new [AdminEventInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminEventInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminEventInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminEventInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminEventInput[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminEventInput[name]" has a null value in JSON.');
        assert(json.containsKey(r'tagline'), 'Required key "AdminEventInput[tagline]" is missing from JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminEventInput[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminEventInput[theme]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminEventInput[startsAt]" is missing from JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AdminEventInput[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'giftIds'), 'Required key "AdminEventInput[giftIds]" is missing from JSON.');
        assert(json[r'giftIds'] != null, 'Required key "AdminEventInput[giftIds]" has a null value in JSON.');
        assert(json.containsKey(r'active'), 'Required key "AdminEventInput[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "AdminEventInput[active]" has a null value in JSON.');
        assert(json.containsKey(r'badgesAwarded'), 'Required key "AdminEventInput[badgesAwarded]" is missing from JSON.');
        assert(json[r'badgesAwarded'] != null, 'Required key "AdminEventInput[badgesAwarded]" has a null value in JSON.');
        return true;
      }());

      return AdminEventInput(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        tagline: mapValueOfType<String>(json, r'tagline'),
        theme: mapValueOfType<String>(json, r'theme')!,
        startsAt: mapValueOfType<Object>(json, r'startsAt'),
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
        giftIds: json[r'giftIds'] is Iterable
            ? (json[r'giftIds'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        active: mapValueOfType<bool>(json, r'active')!,
        badgesAwarded: mapValueOfType<bool>(json, r'badgesAwarded')!,
      );
    }
    return null;
  }

  static List<AdminEventInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminEventInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminEventInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminEventInput> mapFromJson(dynamic json) {
    final map = <String, AdminEventInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminEventInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminEventInput-objects as value to a dart map
  static Map<String, List<AdminEventInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminEventInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminEventInput.listFromJson(entry.value, growable: growable,);
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

