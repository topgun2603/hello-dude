//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomToken200Response {
  /// Returns a new [RoomToken200Response] instance.
  RoomToken200Response({
    required this.token,
    required this.role,
  });

  String token;

  RoomToken200ResponseRoleEnum role;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomToken200Response &&
    other.token == token &&
    other.role == role;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (token.hashCode) +
    (role.hashCode);

  @override
  String toString() => 'RoomToken200Response[token=$token, role=$role]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'token'] = this.token;
      json[r'role'] = this.role;
    return json;
  }

  /// Returns a new [RoomToken200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomToken200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'token'), 'Required key "RoomToken200Response[token]" is missing from JSON.');
        assert(json[r'token'] != null, 'Required key "RoomToken200Response[token]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "RoomToken200Response[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "RoomToken200Response[role]" has a null value in JSON.');
        return true;
      }());

      return RoomToken200Response(
        token: mapValueOfType<String>(json, r'token')!,
        role: RoomToken200ResponseRoleEnum.fromJson(json[r'role'])!,
      );
    }
    return null;
  }

  static List<RoomToken200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomToken200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomToken200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomToken200Response> mapFromJson(dynamic json) {
    final map = <String, RoomToken200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomToken200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomToken200Response-objects as value to a dart map
  static Map<String, List<RoomToken200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomToken200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomToken200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'token',
    'role',
  };
}


enum RoomToken200ResponseRoleEnum {
  host._(r'host'),
  speaker._(r'speaker'),
  listener._(r'listener'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomToken200ResponseRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomToken200ResponseRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomToken200ResponseRoleEnum? fromJson(dynamic value) => RoomToken200ResponseRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomToken200ResponseRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomToken200ResponseRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomToken200ResponseRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomToken200ResponseRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomToken200ResponseRoleEnum] to String,
/// and [decode] dynamic data back to [RoomToken200ResponseRoleEnum].
class RoomToken200ResponseRoleEnumTypeTransformer {
  factory RoomToken200ResponseRoleEnumTypeTransformer() => _instance ??= const RoomToken200ResponseRoleEnumTypeTransformer._();

  const RoomToken200ResponseRoleEnumTypeTransformer._();

  String encode(RoomToken200ResponseRoleEnum data) => data._value;

  /// Returns the instance of [RoomToken200ResponseRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomToken200ResponseRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomToken200ResponseRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return RoomToken200ResponseRoleEnum.host;
        case r'speaker': return RoomToken200ResponseRoleEnum.speaker;
        case r'listener': return RoomToken200ResponseRoleEnum.listener;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomToken200ResponseRoleEnumTypeTransformer? _instance;
}


