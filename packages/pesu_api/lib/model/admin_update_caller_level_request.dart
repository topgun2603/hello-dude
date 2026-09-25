//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateCallerLevelRequest {
  /// Returns a new [AdminUpdateCallerLevelRequest] instance.
  AdminUpdateCallerLevelRequest({
    required this.name,
    required this.minCoins,
    this.perk,
  });

  String name;

  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int minCoins;

  String? perk;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateCallerLevelRequest &&
    other.name == name &&
    other.minCoins == minCoins &&
    other.perk == perk;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (minCoins.hashCode) +
    (perk == null ? 0 : perk!.hashCode);

  @override
  String toString() => 'AdminUpdateCallerLevelRequest[name=$name, minCoins=$minCoins, perk=$perk]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'minCoins'] = this.minCoins;
    if (this.perk != null) {
      json[r'perk'] = this.perk;
    } else {
      json[r'perk'] = null;
    }
    return json;
  }

  /// Returns a new [AdminUpdateCallerLevelRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateCallerLevelRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminUpdateCallerLevelRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminUpdateCallerLevelRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'minCoins'), 'Required key "AdminUpdateCallerLevelRequest[minCoins]" is missing from JSON.');
        assert(json[r'minCoins'] != null, 'Required key "AdminUpdateCallerLevelRequest[minCoins]" has a null value in JSON.');
        return true;
      }());

      return AdminUpdateCallerLevelRequest(
        name: mapValueOfType<String>(json, r'name')!,
        minCoins: mapValueOfType<int>(json, r'minCoins')!,
        perk: mapValueOfType<String>(json, r'perk'),
      );
    }
    return null;
  }

  static List<AdminUpdateCallerLevelRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateCallerLevelRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateCallerLevelRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateCallerLevelRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateCallerLevelRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateCallerLevelRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateCallerLevelRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateCallerLevelRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateCallerLevelRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateCallerLevelRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'minCoins',
  };
}

