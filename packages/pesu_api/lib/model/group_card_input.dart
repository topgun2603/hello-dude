//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupCardInput {
  /// Returns a new [GroupCardInput] instance.
  GroupCardInput({
    required this.id,
    required this.title,
    required this.language,
    required this.status,
    required this.host,
    required this.scheduledAt,
    required this.startedAt,
    required this.members,
    required this.minMembers,
    required this.maxMembers,
    required this.coinsPerMin,
    required this.mySeat,
  });

  String id;

  String title;

  String language;

  GroupCardInputStatusEnum status;

  GroupCardInputHost host;

  Object? scheduledAt;

  Object? startedAt;

  /// Seats taken (booked or in the group)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int members;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minMembers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int maxMembers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsPerMin;

  GroupCardInputMySeatEnum mySeat;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupCardInput &&
    other.id == id &&
    other.title == title &&
    other.language == language &&
    other.status == status &&
    other.host == host &&
    other.scheduledAt == scheduledAt &&
    other.startedAt == startedAt &&
    other.members == members &&
    other.minMembers == minMembers &&
    other.maxMembers == maxMembers &&
    other.coinsPerMin == coinsPerMin &&
    other.mySeat == mySeat;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (language.hashCode) +
    (status.hashCode) +
    (host.hashCode) +
    (scheduledAt == null ? 0 : scheduledAt!.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (members.hashCode) +
    (minMembers.hashCode) +
    (maxMembers.hashCode) +
    (coinsPerMin.hashCode) +
    (mySeat.hashCode);

  @override
  String toString() => 'GroupCardInput[id=$id, title=$title, language=$language, status=$status, host=$host, scheduledAt=$scheduledAt, startedAt=$startedAt, members=$members, minMembers=$minMembers, maxMembers=$maxMembers, coinsPerMin=$coinsPerMin, mySeat=$mySeat]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'status'] = this.status;
      json[r'host'] = this.host;
    if (this.scheduledAt != null) {
      json[r'scheduledAt'] = this.scheduledAt;
    } else {
      json[r'scheduledAt'] = null;
    }
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt;
    } else {
      json[r'startedAt'] = null;
    }
      json[r'members'] = this.members;
      json[r'minMembers'] = this.minMembers;
      json[r'maxMembers'] = this.maxMembers;
      json[r'coinsPerMin'] = this.coinsPerMin;
      json[r'mySeat'] = this.mySeat;
    return json;
  }

  /// Returns a new [GroupCardInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupCardInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "GroupCardInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "GroupCardInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "GroupCardInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "GroupCardInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "GroupCardInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "GroupCardInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "GroupCardInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "GroupCardInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "GroupCardInput[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "GroupCardInput[host]" has a null value in JSON.');
        assert(json.containsKey(r'scheduledAt'), 'Required key "GroupCardInput[scheduledAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "GroupCardInput[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'members'), 'Required key "GroupCardInput[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "GroupCardInput[members]" has a null value in JSON.');
        assert(json.containsKey(r'minMembers'), 'Required key "GroupCardInput[minMembers]" is missing from JSON.');
        assert(json[r'minMembers'] != null, 'Required key "GroupCardInput[minMembers]" has a null value in JSON.');
        assert(json.containsKey(r'maxMembers'), 'Required key "GroupCardInput[maxMembers]" is missing from JSON.');
        assert(json[r'maxMembers'] != null, 'Required key "GroupCardInput[maxMembers]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "GroupCardInput[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "GroupCardInput[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'mySeat'), 'Required key "GroupCardInput[mySeat]" is missing from JSON.');
        assert(json[r'mySeat'] != null, 'Required key "GroupCardInput[mySeat]" has a null value in JSON.');
        return true;
      }());

      return GroupCardInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: GroupCardInputStatusEnum.fromJson(json[r'status'])!,
        host: GroupCardInputHost.fromJson(json[r'host'])!,
        scheduledAt: mapValueOfType<Object>(json, r'scheduledAt'),
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
        members: mapValueOfType<int>(json, r'members')!,
        minMembers: mapValueOfType<int>(json, r'minMembers')!,
        maxMembers: mapValueOfType<int>(json, r'maxMembers')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        mySeat: GroupCardInputMySeatEnum.fromJson(json[r'mySeat'])!,
      );
    }
    return null;
  }

  static List<GroupCardInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCardInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCardInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupCardInput> mapFromJson(dynamic json) {
    final map = <String, GroupCardInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupCardInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupCardInput-objects as value to a dart map
  static Map<String, List<GroupCardInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupCardInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupCardInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'language',
    'status',
    'host',
    'scheduledAt',
    'startedAt',
    'members',
    'minMembers',
    'maxMembers',
    'coinsPerMin',
    'mySeat',
  };
}


enum GroupCardInputStatusEnum {
  scheduled._(r'scheduled'),
  lobby._(r'lobby'),
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const GroupCardInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GroupCardInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GroupCardInputStatusEnum? fromJson(dynamic value) => GroupCardInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GroupCardInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GroupCardInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCardInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCardInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GroupCardInputStatusEnum] to String,
/// and [decode] dynamic data back to [GroupCardInputStatusEnum].
class GroupCardInputStatusEnumTypeTransformer {
  factory GroupCardInputStatusEnumTypeTransformer() => _instance ??= const GroupCardInputStatusEnumTypeTransformer._();

  const GroupCardInputStatusEnumTypeTransformer._();

  String encode(GroupCardInputStatusEnum data) => data._value;

  /// Returns the instance of [GroupCardInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GroupCardInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GroupCardInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'scheduled': return GroupCardInputStatusEnum.scheduled;
        case r'lobby': return GroupCardInputStatusEnum.lobby;
        case r'live': return GroupCardInputStatusEnum.live;
        case r'ended': return GroupCardInputStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GroupCardInputStatusEnumTypeTransformer? _instance;
}



enum GroupCardInputMySeatEnum {
  none._(r'none'),
  booked._(r'booked'),
  joined._(r'joined'),
  ;

  /// Instantiate a new enum with the provided value.
  const GroupCardInputMySeatEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GroupCardInputMySeatEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GroupCardInputMySeatEnum? fromJson(dynamic value) => GroupCardInputMySeatEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GroupCardInputMySeatEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GroupCardInputMySeatEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCardInputMySeatEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCardInputMySeatEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GroupCardInputMySeatEnum] to String,
/// and [decode] dynamic data back to [GroupCardInputMySeatEnum].
class GroupCardInputMySeatEnumTypeTransformer {
  factory GroupCardInputMySeatEnumTypeTransformer() => _instance ??= const GroupCardInputMySeatEnumTypeTransformer._();

  const GroupCardInputMySeatEnumTypeTransformer._();

  String encode(GroupCardInputMySeatEnum data) => data._value;

  /// Returns the instance of [GroupCardInputMySeatEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GroupCardInputMySeatEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GroupCardInputMySeatEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'none': return GroupCardInputMySeatEnum.none;
        case r'booked': return GroupCardInputMySeatEnum.booked;
        case r'joined': return GroupCardInputMySeatEnum.joined;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GroupCardInputMySeatEnumTypeTransformer? _instance;
}


