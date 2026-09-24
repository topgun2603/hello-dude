//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCompanionRewards200Response {
  /// Returns a new [GetCompanionRewards200Response] instance.
  GetCompanionRewards200Response({
    required this.level,
    required this.next,
    required this.monthHours,
    required this.rating,
    required this.ratingCount,
    required this.todayEarnedPaise,
    required this.dailyGoalPaise,
    required this.streakDays,
    this.bonuses = const [],
    required this.academy,
    required this.videoEnabled,
  });

  CompanionLevel level;

  CompanionLevel? next;

  num monthHours;

  num? rating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratingCount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int todayEarnedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int dailyGoalPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int streakDays;

  List<CompanionBonus> bonuses;

  GetCompanionRewards200ResponseAcademy academy;

  bool videoEnabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCompanionRewards200Response &&
    other.level == level &&
    other.next == next &&
    other.monthHours == monthHours &&
    other.rating == rating &&
    other.ratingCount == ratingCount &&
    other.todayEarnedPaise == todayEarnedPaise &&
    other.dailyGoalPaise == dailyGoalPaise &&
    other.streakDays == streakDays &&
    _deepEquality.equals(other.bonuses, bonuses) &&
    other.academy == academy &&
    other.videoEnabled == videoEnabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level.hashCode) +
    (next == null ? 0 : next!.hashCode) +
    (monthHours.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (ratingCount.hashCode) +
    (todayEarnedPaise.hashCode) +
    (dailyGoalPaise.hashCode) +
    (streakDays.hashCode) +
    (bonuses.hashCode) +
    (academy.hashCode) +
    (videoEnabled.hashCode);

  @override
  String toString() => 'GetCompanionRewards200Response[level=$level, next=$next, monthHours=$monthHours, rating=$rating, ratingCount=$ratingCount, todayEarnedPaise=$todayEarnedPaise, dailyGoalPaise=$dailyGoalPaise, streakDays=$streakDays, bonuses=$bonuses, academy=$academy, videoEnabled=$videoEnabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'level'] = this.level;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
      json[r'monthHours'] = this.monthHours;
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'ratingCount'] = this.ratingCount;
      json[r'todayEarnedPaise'] = this.todayEarnedPaise;
      json[r'dailyGoalPaise'] = this.dailyGoalPaise;
      json[r'streakDays'] = this.streakDays;
      json[r'bonuses'] = this.bonuses;
      json[r'academy'] = this.academy;
      json[r'videoEnabled'] = this.videoEnabled;
    return json;
  }

  /// Returns a new [GetCompanionRewards200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCompanionRewards200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'), 'Required key "GetCompanionRewards200Response[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "GetCompanionRewards200Response[level]" has a null value in JSON.');
        assert(json.containsKey(r'next'), 'Required key "GetCompanionRewards200Response[next]" is missing from JSON.');
        assert(json.containsKey(r'monthHours'), 'Required key "GetCompanionRewards200Response[monthHours]" is missing from JSON.');
        assert(json[r'monthHours'] != null, 'Required key "GetCompanionRewards200Response[monthHours]" has a null value in JSON.');
        assert(json.containsKey(r'rating'), 'Required key "GetCompanionRewards200Response[rating]" is missing from JSON.');
        assert(json.containsKey(r'ratingCount'), 'Required key "GetCompanionRewards200Response[ratingCount]" is missing from JSON.');
        assert(json[r'ratingCount'] != null, 'Required key "GetCompanionRewards200Response[ratingCount]" has a null value in JSON.');
        assert(json.containsKey(r'todayEarnedPaise'), 'Required key "GetCompanionRewards200Response[todayEarnedPaise]" is missing from JSON.');
        assert(json[r'todayEarnedPaise'] != null, 'Required key "GetCompanionRewards200Response[todayEarnedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'dailyGoalPaise'), 'Required key "GetCompanionRewards200Response[dailyGoalPaise]" is missing from JSON.');
        assert(json[r'dailyGoalPaise'] != null, 'Required key "GetCompanionRewards200Response[dailyGoalPaise]" has a null value in JSON.');
        assert(json.containsKey(r'streakDays'), 'Required key "GetCompanionRewards200Response[streakDays]" is missing from JSON.');
        assert(json[r'streakDays'] != null, 'Required key "GetCompanionRewards200Response[streakDays]" has a null value in JSON.');
        assert(json.containsKey(r'bonuses'), 'Required key "GetCompanionRewards200Response[bonuses]" is missing from JSON.');
        assert(json[r'bonuses'] != null, 'Required key "GetCompanionRewards200Response[bonuses]" has a null value in JSON.');
        assert(json.containsKey(r'academy'), 'Required key "GetCompanionRewards200Response[academy]" is missing from JSON.');
        assert(json[r'academy'] != null, 'Required key "GetCompanionRewards200Response[academy]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "GetCompanionRewards200Response[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "GetCompanionRewards200Response[videoEnabled]" has a null value in JSON.');
        return true;
      }());

      return GetCompanionRewards200Response(
        level: CompanionLevel.fromJson(json[r'level'])!,
        next: CompanionLevel.fromJson(json[r'next']),
        monthHours: num.parse('${json[r'monthHours']}'),
        rating: json[r'rating'] == null
            ? null
            : num.parse('${json[r'rating']}'),
        ratingCount: mapValueOfType<int>(json, r'ratingCount')!,
        todayEarnedPaise: mapValueOfType<int>(json, r'todayEarnedPaise')!,
        dailyGoalPaise: mapValueOfType<int>(json, r'dailyGoalPaise')!,
        streakDays: mapValueOfType<int>(json, r'streakDays')!,
        bonuses: CompanionBonus.listFromJson(json[r'bonuses']),
        academy: GetCompanionRewards200ResponseAcademy.fromJson(json[r'academy'])!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
      );
    }
    return null;
  }

  static List<GetCompanionRewards200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCompanionRewards200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCompanionRewards200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCompanionRewards200Response> mapFromJson(dynamic json) {
    final map = <String, GetCompanionRewards200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCompanionRewards200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCompanionRewards200Response-objects as value to a dart map
  static Map<String, List<GetCompanionRewards200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCompanionRewards200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCompanionRewards200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'next',
    'monthHours',
    'rating',
    'ratingCount',
    'todayEarnedPaise',
    'dailyGoalPaise',
    'streakDays',
    'bonuses',
    'academy',
    'videoEnabled',
  };
}

