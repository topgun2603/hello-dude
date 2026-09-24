//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AnalyticsTotalsInput {
  /// Returns a new [AnalyticsTotalsInput] instance.
  AnalyticsTotalsInput({
    required this.connectedCalls,
    required this.missedCalls,
    required this.minutes,
    required this.avgCallSeconds,
    required this.coinsSpent,
    required this.coinsOnCalls,
    required this.coinsOnGifts,
    required this.coinsOnLives,
    required this.coinsOnGroups,
    required this.coinsRefunded,
    required this.salesPaise,
    required this.purchases,
    required this.companionEarningsPaise,
    required this.newCallers,
    required this.newCompanions,
    required this.activeCallers,
    required this.payingCallers,
    required this.avgRating,
    required this.ratings,
    required this.companionOnlineMinutes,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int connectedCalls;

  /// Rang but never connected (missed, declined, failed)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int missedCalls;

  /// Billed minutes
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avgCallSeconds;

  /// Calls + gifts, minus refunds
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsOnCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsOnGifts;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsOnLives;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsOnGroups;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  /// Coin packs sold (gross, incl. GST)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int salesPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int purchases;

  /// Calls + gifts + bonuses, after reversals
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionEarningsPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCallers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int newCompanions;

  /// Callers with at least one connected call
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int activeCallers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int payingCallers;

  num? avgRating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratings;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionOnlineMinutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsTotalsInput &&
    other.connectedCalls == connectedCalls &&
    other.missedCalls == missedCalls &&
    other.minutes == minutes &&
    other.avgCallSeconds == avgCallSeconds &&
    other.coinsSpent == coinsSpent &&
    other.coinsOnCalls == coinsOnCalls &&
    other.coinsOnGifts == coinsOnGifts &&
    other.coinsOnLives == coinsOnLives &&
    other.coinsOnGroups == coinsOnGroups &&
    other.coinsRefunded == coinsRefunded &&
    other.salesPaise == salesPaise &&
    other.purchases == purchases &&
    other.companionEarningsPaise == companionEarningsPaise &&
    other.newCallers == newCallers &&
    other.newCompanions == newCompanions &&
    other.activeCallers == activeCallers &&
    other.payingCallers == payingCallers &&
    other.avgRating == avgRating &&
    other.ratings == ratings &&
    other.companionOnlineMinutes == companionOnlineMinutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectedCalls.hashCode) +
    (missedCalls.hashCode) +
    (minutes.hashCode) +
    (avgCallSeconds.hashCode) +
    (coinsSpent.hashCode) +
    (coinsOnCalls.hashCode) +
    (coinsOnGifts.hashCode) +
    (coinsOnLives.hashCode) +
    (coinsOnGroups.hashCode) +
    (coinsRefunded.hashCode) +
    (salesPaise.hashCode) +
    (purchases.hashCode) +
    (companionEarningsPaise.hashCode) +
    (newCallers.hashCode) +
    (newCompanions.hashCode) +
    (activeCallers.hashCode) +
    (payingCallers.hashCode) +
    (avgRating == null ? 0 : avgRating!.hashCode) +
    (ratings.hashCode) +
    (companionOnlineMinutes.hashCode);

  @override
  String toString() => 'AnalyticsTotalsInput[connectedCalls=$connectedCalls, missedCalls=$missedCalls, minutes=$minutes, avgCallSeconds=$avgCallSeconds, coinsSpent=$coinsSpent, coinsOnCalls=$coinsOnCalls, coinsOnGifts=$coinsOnGifts, coinsOnLives=$coinsOnLives, coinsOnGroups=$coinsOnGroups, coinsRefunded=$coinsRefunded, salesPaise=$salesPaise, purchases=$purchases, companionEarningsPaise=$companionEarningsPaise, newCallers=$newCallers, newCompanions=$newCompanions, activeCallers=$activeCallers, payingCallers=$payingCallers, avgRating=$avgRating, ratings=$ratings, companionOnlineMinutes=$companionOnlineMinutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'connectedCalls'] = this.connectedCalls;
      json[r'missedCalls'] = this.missedCalls;
      json[r'minutes'] = this.minutes;
      json[r'avgCallSeconds'] = this.avgCallSeconds;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'coinsOnCalls'] = this.coinsOnCalls;
      json[r'coinsOnGifts'] = this.coinsOnGifts;
      json[r'coinsOnLives'] = this.coinsOnLives;
      json[r'coinsOnGroups'] = this.coinsOnGroups;
      json[r'coinsRefunded'] = this.coinsRefunded;
      json[r'salesPaise'] = this.salesPaise;
      json[r'purchases'] = this.purchases;
      json[r'companionEarningsPaise'] = this.companionEarningsPaise;
      json[r'newCallers'] = this.newCallers;
      json[r'newCompanions'] = this.newCompanions;
      json[r'activeCallers'] = this.activeCallers;
      json[r'payingCallers'] = this.payingCallers;
    if (this.avgRating != null) {
      json[r'avgRating'] = this.avgRating;
    } else {
      json[r'avgRating'] = null;
    }
      json[r'ratings'] = this.ratings;
      json[r'companionOnlineMinutes'] = this.companionOnlineMinutes;
    return json;
  }

  /// Returns a new [AnalyticsTotalsInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsTotalsInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'connectedCalls'), 'Required key "AnalyticsTotalsInput[connectedCalls]" is missing from JSON.');
        assert(json[r'connectedCalls'] != null, 'Required key "AnalyticsTotalsInput[connectedCalls]" has a null value in JSON.');
        assert(json.containsKey(r'missedCalls'), 'Required key "AnalyticsTotalsInput[missedCalls]" is missing from JSON.');
        assert(json[r'missedCalls'] != null, 'Required key "AnalyticsTotalsInput[missedCalls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AnalyticsTotalsInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AnalyticsTotalsInput[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'avgCallSeconds'), 'Required key "AnalyticsTotalsInput[avgCallSeconds]" is missing from JSON.');
        assert(json[r'avgCallSeconds'] != null, 'Required key "AnalyticsTotalsInput[avgCallSeconds]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AnalyticsTotalsInput[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AnalyticsTotalsInput[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'coinsOnCalls'), 'Required key "AnalyticsTotalsInput[coinsOnCalls]" is missing from JSON.');
        assert(json[r'coinsOnCalls'] != null, 'Required key "AnalyticsTotalsInput[coinsOnCalls]" has a null value in JSON.');
        assert(json.containsKey(r'coinsOnGifts'), 'Required key "AnalyticsTotalsInput[coinsOnGifts]" is missing from JSON.');
        assert(json[r'coinsOnGifts'] != null, 'Required key "AnalyticsTotalsInput[coinsOnGifts]" has a null value in JSON.');
        assert(json.containsKey(r'coinsOnLives'), 'Required key "AnalyticsTotalsInput[coinsOnLives]" is missing from JSON.');
        assert(json[r'coinsOnLives'] != null, 'Required key "AnalyticsTotalsInput[coinsOnLives]" has a null value in JSON.');
        assert(json.containsKey(r'coinsOnGroups'), 'Required key "AnalyticsTotalsInput[coinsOnGroups]" is missing from JSON.');
        assert(json[r'coinsOnGroups'] != null, 'Required key "AnalyticsTotalsInput[coinsOnGroups]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "AnalyticsTotalsInput[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "AnalyticsTotalsInput[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'salesPaise'), 'Required key "AnalyticsTotalsInput[salesPaise]" is missing from JSON.');
        assert(json[r'salesPaise'] != null, 'Required key "AnalyticsTotalsInput[salesPaise]" has a null value in JSON.');
        assert(json.containsKey(r'purchases'), 'Required key "AnalyticsTotalsInput[purchases]" is missing from JSON.');
        assert(json[r'purchases'] != null, 'Required key "AnalyticsTotalsInput[purchases]" has a null value in JSON.');
        assert(json.containsKey(r'companionEarningsPaise'), 'Required key "AnalyticsTotalsInput[companionEarningsPaise]" is missing from JSON.');
        assert(json[r'companionEarningsPaise'] != null, 'Required key "AnalyticsTotalsInput[companionEarningsPaise]" has a null value in JSON.');
        assert(json.containsKey(r'newCallers'), 'Required key "AnalyticsTotalsInput[newCallers]" is missing from JSON.');
        assert(json[r'newCallers'] != null, 'Required key "AnalyticsTotalsInput[newCallers]" has a null value in JSON.');
        assert(json.containsKey(r'newCompanions'), 'Required key "AnalyticsTotalsInput[newCompanions]" is missing from JSON.');
        assert(json[r'newCompanions'] != null, 'Required key "AnalyticsTotalsInput[newCompanions]" has a null value in JSON.');
        assert(json.containsKey(r'activeCallers'), 'Required key "AnalyticsTotalsInput[activeCallers]" is missing from JSON.');
        assert(json[r'activeCallers'] != null, 'Required key "AnalyticsTotalsInput[activeCallers]" has a null value in JSON.');
        assert(json.containsKey(r'payingCallers'), 'Required key "AnalyticsTotalsInput[payingCallers]" is missing from JSON.');
        assert(json[r'payingCallers'] != null, 'Required key "AnalyticsTotalsInput[payingCallers]" has a null value in JSON.');
        assert(json.containsKey(r'avgRating'), 'Required key "AnalyticsTotalsInput[avgRating]" is missing from JSON.');
        assert(json.containsKey(r'ratings'), 'Required key "AnalyticsTotalsInput[ratings]" is missing from JSON.');
        assert(json[r'ratings'] != null, 'Required key "AnalyticsTotalsInput[ratings]" has a null value in JSON.');
        assert(json.containsKey(r'companionOnlineMinutes'), 'Required key "AnalyticsTotalsInput[companionOnlineMinutes]" is missing from JSON.');
        assert(json[r'companionOnlineMinutes'] != null, 'Required key "AnalyticsTotalsInput[companionOnlineMinutes]" has a null value in JSON.');
        return true;
      }());

      return AnalyticsTotalsInput(
        connectedCalls: mapValueOfType<int>(json, r'connectedCalls')!,
        missedCalls: mapValueOfType<int>(json, r'missedCalls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        avgCallSeconds: mapValueOfType<int>(json, r'avgCallSeconds')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        coinsOnCalls: mapValueOfType<int>(json, r'coinsOnCalls')!,
        coinsOnGifts: mapValueOfType<int>(json, r'coinsOnGifts')!,
        coinsOnLives: mapValueOfType<int>(json, r'coinsOnLives')!,
        coinsOnGroups: mapValueOfType<int>(json, r'coinsOnGroups')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        salesPaise: mapValueOfType<int>(json, r'salesPaise')!,
        purchases: mapValueOfType<int>(json, r'purchases')!,
        companionEarningsPaise: mapValueOfType<int>(json, r'companionEarningsPaise')!,
        newCallers: mapValueOfType<int>(json, r'newCallers')!,
        newCompanions: mapValueOfType<int>(json, r'newCompanions')!,
        activeCallers: mapValueOfType<int>(json, r'activeCallers')!,
        payingCallers: mapValueOfType<int>(json, r'payingCallers')!,
        avgRating: json[r'avgRating'] == null
            ? null
            : num.parse('${json[r'avgRating']}'),
        ratings: mapValueOfType<int>(json, r'ratings')!,
        companionOnlineMinutes: mapValueOfType<int>(json, r'companionOnlineMinutes')!,
      );
    }
    return null;
  }

  static List<AnalyticsTotalsInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsTotalsInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsTotalsInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsTotalsInput> mapFromJson(dynamic json) {
    final map = <String, AnalyticsTotalsInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsTotalsInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsTotalsInput-objects as value to a dart map
  static Map<String, List<AnalyticsTotalsInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsTotalsInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsTotalsInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connectedCalls',
    'missedCalls',
    'minutes',
    'avgCallSeconds',
    'coinsSpent',
    'coinsOnCalls',
    'coinsOnGifts',
    'coinsOnLives',
    'coinsOnGroups',
    'coinsRefunded',
    'salesPaise',
    'purchases',
    'companionEarningsPaise',
    'newCallers',
    'newCompanions',
    'activeCallers',
    'payingCallers',
    'avgRating',
    'ratings',
    'companionOnlineMinutes',
  };
}

