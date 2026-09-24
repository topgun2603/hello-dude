//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsMostActiveInner {
  /// Returns a new [AdminAnalyticsMostActiveInner] instance.
  AdminAnalyticsMostActiveInner({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.talkMinutes,
    required this.calls,
    required this.onlineMinutes,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int talkMinutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int onlineMinutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsMostActiveInner &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.talkMinutes == talkMinutes &&
    other.calls == calls &&
    other.onlineMinutes == onlineMinutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (talkMinutes.hashCode) +
    (calls.hashCode) +
    (onlineMinutes.hashCode);

  @override
  String toString() => 'AdminAnalyticsMostActiveInner[id=$id, displayName=$displayName, avatarId=$avatarId, talkMinutes=$talkMinutes, calls=$calls, onlineMinutes=$onlineMinutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'talkMinutes'] = this.talkMinutes;
      json[r'calls'] = this.calls;
      json[r'onlineMinutes'] = this.onlineMinutes;
    return json;
  }

  /// Returns a new [AdminAnalyticsMostActiveInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsMostActiveInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsMostActiveInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsMostActiveInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsMostActiveInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsMostActiveInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsMostActiveInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsMostActiveInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'talkMinutes'), 'Required key "AdminAnalyticsMostActiveInner[talkMinutes]" is missing from JSON.');
        assert(json[r'talkMinutes'] != null, 'Required key "AdminAnalyticsMostActiveInner[talkMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsMostActiveInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsMostActiveInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'onlineMinutes'), 'Required key "AdminAnalyticsMostActiveInner[onlineMinutes]" is missing from JSON.');
        assert(json[r'onlineMinutes'] != null, 'Required key "AdminAnalyticsMostActiveInner[onlineMinutes]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsMostActiveInner(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        talkMinutes: mapValueOfType<int>(json, r'talkMinutes')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        onlineMinutes: mapValueOfType<int>(json, r'onlineMinutes')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsMostActiveInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsMostActiveInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsMostActiveInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsMostActiveInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsMostActiveInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsMostActiveInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsMostActiveInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsMostActiveInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsMostActiveInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsMostActiveInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'talkMinutes',
    'calls',
    'onlineMinutes',
  };
}

