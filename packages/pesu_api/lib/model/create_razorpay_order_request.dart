//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CreateRazorpayOrderRequest {
  /// Returns a new [CreateRazorpayOrderRequest] instance.
  CreateRazorpayOrderRequest({
    required this.sku,
  });

  String sku;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateRazorpayOrderRequest &&
    other.sku == sku;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sku.hashCode);

  @override
  String toString() => 'CreateRazorpayOrderRequest[sku=$sku]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'sku'] = this.sku;
    return json;
  }

  /// Returns a new [CreateRazorpayOrderRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateRazorpayOrderRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sku'), 'Required key "CreateRazorpayOrderRequest[sku]" is missing from JSON.');
        assert(json[r'sku'] != null, 'Required key "CreateRazorpayOrderRequest[sku]" has a null value in JSON.');
        return true;
      }());

      return CreateRazorpayOrderRequest(
        sku: mapValueOfType<String>(json, r'sku')!,
      );
    }
    return null;
  }

  static List<CreateRazorpayOrderRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateRazorpayOrderRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateRazorpayOrderRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateRazorpayOrderRequest> mapFromJson(dynamic json) {
    final map = <String, CreateRazorpayOrderRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateRazorpayOrderRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateRazorpayOrderRequest-objects as value to a dart map
  static Map<String, List<CreateRazorpayOrderRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateRazorpayOrderRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateRazorpayOrderRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sku',
  };
}

