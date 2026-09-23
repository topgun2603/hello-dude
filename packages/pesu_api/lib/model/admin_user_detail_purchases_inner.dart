//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailPurchasesInner {
  /// Returns a new [AdminUserDetailPurchasesInner] instance.
  AdminUserDetailPurchasesInner({
    required this.id,
    required this.createdAt,
    required this.sku,
    required this.label,
    required this.pricePaise,
    required this.coins,
    required this.status,
  });

  String id;

  DateTime createdAt;

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
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailPurchasesInner &&
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
    (createdAt.hashCode) +
    (sku.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (pricePaise.hashCode) +
    (coins.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'AdminUserDetailPurchasesInner[id=$id, createdAt=$createdAt, sku=$sku, label=$label, pricePaise=$pricePaise, coins=$coins, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
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

  /// Returns a new [AdminUserDetailPurchasesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailPurchasesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailPurchasesInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailPurchasesInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailPurchasesInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailPurchasesInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'sku'), 'Required key "AdminUserDetailPurchasesInner[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "AdminUserDetailPurchasesInner[sku]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "AdminUserDetailPurchasesInner[label]" is missing from JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "AdminUserDetailPurchasesInner[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "AdminUserDetailPurchasesInner[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetailPurchasesInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetailPurchasesInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailPurchasesInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailPurchasesInner[status]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailPurchasesInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        sku: mapValueOfType<String>(json, r'sku')!,
        label: mapValueOfType<String>(json, r'label'),
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailPurchasesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailPurchasesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailPurchasesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailPurchasesInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailPurchasesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailPurchasesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailPurchasesInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailPurchasesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailPurchasesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailPurchasesInner.listFromJson(entry.value, growable: growable,);
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

