//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class VerifyRazorpayPaymentRequest {
  /// Returns a new [VerifyRazorpayPaymentRequest] instance.
  VerifyRazorpayPaymentRequest({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  String orderId;

  String paymentId;

  String signature;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerifyRazorpayPaymentRequest &&
    other.orderId == orderId &&
    other.paymentId == paymentId &&
    other.signature == signature;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (orderId.hashCode) +
    (paymentId.hashCode) +
    (signature.hashCode);

  @override
  String toString() => 'VerifyRazorpayPaymentRequest[orderId=$orderId, paymentId=$paymentId, signature=$signature]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'orderId'] = this.orderId;
      json[r'paymentId'] = this.paymentId;
      json[r'signature'] = this.signature;
    return json;
  }

  /// Returns a new [VerifyRazorpayPaymentRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VerifyRazorpayPaymentRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'orderId'), 'Required key "VerifyRazorpayPaymentRequest[orderId]" is missing from JSON.');
        assert(json[r'orderId'] != null, 'Required key "VerifyRazorpayPaymentRequest[orderId]" has a null value in JSON.');
        assert(json.containsKey(r'paymentId'), 'Required key "VerifyRazorpayPaymentRequest[paymentId]" is missing from JSON.');
        assert(json[r'paymentId'] != null, 'Required key "VerifyRazorpayPaymentRequest[paymentId]" has a null value in JSON.');
        assert(json.containsKey(r'signature'), 'Required key "VerifyRazorpayPaymentRequest[signature]" is missing from JSON.');
        assert(json[r'signature'] != null, 'Required key "VerifyRazorpayPaymentRequest[signature]" has a null value in JSON.');
        return true;
      }());

      return VerifyRazorpayPaymentRequest(
        orderId: mapValueOfType<String>(json, r'orderId')!,
        paymentId: mapValueOfType<String>(json, r'paymentId')!,
        signature: mapValueOfType<String>(json, r'signature')!,
      );
    }
    return null;
  }

  static List<VerifyRazorpayPaymentRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerifyRazorpayPaymentRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerifyRazorpayPaymentRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerifyRazorpayPaymentRequest> mapFromJson(dynamic json) {
    final map = <String, VerifyRazorpayPaymentRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VerifyRazorpayPaymentRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerifyRazorpayPaymentRequest-objects as value to a dart map
  static Map<String, List<VerifyRazorpayPaymentRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerifyRazorpayPaymentRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerifyRazorpayPaymentRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'orderId',
    'paymentId',
    'signature',
  };
}

