//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminListPayouts200ResponseTotals {
  /// Returns a new [AdminListPayouts200ResponseTotals] instance.
  AdminListPayouts200ResponseTotals({
    required this.requestedPaise,
    required this.requestedCount,
    required this.flaggedCount,
    required this.paidThisWeekPaise,
    required this.tdsThisMonthPaise,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int requestedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int requestedCount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int flaggedCount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paidThisWeekPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsThisMonthPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminListPayouts200ResponseTotals &&
    other.requestedPaise == requestedPaise &&
    other.requestedCount == requestedCount &&
    other.flaggedCount == flaggedCount &&
    other.paidThisWeekPaise == paidThisWeekPaise &&
    other.tdsThisMonthPaise == tdsThisMonthPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (requestedPaise.hashCode) +
    (requestedCount.hashCode) +
    (flaggedCount.hashCode) +
    (paidThisWeekPaise.hashCode) +
    (tdsThisMonthPaise.hashCode);

  @override
  String toString() => 'AdminListPayouts200ResponseTotals[requestedPaise=$requestedPaise, requestedCount=$requestedCount, flaggedCount=$flaggedCount, paidThisWeekPaise=$paidThisWeekPaise, tdsThisMonthPaise=$tdsThisMonthPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'requestedPaise'] = this.requestedPaise;
      json[r'requestedCount'] = this.requestedCount;
      json[r'flaggedCount'] = this.flaggedCount;
      json[r'paidThisWeekPaise'] = this.paidThisWeekPaise;
      json[r'tdsThisMonthPaise'] = this.tdsThisMonthPaise;
    return json;
  }

  /// Returns a new [AdminListPayouts200ResponseTotals] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminListPayouts200ResponseTotals? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'requestedPaise'), 'Required key "AdminListPayouts200ResponseTotals[requestedPaise]" is missing from JSON.');
        assert(json[r'requestedPaise'] != null, 'Required key "AdminListPayouts200ResponseTotals[requestedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'requestedCount'), 'Required key "AdminListPayouts200ResponseTotals[requestedCount]" is missing from JSON.');
        assert(json[r'requestedCount'] != null, 'Required key "AdminListPayouts200ResponseTotals[requestedCount]" has a null value in JSON.');
        assert(json.containsKey(r'flaggedCount'), 'Required key "AdminListPayouts200ResponseTotals[flaggedCount]" is missing from JSON.');
        assert(json[r'flaggedCount'] != null, 'Required key "AdminListPayouts200ResponseTotals[flaggedCount]" has a null value in JSON.');
        assert(json.containsKey(r'paidThisWeekPaise'), 'Required key "AdminListPayouts200ResponseTotals[paidThisWeekPaise]" is missing from JSON.');
        assert(json[r'paidThisWeekPaise'] != null, 'Required key "AdminListPayouts200ResponseTotals[paidThisWeekPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsThisMonthPaise'), 'Required key "AdminListPayouts200ResponseTotals[tdsThisMonthPaise]" is missing from JSON.');
        assert(json[r'tdsThisMonthPaise'] != null, 'Required key "AdminListPayouts200ResponseTotals[tdsThisMonthPaise]" has a null value in JSON.');
        return true;
      }());

      return AdminListPayouts200ResponseTotals(
        requestedPaise: mapValueOfType<int>(json, r'requestedPaise')!,
        requestedCount: mapValueOfType<int>(json, r'requestedCount')!,
        flaggedCount: mapValueOfType<int>(json, r'flaggedCount')!,
        paidThisWeekPaise: mapValueOfType<int>(json, r'paidThisWeekPaise')!,
        tdsThisMonthPaise: mapValueOfType<int>(json, r'tdsThisMonthPaise')!,
      );
    }
    return null;
  }

  static List<AdminListPayouts200ResponseTotals> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminListPayouts200ResponseTotals>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminListPayouts200ResponseTotals.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminListPayouts200ResponseTotals> mapFromJson(dynamic json) {
    final map = <String, AdminListPayouts200ResponseTotals>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminListPayouts200ResponseTotals.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminListPayouts200ResponseTotals-objects as value to a dart map
  static Map<String, List<AdminListPayouts200ResponseTotals>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminListPayouts200ResponseTotals>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminListPayouts200ResponseTotals.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'requestedPaise',
    'requestedCount',
    'flaggedCount',
    'paidThisWeekPaise',
    'tdsThisMonthPaise',
  };
}

