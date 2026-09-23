//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ConversationOther {
  /// Returns a new [ConversationOther] instance.
  ConversationOther({
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

  ConversationOtherRoleEnum role;

  bool online;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversationOther &&
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
  String toString() => 'ConversationOther[id=$id, displayName=$displayName, avatarId=$avatarId, role=$role, online=$online]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'role'] = this.role;
      json[r'online'] = this.online;
    return json;
  }

  /// Returns a new [ConversationOther] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConversationOther? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ConversationOther[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ConversationOther[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "ConversationOther[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "ConversationOther[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "ConversationOther[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "ConversationOther[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'role'), 'Required key "ConversationOther[role]" is missing from JSON.');
        assert(json[r'role'] != null, 'Required key "ConversationOther[role]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "ConversationOther[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "ConversationOther[online]" has a null value in JSON.');
        return true;
      }());

      return ConversationOther(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        role: ConversationOtherRoleEnum.fromJson(json[r'role'])!,
        online: mapValueOfType<bool>(json, r'online')!,
      );
    }
    return null;
  }

  static List<ConversationOther> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationOther>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationOther.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversationOther> mapFromJson(dynamic json) {
    final map = <String, ConversationOther>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConversationOther.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversationOther-objects as value to a dart map
  static Map<String, List<ConversationOther>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversationOther>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversationOther.listFromJson(entry.value, growable: growable,);
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


enum ConversationOtherRoleEnum {
  caller._(r'caller'),
  companion._(r'companion'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConversationOtherRoleEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConversationOtherRoleEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConversationOtherRoleEnum? fromJson(dynamic value) => ConversationOtherRoleEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConversationOtherRoleEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConversationOtherRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationOtherRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationOtherRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversationOtherRoleEnum] to String,
/// and [decode] dynamic data back to [ConversationOtherRoleEnum].
class ConversationOtherRoleEnumTypeTransformer {
  factory ConversationOtherRoleEnumTypeTransformer() => _instance ??= const ConversationOtherRoleEnumTypeTransformer._();

  const ConversationOtherRoleEnumTypeTransformer._();

  String encode(ConversationOtherRoleEnum data) => data._value;

  /// Returns the instance of [ConversationOtherRoleEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversationOtherRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConversationOtherRoleEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'caller': return ConversationOtherRoleEnum.caller;
        case r'companion': return ConversationOtherRoleEnum.companion;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConversationOtherRoleEnumTypeTransformer? _instance;
}


