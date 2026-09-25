//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LeaderboardEntry {
  /// Returns a new [LeaderboardEntry] instance.
  LeaderboardEntry({
    required this.rank,
    required this.user,
    required this.score,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int rank;

  LeaderboardEntryUser user;

  /// Coins
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int score;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LeaderboardEntry &&
    other.rank == rank &&
    other.user == user &&
    other.score == score;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (rank.hashCode) +
    (user.hashCode) +
    (score.hashCode);

  @override
  String toString() => 'LeaderboardEntry[rank=$rank, user=$user, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'rank'] = this.rank;
      json[r'user'] = this.user;
      json[r'score'] = this.score;
    return json;
  }

  /// Returns a new [LeaderboardEntry] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LeaderboardEntry? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'rank'), 'Required key "LeaderboardEntry[rank]" is missing from JSON.');
        assert(json[r'rank'] != null, 'Required key "LeaderboardEntry[rank]" has a null value in JSON.');
        assert(json.containsKey(r'user'), 'Required key "LeaderboardEntry[user]" is missing from JSON.');
        assert(json[r'user'] != null, 'Required key "LeaderboardEntry[user]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "LeaderboardEntry[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "LeaderboardEntry[score]" has a null value in JSON.');
        return true;
      }());

      return LeaderboardEntry(
        rank: mapValueOfType<int>(json, r'rank')!,
        user: LeaderboardEntryUser.fromJson(json[r'user'])!,
        score: mapValueOfType<int>(json, r'score')!,
      );
    }
    return null;
  }

  static List<LeaderboardEntry> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LeaderboardEntry>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LeaderboardEntry.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LeaderboardEntry> mapFromJson(dynamic json) {
    final map = <String, LeaderboardEntry>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LeaderboardEntry.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LeaderboardEntry-objects as value to a dart map
  static Map<String, List<LeaderboardEntry>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LeaderboardEntry>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LeaderboardEntry.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'rank',
    'user',
    'score',
  };
}

