//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateInputVoice {
  /// Returns a new [KycStateInputVoice] instance.
  KycStateInputVoice({
    required this.needed,
    required this.done,
    required this.sentence,
  });

  /// Women companions record a voice intro; an admin listens to it
  bool needed;

  bool done;

  /// Read this aloud (random each time)
  String? sentence;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateInputVoice &&
    other.needed == needed &&
    other.done == done &&
    other.sentence == sentence;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (needed.hashCode) +
    (done.hashCode) +
    (sentence == null ? 0 : sentence!.hashCode);

  @override
  String toString() => 'KycStateInputVoice[needed=$needed, done=$done, sentence=$sentence]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'needed'] = this.needed;
      json[r'done'] = this.done;
    if (this.sentence != null) {
      json[r'sentence'] = this.sentence;
    } else {
      json[r'sentence'] = null;
    }
    return json;
  }

  /// Returns a new [KycStateInputVoice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateInputVoice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'needed'), 'Required key "KycStateInputVoice[needed]" is missing from JSON.');
        assert(json[r'needed'] != null, 'Required key "KycStateInputVoice[needed]" has a null value in JSON.');
        assert(json.containsKey(r'done'), 'Required key "KycStateInputVoice[done]" is missing from JSON.');
        assert(json[r'done'] != null, 'Required key "KycStateInputVoice[done]" has a null value in JSON.');
        assert(json.containsKey(r'sentence'), 'Required key "KycStateInputVoice[sentence]" is missing from JSON.');
        return true;
      }());

      return KycStateInputVoice(
        needed: mapValueOfType<bool>(json, r'needed')!,
        done: mapValueOfType<bool>(json, r'done')!,
        sentence: mapValueOfType<String>(json, r'sentence'),
      );
    }
    return null;
  }

  static List<KycStateInputVoice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInputVoice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInputVoice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateInputVoice> mapFromJson(dynamic json) {
    final map = <String, KycStateInputVoice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateInputVoice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateInputVoice-objects as value to a dart map
  static Map<String, List<KycStateInputVoice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateInputVoice>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateInputVoice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'needed',
    'done',
    'sentence',
  };
}

