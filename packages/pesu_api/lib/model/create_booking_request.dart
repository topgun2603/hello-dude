//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CreateBookingRequest {
  /// Returns a new [CreateBookingRequest] instance.
  CreateBookingRequest({
    required this.companionId,
    required this.startAt,
    required this.minutes,
    this.callType,
  });

  String companionId;

  Object? startAt;

  /// 10, 20 or 30
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Default audio
  CreateBookingRequestCallTypeEnum? callType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateBookingRequest &&
    other.companionId == companionId &&
    other.startAt == startAt &&
    other.minutes == minutes &&
    other.callType == callType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (companionId.hashCode) +
    (startAt == null ? 0 : startAt!.hashCode) +
    (minutes.hashCode) +
    (callType == null ? 0 : callType!.hashCode);

  @override
  String toString() => 'CreateBookingRequest[companionId=$companionId, startAt=$startAt, minutes=$minutes, callType=$callType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'companionId'] = this.companionId;
    if (this.startAt != null) {
      json[r'startAt'] = this.startAt;
    } else {
      json[r'startAt'] = null;
    }
      json[r'minutes'] = this.minutes;
    if (this.callType != null) {
      json[r'callType'] = this.callType;
    } else {
      json[r'callType'] = null;
    }
    return json;
  }

  /// Returns a new [CreateBookingRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateBookingRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'companionId'), 'Required key "CreateBookingRequest[companionId]" is missing from JSON.');
        assert(json[r'companionId'] != null, 'Required key "CreateBookingRequest[companionId]" has a null value in JSON.');
        assert(json.containsKey(r'startAt'), 'Required key "CreateBookingRequest[startAt]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "CreateBookingRequest[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "CreateBookingRequest[minutes]" has a null value in JSON.');
        return true;
      }());

      return CreateBookingRequest(
        companionId: mapValueOfType<String>(json, r'companionId')!,
        startAt: mapValueOfType<Object>(json, r'startAt'),
        minutes: mapValueOfType<int>(json, r'minutes')!,
        callType: CreateBookingRequestCallTypeEnum.fromJson(json[r'callType']),
      );
    }
    return null;
  }

  static List<CreateBookingRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateBookingRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateBookingRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateBookingRequest> mapFromJson(dynamic json) {
    final map = <String, CreateBookingRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateBookingRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateBookingRequest-objects as value to a dart map
  static Map<String, List<CreateBookingRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateBookingRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateBookingRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'companionId',
    'startAt',
    'minutes',
  };
}

/// Default audio
enum CreateBookingRequestCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CreateBookingRequestCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CreateBookingRequestCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CreateBookingRequestCallTypeEnum? fromJson(dynamic value) => CreateBookingRequestCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CreateBookingRequestCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CreateBookingRequestCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateBookingRequestCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateBookingRequestCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateBookingRequestCallTypeEnum] to String,
/// and [decode] dynamic data back to [CreateBookingRequestCallTypeEnum].
class CreateBookingRequestCallTypeEnumTypeTransformer {
  factory CreateBookingRequestCallTypeEnumTypeTransformer() => _instance ??= const CreateBookingRequestCallTypeEnumTypeTransformer._();

  const CreateBookingRequestCallTypeEnumTypeTransformer._();

  String encode(CreateBookingRequestCallTypeEnum data) => data._value;

  /// Returns the instance of [CreateBookingRequestCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateBookingRequestCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CreateBookingRequestCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CreateBookingRequestCallTypeEnum.audio;
        case r'video': return CreateBookingRequestCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CreateBookingRequestCallTypeEnumTypeTransformer? _instance;
}


