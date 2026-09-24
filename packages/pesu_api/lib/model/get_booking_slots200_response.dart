//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetBookingSlots200Response {
  /// Returns a new [GetBookingSlots200Response] instance.
  GetBookingSlots200Response({
    this.durations = const [],
    this.days = const [],
  });

  List<int> durations;

  List<GetBookingSlots200ResponseDaysInner> days;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetBookingSlots200Response &&
    _deepEquality.equals(other.durations, durations) &&
    _deepEquality.equals(other.days, days);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (durations.hashCode) +
    (days.hashCode);

  @override
  String toString() => 'GetBookingSlots200Response[durations=$durations, days=$days]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'durations'] = this.durations;
      json[r'days'] = this.days;
    return json;
  }

  /// Returns a new [GetBookingSlots200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetBookingSlots200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'durations'), 'Required key "GetBookingSlots200Response[durations]" is missing from JSON.');
        assert(json[r'durations'] != null, 'Required key "GetBookingSlots200Response[durations]" has a null value in JSON.');
        assert(json.containsKey(r'days'), 'Required key "GetBookingSlots200Response[days]" is missing from JSON.');
        assert(json[r'days'] != null, 'Required key "GetBookingSlots200Response[days]" has a null value in JSON.');
        return true;
      }());

      return GetBookingSlots200Response(
        durations: json[r'durations'] is Iterable
            ? (json[r'durations'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        days: GetBookingSlots200ResponseDaysInner.listFromJson(json[r'days']),
      );
    }
    return null;
  }

  static List<GetBookingSlots200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetBookingSlots200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetBookingSlots200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetBookingSlots200Response> mapFromJson(dynamic json) {
    final map = <String, GetBookingSlots200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetBookingSlots200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetBookingSlots200Response-objects as value to a dart map
  static Map<String, List<GetBookingSlots200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetBookingSlots200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetBookingSlots200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'durations',
    'days',
  };
}

