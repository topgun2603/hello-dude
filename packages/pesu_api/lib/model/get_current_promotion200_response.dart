//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCurrentPromotion200Response {
  /// Returns a new [GetCurrentPromotion200Response] instance.
  GetCurrentPromotion200Response({
    required this.promotion,
  });

  Promotion? promotion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCurrentPromotion200Response &&
    other.promotion == promotion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (promotion == null ? 0 : promotion!.hashCode);

  @override
  String toString() => 'GetCurrentPromotion200Response[promotion=$promotion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.promotion != null) {
      json[r'promotion'] = this.promotion;
    } else {
      json[r'promotion'] = null;
    }
    return json;
  }

  /// Returns a new [GetCurrentPromotion200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCurrentPromotion200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'promotion'), 'Required key "GetCurrentPromotion200Response[promotion]" is missing from JSON.');
        return true;
      }());

      return GetCurrentPromotion200Response(
        promotion: Promotion.fromJson(json[r'promotion']),
      );
    }
    return null;
  }

  static List<GetCurrentPromotion200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCurrentPromotion200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCurrentPromotion200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCurrentPromotion200Response> mapFromJson(dynamic json) {
    final map = <String, GetCurrentPromotion200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCurrentPromotion200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCurrentPromotion200Response-objects as value to a dart map
  static Map<String, List<GetCurrentPromotion200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCurrentPromotion200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCurrentPromotion200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'promotion',
  };
}

