//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomMemberInput {
  /// Returns a new [RoomMemberInput] instance.
  RoomMemberInput({
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

  RoomMemberInputRoleEnum role;

  bool handRaised;

  bool isCompanion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomMemberInput &&
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
  String toString() => 'RoomMemberInput[id=$id, displayName=$displayName, avatarId=$avatarId, role=$role, handRaised=$handRaised, isCompanion=$isCompanion]';

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

  /// Returns a new [RoomMemberInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomMemberInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RoomMemberInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RoomMemberInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "RoomMemberInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "RoomMemberInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "RoomMemberInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "RoomMemberInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "RoomMemberInput[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "RoomMemberInput[role]" has a null value in JSON.');
        assert(json.containsKey(r'handRaised'), 'Required key "RoomMemberInput[handRaised]" is missing from JSON.');
        assert(json[r'handRaised'] != null, 'Required key "RoomMemberInput[handRaised]" has a null value in JSON.');
        assert(json.containsKey(r'isCompanion'), 'Required key "RoomMemberInput[isCompanion]" is missing from JSON.');
        assert(json[r'isCompanion'] != null, 'Required key "RoomMemberInput[isCompanion]" has a null value in JSON.');
        return true;
      }());

      return RoomMemberInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        role: RoomMemberInputRoleEnum.fromJson(json[r'role'])!,
        handRaised: mapValueOfType<bool>(json, r'handRaised')!,
        isCompanion: mapValueOfType<bool>(json, r'isCompanion')!,
      );
    }
    return null;
  }

  static List<RoomMemberInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomMemberInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomMemberInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomMemberInput> mapFromJson(dynamic json) {
    final map = <String, RoomMemberInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomMemberInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomMemberInput-objects as value to a dart map
  static Map<String, List<RoomMemberInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomMemberInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomMemberInput.listFromJson(entry.value, growable: growable,);
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


enum RoomMemberInputRoleEnum {
  host._(r'host'),
  speaker._(r'speaker'),
  listener._(r'listener'),
  ;

  /// Instantiate a new enum with the provided value.
  const RoomMemberInputRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [RoomMemberInputRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static RoomMemberInputRoleEnum? fromJson(dynamic value) => RoomMemberInputRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [RoomMemberInputRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<RoomMemberInputRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomMemberInputRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomMemberInputRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RoomMemberInputRoleEnum] to String,
/// and [decode] dynamic data back to [RoomMemberInputRoleEnum].
class RoomMemberInputRoleEnumTypeTransformer {
  factory RoomMemberInputRoleEnumTypeTransformer() => _instance ??= const RoomMemberInputRoleEnumTypeTransformer._();

  const RoomMemberInputRoleEnumTypeTransformer._();

  String encode(RoomMemberInputRoleEnum data) => data._value;

  /// Returns the instance of [RoomMemberInputRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RoomMemberInputRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is RoomMemberInputRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return RoomMemberInputRoleEnum.host;
        case r'speaker': return RoomMemberInputRoleEnum.speaker;
        case r'listener': return RoomMemberInputRoleEnum.listener;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static RoomMemberInputRoleEnumTypeTransformer? _instance;
}


