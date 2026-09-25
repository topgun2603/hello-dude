//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class InviteCaller201Response {
  /// Returns a new [InviteCaller201Response] instance.
  InviteCaller201Response({
    required this.invitedUntil,
  });

  DateTime invitedUntil;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InviteCaller201Response &&
    other.invitedUntil == invitedUntil;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (invitedUntil.hashCode);

  @override
  String toString() => 'InviteCaller201Response[invitedUntil=$invitedUntil]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'invitedUntil'] = this.invitedUntil.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [InviteCaller201Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InviteCaller201Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'invitedUntil'), 'Required key "InviteCaller201Response[invitedUntil]" is missing from JSON.');
        assert(json[r'invitedUntil'] != null, 'Required key "InviteCaller201Response[invitedUntil]" has a null value in JSON.');
        return true;
      }());

      return InviteCaller201Response(
        invitedUntil: mapDateTime(json, r'invitedUntil', r'')!,
      );
    }
    return null;
  }

  static List<InviteCaller201Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InviteCaller201Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InviteCaller201Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InviteCaller201Response> mapFromJson(dynamic json) {
    final map = <String, InviteCaller201Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InviteCaller201Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InviteCaller201Response-objects as value to a dart map
  static Map<String, List<InviteCaller201Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InviteCaller201Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InviteCaller201Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'invitedUntil',
  };
}

