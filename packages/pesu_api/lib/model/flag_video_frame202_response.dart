//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class FlagVideoFrame202Response {
  /// Returns a new [FlagVideoFrame202Response] instance.
  FlagVideoFrame202Response({
    required this.accepted,
  });

  bool accepted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlagVideoFrame202Response &&
    other.accepted == accepted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accepted.hashCode);

  @override
  String toString() => 'FlagVideoFrame202Response[accepted=$accepted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accepted'] = this.accepted;
    return json;
  }

  /// Returns a new [FlagVideoFrame202Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FlagVideoFrame202Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'accepted'), 'Required key "FlagVideoFrame202Response[accepted]" is missing from JSON.');
        assert(json[r'accepted'] != null, 'Required key "FlagVideoFrame202Response[accepted]" has a null value in JSON.');
        return true;
      }());

      return FlagVideoFrame202Response(
        accepted: mapValueOfType<bool>(json, r'accepted')!,
      );
    }
    return null;
  }

  static List<FlagVideoFrame202Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FlagVideoFrame202Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FlagVideoFrame202Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FlagVideoFrame202Response> mapFromJson(dynamic json) {
    final map = <String, FlagVideoFrame202Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FlagVideoFrame202Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FlagVideoFrame202Response-objects as value to a dart map
  static Map<String, List<FlagVideoFrame202Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FlagVideoFrame202Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlagVideoFrame202Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accepted',
  };
}

