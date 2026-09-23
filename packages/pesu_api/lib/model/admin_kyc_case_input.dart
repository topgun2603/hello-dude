//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminKycCaseInput {
  /// Returns a new [AdminKycCaseInput] instance.
  AdminKycCaseInput({
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

  AdminKycCaseInputStatusEnum status;

  Object? submittedAt;

  AdminKycCaseInputAadhaar aadhaar;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? selfieBlinks;

  String? panLast4;

  String? upi;

  String? rejectReason;

  bool videoEnabled;

  AdminKycCaseInputAcademy academy;

  List<AdminKycCaseInputDocumentsEnum> documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminKycCaseInput &&
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
  String toString() => 'AdminKycCaseInput[userId=$userId, displayName=$displayName, phone=$phone, gender=$gender, primaryLanguage=$primaryLanguage, status=$status, submittedAt=$submittedAt, aadhaar=$aadhaar, selfieBlinks=$selfieBlinks, panLast4=$panLast4, upi=$upi, rejectReason=$rejectReason, videoEnabled=$videoEnabled, academy=$academy, documents=$documents]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'displayName'] = this.displayName;
      json[r'phone'] = this.phone;
      json[r'gender'] = this.gender;
      json[r'primaryLanguage'] = this.primaryLanguage;
      json[r'status'] = this.status;
    if (this.submittedAt != null) {
      json[r'submittedAt'] = this.submittedAt;
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

  /// Returns a new [AdminKycCaseInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminKycCaseInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'userId'), 'Required key "AdminKycCaseInput[userId]" is missing from JSON.');
        assert(json[r'userId'] != null, 'Required key "AdminKycCaseInput[userId]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminKycCaseInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminKycCaseInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "AdminKycCaseInput[phone]" is missing from JSON.');
        assert(json[r'phone'] != null, 'Required key "AdminKycCaseInput[phone]" has a null value in JSON.');
        assert(json.containsKey(r'gender'), 'Required key "AdminKycCaseInput[gender]" is missing from JSON.');
        assert(json[r'gender'] != null, 'Required key "AdminKycCaseInput[gender]" has a null value in JSON.');
        assert(json.containsKey(r'primaryLanguage'), 'Required key "AdminKycCaseInput[primaryLanguage]" is missing from JSON.');
        assert(json[r'primaryLanguage'] != null, 'Required key "AdminKycCaseInput[primaryLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminKycCaseInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminKycCaseInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'submittedAt'), 'Required key "AdminKycCaseInput[submittedAt]" is missing from JSON.');
        assert(json.containsKey(r'aadhaar'), 'Required key "AdminKycCaseInput[aadhaar]" is missing from JSON.');
        assert(json[r'aadhaar'] != null, 'Required key "AdminKycCaseInput[aadhaar]" has a null value in JSON.');
        assert(json.containsKey(r'selfieBlinks'), 'Required key "AdminKycCaseInput[selfieBlinks]" is missing from JSON.');
        assert(json.containsKey(r'panLast4'), 'Required key "AdminKycCaseInput[panLast4]" is missing from JSON.');
        assert(json.containsKey(r'upi'), 'Required key "AdminKycCaseInput[upi]" is missing from JSON.');
        assert(json.containsKey(r'rejectReason'), 'Required key "AdminKycCaseInput[rejectReason]" is missing from JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "AdminKycCaseInput[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "AdminKycCaseInput[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'academy'), 'Required key "AdminKycCaseInput[academy]" is missing from JSON.');
        assert(json[r'academy'] != null, 'Required key "AdminKycCaseInput[academy]" has a null value in JSON.');
        assert(json.containsKey(r'documents'), 'Required key "AdminKycCaseInput[documents]" is missing from JSON.');
        assert(json[r'documents'] != null, 'Required key "AdminKycCaseInput[documents]" has a null value in JSON.');
        return true;
      }());

      return AdminKycCaseInput(
        userId: mapValueOfType<String>(json, r'userId')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone')!,
        gender: mapValueOfType<String>(json, r'gender')!,
        primaryLanguage: mapValueOfType<String>(json, r'primaryLanguage')!,
        status: AdminKycCaseInputStatusEnum.fromJson(json[r'status'])!,
        submittedAt: mapValueOfType<Object>(json, r'submittedAt'),
        aadhaar: AdminKycCaseInputAadhaar.fromJson(json[r'aadhaar'])!,
        selfieBlinks: mapValueOfType<int>(json, r'selfieBlinks'),
        panLast4: mapValueOfType<String>(json, r'panLast4'),
        upi: mapValueOfType<String>(json, r'upi'),
        rejectReason: mapValueOfType<String>(json, r'rejectReason'),
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        academy: AdminKycCaseInputAcademy.fromJson(json[r'academy'])!,
        documents: AdminKycCaseInputDocumentsEnum.listFromJson(json[r'documents']),
      );
    }
    return null;
  }

  static List<AdminKycCaseInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminKycCaseInput> mapFromJson(dynamic json) {
    final map = <String, AdminKycCaseInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminKycCaseInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminKycCaseInput-objects as value to a dart map
  static Map<String, List<AdminKycCaseInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminKycCaseInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminKycCaseInput.listFromJson(entry.value, growable: growable,);
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


enum AdminKycCaseInputStatusEnum {
  submitted._(r'submitted'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  inProgress._(r'in_progress'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycCaseInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycCaseInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycCaseInputStatusEnum? fromJson(dynamic value) => AdminKycCaseInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycCaseInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycCaseInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycCaseInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminKycCaseInputStatusEnum].
class AdminKycCaseInputStatusEnumTypeTransformer {
  factory AdminKycCaseInputStatusEnumTypeTransformer() => _instance ??= const AdminKycCaseInputStatusEnumTypeTransformer._();

  const AdminKycCaseInputStatusEnumTypeTransformer._();

  String encode(AdminKycCaseInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminKycCaseInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycCaseInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycCaseInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'submitted': return AdminKycCaseInputStatusEnum.submitted;
        case r'approved': return AdminKycCaseInputStatusEnum.approved;
        case r'rejected': return AdminKycCaseInputStatusEnum.rejected;
        case r'in_progress': return AdminKycCaseInputStatusEnum.inProgress;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycCaseInputStatusEnumTypeTransformer? _instance;
}



enum AdminKycCaseInputDocumentsEnum {
  aadhaarPhoto._(r'aadhaar_photo'),
  selfie._(r'selfie'),
  pan._(r'pan'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminKycCaseInputDocumentsEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminKycCaseInputDocumentsEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminKycCaseInputDocumentsEnum? fromJson(dynamic value) => AdminKycCaseInputDocumentsEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminKycCaseInputDocumentsEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminKycCaseInputDocumentsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminKycCaseInputDocumentsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminKycCaseInputDocumentsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminKycCaseInputDocumentsEnum] to String,
/// and [decode] dynamic data back to [AdminKycCaseInputDocumentsEnum].
class AdminKycCaseInputDocumentsEnumTypeTransformer {
  factory AdminKycCaseInputDocumentsEnumTypeTransformer() => _instance ??= const AdminKycCaseInputDocumentsEnumTypeTransformer._();

  const AdminKycCaseInputDocumentsEnumTypeTransformer._();

  String encode(AdminKycCaseInputDocumentsEnum data) => data._value;

  /// Returns the instance of [AdminKycCaseInputDocumentsEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminKycCaseInputDocumentsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminKycCaseInputDocumentsEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'aadhaar_photo': return AdminKycCaseInputDocumentsEnum.aadhaarPhoto;
        case r'selfie': return AdminKycCaseInputDocumentsEnum.selfie;
        case r'pan': return AdminKycCaseInputDocumentsEnum.pan;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminKycCaseInputDocumentsEnumTypeTransformer? _instance;
}


