//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreateRateRequest {
  /// Returns a new [AdminCreateRateRequest] instance.
  AdminCreateRateRequest({
    required this.language,
    required this.callType,
    required this.coinsPerMin,
    required this.companionPaisePerMin,
    this.effectiveFrom,
  });

  String language;

  AdminCreateRateRequestCallTypeEnum callType;

  /// Minimum value: 1
  /// Maximum value: 1000
  int coinsPerMin;

  /// Minimum value: 0
  /// Maximum value: 100000
  int companionPaisePerMin;

  /// Default: now
  Object? effectiveFrom;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreateRateRequest &&
    other.language == language &&
    other.callType == callType &&
    other.coinsPerMin == coinsPerMin &&
    other.companionPaisePerMin == companionPaisePerMin &&
    other.effectiveFrom == effectiveFrom;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (language.hashCode) +
    (callType.hashCode) +
    (coinsPerMin.hashCode) +
    (companionPaisePerMin.hashCode) +
    (effectiveFrom == null ? 0 : effectiveFrom!.hashCode);

  @override
  String toString() => 'AdminCreateRateRequest[language=$language, callType=$callType, coinsPerMin=$coinsPerMin, companionPaisePerMin=$companionPaisePerMin, effectiveFrom=$effectiveFrom]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'language'] = this.language;
      json[r'callType'] = this.callType;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'companionPaisePerMin'] = this.companionPaisePerMin;
    if (this.effectiveFrom != null) {
      json[r'effectiveFrom'] = this.effectiveFrom;
    } else {
      json[r'effectiveFrom'] = null;
    }
    return json;
  }

  /// Returns a new [AdminCreateRateRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreateRateRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'language'), 'Required key "AdminCreateRateRequest[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminCreateRateRequest[language]" has a null value in JSON.');
        assert(json.containsKey(r'callType'), 'Required key "AdminCreateRateRequest[callType]" is missing from JSON.');
        assert(json[r'callType'] != null, 'Required key "AdminCreateRateRequest[callType]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "AdminCreateRateRequest[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "AdminCreateRateRequest[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'companionPaisePerMin'), 'Required key "AdminCreateRateRequest[companionPaisePerMin]" is missing from JSON.');
        assert(json[r'companionPaisePerMin'] != null, 'Required key "AdminCreateRateRequest[companionPaisePerMin]" has a null value in JSON.');
        return true;
      }());

      return AdminCreateRateRequest(
        language: mapValueOfType<String>(json, r'language')!,
        callType: AdminCreateRateRequestCallTypeEnum.fromJson(json[r'callType'])!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        companionPaisePerMin: mapValueOfType<int>(json, r'companionPaisePerMin')!,
        effectiveFrom: mapValueOfType<Object>(json, r'effectiveFrom'),
      );
    }
    return null;
  }

  static List<AdminCreateRateRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateRateRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateRateRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreateRateRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreateRateRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreateRateRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreateRateRequest-objects as value to a dart map
  static Map<String, List<AdminCreateRateRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreateRateRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreateRateRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'language',
    'callType',
    'coinsPerMin',
    'companionPaisePerMin',
  };
}


enum AdminCreateRateRequestCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreateRateRequestCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreateRateRequestCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreateRateRequestCallTypeEnum? fromJson(dynamic value) => AdminCreateRateRequestCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreateRateRequestCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreateRateRequestCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateRateRequestCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateRateRequestCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreateRateRequestCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminCreateRateRequestCallTypeEnum].
class AdminCreateRateRequestCallTypeEnumTypeTransformer {
  factory AdminCreateRateRequestCallTypeEnumTypeTransformer() => _instance ??= const AdminCreateRateRequestCallTypeEnumTypeTransformer._();

  const AdminCreateRateRequestCallTypeEnumTypeTransformer._();

  String encode(AdminCreateRateRequestCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminCreateRateRequestCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreateRateRequestCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreateRateRequestCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminCreateRateRequestCallTypeEnum.audio;
        case r'video': return AdminCreateRateRequestCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreateRateRequestCallTypeEnumTypeTransformer? _instance;
}


