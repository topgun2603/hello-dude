//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SetCompanionCallTypesRequest {
  /// Returns a new [SetCompanionCallTypesRequest] instance.
  SetCompanionCallTypesRequest({
    required this.audio,
    required this.video,
  });

  bool audio;

  bool video;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SetCompanionCallTypesRequest &&
    other.audio == audio &&
    other.video == video;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audio.hashCode) +
    (video.hashCode);

  @override
  String toString() => 'SetCompanionCallTypesRequest[audio=$audio, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audio'] = this.audio;
      json[r'video'] = this.video;
    return json;
  }

  /// Returns a new [SetCompanionCallTypesRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SetCompanionCallTypesRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'audio'), 'Required key "SetCompanionCallTypesRequest[audio]" is missing from JSON.');
        assert(json[r'audio'] != null, 'Required key "SetCompanionCallTypesRequest[audio]" has a null value in JSON.');
        assert(json.containsKey(r'video'), 'Required key "SetCompanionCallTypesRequest[video]" is missing from JSON.');
        assert(json[r'video'] != null, 'Required key "SetCompanionCallTypesRequest[video]" has a null value in JSON.');
        return true;
      }());

      return SetCompanionCallTypesRequest(
        audio: mapValueOfType<bool>(json, r'audio')!,
        video: mapValueOfType<bool>(json, r'video')!,
      );
    }
    return null;
  }

  static List<SetCompanionCallTypesRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SetCompanionCallTypesRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetCompanionCallTypesRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SetCompanionCallTypesRequest> mapFromJson(dynamic json) {
    final map = <String, SetCompanionCallTypesRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SetCompanionCallTypesRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SetCompanionCallTypesRequest-objects as value to a dart map
  static Map<String, List<SetCompanionCallTypesRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SetCompanionCallTypesRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SetCompanionCallTypesRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio',
    'video',
  };
}

