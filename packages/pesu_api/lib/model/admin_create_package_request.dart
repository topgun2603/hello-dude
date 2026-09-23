//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreatePackageRequest {
  /// Returns a new [AdminCreatePackageRequest] instance.
  AdminCreatePackageRequest({
    required this.coins,
    required this.bonusCoins,
    required this.pricePaise,
    this.label,
    required this.isActive,
    required this.sortOrder,
    required this.sku,
  });

  /// Minimum value: 1
  /// Maximum value: 1000000
  int coins;

  /// Minimum value: 0
  /// Maximum value: 1000000
  int bonusCoins;

  /// Minimum value: 100
  /// Maximum value: 10000000
  int pricePaise;

  String? label;

  bool isActive;

  /// Minimum value: 0
  /// Maximum value: 1000
  int sortOrder;

  String sku;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreatePackageRequest &&
    other.coins == coins &&
    other.bonusCoins == bonusCoins &&
    other.pricePaise == pricePaise &&
    other.label == label &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder &&
    other.sku == sku;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coins.hashCode) +
    (bonusCoins.hashCode) +
    (pricePaise.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode) +
    (sku.hashCode);

  @override
  String toString() => 'AdminCreatePackageRequest[coins=$coins, bonusCoins=$bonusCoins, pricePaise=$pricePaise, label=$label, isActive=$isActive, sortOrder=$sortOrder, sku=$sku]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'sku'] = this.sku;
    return json;
  }

  /// Returns a new [AdminCreatePackageRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreatePackageRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'coins'), 'Required key "AdminCreatePackageRequest[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminCreatePackageRequest[coins]" has a null value in JSON.');
        assert(json.containsKey(r'bonusCoins'), 'Required key "AdminCreatePackageRequest[bonusCoins]" is missing from JSON.');
        assert(json[r'bonusCoins'] != null, 'Required key "AdminCreatePackageRequest[bonusCoins]" has a null value in JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "AdminCreatePackageRequest[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "AdminCreatePackageRequest[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminCreatePackageRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminCreatePackageRequest[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'sortOrder'), 'Required key "AdminCreatePackageRequest[sortOrder]" is missing from JSON.');
        assert(json[r'sortOrder'] != null, 'Required key "AdminCreatePackageRequest[sortOrder]" has a null value in JSON.');
        assert(json.containsKey(r'sku'), 'Required key "AdminCreatePackageRequest[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "AdminCreatePackageRequest[sku]" has a null value in JSON.');
        return true;
      }());

      return AdminCreatePackageRequest(
        coins: mapValueOfType<int>(json, r'coins')!,
        bonusCoins: mapValueOfType<int>(json, r'bonusCoins')!,
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        label: mapValueOfType<String>(json, r'label'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: mapValueOfType<int>(json, r'sortOrder')!,
        sku: mapValueOfType<String>(json, r'sku')!,
      );
    }
    return null;
  }

  static List<AdminCreatePackageRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePackageRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePackageRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreatePackageRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreatePackageRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreatePackageRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreatePackageRequest-objects as value to a dart map
  static Map<String, List<AdminCreatePackageRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreatePackageRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreatePackageRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coins',
    'bonusCoins',
    'pricePaise',
    'isActive',
    'sortOrder',
    'sku',
  };
}

