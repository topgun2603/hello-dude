//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class OtpVerifyResult {
  /// Returns a new [OtpVerifyResult] instance.
  OtpVerifyResult({
    required this.status,
    this.tokens,
    this.profile,
    this.signupToken,
  });

  OtpVerifyResultStatusEnum status;

  /// Set when status = signed_in
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TokenPair? tokens;

  /// Set when status = signed_in
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Profile? profile;

  /// Set when status = needs_signup
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? signupToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OtpVerifyResult &&
    other.status == status &&
    other.tokens == tokens &&
    other.profile == profile &&
    other.signupToken == signupToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (tokens == null ? 0 : tokens!.hashCode) +
    (profile == null ? 0 : profile!.hashCode) +
    (signupToken == null ? 0 : signupToken!.hashCode);

  @override
  String toString() => 'OtpVerifyResult[status=$status, tokens=$tokens, profile=$profile, signupToken=$signupToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
    if (this.tokens != null) {
      json[r'tokens'] = this.tokens;
    } else {
      json[r'tokens'] = null;
    }
    if (this.profile != null) {
      json[r'profile'] = this.profile;
    } else {
      json[r'profile'] = null;
    }
    if (this.signupToken != null) {
      json[r'signupToken'] = this.signupToken;
    } else {
      json[r'signupToken'] = null;
    }
    return json;
  }

  /// Returns a new [OtpVerifyResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OtpVerifyResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "OtpVerifyResult[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "OtpVerifyResult[status]" has a null value in JSON.');
        return true;
      }());

      return OtpVerifyResult(
        status: OtpVerifyResultStatusEnum.fromJson(json[r'status'])!,
        tokens: TokenPair.fromJson(json[r'tokens']),
        profile: Profile.fromJson(json[r'profile']),
        signupToken: mapValueOfType<String>(json, r'signupToken'),
      );
    }
    return null;
  }

  static List<OtpVerifyResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpVerifyResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpVerifyResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OtpVerifyResult> mapFromJson(dynamic json) {
    final map = <String, OtpVerifyResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OtpVerifyResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OtpVerifyResult-objects as value to a dart map
  static Map<String, List<OtpVerifyResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OtpVerifyResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OtpVerifyResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
  };
}


enum OtpVerifyResultStatusEnum {
  signedIn._(r'signed_in'),
  needsSignup._(r'needs_signup'),
  ;

  /// Instantiate a new enum with the provided value.
  const OtpVerifyResultStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [OtpVerifyResultStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static OtpVerifyResultStatusEnum? fromJson(dynamic value) => OtpVerifyResultStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [OtpVerifyResultStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<OtpVerifyResultStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OtpVerifyResultStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OtpVerifyResultStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OtpVerifyResultStatusEnum] to String,
/// and [decode] dynamic data back to [OtpVerifyResultStatusEnum].
class OtpVerifyResultStatusEnumTypeTransformer {
  factory OtpVerifyResultStatusEnumTypeTransformer() => _instance ??= const OtpVerifyResultStatusEnumTypeTransformer._();

  const OtpVerifyResultStatusEnumTypeTransformer._();

  String encode(OtpVerifyResultStatusEnum data) => data._value;

  /// Returns the instance of [OtpVerifyResultStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OtpVerifyResultStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is OtpVerifyResultStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'signed_in': return OtpVerifyResultStatusEnum.signedIn;
        case r'needs_signup': return OtpVerifyResultStatusEnum.needsSignup;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static OtpVerifyResultStatusEnumTypeTransformer? _instance;
}


