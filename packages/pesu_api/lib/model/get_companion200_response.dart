//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCompanion200Response {
  /// Returns a new [GetCompanion200Response] instance.
  GetCompanion200Response({
    required this.companion,
    required this.online,
  });

  OnlineCompanion companion;

  bool online;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCompanion200Response &&
    other.companion == companion &&
    other.online == online;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (companion.hashCode) +
    (online.hashCode);

  @override
  String toString() => 'GetCompanion200Response[companion=$companion, online=$online]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'companion'] = this.companion;
      json[r'online'] = this.online;
    return json;
  }

  /// Returns a new [GetCompanion200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCompanion200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'companion'), 'Required key "GetCompanion200Response[companion]" is missing from JSON.');
        assert(json[r'companion'] != null, 'Required key "GetCompanion200Response[companion]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "GetCompanion200Response[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "GetCompanion200Response[online]" has a null value in JSON.');
        return true;
      }());

      return GetCompanion200Response(
        companion: OnlineCompanion.fromJson(json[r'companion'])!,
        online: mapValueOfType<bool>(json, r'online')!,
      );
    }
    return null;
  }

  static List<GetCompanion200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCompanion200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCompanion200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCompanion200Response> mapFromJson(dynamic json) {
    final map = <String, GetCompanion200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCompanion200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCompanion200Response-objects as value to a dart map
  static Map<String, List<GetCompanion200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCompanion200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCompanion200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'companion',
    'online',
  };
}

