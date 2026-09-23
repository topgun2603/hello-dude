//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ConversationInputOther {
  /// Returns a new [ConversationInputOther] instance.
  ConversationInputOther({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.role,
    required this.online,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  ConversationInputOtherRoleEnum role;

  bool online;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversationInputOther &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.role == role &&
    other.online == online;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (role.hashCode) +
    (online.hashCode);

  @override
  String toString() => 'ConversationInputOther[id=$id, displayName=$displayName, avatarId=$avatarId, role=$role, online=$online]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'role'] = this.role;
      json[r'online'] = this.online;
    return json;
  }

  /// Returns a new [ConversationInputOther] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConversationInputOther? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ConversationInputOther[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ConversationInputOther[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "ConversationInputOther[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "ConversationInputOther[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "ConversationInputOther[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "ConversationInputOther[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "ConversationInputOther[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "ConversationInputOther[role]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "ConversationInputOther[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "ConversationInputOther[online]" has a null value in JSON.');
        return true;
      }());

      return ConversationInputOther(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        role: ConversationInputOtherRoleEnum.fromJson(json[r'role'])!,
        online: mapValueOfType<bool>(json, r'online')!,
      );
    }
    return null;
  }

  static List<ConversationInputOther> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationInputOther>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationInputOther.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversationInputOther> mapFromJson(dynamic json) {
    final map = <String, ConversationInputOther>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConversationInputOther.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversationInputOther-objects as value to a dart map
  static Map<String, List<ConversationInputOther>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversationInputOther>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversationInputOther.listFromJson(entry.value, growable: growable,);
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
    'online',
  };
}


enum ConversationInputOtherRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConversationInputOtherRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConversationInputOtherRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConversationInputOtherRoleEnum? fromJson(dynamic value) => ConversationInputOtherRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConversationInputOtherRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConversationInputOtherRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationInputOtherRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationInputOtherRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversationInputOtherRoleEnum] to String,
/// and [decode] dynamic data back to [ConversationInputOtherRoleEnum].
class ConversationInputOtherRoleEnumTypeTransformer {
  factory ConversationInputOtherRoleEnumTypeTransformer() => _instance ??= const ConversationInputOtherRoleEnumTypeTransformer._();

  const ConversationInputOtherRoleEnumTypeTransformer._();

  String encode(ConversationInputOtherRoleEnum data) => data._value;

  /// Returns the instance of [ConversationInputOtherRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversationInputOtherRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConversationInputOtherRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return ConversationInputOtherRoleEnum.caller;
        case r'companion': return ConversationInputOtherRoleEnum.companion;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConversationInputOtherRoleEnumTypeTransformer? _instance;
}


