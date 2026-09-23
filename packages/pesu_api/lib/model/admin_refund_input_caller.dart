//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRefundInputCaller {
  /// Returns a new [AdminRefundInputCaller] instance.
  AdminRefundInputCaller({
    required this.id,
    required this.displayName,
    required this.refundsBefore,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int refundsBefore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRefundInputCaller &&
    other.id == id &&
    other.displayName == displayName &&
    other.refundsBefore == refundsBefore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (refundsBefore.hashCode);

  @override
  String toString() => 'AdminRefundInputCaller[id=$id, displayName=$displayName, refundsBefore=$refundsBefore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'refundsBefore'] = this.refundsBefore;
    return json;
  }

  /// Returns a new [AdminRefundInputCaller] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRefundInputCaller? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminRefundInputCaller[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminRefundInputCaller[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminRefundInputCaller[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminRefundInputCaller[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'refundsBefore'), 'Required key "AdminRefundInputCaller[refundsBefore]" is missing from JSON.');
        assert(json[r'refundsBefore'] != null, 'Required key "AdminRefundInputCaller[refundsBefore]" has a null value in JSON.');
        return true;
      }());

      return AdminRefundInputCaller(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        refundsBefore: mapValueOfType<int>(json, r'refundsBefore')!,
      );
    }
    return null;
  }

  static List<AdminRefundInputCaller> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundInputCaller>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundInputCaller.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRefundInputCaller> mapFromJson(dynamic json) {
    final map = <String, AdminRefundInputCaller>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRefundInputCaller.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRefundInputCaller-objects as value to a dart map
  static Map<String, List<AdminRefundInputCaller>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRefundInputCaller>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRefundInputCaller.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'refundsBefore',
  };
}

