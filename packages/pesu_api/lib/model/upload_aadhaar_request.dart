//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class UploadAadhaarRequest {
  /// Returns a new [UploadAadhaarRequest] instance.
  UploadAadhaarRequest({
    required this.zipBase64,
    required this.shareCode,
  });

  String zipBase64;

  String shareCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UploadAadhaarRequest &&
    other.zipBase64 == zipBase64 &&
    other.shareCode == shareCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (zipBase64.hashCode) +
    (shareCode.hashCode);

  @override
  String toString() => 'UploadAadhaarRequest[zipBase64=$zipBase64, shareCode=$shareCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'zipBase64'] = this.zipBase64;
      json[r'shareCode'] = this.shareCode;
    return json;
  }

  /// Returns a new [UploadAadhaarRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UploadAadhaarRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'zipBase64'), 'Required key "UploadAadhaarRequest[zipBase64]" is missing from JSON.');
        assert(json[r'zipBase64'] != null, 'Required key "UploadAadhaarRequest[zipBase64]" has a null value in JSON.');
        assert(json.containsKey(r'shareCode'), 'Required key "UploadAadhaarRequest[shareCode]" is missing from JSON.');
        assert(json[r'shareCode'] != null, 'Required key "UploadAadhaarRequest[shareCode]" has a null value in JSON.');
        return true;
      }());

      return UploadAadhaarRequest(
        zipBase64: mapValueOfType<String>(json, r'zipBase64')!,
        shareCode: mapValueOfType<String>(json, r'shareCode')!,
      );
    }
    return null;
  }

  static List<UploadAadhaarRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UploadAadhaarRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UploadAadhaarRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UploadAadhaarRequest> mapFromJson(dynamic json) {
    final map = <String, UploadAadhaarRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UploadAadhaarRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UploadAadhaarRequest-objects as value to a dart map
  static Map<String, List<UploadAadhaarRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UploadAadhaarRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UploadAadhaarRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'zipBase64',
    'shareCode',
  };
}

