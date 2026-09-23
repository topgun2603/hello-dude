//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class UploadPanRequest {
  /// Returns a new [UploadPanRequest] instance.
  UploadPanRequest({
    required this.panNumber,
    required this.imageBase64,
  });

  String panNumber;

  String imageBase64;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UploadPanRequest &&
    other.panNumber == panNumber &&
    other.imageBase64 == imageBase64;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (panNumber.hashCode) +
    (imageBase64.hashCode);

  @override
  String toString() => 'UploadPanRequest[panNumber=$panNumber, imageBase64=$imageBase64]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'panNumber'] = this.panNumber;
      json[r'imageBase64'] = this.imageBase64;
    return json;
  }

  /// Returns a new [UploadPanRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UploadPanRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'panNumber'), 'Required key "UploadPanRequest[panNumber]" is missing from JSON.');
        assert(json[r'panNumber'] != null, 'Required key "UploadPanRequest[panNumber]" has a null value in JSON.');
        assert(json.containsKey(r'imageBase64'), 'Required key "UploadPanRequest[imageBase64]" is missing from JSON.');
        assert(json[r'imageBase64'] != null, 'Required key "UploadPanRequest[imageBase64]" has a null value in JSON.');
        return true;
      }());

      return UploadPanRequest(
        panNumber: mapValueOfType<String>(json, r'panNumber')!,
        imageBase64: mapValueOfType<String>(json, r'imageBase64')!,
      );
    }
    return null;
  }

  static List<UploadPanRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UploadPanRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UploadPanRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UploadPanRequest> mapFromJson(dynamic json) {
    final map = <String, UploadPanRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UploadPanRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UploadPanRequest-objects as value to a dart map
  static Map<String, List<UploadPanRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UploadPanRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UploadPanRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'panNumber',
    'imageBase64',
  };
}

