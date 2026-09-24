//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsTopEarnersInner {
  /// Returns a new [AdminAnalyticsTopEarnersInner] instance.
  AdminAnalyticsTopEarnersInner({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.earnedPaise,
    required this.calls,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earnedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsTopEarnersInner &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.earnedPaise == earnedPaise &&
    other.calls == calls;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (earnedPaise.hashCode) +
    (calls.hashCode);

  @override
  String toString() => 'AdminAnalyticsTopEarnersInner[id=$id, displayName=$displayName, avatarId=$avatarId, earnedPaise=$earnedPaise, calls=$calls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'earnedPaise'] = this.earnedPaise;
      json[r'calls'] = this.calls;
    return json;
  }

  /// Returns a new [AdminAnalyticsTopEarnersInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsTopEarnersInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsTopEarnersInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsTopEarnersInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsTopEarnersInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsTopEarnersInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsTopEarnersInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsTopEarnersInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'earnedPaise'), 'Required key "AdminAnalyticsTopEarnersInner[earnedPaise]" is missing from JSON.');
        assert(json[r'earnedPaise'] != null, 'Required key "AdminAnalyticsTopEarnersInner[earnedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsTopEarnersInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsTopEarnersInner[calls]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsTopEarnersInner(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        earnedPaise: mapValueOfType<int>(json, r'earnedPaise')!,
        calls: mapValueOfType<int>(json, r'calls')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsTopEarnersInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsTopEarnersInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsTopEarnersInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsTopEarnersInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsTopEarnersInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsTopEarnersInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsTopEarnersInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsTopEarnersInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsTopEarnersInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsTopEarnersInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'earnedPaise',
    'calls',
  };
}

