//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateInputSelfie {
  /// Returns a new [KycStateInputSelfie] instance.
  KycStateInputSelfie({
    required this.done,
  });

  bool done;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateInputSelfie &&
    other.done == done;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (done.hashCode);

  @override
  String toString() => 'KycStateInputSelfie[done=$done]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'done'] = this.done;
    return json;
  }

  /// Returns a new [KycStateInputSelfie] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateInputSelfie? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'done'), 'Required key "KycStateInputSelfie[done]" is missing from JSON.');
        assert(json[r'done'] != null, 'Required key "KycStateInputSelfie[done]" has a null value in JSON.');
        return true;
      }());

      return KycStateInputSelfie(
        done: mapValueOfType<bool>(json, r'done')!,
      );
    }
    return null;
  }

  static List<KycStateInputSelfie> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInputSelfie>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInputSelfie.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateInputSelfie> mapFromJson(dynamic json) {
    final map = <String, KycStateInputSelfie>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateInputSelfie.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateInputSelfie-objects as value to a dart map
  static Map<String, List<KycStateInputSelfie>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateInputSelfie>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateInputSelfie.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'done',
  };
}

