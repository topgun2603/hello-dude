//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RequestRefundRequest {
  /// Returns a new [RequestRefundRequest] instance.
  RequestRefundRequest({
    required this.reason,
    this.details,
  });

  RequestRefundRequestReasonEnum reason;

  String? details;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestRefundRequest &&
    other.reason == reason &&
    other.details == details;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode);

  @override
  String toString() => 'RequestRefundRequest[reason=$reason, details=$details]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reason'] = this.reason;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
    return json;
  }

  /// Returns a new [RequestRefundRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RequestRefundRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reason'), 'Required key "RequestRefundRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "RequestRefundRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return RequestRefundRequest(
        reason: RequestRefundRequestReasonEnum.fromJson(json[r'reason'])!,
        details: mapValueOfType<String>(json, r'details'),
      );
    }
    return null;
  }

  static List<RequestRefundRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestRefundRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestRefundRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestRefundRequest> mapFromJson(dynamic json) {
    final map = <String, RequestRefundRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RequestRefundRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestRefundRequest-objects as value to a dart map
  static Map<String, List<RequestRefundRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestRefundRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestRefundRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reason',
  };
}


enum RequestRefundRequestReasonEnum {
  callDropped._(r'call_dropped'),
  couldntHear._(r'couldnt_hear'),
  wrongLanguage._(r'wrong_language'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const RequestRefundRequestReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RequestRefundRequestReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RequestRefundRequestReasonEnum? fromJson(dynamic value) => RequestRefundRequestReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RequestRefundRequestReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RequestRefundRequestReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestRefundRequestReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestRefundRequestReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RequestRefundRequestReasonEnum] to String,
/// and [decode] dynamic data back to [RequestRefundRequestReasonEnum].
class RequestRefundRequestReasonEnumTypeTransformer {
  factory RequestRefundRequestReasonEnumTypeTransformer() => _instance ??= const RequestRefundRequestReasonEnumTypeTransformer._();

  const RequestRefundRequestReasonEnumTypeTransformer._();

  String encode(RequestRefundRequestReasonEnum data) => data._value;

  /// Returns the instance of [RequestRefundRequestReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RequestRefundRequestReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RequestRefundRequestReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'call_dropped': return RequestRefundRequestReasonEnum.callDropped;
        case r'couldnt_hear': return RequestRefundRequestReasonEnum.couldntHear;
        case r'wrong_language': return RequestRefundRequestReasonEnum.wrongLanguage;
        case r'other': return RequestRefundRequestReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RequestRefundRequestReasonEnumTypeTransformer? _instance;
}


