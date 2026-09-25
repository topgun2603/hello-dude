//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LeaderboardEntryInput {
  /// Returns a new [LeaderboardEntryInput] instance.
  LeaderboardEntryInput({
    required this.rank,
    required this.user,
    required this.score,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int rank;

  LeaderboardEntryInputUser user;

  /// Coins
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int score;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LeaderboardEntryInput &&
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
  String toString() => 'LeaderboardEntryInput[rank=$rank, user=$user, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'rank'] = this.rank;
      json[r'user'] = this.user;
      json[r'score'] = this.score;
    return json;
  }

  /// Returns a new [LeaderboardEntryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LeaderboardEntryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'rank'), 'Required key "LeaderboardEntryInput[rank]" is missing from JSON.');
        assert(json[r'rank'] != null, 'Required key "LeaderboardEntryInput[rank]" has a null value in JSON.');
        assert(json.containsKey(r'user'), 'Required key "LeaderboardEntryInput[user]" is missing from JSON.');
        assert(json[r'user'] != null, 'Required key "LeaderboardEntryInput[user]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "LeaderboardEntryInput[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "LeaderboardEntryInput[score]" has a null value in JSON.');
        return true;
      }());

      return LeaderboardEntryInput(
        rank: mapValueOfType<int>(json, r'rank')!,
        user: LeaderboardEntryInputUser.fromJson(json[r'user'])!,
        score: mapValueOfType<int>(json, r'score')!,
      );
    }
    return null;
  }

  static List<LeaderboardEntryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LeaderboardEntryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LeaderboardEntryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LeaderboardEntryInput> mapFromJson(dynamic json) {
    final map = <String, LeaderboardEntryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LeaderboardEntryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LeaderboardEntryInput-objects as value to a dart map
  static Map<String, List<LeaderboardEntryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LeaderboardEntryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LeaderboardEntryInput.listFromJson(entry.value, growable: growable,);
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

