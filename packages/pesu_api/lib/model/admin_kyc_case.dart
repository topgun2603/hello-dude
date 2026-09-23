//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycCase {
  /// Returns a new [AdminKycCase] instance.
  AdminKycCase({
    required this.userId,
    required this.displayName,
    required this.phone,
    required this.gender,
    required this.primaryLanguage,
    required this.status,
    required this.submittedAt,
    required this.aadhaar,
    required this.selfieBlinks,
    required this.panLast4,
    required this.upi,
    required this.rejectReason,
    required this.videoEnabled,
    required this.academy,
    this.documents = const [],
  });

  String userId;

  String displayName;

  String phone;

  String gender;

  String primaryLanguage;

  AdminKycCaseStatusEnum status;

  DateTime? submittedAt;

  AdminKycCaseAadhaar aadhaar;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? selfieBlinks;

  String? panLast4;

  String? upi;

  String? rejectReason;

  bool videoEnabled;

  AdminKycCaseAcademy academy;

  List<AdminKycCaseDocumentsEnum> documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycCase &&
    other.userId == userId &&
    other.displayName == displayName &&
    other.phone == phone &&
    other.gender == gender &&
    other.primaryLanguage == primaryLanguage &&
    other.status == status &&
    other.submittedAt == submittedAt &&
    other.aadhaar == aadhaar &&
    other.selfieBlinks == selfieBlinks &&
    other.panLast4 == panLast4 &&
    other.upi == upi &&
    other.rejectReason == rejectReason &&
    other.videoEnabled == videoEnabled &&
    other.academy == academy &&
    _deepEquality.equals(other.documents, documents);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (displayName.hashCode) +
    (phone.hashCode) +
    (gender.hashCode) +
    (primaryLanguage.hashCode) +
    (status.hashCode) +
    (submittedAt == null ? 0 : submittedAt!.hashCode) +
    (aadhaar.hashCode) +
    (selfieBlinks == null ? 0 : selfieBlinks!.hashCode) +
    (panLast4 == null ? 0 : panLast4!.hashCode) +
    (upi == null ? 0 : upi!.hashCode) +
    (rejectReason == null ? 0 : rejectReason!.hashCode) +
    (videoEnabled.hashCode) +
    (academy.hashCode) +
    (documents.hashCode);

  @override
  String toString() => 'AdminKycCase[userId=$userId, displayName=$displayName, phone=$phone, gender=$gender, primaryLanguage=$primaryLanguage, status=$status, submittedAt=$submittedAt, aadhaar=$aadhaar, selfieBlinks=$selfieBlinks, panLast4=$panLast4, upi=$upi, rejectReason=$rejectReason, videoEnabled=$videoEnabled, academy=$academy, documents=$documents]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'gender'] = this.gender;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'status'] = this.status;
    if (this.submittedAt != null) {
      json[r'submittedAt'] = this.submittedAt!.toUtc().toIso8601String();
    } else {
      json[r'submittedAt'] = null;
    }
      json[r'aadhaar'] = this.aadhaar;
    if (this.selfieBlinks != null) {
      json[r'selfieBlinks'] = this.selfieBlinks;
    } else {
      json[r'selfieBlinks'] = null;
    }
    if (this.panLast4 != null) {
      json[r'panLast4'] = this.panLast4;
    } else {
      json[r'panLast4'] = null;
    }
    if (this.upi != null) {
      json[r'upi'] = this.upi;
    } else {
      json[r'upi'] = null;
    }
    if (this.rejectReason != null) {
      json[r'rejectReason'] = this.rejectReason;
    } else {
      json[r'rejectReason'] = null;
    }
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'academy'] = this.academy;
      json[r'documents'] = this.documents;
    return json;
  }

  /// Returns a new [AdminKycCase] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycCase? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'userId'), 'Required key "AdminKycCase[userId]" is missing from JSON.');
        assert(json[r'userId'] != null, 'Required key "AdminKycCase[userId]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminKycCase[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminKycCase[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminKycCase[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminKycCase[phone]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "AdminKycCase[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "AdminKycCase[gender]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminKycCase[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminKycCase[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminKycCase[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminKycCase[status]" has a null value in JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "AdminKycCase[submittedAt]" is missing from JSON.');
        assert(json.containsKey(r'aadhaar'), 'Required key "AdminKycCase[aadhaar]" is missing from JSON.');
        assert(json[r'aadhaar'] != null, 'Required key "AdminKycCase[aadhaar]" has a null value in JSON.');
        assert(json.containsKey(r'selfieBlinks'), 'Required key "AdminKycCase[selfieBlinks]" is missing from JSON.');
        assert(json.containsKey(r'panLast4'), 'Required key "AdminKycCase[panLast4]" is missing from JSON.');
        assert(json.containsKey(r'upi'), 'Required key "AdminKycCase[upi]" is missing from JSON.');
        assert(json.containsKey(r'rejectReason'), 'Required key "AdminKycCase[rejectReason]" is missing from JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "AdminKycCase[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "AdminKycCase[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'academy'), 'Required key "AdminKycCase[academy]" is missing from JSON.');
        assert(json[r'academy'] != null, 'Required key "AdminKycCase[academy]" has a null value in JSON.');
        assert(json.containsKey(r'documents'), 'Required key "AdminKycCase[documents]" is missing from JSON.');
        assert(json[r'documents'] != null, 'Required key "AdminKycCase[documents]" has a null value in JSON.');
        return true;
      }());

      return AdminKycCase(
        userId: mapValueOfType<String>(json, r'userId')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        gender: mapValueOfType<String>(json, r'gender')!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        status: AdminKycCaseStatusEnum.fromJson(json[r'status'])!,
        submittedAt: mapDateTime(json, r'submittedAt', r''),
        aadhaar: AdminKycCaseAadhaar.fromJson(json[r'aadhaar'])!,
        selfieBlinks: mapValueOfType<int>(json, r'selfieBlinks'),
        panLast4: mapValueOfType<String>(json, r'panLast4'),
        upi: mapValueOfType<String>(json, r'upi'),
        rejectReason: mapValueOfType<String>(json, r'rejectReason'),
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        academy: AdminKycCaseAcademy.fromJson(json[r'academy'])!,
        documents: AdminKycCaseDocumentsEnum.listFromJson(json[r'documents']),
      );
    }
    return null;
  }

  static List<AdminKycCase> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCase>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCase.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycCase> mapFromJson(dynamic json) {
    final map = <String, AdminKycCase>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycCase.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycCase-objects as value to a dart map
  static Map<String, List<AdminKycCase>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycCase>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycCase.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'userId',
    'displayName',
    'phone',
    'gender',
    'primaryLanguage',
    'status',
    'submittedAt',
    'aadhaar',
    'selfieBlinks',
    'panLast4',
    'upi',
    'rejectReason',
    'videoEnabled',
    'academy',
    'documents',
  };
}


enum AdminKycCaseStatusEnum {
  submitted._(r'submitted'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  inProgress._(r'in_progress'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycCaseStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycCaseStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycCaseStatusEnum? fromJson(dynamic value) => AdminKycCaseStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycCaseStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycCaseStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycCaseStatusEnum] to String,
/// and [decode] dynamic data back to [AdminKycCaseStatusEnum].
class AdminKycCaseStatusEnumTypeTransformer {
  factory AdminKycCaseStatusEnumTypeTransformer() => _instance ??= const AdminKycCaseStatusEnumTypeTransformer._();

  const AdminKycCaseStatusEnumTypeTransformer._();

  String encode(AdminKycCaseStatusEnum data) => data._value;

  /// Returns the instance of [AdminKycCaseStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycCaseStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycCaseStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'submitted': return AdminKycCaseStatusEnum.submitted;
        case r'approved': return AdminKycCaseStatusEnum.approved;
        case r'rejected': return AdminKycCaseStatusEnum.rejected;
        case r'in_progress': return AdminKycCaseStatusEnum.inProgress;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycCaseStatusEnumTypeTransformer? _instance;
}



enum AdminKycCaseDocumentsEnum {
  aadhaarPhoto._(r'aadhaar_photo'),
  selfie._(r'selfie'),
  pan._(r'pan'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycCaseDocumentsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycCaseDocumentsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycCaseDocumentsEnum? fromJson(dynamic value) => AdminKycCaseDocumentsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycCaseDocumentsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycCaseDocumentsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseDocumentsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseDocumentsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycCaseDocumentsEnum] to String,
/// and [decode] dynamic data back to [AdminKycCaseDocumentsEnum].
class AdminKycCaseDocumentsEnumTypeTransformer {
  factory AdminKycCaseDocumentsEnumTypeTransformer() => _instance ??= const AdminKycCaseDocumentsEnumTypeTransformer._();

  const AdminKycCaseDocumentsEnumTypeTransformer._();

  String encode(AdminKycCaseDocumentsEnum data) => data._value;

  /// Returns the instance of [AdminKycCaseDocumentsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycCaseDocumentsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycCaseDocumentsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'aadhaar_photo': return AdminKycCaseDocumentsEnum.aadhaarPhoto;
        case r'selfie': return AdminKycCaseDocumentsEnum.selfie;
        case r'pan': return AdminKycCaseDocumentsEnum.pan;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycCaseDocumentsEnumTypeTransformer? _instance;
}


