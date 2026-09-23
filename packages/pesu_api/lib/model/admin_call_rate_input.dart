//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCallRateInput {
  /// Returns a new [AdminCallRateInput] instance.
  AdminCallRateInput({
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

  AdminCallRateInputCallTypeEnum callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionPaisePerMin;

  Object? effectiveFrom;

  AdminCallRateInputStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCallRateInput &&
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
    (effectiveFrom == null ? 0 : effectiveFrom!.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'AdminCallRateInput[id=$id, language=$language, callType=$callType, coinsPerMin=$coinsPerMin, companionPaisePerMin=$companionPaisePerMin, effectiveFrom=$effectiveFrom, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'language'] = this.language;
      json[r'callType'] = this.callType;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'companionPaisePerMin'] = this.companionPaisePerMin;
    if (this.effectiveFrom != null) {
      json[r'effectiveFrom'] = this.effectiveFrom;
    } else {
      json[r'effectiveFrom'] = null;
    }
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [AdminCallRateInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCallRateInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminCallRateInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminCallRateInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminCallRateInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminCallRateInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'callType'), 'Required key "AdminCallRateInput[callType]" is missing from JSON.');
        assert(json[r'callType'] != null, 'Required key "AdminCallRateInput[callType]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "AdminCallRateInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "AdminCallRateInput[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'companionPaisePerMin'), 'Required key "AdminCallRateInput[companionPaisePerMin]" is missing from JSON.');
        assert(json[r'companionPaisePerMin'] != null, 'Required key "AdminCallRateInput[companionPaisePerMin]" has a null value in JSON.');
        assert(json.containsKey(r'effectiveFrom'), 'Required key "AdminCallRateInput[effectiveFrom]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminCallRateInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminCallRateInput[status]" has a null value in JSON.');
        return true;
      }());

      return AdminCallRateInput(
        id: mapValueOfType<int>(json, r'id')!,
        language: mapValueOfType<String>(json, r'language')!,
        callType: AdminCallRateInputCallTypeEnum.fromJson(json[r'callType'])!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        companionPaisePerMin: mapValueOfType<int>(json, r'companionPaisePerMin')!,
        effectiveFrom: mapValueOfType<Object>(json, r'effectiveFrom'),
        status: AdminCallRateInputStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<AdminCallRateInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRateInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRateInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCallRateInput> mapFromJson(dynamic json) {
    final map = <String, AdminCallRateInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCallRateInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCallRateInput-objects as value to a dart map
  static Map<String, List<AdminCallRateInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCallRateInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCallRateInput.listFromJson(entry.value, growable: growable,);
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


enum AdminCallRateInputCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCallRateInputCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCallRateInputCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCallRateInputCallTypeEnum? fromJson(dynamic value) => AdminCallRateInputCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCallRateInputCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCallRateInputCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRateInputCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRateInputCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCallRateInputCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminCallRateInputCallTypeEnum].
class AdminCallRateInputCallTypeEnumTypeTransformer {
  factory AdminCallRateInputCallTypeEnumTypeTransformer() => _instance ??= const AdminCallRateInputCallTypeEnumTypeTransformer._();

  const AdminCallRateInputCallTypeEnumTypeTransformer._();

  String encode(AdminCallRateInputCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminCallRateInputCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCallRateInputCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCallRateInputCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminCallRateInputCallTypeEnum.audio;
        case r'video': return AdminCallRateInputCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCallRateInputCallTypeEnumTypeTransformer? _instance;
}



enum AdminCallRateInputStatusEnum {
  current._(r'current'),
  scheduled._(r'scheduled'),
  past._(r'past'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCallRateInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCallRateInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCallRateInputStatusEnum? fromJson(dynamic value) => AdminCallRateInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCallRateInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCallRateInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCallRateInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCallRateInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCallRateInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminCallRateInputStatusEnum].
class AdminCallRateInputStatusEnumTypeTransformer {
  factory AdminCallRateInputStatusEnumTypeTransformer() => _instance ??= const AdminCallRateInputStatusEnumTypeTransformer._();

  const AdminCallRateInputStatusEnumTypeTransformer._();

  String encode(AdminCallRateInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminCallRateInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCallRateInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCallRateInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'current': return AdminCallRateInputStatusEnum.current;
        case r'scheduled': return AdminCallRateInputStatusEnum.scheduled;
        case r'past': return AdminCallRateInputStatusEnum.past;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCallRateInputStatusEnumTypeTransformer? _instance;
}


