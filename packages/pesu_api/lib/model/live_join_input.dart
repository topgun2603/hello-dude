//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveJoinInput {
  /// Returns a new [LiveJoinInput] instance.
  LiveJoinInput({
    required this.live,
    required this.liveKitUrl,
    required this.livekitRoom,
    required this.token,
    required this.access,
    required this.pricing,
    required this.coinsLeft,
  });

  LiveCardInput live;

  String liveKitUrl;

  String livekitRoom;

  String token;

  LiveAccessInput access;

  LivePricingInput pricing;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? coinsLeft;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveJoinInput &&
    other.live == live &&
    other.liveKitUrl == liveKitUrl &&
    other.livekitRoom == livekitRoom &&
    other.token == token &&
    other.access == access &&
    other.pricing == pricing &&
    other.coinsLeft == coinsLeft;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (live.hashCode) +
    (liveKitUrl.hashCode) +
    (livekitRoom.hashCode) +
    (token.hashCode) +
    (access.hashCode) +
    (pricing.hashCode) +
    (coinsLeft == null ? 0 : coinsLeft!.hashCode);

  @override
  String toString() => 'LiveJoinInput[live=$live, liveKitUrl=$liveKitUrl, livekitRoom=$livekitRoom, token=$token, access=$access, pricing=$pricing, coinsLeft=$coinsLeft]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'live'] = this.live;
      json[r'liveKitUrl'] = this.liveKitUrl;
      json[r'livekitRoom'] = this.livekitRoom;
      json[r'token'] = this.token;
      json[r'access'] = this.access;
      json[r'pricing'] = this.pricing;
    if (this.coinsLeft != null) {
      json[r'coinsLeft'] = this.coinsLeft;
    } else {
      json[r'coinsLeft'] = null;
    }
    return json;
  }

  /// Returns a new [LiveJoinInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveJoinInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'live'), 'Required key "LiveJoinInput[live]" is missing from JSON.');
        assert(json[r'live'] != null, 'Required key "LiveJoinInput[live]" has a null value in JSON.');
        assert(json.containsKey(r'liveKitUrl'), 'Required key "LiveJoinInput[liveKitUrl]" is missing from JSON.');
        assert(json[r'liveKitUrl'] != null, 'Required key "LiveJoinInput[liveKitUrl]" has a null value in JSON.');
        assert(json.containsKey(r'livekitRoom'), 'Required key "LiveJoinInput[livekitRoom]" is missing from JSON.');
        assert(json[r'livekitRoom'] != null, 'Required key "LiveJoinInput[livekitRoom]" has a null value in JSON.');
        assert(json.containsKey(r'token'), 'Required key "LiveJoinInput[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "LiveJoinInput[token]" has a null value in JSON.');
        assert(json.containsKey(r'access'), 'Required key "LiveJoinInput[access]" is missing from JSON.');
        assert(json[r'access'] != null, 'Required key "LiveJoinInput[access]" has a null value in JSON.');
        assert(json.containsKey(r'pricing'), 'Required key "LiveJoinInput[pricing]" is missing from JSON.');
        assert(json[r'pricing'] != null, 'Required key "LiveJoinInput[pricing]" has a null value in JSON.');
        assert(json.containsKey(r'coinsLeft'), 'Required key "LiveJoinInput[coinsLeft]" is missing from JSON.');
        return true;
      }());

      return LiveJoinInput(
        live: LiveCardInput.fromJson(json[r'live'])!,
        liveKitUrl: mapValueOfType<String>(json, r'liveKitUrl')!,
        livekitRoom: mapValueOfType<String>(json, r'livekitRoom')!,
        token: mapValueOfType<String>(json, r'token')!,
        access: LiveAccessInput.fromJson(json[r'access'])!,
        pricing: LivePricingInput.fromJson(json[r'pricing'])!,
        coinsLeft: mapValueOfType<int>(json, r'coinsLeft'),
      );
    }
    return null;
  }

  static List<LiveJoinInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveJoinInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveJoinInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveJoinInput> mapFromJson(dynamic json) {
    final map = <String, LiveJoinInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveJoinInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveJoinInput-objects as value to a dart map
  static Map<String, List<LiveJoinInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveJoinInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveJoinInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'live',
    'liveKitUrl',
    'livekitRoom',
    'token',
    'access',
    'pricing',
    'coinsLeft',
  };
}

