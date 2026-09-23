//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminListPayouts200Response {
  /// Returns a new [AdminListPayouts200Response] instance.
  AdminListPayouts200Response({
    this.payouts = const [],
    required this.totals,
  });

  List<AdminPayout> payouts;

  AdminListPayouts200ResponseTotals totals;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminListPayouts200Response &&
    _deepEquality.equals(other.payouts, payouts) &&
    other.totals == totals;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (payouts.hashCode) +
    (totals.hashCode);

  @override
  String toString() => 'AdminListPayouts200Response[payouts=$payouts, totals=$totals]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'payouts'] = this.payouts;
      json[r'totals'] = this.totals;
    return json;
  }

  /// Returns a new [AdminListPayouts200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminListPayouts200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'payouts'), 'Required key "AdminListPayouts200Response[payouts]" is missing from JSON.');
        assert(json[r'payouts'] != null, 'Required key "AdminListPayouts200Response[payouts]" has a null value in JSON.');
        assert(json.containsKey(r'totals'), 'Required key "AdminListPayouts200Response[totals]" is missing from JSON.');
        assert(json[r'totals'] != null, 'Required key "AdminListPayouts200Response[totals]" has a null value in JSON.');
        return true;
      }());

      return AdminListPayouts200Response(
        payouts: AdminPayout.listFromJson(json[r'payouts']),
        totals: AdminListPayouts200ResponseTotals.fromJson(json[r'totals'])!,
      );
    }
    return null;
  }

  static List<AdminListPayouts200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminListPayouts200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminListPayouts200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminListPayouts200Response> mapFromJson(dynamic json) {
    final map = <String, AdminListPayouts200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminListPayouts200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminListPayouts200Response-objects as value to a dart map
  static Map<String, List<AdminListPayouts200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminListPayouts200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminListPayouts200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'payouts',
    'totals',
  };
}

