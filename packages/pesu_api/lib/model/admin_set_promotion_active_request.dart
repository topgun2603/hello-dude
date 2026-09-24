//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminSetPromotionActiveRequest {
  /// Returns a new [AdminSetPromotionActiveRequest] instance.
  AdminSetPromotionActiveRequest({
    required this.isActive,
  });

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminSetPromotionActiveRequest &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (isActive.hashCode);

  @override
  String toString() => 'AdminSetPromotionActiveRequest[isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [AdminSetPromotionActiveRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminSetPromotionActiveRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'isActive'), 'Required key "AdminSetPromotionActiveRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminSetPromotionActiveRequest[isActive]" has a null value in JSON.');
        return true;
      }());

      return AdminSetPromotionActiveRequest(
        isActive: mapValueOfType<bool>(json, r'isActive')!,
      );
    }
    return null;
  }

  static List<AdminSetPromotionActiveRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminSetPromotionActiveRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminSetPromotionActiveRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminSetPromotionActiveRequest> mapFromJson(dynamic json) {
    final map = <String, AdminSetPromotionActiveRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminSetPromotionActiveRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminSetPromotionActiveRequest-objects as value to a dart map
  static Map<String, List<AdminSetPromotionActiveRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminSetPromotionActiveRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminSetPromotionActiveRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'isActive',
  };
}

