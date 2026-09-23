//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminModerationFlagInputCall {
  /// Returns a new [AdminModerationFlagInputCall] instance.
  AdminModerationFlagInputCall({
    required this.id,
    required this.type,
  });

  String id;

  AdminModerationFlagInputCallTypeEnum type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminModerationFlagInputCall &&
    other.id == id &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'AdminModerationFlagInputCall[id=$id, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [AdminModerationFlagInputCall] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminModerationFlagInputCall? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminModerationFlagInputCall[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminModerationFlagInputCall[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminModerationFlagInputCall[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminModerationFlagInputCall[type]" has a null value in JSON.');
        return true;
      }());

      return AdminModerationFlagInputCall(
        id: mapValueOfType<String>(json, r'id')!,
        type: AdminModerationFlagInputCallTypeEnum.fromJson(json[r'type'])!,
      );
    }
    return null;
  }

  static List<AdminModerationFlagInputCall> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagInputCall>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagInputCall.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminModerationFlagInputCall> mapFromJson(dynamic json) {
    final map = <String, AdminModerationFlagInputCall>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminModerationFlagInputCall.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminModerationFlagInputCall-objects as value to a dart map
  static Map<String, List<AdminModerationFlagInputCall>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminModerationFlagInputCall>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminModerationFlagInputCall.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
  };
}


enum AdminModerationFlagInputCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminModerationFlagInputCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminModerationFlagInputCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminModerationFlagInputCallTypeEnum? fromJson(dynamic value) => AdminModerationFlagInputCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminModerationFlagInputCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminModerationFlagInputCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagInputCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagInputCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminModerationFlagInputCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminModerationFlagInputCallTypeEnum].
class AdminModerationFlagInputCallTypeEnumTypeTransformer {
  factory AdminModerationFlagInputCallTypeEnumTypeTransformer() => _instance ??= const AdminModerationFlagInputCallTypeEnumTypeTransformer._();

  const AdminModerationFlagInputCallTypeEnumTypeTransformer._();

  String encode(AdminModerationFlagInputCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminModerationFlagInputCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminModerationFlagInputCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminModerationFlagInputCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminModerationFlagInputCallTypeEnum.audio;
        case r'video': return AdminModerationFlagInputCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminModerationFlagInputCallTypeEnumTypeTransformer? _instance;
}


