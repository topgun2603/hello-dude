//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LivePricingInput {
  /// Returns a new [LivePricingInput] instance.
  LivePricingInput({
    required this.previewSeconds,
    required this.coinsPerMin,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int previewSeconds;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LivePricingInput &&
    other.previewSeconds == previewSeconds &&
    other.coinsPerMin == coinsPerMin;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (previewSeconds.hashCode) +
    (coinsPerMin.hashCode);

  @override
  String toString() => 'LivePricingInput[previewSeconds=$previewSeconds, coinsPerMin=$coinsPerMin]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'previewSeconds'] = this.previewSeconds;
      json[r'coinsPerMin'] = this.coinsPerMin;
    return json;
  }

  /// Returns a new [LivePricingInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LivePricingInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'previewSeconds'), 'Required key "LivePricingInput[previewSeconds]" is missing from JSON.');
        assert(json[r'previewSeconds'] != null, 'Required key "LivePricingInput[previewSeconds]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "LivePricingInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "LivePricingInput[coinsPerMin]" has a null value in JSON.');
        return true;
      }());

      return LivePricingInput(
        previewSeconds: mapValueOfType<int>(json, r'previewSeconds')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
      );
    }
    return null;
  }

  static List<LivePricingInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LivePricingInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LivePricingInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LivePricingInput> mapFromJson(dynamic json) {
    final map = <String, LivePricingInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LivePricingInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LivePricingInput-objects as value to a dart map
  static Map<String, List<LivePricingInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LivePricingInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LivePricingInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'previewSeconds',
    'coinsPerMin',
  };
}

