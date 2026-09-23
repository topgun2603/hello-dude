//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListCoinPackages200ResponseInner {
  /// Returns a new [ListCoinPackages200ResponseInner] instance.
  ListCoinPackages200ResponseInner({
    required this.sku,
    required this.coins,
    required this.bonusCoins,
    required this.pricePaise,
    required this.label,
    required this.firstRecharge,
    required this.offerEndsAt,
  });

  String sku;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int bonusCoins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int pricePaise;

  String? label;

  bool firstRecharge;

  DateTime? offerEndsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListCoinPackages200ResponseInner &&
    other.sku == sku &&
    other.coins == coins &&
    other.bonusCoins == bonusCoins &&
    other.pricePaise == pricePaise &&
    other.label == label &&
    other.firstRecharge == firstRecharge &&
    other.offerEndsAt == offerEndsAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sku.hashCode) +
    (coins.hashCode) +
    (bonusCoins.hashCode) +
    (pricePaise.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (firstRecharge.hashCode) +
    (offerEndsAt == null ? 0 : offerEndsAt!.hashCode);

  @override
  String toString() => 'ListCoinPackages200ResponseInner[sku=$sku, coins=$coins, bonusCoins=$bonusCoins, pricePaise=$pricePaise, label=$label, firstRecharge=$firstRecharge, offerEndsAt=$offerEndsAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'sku'] = this.sku;
      json[r'coins'] = this.coins;
      json[r'bonusCoins'] = this.bonusCoins;
      json[r'pricePaise'] = this.pricePaise;
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
      json[r'firstRecharge'] = this.firstRecharge;
    if (this.offerEndsAt != null) {
      json[r'offerEndsAt'] = this.offerEndsAt!.toUtc().toIso8601String();
    } else {
      json[r'offerEndsAt'] = null;
    }
    return json;
  }

  /// Returns a new [ListCoinPackages200ResponseInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListCoinPackages200ResponseInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sku'), 'Required key "ListCoinPackages200ResponseInner[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "ListCoinPackages200ResponseInner[sku]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "ListCoinPackages200ResponseInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "ListCoinPackages200ResponseInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'bonusCoins'), 'Required key "ListCoinPackages200ResponseInner[bonusCoins]" is missing from JSON.');
        assert(json[r'bonusCoins'] != null, 'Required key "ListCoinPackages200ResponseInner[bonusCoins]" has a null value in JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "ListCoinPackages200ResponseInner[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "ListCoinPackages200ResponseInner[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "ListCoinPackages200ResponseInner[label]" is missing from JSON.');
        assert(json.containsKey(r'firstRecharge'), 'Required key "ListCoinPackages200ResponseInner[firstRecharge]" is missing from JSON.');
        assert(json[r'firstRecharge'] != null, 'Required key "ListCoinPackages200ResponseInner[firstRecharge]" has a null value in JSON.');
        assert(json.containsKey(r'offerEndsAt'), 'Required key "ListCoinPackages200ResponseInner[offerEndsAt]" is missing from JSON.');
        return true;
      }());

      return ListCoinPackages200ResponseInner(
        sku: mapValueOfType<String>(json, r'sku')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        bonusCoins: mapValueOfType<int>(json, r'bonusCoins')!,
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        label: mapValueOfType<String>(json, r'label'),
        firstRecharge: mapValueOfType<bool>(json, r'firstRecharge')!,
        offerEndsAt: mapDateTime(json, r'offerEndsAt', r''),
      );
    }
    return null;
  }

  static List<ListCoinPackages200ResponseInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListCoinPackages200ResponseInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListCoinPackages200ResponseInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListCoinPackages200ResponseInner> mapFromJson(dynamic json) {
    final map = <String, ListCoinPackages200ResponseInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListCoinPackages200ResponseInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListCoinPackages200ResponseInner-objects as value to a dart map
  static Map<String, List<ListCoinPackages200ResponseInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListCoinPackages200ResponseInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListCoinPackages200ResponseInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sku',
    'coins',
    'bonusCoins',
    'pricePaise',
    'label',
    'firstRecharge',
    'offerEndsAt',
  };
}

