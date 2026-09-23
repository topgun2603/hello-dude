//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminPayoutCompanion {
  /// Returns a new [AdminPayoutCompanion] instance.
  AdminPayoutCompanion({
    required this.id,
    required this.displayName,
    required this.kycStatus,
  });

  String id;

  String displayName;

  String kycStatus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPayoutCompanion &&
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
  String toString() => 'AdminPayoutCompanion[id=$id, displayName=$displayName, kycStatus=$kycStatus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'kycStatus'] = this.kycStatus;
    return json;
  }

  /// Returns a new [AdminPayoutCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPayoutCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminPayoutCompanion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminPayoutCompanion[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminPayoutCompanion[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminPayoutCompanion[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'kycStatus'), 'Required key "AdminPayoutCompanion[kycStatus]" is missing from JSON.');
        assert(json[r'kycStatus'] != null, 'Required key "AdminPayoutCompanion[kycStatus]" has a null value in JSON.');
        return true;
      }());

      return AdminPayoutCompanion(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        kycStatus: mapValueOfType<String>(json, r'kycStatus')!,
      );
    }
    return null;
  }

  static List<AdminPayoutCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPayoutCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPayoutCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPayoutCompanion> mapFromJson(dynamic json) {
    final map = <String, AdminPayoutCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPayoutCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPayoutCompanion-objects as value to a dart map
  static Map<String, List<AdminPayoutCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPayoutCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPayoutCompanion.listFromJson(entry.value, growable: growable,);
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

