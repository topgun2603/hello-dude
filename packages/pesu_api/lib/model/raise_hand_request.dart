//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RaiseHandRequest {
  /// Returns a new [RaiseHandRequest] instance.
  RaiseHandRequest({
    required this.raised,
  });

  bool raised;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RaiseHandRequest &&
    other.raised == raised;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (raised.hashCode);

  @override
  String toString() => 'RaiseHandRequest[raised=$raised]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'raised'] = this.raised;
    return json;
  }

  /// Returns a new [RaiseHandRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RaiseHandRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'raised'), 'Required key "RaiseHandRequest[raised]" is missing from JSON.');
        assert(json[r'raised'] != null, 'Required key "RaiseHandRequest[raised]" has a null value in JSON.');
        return true;
      }());

      return RaiseHandRequest(
        raised: mapValueOfType<bool>(json, r'raised')!,
      );
    }
    return null;
  }

  static List<RaiseHandRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RaiseHandRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RaiseHandRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RaiseHandRequest> mapFromJson(dynamic json) {
    final map = <String, RaiseHandRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RaiseHandRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RaiseHandRequest-objects as value to a dart map
  static Map<String, List<RaiseHandRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RaiseHandRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RaiseHandRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'raised',
  };
}

