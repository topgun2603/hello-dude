//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminGift {
  /// Returns a new [AdminGift] instance.
  AdminGift({
    required this.id,
    required this.code,
    required this.name,
    required this.emoji,
    required this.coins,
    required this.isActive,
    required this.sortOrder,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String code;

  String name;

  String emoji;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  bool isActive;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminGift &&
    other.id == id &&
    other.code == code &&
    other.name == name &&
    other.emoji == emoji &&
    other.coins == coins &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (code.hashCode) +
    (name.hashCode) +
    (emoji.hashCode) +
    (coins.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'AdminGift[id=$id, code=$code, name=$name, emoji=$emoji, coins=$coins, isActive=$isActive, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
      json[r'isActive'] = this.isActive;
      json[r'sortOrder'] = this.sortOrder;
    return json;
  }

  /// Returns a new [AdminGift] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminGift? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminGift[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminGift[id]" has a null value in JSON.');
        assert(json.containsKey(r'code'), 'Required key "AdminGift[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminGift[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminGift[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminGift[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "AdminGift[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "AdminGift[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminGift[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminGift[coins]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminGift[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminGift[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'sortOrder'), 'Required key "AdminGift[sortOrder]" is missing from JSON.');
        assert(json[r'sortOrder'] != null, 'Required key "AdminGift[sortOrder]" has a null value in JSON.');
        return true;
      }());

      return AdminGift(
        id: mapValueOfType<int>(json, r'id')!,
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: mapValueOfType<int>(json, r'sortOrder')!,
      );
    }
    return null;
  }

  static List<AdminGift> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminGift>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminGift.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminGift> mapFromJson(dynamic json) {
    final map = <String, AdminGift>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminGift.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminGift-objects as value to a dart map
  static Map<String, List<AdminGift>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminGift>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminGift.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'code',
    'name',
    'emoji',
    'coins',
    'isActive',
    'sortOrder',
  };
}

