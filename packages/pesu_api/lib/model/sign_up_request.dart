//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SignUpRequest {
  /// Returns a new [SignUpRequest] instance.
  SignUpRequest({
    required this.signupToken,
    required this.gender,
    required this.language,
    this.displayName,
    this.avatarId,
    required this.ageConfirmed,
    this.referralCode,
  });

  String signupToken;

  SignUpRequestGenderEnum gender;

  String language;

  String? displayName;

  /// Minimum value: 1
  /// Maximum value: 50
  int? avatarId;

  /// User confirmed they are 18+ and accepted the terms
  bool ageConfirmed;

  /// A friend's invite code (optional)
  String? referralCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SignUpRequest &&
    other.signupToken == signupToken &&
    other.gender == gender &&
    other.language == language &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.ageConfirmed == ageConfirmed &&
    other.referralCode == referralCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (signupToken.hashCode) +
    (gender.hashCode) +
    (language.hashCode) +
    (displayName == null ? 0 : displayName!.hashCode) +
    (avatarId == null ? 0 : avatarId!.hashCode) +
    (ageConfirmed.hashCode) +
    (referralCode == null ? 0 : referralCode!.hashCode);

  @override
  String toString() => 'SignUpRequest[signupToken=$signupToken, gender=$gender, language=$language, displayName=$displayName, avatarId=$avatarId, ageConfirmed=$ageConfirmed, referralCode=$referralCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'signupToken'] = this.signupToken;
      json[r'gender'] = this.gender;
      json[r'language'] = this.language;
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
    if (this.avatarId != null) {
      json[r'avatarId'] = this.avatarId;
    } else {
      json[r'avatarId'] = null;
    }
      json[r'ageConfirmed'] = this.ageConfirmed;
    if (this.referralCode != null) {
      json[r'referralCode'] = this.referralCode;
    } else {
      json[r'referralCode'] = null;
    }
    return json;
  }

  /// Returns a new [SignUpRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SignUpRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'signupToken'), 'Required key "SignUpRequest[signupToken]" is missing from JSON.');
        assert(json[r'signupToken'] != null, 'Required key "SignUpRequest[signupToken]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "SignUpRequest[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "SignUpRequest[gender]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "SignUpRequest[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "SignUpRequest[language]" has a null value in JSON.');
        assert(json.containsKey(r'ageConfirmed'), 'Required key "SignUpRequest[ageConfirmed]" is missing from JSON.');
        assert(json[r'ageConfirmed'] != null, 'Required key "SignUpRequest[ageConfirmed]" has a null value in JSON.');
        return true;
      }());

      return SignUpRequest(
        signupToken: mapValueOfType<String>(json, r'signupToken')!,
        gender: SignUpRequestGenderEnum.fromJson(json[r'gender'])!,
        language: mapValueOfType<String>(json, r'language')!,
        displayName: mapValueOfType<String>(json, r'displayName'),
        avatarId: mapValueOfType<int>(json, r'avatarId'),
        ageConfirmed: mapValueOfType<bool>(json, r'ageConfirmed')!,
        referralCode: mapValueOfType<String>(json, r'referralCode'),
      );
    }
    return null;
  }

  static List<SignUpRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SignUpRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SignUpRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SignUpRequest> mapFromJson(dynamic json) {
    final map = <String, SignUpRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SignUpRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SignUpRequest-objects as value to a dart map
  static Map<String, List<SignUpRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SignUpRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SignUpRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'signupToken',
    'gender',
    'language',
    'ageConfirmed',
  };
}


enum SignUpRequestGenderEnum {
  male._(r'male'),
  female._(r'female'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const SignUpRequestGenderEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [SignUpRequestGenderEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static SignUpRequestGenderEnum? fromJson(dynamic value) => SignUpRequestGenderEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [SignUpRequestGenderEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<SignUpRequestGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SignUpRequestGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SignUpRequestGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SignUpRequestGenderEnum] to String,
/// and [decode] dynamic data back to [SignUpRequestGenderEnum].
class SignUpRequestGenderEnumTypeTransformer {
  factory SignUpRequestGenderEnumTypeTransformer() => _instance ??= const SignUpRequestGenderEnumTypeTransformer._();

  const SignUpRequestGenderEnumTypeTransformer._();

  String encode(SignUpRequestGenderEnum data) => data._value;

  /// Returns the instance of [SignUpRequestGenderEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SignUpRequestGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is SignUpRequestGenderEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'male': return SignUpRequestGenderEnum.male;
        case r'female': return SignUpRequestGenderEnum.female;
        case r'other': return SignUpRequestGenderEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static SignUpRequestGenderEnumTypeTransformer? _instance;
}


