//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponsePendingPayouts {
  /// Returns a new [AdminDashboard200ResponsePendingPayouts] instance.
  AdminDashboard200ResponsePendingPayouts({
    required this.count,
    required this.paise,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int count;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponsePendingPayouts &&
    other.count == count &&
    other.paise == paise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (count.hashCode) +
    (paise.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponsePendingPayouts[count=$count, paise=$paise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'count'] = this.count;
      json[r'paise'] = this.paise;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponsePendingPayouts] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponsePendingPayouts? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'count'), 'Required key "AdminDashboard200ResponsePendingPayouts[count]" is missing from JSON.');
        assert(json[r'count'] != null, 'Required key "AdminDashboard200ResponsePendingPayouts[count]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "AdminDashboard200ResponsePendingPayouts[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "AdminDashboard200ResponsePendingPayouts[paise]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponsePendingPayouts(
        count: mapValueOfType<int>(json, r'count')!,
        paise: mapValueOfType<int>(json, r'paise')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponsePendingPayouts> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponsePendingPayouts>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponsePendingPayouts.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponsePendingPayouts> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponsePendingPayouts>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponsePendingPayouts.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponsePendingPayouts-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponsePendingPayouts>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponsePendingPayouts>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponsePendingPayouts.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'paise',
  };
}

