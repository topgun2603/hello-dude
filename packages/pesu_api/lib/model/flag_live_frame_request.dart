//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class FlagLiveFrameRequest {
  /// Returns a new [FlagLiveFrameRequest] instance.
  FlagLiveFrameRequest({
    required this.frameBase64,
    required this.score,
  });

  String frameBase64;

  /// Minimum value: 0
  /// Maximum value: 1
  num score;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlagLiveFrameRequest &&
    other.frameBase64 == frameBase64 &&
    other.score == score;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (frameBase64.hashCode) +
    (score.hashCode);

  @override
  String toString() => 'FlagLiveFrameRequest[frameBase64=$frameBase64, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'frameBase64'] = this.frameBase64;
      json[r'score'] = this.score;
    return json;
  }

  /// Returns a new [FlagLiveFrameRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FlagLiveFrameRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'frameBase64'), 'Required key "FlagLiveFrameRequest[frameBase64]" is missing from JSON.');
        assert(json[r'frameBase64'] != null, 'Required key "FlagLiveFrameRequest[frameBase64]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "FlagLiveFrameRequest[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "FlagLiveFrameRequest[score]" has a null value in JSON.');
        return true;
      }());

      return FlagLiveFrameRequest(
        frameBase64: mapValueOfType<String>(json, r'frameBase64')!,
        score: num.parse('${json[r'score']}'),
      );
    }
    return null;
  }

  static List<FlagLiveFrameRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FlagLiveFrameRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FlagLiveFrameRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FlagLiveFrameRequest> mapFromJson(dynamic json) {
    final map = <String, FlagLiveFrameRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FlagLiveFrameRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FlagLiveFrameRequest-objects as value to a dart map
  static Map<String, List<FlagLiveFrameRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FlagLiveFrameRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlagLiveFrameRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'frameBase64',
    'score',
  };
}

