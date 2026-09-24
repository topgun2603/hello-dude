//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetBookingSlots200ResponseDaysInner {
  /// Returns a new [GetBookingSlots200ResponseDaysInner] instance.
  GetBookingSlots200ResponseDaysInner({
    required this.date,
    this.slots = const [],
  });

  String date;

  List<GetBookingSlots200ResponseDaysInnerSlotsInner> slots;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetBookingSlots200ResponseDaysInner &&
    other.date == date &&
    _deepEquality.equals(other.slots, slots);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (slots.hashCode);

  @override
  String toString() => 'GetBookingSlots200ResponseDaysInner[date=$date, slots=$slots]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'slots'] = this.slots;
    return json;
  }

  /// Returns a new [GetBookingSlots200ResponseDaysInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetBookingSlots200ResponseDaysInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "GetBookingSlots200ResponseDaysInner[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "GetBookingSlots200ResponseDaysInner[date]" has a null value in JSON.');
        assert(json.containsKey(r'slots'), 'Required key "GetBookingSlots200ResponseDaysInner[slots]" is missing from JSON.');
        assert(json[r'slots'] != null, 'Required key "GetBookingSlots200ResponseDaysInner[slots]" has a null value in JSON.');
        return true;
      }());

      return GetBookingSlots200ResponseDaysInner(
        date: mapValueOfType<String>(json, r'date')!,
        slots: GetBookingSlots200ResponseDaysInnerSlotsInner.listFromJson(json[r'slots']),
      );
    }
    return null;
  }

  static List<GetBookingSlots200ResponseDaysInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetBookingSlots200ResponseDaysInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetBookingSlots200ResponseDaysInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetBookingSlots200ResponseDaysInner> mapFromJson(dynamic json) {
    final map = <String, GetBookingSlots200ResponseDaysInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetBookingSlots200ResponseDaysInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetBookingSlots200ResponseDaysInner-objects as value to a dart map
  static Map<String, List<GetBookingSlots200ResponseDaysInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetBookingSlots200ResponseDaysInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetBookingSlots200ResponseDaysInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'slots',
  };
}

