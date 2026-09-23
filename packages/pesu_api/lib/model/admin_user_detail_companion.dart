//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailCompanion {
  /// Returns a new [AdminUserDetailCompanion] instance.
  AdminUserDetailCompanion({
    required this.kycStatus,
    required this.kycVerifiedAt,
    required this.videoEnabled,
    required this.bio,
    required this.upiId,
    required this.lastOnlineAt,
    required this.rating,
    required this.ratingCount,
    required this.academyPassed,
    required this.academyTotal,
  });

  AdminUserDetailCompanionKycStatusEnum? kycStatus;

  DateTime? kycVerifiedAt;

  bool videoEnabled;

  String? bio;

  /// Masked
  String? upiId;

  DateTime? lastOnlineAt;

  num? rating;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ratingCount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int academyPassed;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int academyTotal;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailCompanion &&
    other.kycStatus == kycStatus &&
    other.kycVerifiedAt == kycVerifiedAt &&
    other.videoEnabled == videoEnabled &&
    other.bio == bio &&
    other.upiId == upiId &&
    other.lastOnlineAt == lastOnlineAt &&
    other.rating == rating &&
    other.ratingCount == ratingCount &&
    other.academyPassed == academyPassed &&
    other.academyTotal == academyTotal;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kycStatus == null ? 0 : kycStatus!.hashCode) +
    (kycVerifiedAt == null ? 0 : kycVerifiedAt!.hashCode) +
    (videoEnabled.hashCode) +
    (bio == null ? 0 : bio!.hashCode) +
    (upiId == null ? 0 : upiId!.hashCode) +
    (lastOnlineAt == null ? 0 : lastOnlineAt!.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (ratingCount.hashCode) +
    (academyPassed.hashCode) +
    (academyTotal.hashCode);

  @override
  String toString() => 'AdminUserDetailCompanion[kycStatus=$kycStatus, kycVerifiedAt=$kycVerifiedAt, videoEnabled=$videoEnabled, bio=$bio, upiId=$upiId, lastOnlineAt=$lastOnlineAt, rating=$rating, ratingCount=$ratingCount, academyPassed=$academyPassed, academyTotal=$academyTotal]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.kycStatus != null) {
      json[r'kycStatus'] = this.kycStatus;
    } else {
      json[r'kycStatus'] = null;
    }
    if (this.kycVerifiedAt != null) {
      json[r'kycVerifiedAt'] = this.kycVerifiedAt!.toUtc().toIso8601String();
    } else {
      json[r'kycVerifiedAt'] = null;
    }
      json[r'videoEnabled'] = this.videoEnabled;
    if (this.bio != null) {
      json[r'bio'] = this.bio;
    } else {
      json[r'bio'] = null;
    }
    if (this.upiId != null) {
      json[r'upiId'] = this.upiId;
    } else {
      json[r'upiId'] = null;
    }
    if (this.lastOnlineAt != null) {
      json[r'lastOnlineAt'] = this.lastOnlineAt!.toUtc().toIso8601String();
    } else {
      json[r'lastOnlineAt'] = null;
    }
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
      json[r'ratingCount'] = this.ratingCount;
      json[r'academyPassed'] = this.academyPassed;
      json[r'academyTotal'] = this.academyTotal;
    return json;
  }

  /// Returns a new [AdminUserDetailCompanion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailCompanion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kycStatus'), 'Required key "AdminUserDetailCompanion[kycStatus]" is missing from JSON.');
        assert(json.containsKey(r'kycVerifiedAt'), 'Required key "AdminUserDetailCompanion[kycVerifiedAt]" is missing from JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "AdminUserDetailCompanion[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "AdminUserDetailCompanion[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'bio'), 'Required key "AdminUserDetailCompanion[bio]" is missing from JSON.');
        assert(json.containsKey(r'upiId'), 'Required key "AdminUserDetailCompanion[upiId]" is missing from JSON.');
        assert(json.containsKey(r'lastOnlineAt'), 'Required key "AdminUserDetailCompanion[lastOnlineAt]" is missing from JSON.');
        assert(json.containsKey(r'rating'), 'Required key "AdminUserDetailCompanion[rating]" is missing from JSON.');
        assert(json.containsKey(r'ratingCount'), 'Required key "AdminUserDetailCompanion[ratingCount]" is missing from JSON.');
        assert(json[r'ratingCount'] != null, 'Required key "AdminUserDetailCompanion[ratingCount]" has a null value in JSON.');
        assert(json.containsKey(r'academyPassed'), 'Required key "AdminUserDetailCompanion[academyPassed]" is missing from JSON.');
        assert(json[r'academyPassed'] != null, 'Required key "AdminUserDetailCompanion[academyPassed]" has a null value in JSON.');
        assert(json.containsKey(r'academyTotal'), 'Required key "AdminUserDetailCompanion[academyTotal]" is missing from JSON.');
        assert(json[r'academyTotal'] != null, 'Required key "AdminUserDetailCompanion[academyTotal]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailCompanion(
        kycStatus: AdminUserDetailCompanionKycStatusEnum.fromJson(json[r'kycStatus']),
        kycVerifiedAt: mapDateTime(json, r'kycVerifiedAt', r''),
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        bio: mapValueOfType<String>(json, r'bio'),
        upiId: mapValueOfType<String>(json, r'upiId'),
        lastOnlineAt: mapDateTime(json, r'lastOnlineAt', r''),
        rating: json[r'rating'] == null
            ? null
            : num.parse('${json[r'rating']}'),
        ratingCount: mapValueOfType<int>(json, r'ratingCount')!,
        academyPassed: mapValueOfType<int>(json, r'academyPassed')!,
        academyTotal: mapValueOfType<int>(json, r'academyTotal')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailCompanion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailCompanion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailCompanion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailCompanion> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailCompanion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailCompanion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailCompanion-objects as value to a dart map
  static Map<String, List<AdminUserDetailCompanion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailCompanion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailCompanion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kycStatus',
    'kycVerifiedAt',
    'videoEnabled',
    'bio',
    'upiId',
    'lastOnlineAt',
    'rating',
    'ratingCount',
    'academyPassed',
    'academyTotal',
  };
}


enum AdminUserDetailCompanionKycStatusEnum {
  pending._(r'pending'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailCompanionKycStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailCompanionKycStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailCompanionKycStatusEnum? fromJson(dynamic value) => AdminUserDetailCompanionKycStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailCompanionKycStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailCompanionKycStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailCompanionKycStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailCompanionKycStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailCompanionKycStatusEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailCompanionKycStatusEnum].
class AdminUserDetailCompanionKycStatusEnumTypeTransformer {
  factory AdminUserDetailCompanionKycStatusEnumTypeTransformer() => _instance ??= const AdminUserDetailCompanionKycStatusEnumTypeTransformer._();

  const AdminUserDetailCompanionKycStatusEnumTypeTransformer._();

  String encode(AdminUserDetailCompanionKycStatusEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailCompanionKycStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailCompanionKycStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailCompanionKycStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return AdminUserDetailCompanionKycStatusEnum.pending;
        case r'approved': return AdminUserDetailCompanionKycStatusEnum.approved;
        case r'rejected': return AdminUserDetailCompanionKycStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailCompanionKycStatusEnumTypeTransformer? _instance;
}


