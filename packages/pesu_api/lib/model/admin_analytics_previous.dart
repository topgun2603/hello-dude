//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsPrevious {
  /// Returns a new [AdminAnalyticsPrevious] instance.
  AdminAnalyticsPrevious({
    required this.from,
    required this.to,
  });

  String from;

  String to;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsPrevious &&
    other.from == from &&
    other.to == to;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (from.hashCode) +
    (to.hashCode);

  @override
  String toString() => 'AdminAnalyticsPrevious[from=$from, to=$to]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'from'] = this.from;
      json[r'to'] = this.to;
    return json;
  }

  /// Returns a new [AdminAnalyticsPrevious] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsPrevious? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'from'), 'Required key "AdminAnalyticsPrevious[from]" is missing from JSON.');
        assert(json[r'from'] != null, 'Required key "AdminAnalyticsPrevious[from]" has a null value in JSON.');
        assert(json.containsKey(r'to'), 'Required key "AdminAnalyticsPrevious[to]" is missing from JSON.');
        assert(json[r'to'] != null, 'Required key "AdminAnalyticsPrevious[to]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsPrevious(
        from: mapValueOfType<String>(json, r'from')!,
        to: mapValueOfType<String>(json, r'to')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsPrevious> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsPrevious>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsPrevious.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsPrevious> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsPrevious>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsPrevious.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsPrevious-objects as value to a dart map
  static Map<String, List<AdminAnalyticsPrevious>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsPrevious>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsPrevious.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'from',
    'to',
  };
}

