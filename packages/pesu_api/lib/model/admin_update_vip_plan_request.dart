//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUpdateVipPlanRequest {
  /// Returns a new [AdminUpdateVipPlanRequest] instance.
  AdminUpdateVipPlanRequest({
    required this.pricePaise,
    this.label,
    required this.isActive,
  });

  /// Minimum value: 100
  /// Maximum value: 10000000
  int pricePaise;

  String? label;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUpdateVipPlanRequest &&
    other.pricePaise == pricePaise &&
    other.label == label &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (pricePaise.hashCode) +
    (label == null ? 0 : label!.hashCode) +
    (isActive.hashCode);

  @override
  String toString() => 'AdminUpdateVipPlanRequest[pricePaise=$pricePaise, label=$label, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'pricePaise'] = this.pricePaise;
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [AdminUpdateVipPlanRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUpdateVipPlanRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'pricePaise'), 'Required key "AdminUpdateVipPlanRequest[pricePaise]" is missing from JSON.');
        assert(json[r'pricePaise'] != null, 'Required key "AdminUpdateVipPlanRequest[pricePaise]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminUpdateVipPlanRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminUpdateVipPlanRequest[isActive]" has a null value in JSON.');
        return true;
      }());

      return AdminUpdateVipPlanRequest(
        pricePaise: mapValueOfType<int>(json, r'pricePaise')!,
        label: mapValueOfType<String>(json, r'label'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
      );
    }
    return null;
  }

  static List<AdminUpdateVipPlanRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUpdateVipPlanRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUpdateVipPlanRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUpdateVipPlanRequest> mapFromJson(dynamic json) {
    final map = <String, AdminUpdateVipPlanRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUpdateVipPlanRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUpdateVipPlanRequest-objects as value to a dart map
  static Map<String, List<AdminUpdateVipPlanRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUpdateVipPlanRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUpdateVipPlanRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'pricePaise',
    'isActive',
  };
}

