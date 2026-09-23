//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminModerationFlagCall {
  /// Returns a new [AdminModerationFlagCall] instance.
  AdminModerationFlagCall({
    required this.id,
    required this.type,
  });

  String id;

  AdminModerationFlagCallTypeEnum type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminModerationFlagCall &&
    other.id == id &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'AdminModerationFlagCall[id=$id, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [AdminModerationFlagCall] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminModerationFlagCall? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminModerationFlagCall[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminModerationFlagCall[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminModerationFlagCall[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminModerationFlagCall[type]" has a null value in JSON.');
        return true;
      }());

      return AdminModerationFlagCall(
        id: mapValueOfType<String>(json, r'id')!,
        type: AdminModerationFlagCallTypeEnum.fromJson(json[r'type'])!,
      );
    }
    return null;
  }

  static List<AdminModerationFlagCall> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagCall>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagCall.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminModerationFlagCall> mapFromJson(dynamic json) {
    final map = <String, AdminModerationFlagCall>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminModerationFlagCall.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminModerationFlagCall-objects as value to a dart map
  static Map<String, List<AdminModerationFlagCall>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminModerationFlagCall>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminModerationFlagCall.listFromJson(entry.value, growable: growable,);
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


enum AdminModerationFlagCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminModerationFlagCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminModerationFlagCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminModerationFlagCallTypeEnum? fromJson(dynamic value) => AdminModerationFlagCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminModerationFlagCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminModerationFlagCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminModerationFlagCallTypeEnum] to String,
/// and [decode] dynamic data back to [AdminModerationFlagCallTypeEnum].
class AdminModerationFlagCallTypeEnumTypeTransformer {
  factory AdminModerationFlagCallTypeEnumTypeTransformer() => _instance ??= const AdminModerationFlagCallTypeEnumTypeTransformer._();

  const AdminModerationFlagCallTypeEnumTypeTransformer._();

  String encode(AdminModerationFlagCallTypeEnum data) => data._value;

  /// Returns the instance of [AdminModerationFlagCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminModerationFlagCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminModerationFlagCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminModerationFlagCallTypeEnum.audio;
        case r'video': return AdminModerationFlagCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminModerationFlagCallTypeEnumTypeTransformer? _instance;
}


