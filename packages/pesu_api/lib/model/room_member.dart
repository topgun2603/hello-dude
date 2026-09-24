//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomMember {
  /// Returns a new [RoomMember] instance.
  RoomMember({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.role,
    required this.handRaised,
    required this.isCompanion,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  RoomMemberRoleEnum role;

  bool handRaised;

  bool isCompanion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomMember &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.role == role &&
    other.handRaised == handRaised &&
    other.isCompanion == isCompanion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (role.hashCode) +
    (handRaised.hashCode) +
    (isCompanion.hashCode);

  @override
  String toString() => 'RoomMember[id=$id, displayName=$displayName, avatarId=$avatarId, role=$role, handRaised=$handRaised, isCompanion=$isCompanion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'role'] = this.role;
      json[r'handRaised'] = this.handRaised;
      json[r'isCompanion'] = this.isCompanion;
    return json;
  }

  /// Returns a new [RoomMember] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomMember? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RoomMember[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RoomMember[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "RoomMember[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "RoomMember[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "RoomMember[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "RoomMember[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "RoomMember[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "RoomMember[role]" has a null value in JSON.');
        assert(json.containsKey(r'handRaised'), 'Required key "RoomMember[handRaised]" is missing from JSON.');
        assert(json[r'handRaised'] != null, 'Required key "RoomMember[handRaised]" has a null value in JSON.');
        assert(json.containsKey(r'isCompanion'), 'Required key "RoomMember[isCompanion]" is missing from JSON.');
        assert(json[r'isCompanion'] != null, 'Required key "RoomMember[isCompanion]" has a null value in JSON.');
        return true;
      }());

      return RoomMember(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        role: RoomMemberRoleEnum.fromJson(json[r'role'])!,
        handRaised: mapValueOfType<bool>(json, r'handRaised')!,
        isCompanion: mapValueOfType<bool>(json, r'isCompanion')!,
      );
    }
    return null;
  }

  static List<RoomMember> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomMember>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomMember.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomMember> mapFromJson(dynamic json) {
    final map = <String, RoomMember>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomMember.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomMember-objects as value to a dart map
  static Map<String, List<RoomMember>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomMember>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomMember.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'role',
    'handRaised',
    'isCompanion',
  };
}


enum RoomMemberRoleEnum {
  host._(r'host'),
  speaker._(r'speaker'),
  listener._(r'listener'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomMemberRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomMemberRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomMemberRoleEnum? fromJson(dynamic value) => RoomMemberRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomMemberRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomMemberRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomMemberRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomMemberRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomMemberRoleEnum] to String,
/// and [decode] dynamic data back to [RoomMemberRoleEnum].
class RoomMemberRoleEnumTypeTransformer {
  factory RoomMemberRoleEnumTypeTransformer() => _instance ??= const RoomMemberRoleEnumTypeTransformer._();

  const RoomMemberRoleEnumTypeTransformer._();

  String encode(RoomMemberRoleEnum data) => data._value;

  /// Returns the instance of [RoomMemberRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomMemberRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomMemberRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return RoomMemberRoleEnum.host;
        case r'speaker': return RoomMemberRoleEnum.speaker;
        case r'listener': return RoomMemberRoleEnum.listener;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomMemberRoleEnumTypeTransformer? _instance;
}


