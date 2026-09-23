//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionRates {
  /// Returns a new [CompanionRates] instance.
  CompanionRates({
    required this.audioCoinsPerMin,
    required this.videoCoinsPerMin,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? audioCoinsPerMin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? videoCoinsPerMin;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionRates &&
    other.audioCoinsPerMin == audioCoinsPerMin &&
    other.videoCoinsPerMin == videoCoinsPerMin;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioCoinsPerMin == null ? 0 : audioCoinsPerMin!.hashCode) +
    (videoCoinsPerMin == null ? 0 : videoCoinsPerMin!.hashCode);

  @override
  String toString() => 'CompanionRates[audioCoinsPerMin=$audioCoinsPerMin, videoCoinsPerMin=$videoCoinsPerMin]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audioCoinsPerMin != null) {
      json[r'audioCoinsPerMin'] = this.audioCoinsPerMin;
    } else {
      json[r'audioCoinsPerMin'] = null;
    }
    if (this.videoCoinsPerMin != null) {
      json[r'videoCoinsPerMin'] = this.videoCoinsPerMin;
    } else {
      json[r'videoCoinsPerMin'] = null;
    }
    return json;
  }

  /// Returns a new [CompanionRates] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionRates? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'audioCoinsPerMin'), 'Required key "CompanionRates[audioCoinsPerMin]" is missing from JSON.');
        assert(json.containsKey(r'videoCoinsPerMin'), 'Required key "CompanionRates[videoCoinsPerMin]" is missing from JSON.');
        return true;
      }());

      return CompanionRates(
        audioCoinsPerMin: mapValueOfType<int>(json, r'audioCoinsPerMin'),
        videoCoinsPerMin: mapValueOfType<int>(json, r'videoCoinsPerMin'),
      );
    }
    return null;
  }

  static List<CompanionRates> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionRates>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionRates.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionRates> mapFromJson(dynamic json) {
    final map = <String, CompanionRates>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionRates.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionRates-objects as value to a dart map
  static Map<String, List<CompanionRates>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionRates>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionRates.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audioCoinsPerMin',
    'videoCoinsPerMin',
  };
}

