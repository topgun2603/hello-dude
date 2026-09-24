//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputTopRatedInner {
  /// Returns a new [AdminAnalyticsInputTopRatedInner] instance.
  AdminAnalyticsInputTopRatedInner({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.rating,
    required this.ratings,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  num rating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratings;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputTopRatedInner &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.rating == rating &&
    other.ratings == ratings;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (rating.hashCode) +
    (ratings.hashCode);

  @override
  String toString() => 'AdminAnalyticsInputTopRatedInner[id=$id, displayName=$displayName, avatarId=$avatarId, rating=$rating, ratings=$ratings]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'rating'] = this.rating;
      json[r'ratings'] = this.ratings;
    return json;
  }

  /// Returns a new [AdminAnalyticsInputTopRatedInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputTopRatedInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsInputTopRatedInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsInputTopRatedInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsInputTopRatedInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsInputTopRatedInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsInputTopRatedInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsInputTopRatedInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'rating'), 'Required key "AdminAnalyticsInputTopRatedInner[rating]" is missing from JSON.');
        assert(json[r'rating'] != null, 'Required key "AdminAnalyticsInputTopRatedInner[rating]" has a null value in JSON.');
        assert(json.containsKey(r'ratings'), 'Required key "AdminAnalyticsInputTopRatedInner[ratings]" is missing from JSON.');
        assert(json[r'ratings'] != null, 'Required key "AdminAnalyticsInputTopRatedInner[ratings]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputTopRatedInner(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        rating: num.parse('${json[r'rating']}'),
        ratings: mapValueOfType<int>(json, r'ratings')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsInputTopRatedInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputTopRatedInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputTopRatedInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputTopRatedInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputTopRatedInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputTopRatedInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputTopRatedInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputTopRatedInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputTopRatedInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputTopRatedInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'rating',
    'ratings',
  };
}

