//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCallRate {
  /// Returns a new [AdminCallRate] instance.
  AdminCallRate({
    required this.id,
    required this.language,
    required this.callType,
    required this.coinsPerMin,
    required this.companionPaisePerMin,
    required this.effectiveFrom,
    required this.status,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String language;

  AdminCallRateCallTypeEnum callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionPaisePerMin;

  DateTime effectiveFrom;

  AdminCallRateStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCallRate &&
    other.id == id &&
    other.language == language &&
    other.callType == callType &&
    other.coinsPerMin == coinsPerMin &&
    other.companionPaisePerMin == companionPaisePerMin &&
    other.effectiveFrom == effectiveFrom &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (language.hashCode) +
    (callType.hashCode) +
    (coinsPerMin.hashCode) +
    (companionPaisePerMin.hashCode) +
    (effectiveFrom.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'AdminCallRate[id=$id, language=$language, callType=$callType, coinsPerMin=$coinsPerMin, companionPaisePerMin=$companionPaisePerMin, effectiveFrom=$effectiveFrom, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'language'] = this.language;
      json[r'callType'] = this.callType;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'companionPaisePerMin'] = this.companionPaisePerMin;
      json[r'effectiveFrom'] = this.effectiveFrom.toUtc().toIso8601String();
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [AdminCallRate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCallRate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminCallRate[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminCallRate[id]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminCallRate[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminCallRate[language]" has a null value in JSON.');
        assert(json.containsKey(r'callType'), 'Required key "AdminCallRate[callType]" is missing from JSON.');
        assert(json[r'callType'] != null, 'Required key "AdminCallRate[callType]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "AdminCallRate[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "AdminCallRate[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'companionPaisePerMin'), 'Required key "AdminCallRate[companionPaisePerMin]" is missing from JSON.');
        assert(json[r'companionPaisePerMin'] != null, 'Required key "AdminCallRate[companionPaisePerMin]" has a null value in JSON.');
        assert(json.containsKey(r'effectiveFrom'), 'Required key "AdminCallRate[effectiveFrom]" is missing from JSON.');
        assert(json[r'effectiveFrom'] != null, 'Required key "AdminCallRate[effectiveFrom]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminCallRate[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminCallRate[status]" has a null value in JSON.');
        return true;
      }());

      return AdminCallRate(
        id: mapValueOfType<int>(json, r'id')!,
        language: mapValueOfType<String>(json, r'language')!,
        callType: AdminCallRateCallTypeEnum.fromJson(json[r'callType'])!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        companionPaisePerMin: mapValueOfType<int>(json, r'companionPaisePerMin')!,
        effectiveFrom: mapDateTime(json, r'effectiveFrom', r'')!,
        status: AdminCallRateStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<AdminCallRate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCallRate> mapFromJson(dynamic json) {
    final map = <String, AdminCallRate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCallRate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCallRate-objects as value to a dart map
  static Map<String, List<AdminCallRate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCallRate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCallRate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'language',
    'callType',
    'coinsPerMin',
    'companionPaisePerMin',
    'effectiveFrom',
    'status',
  };
}


enum AdminCallRateCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCallRateCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCallRateCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCallRateCallTypeEnum? fromJson(dynamic value) => AdminCallRateCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCallRateCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCallRateCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRateCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRateCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCallRateCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminCallRateCallTypeEnum].
class AdminCallRateCallTypeEnumTypeTransformer {
  factory AdminCallRateCallTypeEnumTypeTransformer() => _instance ??= const AdminCallRateCallTypeEnumTypeTransformer._();

  const AdminCallRateCallTypeEnumTypeTransformer._();

  String encode(AdminCallRateCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminCallRateCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCallRateCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCallRateCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminCallRateCallTypeEnum.audio;
        case r'video': return AdminCallRateCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCallRateCallTypeEnumTypeTransformer? _instance;
}



enum AdminCallRateStatusEnum {
  current._(r'current'),
  scheduled._(r'scheduled'),
  past._(r'past'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCallRateStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCallRateStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCallRateStatusEnum? fromJson(dynamic value) => AdminCallRateStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCallRateStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCallRateStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRateStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRateStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCallRateStatusEnum] to String,
/// and [decode] dynamic data back to [AdminCallRateStatusEnum].
class AdminCallRateStatusEnumTypeTransformer {
  factory AdminCallRateStatusEnumTypeTransformer() => _instance ??= const AdminCallRateStatusEnumTypeTransformer._();

  const AdminCallRateStatusEnumTypeTransformer._();

  String encode(AdminCallRateStatusEnum data) => data._value;

  /// Returns the instance of [AdminCallRateStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCallRateStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCallRateStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'current': return AdminCallRateStatusEnum.current;
        case r'scheduled': return AdminCallRateStatusEnum.scheduled;
        case r'past': return AdminCallRateStatusEnum.past;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCallRateStatusEnumTypeTransformer? _instance;
}


