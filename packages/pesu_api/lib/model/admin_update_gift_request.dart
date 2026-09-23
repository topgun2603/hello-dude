//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateGiftRequest {
  /// Returns a new [AdminUpdateGiftRequest] instance.
  AdminUpdateGiftRequest({
    required this.name,
    required this.emoji,
    required this.coins,
    required this.isActive,
    required this.sortOrder,
  });

  String name;

  String emoji;

  /// Minimum value: 1
  /// Maximum value: 100000
  int coins;

  bool isActive;

  /// Minimum value: 0
  /// Maximum value: 1000
  int sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateGiftRequest &&
    other.name == name &&
    other.emoji == emoji &&
    other.coins == coins &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (emoji.hashCode) +
    (coins.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'AdminUpdateGiftRequest[name=$name, emoji=$emoji, coins=$coins, isActive=$isActive, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
      json[r'isActive'] = this.isActive;
      json[r'sortOrder'] = this.sortOrder;
    return json;
  }

  /// Returns a new [AdminUpdateGiftRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateGiftRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminUpdateGiftRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminUpdateGiftRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "AdminUpdateGiftRequest[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "AdminUpdateGiftRequest[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUpdateGiftRequest[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUpdateGiftRequest[coins]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminUpdateGiftRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminUpdateGiftRequest[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'sortOrder'), 'Required key "AdminUpdateGiftRequest[sortOrder]" is missing from JSON.');
        assert(json[r'sortOrder'] != null, 'Required key "AdminUpdateGiftRequest[sortOrder]" has a null value in JSON.');
        return true;
      }());

      return AdminUpdateGiftRequest(
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: mapValueOfType<int>(json, r'sortOrder')!,
      );
    }
    return null;
  }

  static List<AdminUpdateGiftRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateGiftRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateGiftRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateGiftRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateGiftRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateGiftRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateGiftRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateGiftRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateGiftRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateGiftRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'emoji',
    'coins',
    'isActive',
    'sortOrder',
  };
}

