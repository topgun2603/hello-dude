//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateUpi {
  /// Returns a new [KycStateUpi] instance.
  KycStateUpi({
    required this.done,
    required this.masked,
  });

  bool done;

  String? masked;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateUpi &&
    other.done == done &&
    other.masked == masked;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (done.hashCode) +
    (masked == null ? 0 : masked!.hashCode);

  @override
  String toString() => 'KycStateUpi[done=$done, masked=$masked]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'done'] = this.done;
    if (this.masked != null) {
      json[r'masked'] = this.masked;
    } else {
      json[r'masked'] = null;
    }
    return json;
  }

  /// Returns a new [KycStateUpi] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateUpi? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'done'), 'Required key "KycStateUpi[done]" is missing from JSON.');
        assert(json[r'done'] != null, 'Required key "KycStateUpi[done]" has a null value in JSON.');
        assert(json.containsKey(r'masked'), 'Required key "KycStateUpi[masked]" is missing from JSON.');
        return true;
      }());

      return KycStateUpi(
        done: mapValueOfType<bool>(json, r'done')!,
        masked: mapValueOfType<String>(json, r'masked'),
      );
    }
    return null;
  }

  static List<KycStateUpi> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateUpi>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateUpi.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateUpi> mapFromJson(dynamic json) {
    final map = <String, KycStateUpi>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateUpi.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateUpi-objects as value to a dart map
  static Map<String, List<KycStateUpi>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateUpi>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateUpi.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'done',
    'masked',
  };
}

