//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListBookings200Response {
  /// Returns a new [ListBookings200Response] instance.
  ListBookings200Response({
    this.upcoming = const [],
    this.past = const [],
  });

  List<Booking> upcoming;

  List<Booking> past;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListBookings200Response &&
    _deepEquality.equals(other.upcoming, upcoming) &&
    _deepEquality.equals(other.past, past);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (upcoming.hashCode) +
    (past.hashCode);

  @override
  String toString() => 'ListBookings200Response[upcoming=$upcoming, past=$past]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'upcoming'] = this.upcoming;
      json[r'past'] = this.past;
    return json;
  }

  /// Returns a new [ListBookings200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListBookings200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'upcoming'), 'Required key "ListBookings200Response[upcoming]" is missing from JSON.');
        assert(json[r'upcoming'] != null, 'Required key "ListBookings200Response[upcoming]" has a null value in JSON.');
        assert(json.containsKey(r'past'), 'Required key "ListBookings200Response[past]" is missing from JSON.');
        assert(json[r'past'] != null, 'Required key "ListBookings200Response[past]" has a null value in JSON.');
        return true;
      }());

      return ListBookings200Response(
        upcoming: Booking.listFromJson(json[r'upcoming']),
        past: Booking.listFromJson(json[r'past']),
      );
    }
    return null;
  }

  static List<ListBookings200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListBookings200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListBookings200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListBookings200Response> mapFromJson(dynamic json) {
    final map = <String, ListBookings200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListBookings200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListBookings200Response-objects as value to a dart map
  static Map<String, List<ListBookings200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListBookings200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListBookings200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'upcoming',
    'past',
  };
}

