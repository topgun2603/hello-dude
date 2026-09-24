//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class VipPlan {
  /// Returns a new [VipPlan] instance.
  VipPlan({
    required this.id,
    required this.sku,
    required this.months,
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
  int months;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int pricePaise;

  String? label;

  bool isActive;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VipPlan &&
    other.id == id &&
    other.sku == sku &&
    other.months == months &&
    other.pricePaise == pricePaise &&
    other.label == label &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (sku.hashCode) +
    (months.hashCode) +
    (pricePaise.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'VipPlan[id=$id, sku=$sku, months=$months, pricePaise=$pricePaise, label=$label, isActive=$isActive, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'sku'] = this.sku;
      json[r'months'] = this.months;
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

  /// Returns a new [VipPlan] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VipPlan? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VipPlan[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VipPlan[id]" has a null value in JSON.');
        assert(json.containsKey(r'sku'), 'Required key "VipPlan[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "VipPlan[sku]" has a null value in JSON.');
        assert(json.containsKey(r'months'), 'Required key "VipPlan[months]" is missing from JSON.');
        assert(json[r'months'] != null, 'Required key "VipPlan[months]" has a null value in JSON.');
        assert(json.containsKey(r'pricePaise'), 'Required key "VipPlan[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "VipPlan[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'label'), 'Required key "VipPlan[label]" is missing from JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "VipPlan[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "VipPlan[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'sortOrder'), 'Required key "VipPlan[sortOrder]" is missing from JSON.');
        assert(json[r'sortOrder'] != null, 'Required key "VipPlan[sortOrder]" has a null value in JSON.');
        return true;
      }());

      return VipPlan(
        id: mapValueOfType<int>(json, r'id')!,
        sku: mapValueOfType<String>(json, r'sku')!,
        months: mapValueOfType<int>(json, r'months')!,
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        label: mapValueOfType<String>(json, r'label'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: mapValueOfType<int>(json, r'sortOrder')!,
      );
    }
    return null;
  }

  static List<VipPlan> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VipPlan>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VipPlan.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VipPlan> mapFromJson(dynamic json) {
    final map = <String, VipPlan>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VipPlan.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VipPlan-objects as value to a dart map
  static Map<String, List<VipPlan>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VipPlan>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VipPlan.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'sku',
    'months',
    'pricePaise',
    'label',
    'isActive',
    'sortOrder',
  };
}

