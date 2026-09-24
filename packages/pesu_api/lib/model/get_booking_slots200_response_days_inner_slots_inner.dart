//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetBookingSlots200ResponseDaysInnerSlotsInner {
  /// Returns a new [GetBookingSlots200ResponseDaysInnerSlotsInner] instance.
  GetBookingSlots200ResponseDaysInnerSlotsInner({
    required this.startAt,
    required this.available,
  });

  DateTime startAt;

  bool available;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetBookingSlots200ResponseDaysInnerSlotsInner &&
    other.startAt == startAt &&
    other.available == available;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (startAt.hashCode) +
    (available.hashCode);

  @override
  String toString() => 'GetBookingSlots200ResponseDaysInnerSlotsInner[startAt=$startAt, available=$available]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'startAt'] = this.startAt.toUtc().toIso8601String();
      json[r'available'] = this.available;
    return json;
  }

  /// Returns a new [GetBookingSlots200ResponseDaysInnerSlotsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetBookingSlots200ResponseDaysInnerSlotsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'startAt'), 'Required key "GetBookingSlots200ResponseDaysInnerSlotsInner[startAt]" is missing from JSON.');
        assert(json[r'startAt'] != null, 'Required key "GetBookingSlots200ResponseDaysInnerSlotsInner[startAt]" has a null value in JSON.');
        assert(json.containsKey(r'available'), 'Required key "GetBookingSlots200ResponseDaysInnerSlotsInner[available]" is missing from JSON.');
        assert(json[r'available'] != null, 'Required key "GetBookingSlots200ResponseDaysInnerSlotsInner[available]" has a null value in JSON.');
        return true;
      }());

      return GetBookingSlots200ResponseDaysInnerSlotsInner(
        startAt: mapDateTime(json, r'startAt', r'')!,
        available: mapValueOfType<bool>(json, r'available')!,
      );
    }
    return null;
  }

  static List<GetBookingSlots200ResponseDaysInnerSlotsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetBookingSlots200ResponseDaysInnerSlotsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetBookingSlots200ResponseDaysInnerSlotsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetBookingSlots200ResponseDaysInnerSlotsInner> mapFromJson(dynamic json) {
    final map = <String, GetBookingSlots200ResponseDaysInnerSlotsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetBookingSlots200ResponseDaysInnerSlotsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetBookingSlots200ResponseDaysInnerSlotsInner-objects as value to a dart map
  static Map<String, List<GetBookingSlots200ResponseDaysInnerSlotsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetBookingSlots200ResponseDaysInnerSlotsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetBookingSlots200ResponseDaysInnerSlotsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'startAt',
    'available',
  };
}

