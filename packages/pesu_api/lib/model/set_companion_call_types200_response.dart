//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SetCompanionCallTypes200Response {
  /// Returns a new [SetCompanionCallTypes200Response] instance.
  SetCompanionCallTypes200Response({
    required this.takesAudio,
    required this.takesVideo,
  });

  bool takesAudio;

  bool takesVideo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SetCompanionCallTypes200Response &&
    other.takesAudio == takesAudio &&
    other.takesVideo == takesVideo;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (takesAudio.hashCode) +
    (takesVideo.hashCode);

  @override
  String toString() => 'SetCompanionCallTypes200Response[takesAudio=$takesAudio, takesVideo=$takesVideo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'takesAudio'] = this.takesAudio;
      json[r'takesVideo'] = this.takesVideo;
    return json;
  }

  /// Returns a new [SetCompanionCallTypes200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SetCompanionCallTypes200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'takesAudio'), 'Required key "SetCompanionCallTypes200Response[takesAudio]" is missing from JSON.');
        assert(json[r'takesAudio'] != null, 'Required key "SetCompanionCallTypes200Response[takesAudio]" has a null value in JSON.');
        assert(json.containsKey(r'takesVideo'), 'Required key "SetCompanionCallTypes200Response[takesVideo]" is missing from JSON.');
        assert(json[r'takesVideo'] != null, 'Required key "SetCompanionCallTypes200Response[takesVideo]" has a null value in JSON.');
        return true;
      }());

      return SetCompanionCallTypes200Response(
        takesAudio: mapValueOfType<bool>(json, r'takesAudio')!,
        takesVideo: mapValueOfType<bool>(json, r'takesVideo')!,
      );
    }
    return null;
  }

  static List<SetCompanionCallTypes200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SetCompanionCallTypes200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetCompanionCallTypes200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SetCompanionCallTypes200Response> mapFromJson(dynamic json) {
    final map = <String, SetCompanionCallTypes200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SetCompanionCallTypes200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SetCompanionCallTypes200Response-objects as value to a dart map
  static Map<String, List<SetCompanionCallTypes200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SetCompanionCallTypes200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SetCompanionCallTypes200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'takesAudio',
    'takesVideo',
  };
}

