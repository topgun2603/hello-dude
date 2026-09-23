//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class StartCallRequest {
  /// Returns a new [StartCallRequest] instance.
  StartCallRequest({
    required this.companionId,
    required this.type,
  });

  String companionId;

  StartCallRequestTypeEnum type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StartCallRequest &&
    other.companionId == companionId &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (companionId.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'StartCallRequest[companionId=$companionId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'companionId'] = this.companionId;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [StartCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'companionId'), 'Required key "StartCallRequest[companionId]" is missing from JSON.');
        assert(json[r'companionId'] != null, 'Required key "StartCallRequest[companionId]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "StartCallRequest[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "StartCallRequest[type]" has a null value in JSON.');
        return true;
      }());

      return StartCallRequest(
        companionId: mapValueOfType<String>(json, r'companionId')!,
        type: StartCallRequestTypeEnum.fromJson(json[r'type'])!,
      );
    }
    return null;
  }

  static List<StartCallRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartCallRequest> mapFromJson(dynamic json) {
    final map = <String, StartCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartCallRequest-objects as value to a dart map
  static Map<String, List<StartCallRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StartCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartCallRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'companionId',
    'type',
  };
}


enum StartCallRequestTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const StartCallRequestTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [StartCallRequestTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static StartCallRequestTypeEnum? fromJson(dynamic value) => StartCallRequestTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [StartCallRequestTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<StartCallRequestTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartCallRequestTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartCallRequestTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [StartCallRequestTypeEnum] to String,
/// and [decode] dynamic data back to [StartCallRequestTypeEnum].
class StartCallRequestTypeEnumTypeTransformer {
  factory StartCallRequestTypeEnumTypeTransformer() => _instance ??= const StartCallRequestTypeEnumTypeTransformer._();

  const StartCallRequestTypeEnumTypeTransformer._();

  String encode(StartCallRequestTypeEnum data) => data._value;

  /// Returns the instance of [StartCallRequestTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  StartCallRequestTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is StartCallRequestTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return StartCallRequestTypeEnum.audio;
        case r'video': return StartCallRequestTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static StartCallRequestTypeEnumTypeTransformer? _instance;
}


