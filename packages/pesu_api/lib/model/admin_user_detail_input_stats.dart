//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputStats {
  /// Returns a new [AdminUserDetailInputStats] instance.
  AdminUserDetailInputStats({
    required this.calls,
    required this.missedCalls,
    required this.minutes,
    required this.coinsSpent,
    required this.paiseEarned,
    required this.giftsSent,
    required this.giftsSentCoins,
    required this.giftsReceived,
    required this.giftsReceivedPaise,
    required this.favourites,
    required this.followers,
    required this.blockedBy,
    required this.blocking,
    required this.ratingsGiven,
    required this.reportsAgainst,
    required this.reportsMade,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int missedCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paiseEarned;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftsSent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftsSentCoins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftsReceived;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftsReceivedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int favourites;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int followers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int blockedBy;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int blocking;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratingsGiven;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reportsAgainst;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reportsMade;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputStats &&
    other.calls == calls &&
    other.missedCalls == missedCalls &&
    other.minutes == minutes &&
    other.coinsSpent == coinsSpent &&
    other.paiseEarned == paiseEarned &&
    other.giftsSent == giftsSent &&
    other.giftsSentCoins == giftsSentCoins &&
    other.giftsReceived == giftsReceived &&
    other.giftsReceivedPaise == giftsReceivedPaise &&
    other.favourites == favourites &&
    other.followers == followers &&
    other.blockedBy == blockedBy &&
    other.blocking == blocking &&
    other.ratingsGiven == ratingsGiven &&
    other.reportsAgainst == reportsAgainst &&
    other.reportsMade == reportsMade;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calls.hashCode) +
    (missedCalls.hashCode) +
    (minutes.hashCode) +
    (coinsSpent.hashCode) +
    (paiseEarned.hashCode) +
    (giftsSent.hashCode) +
    (giftsSentCoins.hashCode) +
    (giftsReceived.hashCode) +
    (giftsReceivedPaise.hashCode) +
    (favourites.hashCode) +
    (followers.hashCode) +
    (blockedBy.hashCode) +
    (blocking.hashCode) +
    (ratingsGiven.hashCode) +
    (reportsAgainst.hashCode) +
    (reportsMade.hashCode);

  @override
  String toString() => 'AdminUserDetailInputStats[calls=$calls, missedCalls=$missedCalls, minutes=$minutes, coinsSpent=$coinsSpent, paiseEarned=$paiseEarned, giftsSent=$giftsSent, giftsSentCoins=$giftsSentCoins, giftsReceived=$giftsReceived, giftsReceivedPaise=$giftsReceivedPaise, favourites=$favourites, followers=$followers, blockedBy=$blockedBy, blocking=$blocking, ratingsGiven=$ratingsGiven, reportsAgainst=$reportsAgainst, reportsMade=$reportsMade]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'calls'] = this.calls;
      json[r'missedCalls'] = this.missedCalls;
      json[r'minutes'] = this.minutes;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'paiseEarned'] = this.paiseEarned;
      json[r'giftsSent'] = this.giftsSent;
      json[r'giftsSentCoins'] = this.giftsSentCoins;
      json[r'giftsReceived'] = this.giftsReceived;
      json[r'giftsReceivedPaise'] = this.giftsReceivedPaise;
      json[r'favourites'] = this.favourites;
      json[r'followers'] = this.followers;
      json[r'blockedBy'] = this.blockedBy;
      json[r'blocking'] = this.blocking;
      json[r'ratingsGiven'] = this.ratingsGiven;
      json[r'reportsAgainst'] = this.reportsAgainst;
      json[r'reportsMade'] = this.reportsMade;
    return json;
  }

  /// Returns a new [AdminUserDetailInputStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'calls'), 'Required key "AdminUserDetailInputStats[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminUserDetailInputStats[calls]" has a null value in JSON.');
        assert(json.containsKey(r'missedCalls'), 'Required key "AdminUserDetailInputStats[missedCalls]" is missing from JSON.');
        assert(json[r'missedCalls'] != null, 'Required key "AdminUserDetailInputStats[missedCalls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminUserDetailInputStats[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminUserDetailInputStats[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminUserDetailInputStats[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminUserDetailInputStats[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "AdminUserDetailInputStats[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "AdminUserDetailInputStats[paiseEarned]" has a null value in JSON.');
        assert(json.containsKey(r'giftsSent'), 'Required key "AdminUserDetailInputStats[giftsSent]" is missing from JSON.');
        assert(json[r'giftsSent'] != null, 'Required key "AdminUserDetailInputStats[giftsSent]" has a null value in JSON.');
        assert(json.containsKey(r'giftsSentCoins'), 'Required key "AdminUserDetailInputStats[giftsSentCoins]" is missing from JSON.');
        assert(json[r'giftsSentCoins'] != null, 'Required key "AdminUserDetailInputStats[giftsSentCoins]" has a null value in JSON.');
        assert(json.containsKey(r'giftsReceived'), 'Required key "AdminUserDetailInputStats[giftsReceived]" is missing from JSON.');
        assert(json[r'giftsReceived'] != null, 'Required key "AdminUserDetailInputStats[giftsReceived]" has a null value in JSON.');
        assert(json.containsKey(r'giftsReceivedPaise'), 'Required key "AdminUserDetailInputStats[giftsReceivedPaise]" is missing from JSON.');
        assert(json[r'giftsReceivedPaise'] != null, 'Required key "AdminUserDetailInputStats[giftsReceivedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'favourites'), 'Required key "AdminUserDetailInputStats[favourites]" is missing from JSON.');
        assert(json[r'favourites'] != null, 'Required key "AdminUserDetailInputStats[favourites]" has a null value in JSON.');
        assert(json.containsKey(r'followers'), 'Required key "AdminUserDetailInputStats[followers]" is missing from JSON.');
        assert(json[r'followers'] != null, 'Required key "AdminUserDetailInputStats[followers]" has a null value in JSON.');
        assert(json.containsKey(r'blockedBy'), 'Required key "AdminUserDetailInputStats[blockedBy]" is missing from JSON.');
        assert(json[r'blockedBy'] != null, 'Required key "AdminUserDetailInputStats[blockedBy]" has a null value in JSON.');
        assert(json.containsKey(r'blocking'), 'Required key "AdminUserDetailInputStats[blocking]" is missing from JSON.');
        assert(json[r'blocking'] != null, 'Required key "AdminUserDetailInputStats[blocking]" has a null value in JSON.');
        assert(json.containsKey(r'ratingsGiven'), 'Required key "AdminUserDetailInputStats[ratingsGiven]" is missing from JSON.');
        assert(json[r'ratingsGiven'] != null, 'Required key "AdminUserDetailInputStats[ratingsGiven]" has a null value in JSON.');
        assert(json.containsKey(r'reportsAgainst'), 'Required key "AdminUserDetailInputStats[reportsAgainst]" is missing from JSON.');
        assert(json[r'reportsAgainst'] != null, 'Required key "AdminUserDetailInputStats[reportsAgainst]" has a null value in JSON.');
        assert(json.containsKey(r'reportsMade'), 'Required key "AdminUserDetailInputStats[reportsMade]" is missing from JSON.');
        assert(json[r'reportsMade'] != null, 'Required key "AdminUserDetailInputStats[reportsMade]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputStats(
        calls: mapValueOfType<int>(json, r'calls')!,
        missedCalls: mapValueOfType<int>(json, r'missedCalls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        paiseEarned: mapValueOfType<int>(json, r'paiseEarned')!,
        giftsSent: mapValueOfType<int>(json, r'giftsSent')!,
        giftsSentCoins: mapValueOfType<int>(json, r'giftsSentCoins')!,
        giftsReceived: mapValueOfType<int>(json, r'giftsReceived')!,
        giftsReceivedPaise: mapValueOfType<int>(json, r'giftsReceivedPaise')!,
        favourites: mapValueOfType<int>(json, r'favourites')!,
        followers: mapValueOfType<int>(json, r'followers')!,
        blockedBy: mapValueOfType<int>(json, r'blockedBy')!,
        blocking: mapValueOfType<int>(json, r'blocking')!,
        ratingsGiven: mapValueOfType<int>(json, r'ratingsGiven')!,
        reportsAgainst: mapValueOfType<int>(json, r'reportsAgainst')!,
        reportsMade: mapValueOfType<int>(json, r'reportsMade')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailInputStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputStats> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputStats-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'calls',
    'missedCalls',
    'minutes',
    'coinsSpent',
    'paiseEarned',
    'giftsSent',
    'giftsSentCoins',
    'giftsReceived',
    'giftsReceivedPaise',
    'favourites',
    'followers',
    'blockedBy',
    'blocking',
    'ratingsGiven',
    'reportsAgainst',
    'reportsMade',
  };
}

