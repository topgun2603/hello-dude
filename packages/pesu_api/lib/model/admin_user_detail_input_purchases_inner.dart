//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputPurchasesInner {
  /// Returns a new [AdminUserDetailInputPurchasesInner] instance.
  AdminUserDetailInputPurchasesInner({
    required this.id,
    required this.createdAt,
    required this.sku,
    required this.label,
    required this.pricePaise,
    required this.coins,
    required this.status,
  });

  String id;

  Object? createdAt;

  String sku;

  String? label;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int pricePaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  String status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputPurchasesInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.sku == sku &&
    other.label == label &&
    other.pricePaise == pricePaise &&
    other.coins == coins &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (sku.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (pricePaise.hashCode) +
    (coins.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'AdminUserDetailInputPurchasesInner[id=$id, createdAt=$createdAt, sku=$sku, label=$label, pricePaise=$pricePaise, coins=$coins, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'sku'] = this.sku;
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
      json[r'pricePaise'] = this.pricePaise;
      json[r'coins'] = this.coins;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [AdminUserDetailInputPurchasesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputPurchasesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputPurchasesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputPurchasesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputPurchasesInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'sku'), 'Required key "AdminUserDetailInputPurchasesInner[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "AdminUserDetailInputPurchasesInner[sku]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "AdminUserDetailInputPurchasesInner[label]" is missing from JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "AdminUserDetailInputPurchasesInner[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "AdminUserDetailInputPurchasesInner[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetailInputPurchasesInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetailInputPurchasesInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInputPurchasesInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInputPurchasesInner[status]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputPurchasesInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        sku: mapValueOfType<String>(json, r'sku')!,
        label: mapValueOfType<String>(json, r'label'),
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailInputPurchasesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputPurchasesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputPurchasesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputPurchasesInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputPurchasesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputPurchasesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputPurchasesInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputPurchasesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputPurchasesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputPurchasesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'sku',
    'label',
    'pricePaise',
    'coins',
    'status',
  };
}

