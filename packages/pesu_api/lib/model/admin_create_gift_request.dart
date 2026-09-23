//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreateGiftRequest {
  /// Returns a new [AdminCreateGiftRequest] instance.
  AdminCreateGiftRequest({
    required this.name,
    required this.emoji,
    required this.coins,
    this.isActive = true,
  });

  String name;

  String emoji;

  /// Minimum value: 1
  /// Maximum value: 100000
  int coins;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreateGiftRequest &&
    other.name == name &&
    other.emoji == emoji &&
    other.coins == coins &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (emoji.hashCode) +
    (coins.hashCode) +
    (isActive.hashCode);

  @override
  String toString() => 'AdminCreateGiftRequest[name=$name, emoji=$emoji, coins=$coins, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'emoji'] = this.emoji;
      json[r'coins'] = this.coins;
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [AdminCreateGiftRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreateGiftRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminCreateGiftRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminCreateGiftRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "AdminCreateGiftRequest[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "AdminCreateGiftRequest[emoji]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminCreateGiftRequest[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminCreateGiftRequest[coins]" has a null value in JSON.');
        return true;
      }());

      return AdminCreateGiftRequest(
        name: mapValueOfType<String>(json, r'name')!,
        emoji: mapValueOfType<String>(json, r'emoji')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        isActive: mapValueOfType<bool>(json, r'isActive') ?? true,
      );
    }
    return null;
  }

  static List<AdminCreateGiftRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateGiftRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateGiftRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreateGiftRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreateGiftRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreateGiftRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreateGiftRequest-objects as value to a dart map
  static Map<String, List<AdminCreateGiftRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreateGiftRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreateGiftRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'emoji',
    'coins',
  };
}

