//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class UploadVoiceIntroRequest {
  /// Returns a new [UploadVoiceIntroRequest] instance.
  UploadVoiceIntroRequest({
    required this.audioBase64,
  });

  String audioBase64;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UploadVoiceIntroRequest &&
    other.audioBase64 == audioBase64;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioBase64.hashCode);

  @override
  String toString() => 'UploadVoiceIntroRequest[audioBase64=$audioBase64]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audioBase64'] = this.audioBase64;
    return json;
  }

  /// Returns a new [UploadVoiceIntroRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UploadVoiceIntroRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'audioBase64'), 'Required key "UploadVoiceIntroRequest[audioBase64]" is missing from JSON.');
        assert(json[r'audioBase64'] != null, 'Required key "UploadVoiceIntroRequest[audioBase64]" has a null value in JSON.');
        return true;
      }());

      return UploadVoiceIntroRequest(
        audioBase64: mapValueOfType<String>(json, r'audioBase64')!,
      );
    }
    return null;
  }

  static List<UploadVoiceIntroRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UploadVoiceIntroRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UploadVoiceIntroRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UploadVoiceIntroRequest> mapFromJson(dynamic json) {
    final map = <String, UploadVoiceIntroRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UploadVoiceIntroRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UploadVoiceIntroRequest-objects as value to a dart map
  static Map<String, List<UploadVoiceIntroRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UploadVoiceIntroRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UploadVoiceIntroRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audioBase64',
  };
}

