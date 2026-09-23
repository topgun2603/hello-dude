//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminPayoutInputCompanion {
  /// Returns a new [AdminPayoutInputCompanion] instance.
  AdminPayoutInputCompanion({
    required this.id,
    required this.displayName,
    required this.kycStatus,
  });

  String id;

  String displayName;

  String kycStatus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPayoutInputCompanion &&
    other.id == id &&
    other.displayName == displayName &&
    other.kycStatus == kycStatus;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (kycStatus.hashCode);

  @override
  String toString() => 'AdminPayoutInputCompanion[id=$id, displayName=$displayName, kycStatus=$kycStatus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'kycStatus'] = this.kycStatus;
    return json;
  }

  /// Returns a new [AdminPayoutInputCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPayoutInputCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminPayoutInputCompanion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminPayoutInputCompanion[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminPayoutInputCompanion[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminPayoutInputCompanion[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'kycStatus'), 'Required key "AdminPayoutInputCompanion[kycStatus]" is missing from JSON.');
        assert(json[r'kycStatus'] != null, 'Required key "AdminPayoutInputCompanion[kycStatus]" has a null value in JSON.');
        return true;
      }());

      return AdminPayoutInputCompanion(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        kycStatus: mapValueOfType<String>(json, r'kycStatus')!,
      );
    }
    return null;
  }

  static List<AdminPayoutInputCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPayoutInputCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPayoutInputCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPayoutInputCompanion> mapFromJson(dynamic json) {
    final map = <String, AdminPayoutInputCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPayoutInputCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPayoutInputCompanion-objects as value to a dart map
  static Map<String, List<AdminPayoutInputCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPayoutInputCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPayoutInputCompanion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'kycStatus',
  };
}

