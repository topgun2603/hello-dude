//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCurrentEvent200Response {
  /// Returns a new [GetCurrentEvent200Response] instance.
  GetCurrentEvent200Response({
    required this.event,
  });

  AppEvent? event;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCurrentEvent200Response &&
    other.event == event;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (event == null ? 0 : event!.hashCode);

  @override
  String toString() => 'GetCurrentEvent200Response[event=$event]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.event != null) {
      json[r'event'] = this.event;
    } else {
      json[r'event'] = null;
    }
    return json;
  }

  /// Returns a new [GetCurrentEvent200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCurrentEvent200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'event'), 'Required key "GetCurrentEvent200Response[event]" is missing from JSON.');
        return true;
      }());

      return GetCurrentEvent200Response(
        event: AppEvent.fromJson(json[r'event']),
      );
    }
    return null;
  }

  static List<GetCurrentEvent200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCurrentEvent200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCurrentEvent200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCurrentEvent200Response> mapFromJson(dynamic json) {
    final map = <String, GetCurrentEvent200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCurrentEvent200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCurrentEvent200Response-objects as value to a dart map
  static Map<String, List<GetCurrentEvent200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCurrentEvent200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCurrentEvent200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'event',
  };
}

