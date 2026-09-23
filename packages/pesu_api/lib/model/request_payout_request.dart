//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RequestPayoutRequest {
  /// Returns a new [RequestPayoutRequest] instance.
  RequestPayoutRequest({
    this.amountPaise,
  });

  /// Default: everything available
  ///
  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int? amountPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestPayoutRequest &&
    other.amountPaise == amountPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amountPaise == null ? 0 : amountPaise!.hashCode);

  @override
  String toString() => 'RequestPayoutRequest[amountPaise=$amountPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.amountPaise != null) {
      json[r'amountPaise'] = this.amountPaise;
    } else {
      json[r'amountPaise'] = null;
    }
    return json;
  }

  /// Returns a new [RequestPayoutRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RequestPayoutRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return RequestPayoutRequest(
        amountPaise: mapValueOfType<int>(json, r'amountPaise'),
      );
    }
    return null;
  }

  static List<RequestPayoutRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestPayoutRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestPayoutRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestPayoutRequest> mapFromJson(dynamic json) {
    final map = <String, RequestPayoutRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RequestPayoutRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestPayoutRequest-objects as value to a dart map
  static Map<String, List<RequestPayoutRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestPayoutRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestPayoutRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

