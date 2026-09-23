//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ProfileInput {
  /// Returns a new [ProfileInput] instance.
  ProfileInput({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.gender,
    required this.role,
    required this.primaryLanguage,
    this.languages = const [],
    required this.phone,
    required this.companion,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  ProfileInputGenderEnum gender;

  ProfileInputRoleEnum role;

  String primaryLanguage;

  List<String> languages;

  /// Masked, e.g. +91 ••••••3210
  String phone;

  ProfileInputCompanion? companion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileInput &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.gender == gender &&
    other.role == role &&
    other.primaryLanguage == primaryLanguage &&
    _deepEquality.equals(other.languages, languages) &&
    other.phone == phone &&
    other.companion == companion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (gender.hashCode) +
    (role.hashCode) +
    (primaryLanguage.hashCode) +
    (languages.hashCode) +
    (phone.hashCode) +
    (companion == null ? 0 : companion!.hashCode);

  @override
  String toString() => 'ProfileInput[id=$id, displayName=$displayName, avatarId=$avatarId, gender=$gender, role=$role, primaryLanguage=$primaryLanguage, languages=$languages, phone=$phone, companion=$companion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'gender'] = this.gender;
      json[r'role'] = this.role;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'languages'] = this.languages;
      json[r'phone'] = this.phone;
    if (this.companion != null) {
      json[r'companion'] = this.companion;
    } else {
      json[r'companion'] = null;
    }
    return json;
  }

  /// Returns a new [ProfileInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProfileInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ProfileInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ProfileInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "ProfileInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "ProfileInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "ProfileInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "ProfileInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "ProfileInput[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "ProfileInput[gender]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "ProfileInput[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "ProfileInput[role]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "ProfileInput[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "ProfileInput[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "ProfileInput[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "ProfileInput[languages]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "ProfileInput[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "ProfileInput[phone]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "ProfileInput[companion]" is missing from JSON.');
        return true;
      }());

      return ProfileInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        gender: ProfileInputGenderEnum.fromJson(json[r'gender'])!,
        role: ProfileInputRoleEnum.fromJson(json[r'role'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        phone: mapValueOfType<String>(json, r'phone')!,
        companion: ProfileInputCompanion.fromJson(json[r'companion']),
      );
    }
    return null;
  }

  static List<ProfileInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfileInput> mapFromJson(dynamic json) {
    final map = <String, ProfileInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProfileInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfileInput-objects as value to a dart map
  static Map<String, List<ProfileInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProfileInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfileInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'gender',
    'role',
    'primaryLanguage',
    'languages',
    'phone',
    'companion',
  };
}


enum ProfileInputGenderEnum {
  male._(r'male'),
  female._(r'female'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileInputGenderEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileInputGenderEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileInputGenderEnum? fromJson(dynamic value) => ProfileInputGenderEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileInputGenderEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileInputGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileInputGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileInputGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileInputGenderEnum] to String,
/// and [decode] dynamic data back to [ProfileInputGenderEnum].
class ProfileInputGenderEnumTypeTransformer {
  factory ProfileInputGenderEnumTypeTransformer() => _instance ??= const ProfileInputGenderEnumTypeTransformer._();

  const ProfileInputGenderEnumTypeTransformer._();

  String encode(ProfileInputGenderEnum data) => data._value;

  /// Returns the instance of [ProfileInputGenderEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileInputGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileInputGenderEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'male': return ProfileInputGenderEnum.male;
        case r'female': return ProfileInputGenderEnum.female;
        case r'other': return ProfileInputGenderEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileInputGenderEnumTypeTransformer? _instance;
}



enum ProfileInputRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileInputRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileInputRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileInputRoleEnum? fromJson(dynamic value) => ProfileInputRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileInputRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileInputRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileInputRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileInputRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileInputRoleEnum] to String,
/// and [decode] dynamic data back to [ProfileInputRoleEnum].
class ProfileInputRoleEnumTypeTransformer {
  factory ProfileInputRoleEnumTypeTransformer() => _instance ??= const ProfileInputRoleEnumTypeTransformer._();

  const ProfileInputRoleEnumTypeTransformer._();

  String encode(ProfileInputRoleEnum data) => data._value;

  /// Returns the instance of [ProfileInputRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileInputRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileInputRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return ProfileInputRoleEnum.caller;
        case r'companion': return ProfileInputRoleEnum.companion;
        case r'admin': return ProfileInputRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileInputRoleEnumTypeTransformer? _instance;
}


