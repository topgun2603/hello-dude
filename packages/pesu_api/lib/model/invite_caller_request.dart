//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class InviteCallerRequest {
  /// Returns a new [InviteCallerRequest] instance.
  InviteCallerRequest({
    required this.callerId,
  });

  String callerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InviteCallerRequest &&
    other.callerId == callerId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callerId.hashCode);

  @override
  String toString() => 'InviteCallerRequest[callerId=$callerId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'callerId'] = this.callerId;
    return json;
  }

  /// Returns a new [InviteCallerRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InviteCallerRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'callerId'), 'Required key "InviteCallerRequest[callerId]" is missing from JSON.');
        assert(json[r'callerId'] != null, 'Required key "InviteCallerRequest[callerId]" has a null value in JSON.');
        return true;
      }());

      return InviteCallerRequest(
        callerId: mapValueOfType<String>(json, r'callerId')!,
      );
    }
    return null;
  }

  static List<InviteCallerRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InviteCallerRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InviteCallerRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InviteCallerRequest> mapFromJson(dynamic json) {
    final map = <String, InviteCallerRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InviteCallerRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InviteCallerRequest-objects as value to a dart map
  static Map<String, List<InviteCallerRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InviteCallerRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InviteCallerRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'callerId',
  };
}

