//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Profile {
  /// Returns a new [Profile] instance.
  Profile({
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

  ProfileGenderEnum gender;

  ProfileRoleEnum role;

  String primaryLanguage;

  List<String> languages;

  /// Masked, e.g. +91 ••••••3210
  String phone;

  ProfileCompanion? companion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Profile &&
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
  String toString() => 'Profile[id=$id, displayName=$displayName, avatarId=$avatarId, gender=$gender, role=$role, primaryLanguage=$primaryLanguage, languages=$languages, phone=$phone, companion=$companion]';

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

  /// Returns a new [Profile] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Profile? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Profile[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Profile[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "Profile[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "Profile[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "Profile[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "Profile[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "Profile[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "Profile[gender]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "Profile[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "Profile[role]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "Profile[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "Profile[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "Profile[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "Profile[languages]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "Profile[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "Profile[phone]" has a null value in JSON.');
        assert(json.containsKey(r'companion'), 'Required key "Profile[companion]" is missing from JSON.');
        return true;
      }());

      return Profile(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        gender: ProfileGenderEnum.fromJson(json[r'gender'])!,
        role: ProfileRoleEnum.fromJson(json[r'role'])!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        phone: mapValueOfType<String>(json, r'phone')!,
        companion: ProfileCompanion.fromJson(json[r'companion']),
      );
    }
    return null;
  }

  static List<Profile> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Profile>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Profile.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Profile> mapFromJson(dynamic json) {
    final map = <String, Profile>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Profile.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Profile-objects as value to a dart map
  static Map<String, List<Profile>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Profile>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Profile.listFromJson(entry.value, growable: growable,);
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


enum ProfileGenderEnum {
  male._(r'male'),
  female._(r'female'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileGenderEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileGenderEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileGenderEnum? fromJson(dynamic value) => ProfileGenderEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileGenderEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileGenderEnum] to String,
/// and [decode] dynamic data back to [ProfileGenderEnum].
class ProfileGenderEnumTypeTransformer {
  factory ProfileGenderEnumTypeTransformer() => _instance ??= const ProfileGenderEnumTypeTransformer._();

  const ProfileGenderEnumTypeTransformer._();

  String encode(ProfileGenderEnum data) => data._value;

  /// Returns the instance of [ProfileGenderEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileGenderEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'male': return ProfileGenderEnum.male;
        case r'female': return ProfileGenderEnum.female;
        case r'other': return ProfileGenderEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileGenderEnumTypeTransformer? _instance;
}



enum ProfileRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileRoleEnum? fromJson(dynamic value) => ProfileRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRoleEnum] to String,
/// and [decode] dynamic data back to [ProfileRoleEnum].
class ProfileRoleEnumTypeTransformer {
  factory ProfileRoleEnumTypeTransformer() => _instance ??= const ProfileRoleEnumTypeTransformer._();

  const ProfileRoleEnumTypeTransformer._();

  String encode(ProfileRoleEnum data) => data._value;

  /// Returns the instance of [ProfileRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return ProfileRoleEnum.caller;
        case r'companion': return ProfileRoleEnum.companion;
        case r'admin': return ProfileRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileRoleEnumTypeTransformer? _instance;
}


