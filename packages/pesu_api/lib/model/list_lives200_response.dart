//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListLives200Response {
  /// Returns a new [ListLives200Response] instance.
  ListLives200Response({
    this.lives = const [],
    required this.pricing,
  });

  List<LiveCard> lives;

  LivePricing pricing;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListLives200Response &&
    _deepEquality.equals(other.lives, lives) &&
    other.pricing == pricing;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (lives.hashCode) +
    (pricing.hashCode);

  @override
  String toString() => 'ListLives200Response[lives=$lives, pricing=$pricing]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'lives'] = this.lives;
      json[r'pricing'] = this.pricing;
    return json;
  }

  /// Returns a new [ListLives200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListLives200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'lives'), 'Required key "ListLives200Response[lives]" is missing from JSON.');
        assert(json[r'lives'] != null, 'Required key "ListLives200Response[lives]" has a null value in JSON.');
        assert(json.containsKey(r'pricing'), 'Required key "ListLives200Response[pricing]" is missing from JSON.');
        assert(json[r'pricing'] != null, 'Required key "ListLives200Response[pricing]" has a null value in JSON.');
        return true;
      }());

      return ListLives200Response(
        lives: LiveCard.listFromJson(json[r'lives']),
        pricing: LivePricing.fromJson(json[r'pricing'])!,
      );
    }
    return null;
  }

  static List<ListLives200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListLives200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListLives200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListLives200Response> mapFromJson(dynamic json) {
    final map = <String, ListLives200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListLives200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListLives200Response-objects as value to a dart map
  static Map<String, List<ListLives200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListLives200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListLives200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'lives',
    'pricing',
  };
}

