//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetPk200Response {
  /// Returns a new [GetPk200Response] instance.
  GetPk200Response({
    required this.battle,
    required this.other,
  });

  PkBattle battle;

  GetPk200ResponseOther? other;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetPk200Response &&
    other.battle == battle &&
    other.other == other;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (battle.hashCode) +
    (other == null ? 0 : other!.hashCode);

  @override
  String toString() => 'GetPk200Response[battle=$battle, other=$other]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'battle'] = this.battle;
    if (this.other != null) {
      json[r'other'] = this.other;
    } else {
      json[r'other'] = null;
    }
    return json;
  }

  /// Returns a new [GetPk200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetPk200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'battle'), 'Required key "GetPk200Response[battle]" is missing from JSON.');
        assert(json[r'battle'] != null, 'Required key "GetPk200Response[battle]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "GetPk200Response[other]" is missing from JSON.');
        return true;
      }());

      return GetPk200Response(
        battle: PkBattle.fromJson(json[r'battle'])!,
        other: GetPk200ResponseOther.fromJson(json[r'other']),
      );
    }
    return null;
  }

  static List<GetPk200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetPk200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetPk200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetPk200Response> mapFromJson(dynamic json) {
    final map = <String, GetPk200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetPk200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetPk200Response-objects as value to a dart map
  static Map<String, List<GetPk200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetPk200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetPk200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'battle',
    'other',
  };
}

