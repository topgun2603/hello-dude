//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CoinHistorySummaryInput {
  /// Returns a new [CoinHistorySummaryInput] instance.
  CoinHistorySummaryInput({
    required this.spent,
    required this.added,
    required this.calls,
    required this.gifts,
    required this.lives,
    required this.groups,
    required this.bookings,
    required this.purchases,
    required this.bonuses,
    required this.refunds,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int spent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int added;

  /// Coins spent on calls
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int gifts;

  /// Coins on lives
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int lives;

  /// Coins on group video
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int groups;

  /// Coins held for booked calls, net of releases
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int bookings;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int purchases;

  /// Daily, invite and support bonuses
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int bonuses;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int refunds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CoinHistorySummaryInput &&
    other.spent == spent &&
    other.added == added &&
    other.calls == calls &&
    other.gifts == gifts &&
    other.lives == lives &&
    other.groups == groups &&
    other.bookings == bookings &&
    other.purchases == purchases &&
    other.bonuses == bonuses &&
    other.refunds == refunds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (spent.hashCode) +
    (added.hashCode) +
    (calls.hashCode) +
    (gifts.hashCode) +
    (lives.hashCode) +
    (groups.hashCode) +
    (bookings.hashCode) +
    (purchases.hashCode) +
    (bonuses.hashCode) +
    (refunds.hashCode);

  @override
  String toString() => 'CoinHistorySummaryInput[spent=$spent, added=$added, calls=$calls, gifts=$gifts, lives=$lives, groups=$groups, bookings=$bookings, purchases=$purchases, bonuses=$bonuses, refunds=$refunds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'spent'] = this.spent;
      json[r'added'] = this.added;
      json[r'calls'] = this.calls;
      json[r'gifts'] = this.gifts;
      json[r'lives'] = this.lives;
      json[r'groups'] = this.groups;
      json[r'bookings'] = this.bookings;
      json[r'purchases'] = this.purchases;
      json[r'bonuses'] = this.bonuses;
      json[r'refunds'] = this.refunds;
    return json;
  }

  /// Returns a new [CoinHistorySummaryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoinHistorySummaryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'spent'), 'Required key "CoinHistorySummaryInput[spent]" is missing from JSON.');
        assert(json[r'spent'] != null, 'Required key "CoinHistorySummaryInput[spent]" has a null value in JSON.');
        assert(json.containsKey(r'added'), 'Required key "CoinHistorySummaryInput[added]" is missing from JSON.');
        assert(json[r'added'] != null, 'Required key "CoinHistorySummaryInput[added]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "CoinHistorySummaryInput[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "CoinHistorySummaryInput[calls]" has a null value in JSON.');
        assert(json.containsKey(r'gifts'), 'Required key "CoinHistorySummaryInput[gifts]" is missing from JSON.');
        assert(json[r'gifts'] != null, 'Required key "CoinHistorySummaryInput[gifts]" has a null value in JSON.');
        assert(json.containsKey(r'lives'), 'Required key "CoinHistorySummaryInput[lives]" is missing from JSON.');
        assert(json[r'lives'] != null, 'Required key "CoinHistorySummaryInput[lives]" has a null value in JSON.');
        assert(json.containsKey(r'groups'), 'Required key "CoinHistorySummaryInput[groups]" is missing from JSON.');
        assert(json[r'groups'] != null, 'Required key "CoinHistorySummaryInput[groups]" has a null value in JSON.');
        assert(json.containsKey(r'bookings'), 'Required key "CoinHistorySummaryInput[bookings]" is missing from JSON.');
        assert(json[r'bookings'] != null, 'Required key "CoinHistorySummaryInput[bookings]" has a null value in JSON.');
        assert(json.containsKey(r'purchases'), 'Required key "CoinHistorySummaryInput[purchases]" is missing from JSON.');
        assert(json[r'purchases'] != null, 'Required key "CoinHistorySummaryInput[purchases]" has a null value in JSON.');
        assert(json.containsKey(r'bonuses'), 'Required key "CoinHistorySummaryInput[bonuses]" is missing from JSON.');
        assert(json[r'bonuses'] != null, 'Required key "CoinHistorySummaryInput[bonuses]" has a null value in JSON.');
        assert(json.containsKey(r'refunds'), 'Required key "CoinHistorySummaryInput[refunds]" is missing from JSON.');
        assert(json[r'refunds'] != null, 'Required key "CoinHistorySummaryInput[refunds]" has a null value in JSON.');
        return true;
      }());

      return CoinHistorySummaryInput(
        spent: mapValueOfType<int>(json, r'spent')!,
        added: mapValueOfType<int>(json, r'added')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        gifts: mapValueOfType<int>(json, r'gifts')!,
        lives: mapValueOfType<int>(json, r'lives')!,
        groups: mapValueOfType<int>(json, r'groups')!,
        bookings: mapValueOfType<int>(json, r'bookings')!,
        purchases: mapValueOfType<int>(json, r'purchases')!,
        bonuses: mapValueOfType<int>(json, r'bonuses')!,
        refunds: mapValueOfType<int>(json, r'refunds')!,
      );
    }
    return null;
  }

  static List<CoinHistorySummaryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoinHistorySummaryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoinHistorySummaryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoinHistorySummaryInput> mapFromJson(dynamic json) {
    final map = <String, CoinHistorySummaryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoinHistorySummaryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoinHistorySummaryInput-objects as value to a dart map
  static Map<String, List<CoinHistorySummaryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CoinHistorySummaryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoinHistorySummaryInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'spent',
    'added',
    'calls',
    'gifts',
    'lives',
    'groups',
    'bookings',
    'purchases',
    'bonuses',
    'refunds',
  };
}

