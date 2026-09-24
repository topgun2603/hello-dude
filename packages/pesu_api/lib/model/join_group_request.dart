//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class JoinGroupRequest {
  /// Returns a new [JoinGroupRequest] instance.
  JoinGroupRequest({
    this.agree,
  });

  /// Agree to the per-minute price and to being on camera
  bool? agree;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JoinGroupRequest &&
    other.agree == agree;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (agree == null ? 0 : agree!.hashCode);

  @override
  String toString() => 'JoinGroupRequest[agree=$agree]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.agree != null) {
      json[r'agree'] = this.agree;
    } else {
      json[r'agree'] = null;
    }
    return json;
  }

  /// Returns a new [JoinGroupRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static JoinGroupRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return JoinGroupRequest(
        agree: mapValueOfType<bool>(json, r'agree'),
      );
    }
    return null;
  }

  static List<JoinGroupRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <JoinGroupRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = JoinGroupRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, JoinGroupRequest> mapFromJson(dynamic json) {
    final map = <String, JoinGroupRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = JoinGroupRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of JoinGroupRequest-objects as value to a dart map
  static Map<String, List<JoinGroupRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<JoinGroupRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = JoinGroupRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

