//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ClaimCheckIn200Response {
  /// Returns a new [ClaimCheckIn200Response] instance.
  ClaimCheckIn200Response({
    required this.credited,
    required this.coins,
    required this.checkin,
  });

  /// 0 if today was already claimed
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int credited;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? coins;

  CheckIn checkin;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClaimCheckIn200Response &&
    other.credited == credited &&
    other.coins == coins &&
    other.checkin == checkin;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (credited.hashCode) +
    (coins == null ? 0 : coins!.hashCode) +
    (checkin.hashCode);

  @override
  String toString() => 'ClaimCheckIn200Response[credited=$credited, coins=$coins, checkin=$checkin]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'credited'] = this.credited;
    if (this.coins != null) {
      json[r'coins'] = this.coins;
    } else {
      json[r'coins'] = null;
    }
      json[r'checkin'] = this.checkin;
    return json;
  }

  /// Returns a new [ClaimCheckIn200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClaimCheckIn200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'credited'), 'Required key "ClaimCheckIn200Response[credited]" is missing from JSON.');
        assert(json[r'credited'] != null, 'Required key "ClaimCheckIn200Response[credited]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "ClaimCheckIn200Response[coins]" is missing from JSON.');
        assert(json.containsKey(r'checkin'), 'Required key "ClaimCheckIn200Response[checkin]" is missing from JSON.');
        assert(json[r'checkin'] != null, 'Required key "ClaimCheckIn200Response[checkin]" has a null value in JSON.');
        return true;
      }());

      return ClaimCheckIn200Response(
        credited: mapValueOfType<int>(json, r'credited')!,
        coins: mapValueOfType<int>(json, r'coins'),
        checkin: CheckIn.fromJson(json[r'checkin'])!,
      );
    }
    return null;
  }

  static List<ClaimCheckIn200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClaimCheckIn200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClaimCheckIn200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClaimCheckIn200Response> mapFromJson(dynamic json) {
    final map = <String, ClaimCheckIn200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClaimCheckIn200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClaimCheckIn200Response-objects as value to a dart map
  static Map<String, List<ClaimCheckIn200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClaimCheckIn200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClaimCheckIn200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'credited',
    'coins',
    'checkin',
  };
}

