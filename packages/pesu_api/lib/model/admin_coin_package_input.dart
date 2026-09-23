//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCoinPackageInput {
  /// Returns a new [AdminCoinPackageInput] instance.
  AdminCoinPackageInput({
    required this.id,
    required this.sku,
    required this.coins,
    required this.bonusCoins,
    required this.pricePaise,
    required this.label,
    required this.isActive,
    required this.sortOrder,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

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

  bool isActive;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCoinPackageInput &&
    other.id == id &&
    other.sku == sku &&
    other.coins == coins &&
    other.bonusCoins == bonusCoins &&
    other.pricePaise == pricePaise &&
    other.label == label &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (sku.hashCode) +
    (coins.hashCode) +
    (bonusCoins.hashCode) +
    (pricePaise.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'AdminCoinPackageInput[id=$id, sku=$sku, coins=$coins, bonusCoins=$bonusCoins, pricePaise=$pricePaise, label=$label, isActive=$isActive, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'sku'] = this.sku;
      json[r'coins'] = this.coins;
      json[r'bonusCoins'] = this.bonusCoins;
      json[r'pricePaise'] = this.pricePaise;
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
      json[r'isActive'] = this.isActive;
      json[r'sortOrder'] = this.sortOrder;
    return json;
  }

  /// Returns a new [AdminCoinPackageInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCoinPackageInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminCoinPackageInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminCoinPackageInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'sku'), 'Required key "AdminCoinPackageInput[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "AdminCoinPackageInput[sku]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminCoinPackageInput[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminCoinPackageInput[coins]" has a null value in JSON.');
        assert(json.containsKey(r'bonusCoins'), 'Required key "AdminCoinPackageInput[bonusCoins]" is missing from JSON.');
        assert(json[r'bonusCoins'] != null, 'Required key "AdminCoinPackageInput[bonusCoins]" has a null value in JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "AdminCoinPackageInput[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "AdminCoinPackageInput[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "AdminCoinPackageInput[label]" is missing from JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminCoinPackageInput[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminCoinPackageInput[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'sortOrder'), 'Required key "AdminCoinPackageInput[sortOrder]" is missing from JSON.');
        assert(json[r'sortOrder'] != null, 'Required key "AdminCoinPackageInput[sortOrder]" has a null value in JSON.');
        return true;
      }());

      return AdminCoinPackageInput(
        id: mapValueOfType<int>(json, r'id')!,
        sku: mapValueOfType<String>(json, r'sku')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        bonusCoins: mapValueOfType<int>(json, r'bonusCoins')!,
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        label: mapValueOfType<String>(json, r'label'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: mapValueOfType<int>(json, r'sortOrder')!,
      );
    }
    return null;
  }

  static List<AdminCoinPackageInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCoinPackageInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCoinPackageInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCoinPackageInput> mapFromJson(dynamic json) {
    final map = <String, AdminCoinPackageInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCoinPackageInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCoinPackageInput-objects as value to a dart map
  static Map<String, List<AdminCoinPackageInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCoinPackageInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCoinPackageInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'sku',
    'coins',
    'bonusCoins',
    'pricePaise',
    'label',
    'isActive',
    'sortOrder',
  };
}

