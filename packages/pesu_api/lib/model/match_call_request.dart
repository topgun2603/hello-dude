//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class MatchCallRequest {
  /// Returns a new [MatchCallRequest] instance.
  MatchCallRequest({
    required this.language,
    required this.type,
  });

  String language;

  MatchCallRequestTypeEnum type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MatchCallRequest &&
    other.language == language &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (language.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'MatchCallRequest[language=$language, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'language'] = this.language;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [MatchCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MatchCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'language'), 'Required key "MatchCallRequest[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "MatchCallRequest[language]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "MatchCallRequest[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "MatchCallRequest[type]" has a null value in JSON.');
        return true;
      }());

      return MatchCallRequest(
        language: mapValueOfType<String>(json, r'language')!,
        type: MatchCallRequestTypeEnum.fromJson(json[r'type'])!,
      );
    }
    return null;
  }

  static List<MatchCallRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MatchCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MatchCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MatchCallRequest> mapFromJson(dynamic json) {
    final map = <String, MatchCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MatchCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MatchCallRequest-objects as value to a dart map
  static Map<String, List<MatchCallRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MatchCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MatchCallRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'language',
    'type',
  };
}


enum MatchCallRequestTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const MatchCallRequestTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [MatchCallRequestTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static MatchCallRequestTypeEnum? fromJson(dynamic value) => MatchCallRequestTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [MatchCallRequestTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<MatchCallRequestTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MatchCallRequestTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MatchCallRequestTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MatchCallRequestTypeEnum] to String,
/// and [decode] dynamic data back to [MatchCallRequestTypeEnum].
class MatchCallRequestTypeEnumTypeTransformer {
  factory MatchCallRequestTypeEnumTypeTransformer() => _instance ??= const MatchCallRequestTypeEnumTypeTransformer._();

  const MatchCallRequestTypeEnumTypeTransformer._();

  String encode(MatchCallRequestTypeEnum data) => data._value;

  /// Returns the instance of [MatchCallRequestTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MatchCallRequestTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is MatchCallRequestTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return MatchCallRequestTypeEnum.audio;
        case r'video': return MatchCallRequestTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static MatchCallRequestTypeEnumTypeTransformer? _instance;
}


