//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseByHourInner {
  /// Returns a new [AdminDashboard200ResponseByHourInner] instance.
  AdminDashboard200ResponseByHourInner({
    required this.hour,
    required this.calls,
    required this.coins,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int hour;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseByHourInner &&
    other.hour == hour &&
    other.calls == calls &&
    other.coins == coins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (hour.hashCode) +
    (calls.hashCode) +
    (coins.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseByHourInner[hour=$hour, calls=$calls, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'hour'] = this.hour;
      json[r'calls'] = this.calls;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseByHourInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseByHourInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'hour'), 'Required key "AdminDashboard200ResponseByHourInner[hour]" is missing from JSON.');
        assert(json[r'hour'] != null, 'Required key "AdminDashboard200ResponseByHourInner[hour]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminDashboard200ResponseByHourInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminDashboard200ResponseByHourInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminDashboard200ResponseByHourInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminDashboard200ResponseByHourInner[coins]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseByHourInner(
        hour: mapValueOfType<int>(json, r'hour')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseByHourInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseByHourInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseByHourInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseByHourInner> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseByHourInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseByHourInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseByHourInner-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseByHourInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseByHourInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseByHourInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'hour',
    'calls',
    'coins',
  };
}

