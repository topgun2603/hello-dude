//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetReferral200Response {
  /// Returns a new [GetReferral200Response] instance.
  GetReferral200Response({
    required this.code,
    required this.link,
    required this.referrerCoins,
    required this.referrerPaise,
    required this.refereeCoins,
    required this.joined,
    required this.rewarded,
    required this.coinsEarned,
    required this.paiseEarned,
  });

  String code;

  String link;

  /// Callers: coins per friend
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int referrerCoins;

  /// Companions: earnings per invited caller
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int referrerPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int refereeCoins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int joined;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int rewarded;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEarned;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paiseEarned;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetReferral200Response &&
    other.code == code &&
    other.link == link &&
    other.referrerCoins == referrerCoins &&
    other.referrerPaise == referrerPaise &&
    other.refereeCoins == refereeCoins &&
    other.joined == joined &&
    other.rewarded == rewarded &&
    other.coinsEarned == coinsEarned &&
    other.paiseEarned == paiseEarned;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (link.hashCode) +
    (referrerCoins.hashCode) +
    (referrerPaise.hashCode) +
    (refereeCoins.hashCode) +
    (joined.hashCode) +
    (rewarded.hashCode) +
    (coinsEarned.hashCode) +
    (paiseEarned.hashCode);

  @override
  String toString() => 'GetReferral200Response[code=$code, link=$link, referrerCoins=$referrerCoins, referrerPaise=$referrerPaise, refereeCoins=$refereeCoins, joined=$joined, rewarded=$rewarded, coinsEarned=$coinsEarned, paiseEarned=$paiseEarned]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'link'] = this.link;
      json[r'referrerCoins'] = this.referrerCoins;
      json[r'referrerPaise'] = this.referrerPaise;
      json[r'refereeCoins'] = this.refereeCoins;
      json[r'joined'] = this.joined;
      json[r'rewarded'] = this.rewarded;
      json[r'coinsEarned'] = this.coinsEarned;
      json[r'paiseEarned'] = this.paiseEarned;
    return json;
  }

  /// Returns a new [GetReferral200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetReferral200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "GetReferral200Response[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "GetReferral200Response[code]" has a null value in JSON.');
        assert(json.containsKey(r'link'), 'Required key "GetReferral200Response[link]" is missing from JSON.');
        assert(json[r'link'] != null, 'Required key "GetReferral200Response[link]" has a null value in JSON.');
        assert(json.containsKey(r'referrerCoins'), 'Required key "GetReferral200Response[referrerCoins]" is missing from JSON.');
        assert(json[r'referrerCoins'] != null, 'Required key "GetReferral200Response[referrerCoins]" has a null value in JSON.');
        assert(json.containsKey(r'referrerPaise'), 'Required key "GetReferral200Response[referrerPaise]" is missing from JSON.');
        assert(json[r'referrerPaise'] != null, 'Required key "GetReferral200Response[referrerPaise]" has a null value in JSON.');
        assert(json.containsKey(r'refereeCoins'), 'Required key "GetReferral200Response[refereeCoins]" is missing from JSON.');
        assert(json[r'refereeCoins'] != null, 'Required key "GetReferral200Response[refereeCoins]" has a null value in JSON.');
        assert(json.containsKey(r'joined'), 'Required key "GetReferral200Response[joined]" is missing from JSON.');
        assert(json[r'joined'] != null, 'Required key "GetReferral200Response[joined]" has a null value in JSON.');
        assert(json.containsKey(r'rewarded'), 'Required key "GetReferral200Response[rewarded]" is missing from JSON.');
        assert(json[r'rewarded'] != null, 'Required key "GetReferral200Response[rewarded]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEarned'), 'Required key "GetReferral200Response[coinsEarned]" is missing from JSON.');
        assert(json[r'coinsEarned'] != null, 'Required key "GetReferral200Response[coinsEarned]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "GetReferral200Response[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "GetReferral200Response[paiseEarned]" has a null value in JSON.');
        return true;
      }());

      return GetReferral200Response(
        code: mapValueOfType<String>(json, r'code')!,
        link: mapValueOfType<String>(json, r'link')!,
        referrerCoins: mapValueOfType<int>(json, r'referrerCoins')!,
        referrerPaise: mapValueOfType<int>(json, r'referrerPaise')!,
        refereeCoins: mapValueOfType<int>(json, r'refereeCoins')!,
        joined: mapValueOfType<int>(json, r'joined')!,
        rewarded: mapValueOfType<int>(json, r'rewarded')!,
        coinsEarned: mapValueOfType<int>(json, r'coinsEarned')!,
        paiseEarned: mapValueOfType<int>(json, r'paiseEarned')!,
      );
    }
    return null;
  }

  static List<GetReferral200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetReferral200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetReferral200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetReferral200Response> mapFromJson(dynamic json) {
    final map = <String, GetReferral200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetReferral200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetReferral200Response-objects as value to a dart map
  static Map<String, List<GetReferral200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetReferral200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetReferral200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'link',
    'referrerCoins',
    'referrerPaise',
    'refereeCoins',
    'joined',
    'rewarded',
    'coinsEarned',
    'paiseEarned',
  };
}

