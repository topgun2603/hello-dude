//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendOtp200Response {
  /// Returns a new [SendOtp200Response] instance.
  SendOtp200Response({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
  });

  num expiresInSeconds;

  num resendAfterSeconds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendOtp200Response &&
    other.expiresInSeconds == expiresInSeconds &&
    other.resendAfterSeconds == resendAfterSeconds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (expiresInSeconds.hashCode) +
    (resendAfterSeconds.hashCode);

  @override
  String toString() => 'SendOtp200Response[expiresInSeconds=$expiresInSeconds, resendAfterSeconds=$resendAfterSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'expiresInSeconds'] = this.expiresInSeconds;
      json[r'resendAfterSeconds'] = this.resendAfterSeconds;
    return json;
  }

  /// Returns a new [SendOtp200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendOtp200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'expiresInSeconds'), 'Required key "SendOtp200Response[expiresInSeconds]" is missing from JSON.');
        assert(json[r'expiresInSeconds'] != null, 'Required key "SendOtp200Response[expiresInSeconds]" has a null value in JSON.');
        assert(json.containsKey(r'resendAfterSeconds'), 'Required key "SendOtp200Response[resendAfterSeconds]" is missing from JSON.');
        assert(json[r'resendAfterSeconds'] != null, 'Required key "SendOtp200Response[resendAfterSeconds]" has a null value in JSON.');
        return true;
      }());

      return SendOtp200Response(
        expiresInSeconds: num.parse('${json[r'expiresInSeconds']}'),
        resendAfterSeconds: num.parse('${json[r'resendAfterSeconds']}'),
      );
    }
    return null;
  }

  static List<SendOtp200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendOtp200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendOtp200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendOtp200Response> mapFromJson(dynamic json) {
    final map = <String, SendOtp200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendOtp200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendOtp200Response-objects as value to a dart map
  static Map<String, List<SendOtp200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendOtp200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendOtp200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'expiresInSeconds',
    'resendAfterSeconds',
  };
}

