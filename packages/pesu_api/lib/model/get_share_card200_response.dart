//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetShareCard200Response {
  /// Returns a new [GetShareCard200Response] instance.
  GetShareCard200Response({
    required this.todayMinutes,
    required this.language,
    required this.code,
    required this.link,
    required this.refereeCoins,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int todayMinutes;

  String language;

  String code;

  String link;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int refereeCoins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetShareCard200Response &&
    other.todayMinutes == todayMinutes &&
    other.language == language &&
    other.code == code &&
    other.link == link &&
    other.refereeCoins == refereeCoins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (todayMinutes.hashCode) +
    (language.hashCode) +
    (code.hashCode) +
    (link.hashCode) +
    (refereeCoins.hashCode);

  @override
  String toString() => 'GetShareCard200Response[todayMinutes=$todayMinutes, language=$language, code=$code, link=$link, refereeCoins=$refereeCoins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'todayMinutes'] = this.todayMinutes;
      json[r'language'] = this.language;
      json[r'code'] = this.code;
      json[r'link'] = this.link;
      json[r'refereeCoins'] = this.refereeCoins;
    return json;
  }

  /// Returns a new [GetShareCard200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetShareCard200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'todayMinutes'), 'Required key "GetShareCard200Response[todayMinutes]" is missing from JSON.');
        assert(json[r'todayMinutes'] != null, 'Required key "GetShareCard200Response[todayMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "GetShareCard200Response[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "GetShareCard200Response[language]" has a null value in JSON.');
        assert(json.containsKey(r'code'), 'Required key "GetShareCard200Response[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "GetShareCard200Response[code]" has a null value in JSON.');
        assert(json.containsKey(r'link'), 'Required key "GetShareCard200Response[link]" is missing from JSON.');
        assert(json[r'link'] != null, 'Required key "GetShareCard200Response[link]" has a null value in JSON.');
        assert(json.containsKey(r'refereeCoins'), 'Required key "GetShareCard200Response[refereeCoins]" is missing from JSON.');
        assert(json[r'refereeCoins'] != null, 'Required key "GetShareCard200Response[refereeCoins]" has a null value in JSON.');
        return true;
      }());

      return GetShareCard200Response(
        todayMinutes: mapValueOfType<int>(json, r'todayMinutes')!,
        language: mapValueOfType<String>(json, r'language')!,
        code: mapValueOfType<String>(json, r'code')!,
        link: mapValueOfType<String>(json, r'link')!,
        refereeCoins: mapValueOfType<int>(json, r'refereeCoins')!,
      );
    }
    return null;
  }

  static List<GetShareCard200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetShareCard200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetShareCard200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetShareCard200Response> mapFromJson(dynamic json) {
    final map = <String, GetShareCard200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetShareCard200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetShareCard200Response-objects as value to a dart map
  static Map<String, List<GetShareCard200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetShareCard200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetShareCard200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'todayMinutes',
    'language',
    'code',
    'link',
    'refereeCoins',
  };
}

