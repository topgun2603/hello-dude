//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ProfileInputCompanion {
  /// Returns a new [ProfileInputCompanion] instance.
  ProfileInputCompanion({
    required this.kycStatus,
    required this.videoEnabled,
  });

  ProfileInputCompanionKycStatusEnum kycStatus;

  bool videoEnabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileInputCompanion &&
    other.kycStatus == kycStatus &&
    other.videoEnabled == videoEnabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kycStatus.hashCode) +
    (videoEnabled.hashCode);

  @override
  String toString() => 'ProfileInputCompanion[kycStatus=$kycStatus, videoEnabled=$videoEnabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kycStatus'] = this.kycStatus;
      json[r'videoEnabled'] = this.videoEnabled;
    return json;
  }

  /// Returns a new [ProfileInputCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProfileInputCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kycStatus'), 'Required key "ProfileInputCompanion[kycStatus]" is missing from JSON.');
        assert(json[r'kycStatus'] != null, 'Required key "ProfileInputCompanion[kycStatus]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "ProfileInputCompanion[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "ProfileInputCompanion[videoEnabled]" has a null value in JSON.');
        return true;
      }());

      return ProfileInputCompanion(
        kycStatus: ProfileInputCompanionKycStatusEnum.fromJson(json[r'kycStatus'])!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
      );
    }
    return null;
  }

  static List<ProfileInputCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileInputCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileInputCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfileInputCompanion> mapFromJson(dynamic json) {
    final map = <String, ProfileInputCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProfileInputCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfileInputCompanion-objects as value to a dart map
  static Map<String, List<ProfileInputCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProfileInputCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfileInputCompanion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kycStatus',
    'videoEnabled',
  };
}


enum ProfileInputCompanionKycStatusEnum {
  pending._(r'pending'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const ProfileInputCompanionKycStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ProfileInputCompanionKycStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ProfileInputCompanionKycStatusEnum? fromJson(dynamic value) => ProfileInputCompanionKycStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ProfileInputCompanionKycStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ProfileInputCompanionKycStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileInputCompanionKycStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileInputCompanionKycStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileInputCompanionKycStatusEnum] to String,
/// and [decode] dynamic data back to [ProfileInputCompanionKycStatusEnum].
class ProfileInputCompanionKycStatusEnumTypeTransformer {
  factory ProfileInputCompanionKycStatusEnumTypeTransformer() => _instance ??= const ProfileInputCompanionKycStatusEnumTypeTransformer._();

  const ProfileInputCompanionKycStatusEnumTypeTransformer._();

  String encode(ProfileInputCompanionKycStatusEnum data) => data._value;

  /// Returns the instance of [ProfileInputCompanionKycStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileInputCompanionKycStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ProfileInputCompanionKycStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return ProfileInputCompanionKycStatusEnum.pending;
        case r'approved': return ProfileInputCompanionKycStatusEnum.approved;
        case r'rejected': return ProfileInputCompanionKycStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ProfileInputCompanionKycStatusEnumTypeTransformer? _instance;
}


