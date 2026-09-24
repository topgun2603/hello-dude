//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GroupCard {
  /// Returns a new [GroupCard] instance.
  GroupCard({
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

  GroupCardStatusEnum status;

  GroupCardHost host;

  DateTime? scheduledAt;

  DateTime? startedAt;

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

  GroupCardMySeatEnum mySeat;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GroupCard &&
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
  String toString() => 'GroupCard[id=$id, title=$title, language=$language, status=$status, host=$host, scheduledAt=$scheduledAt, startedAt=$startedAt, members=$members, minMembers=$minMembers, maxMembers=$maxMembers, coinsPerMin=$coinsPerMin, mySeat=$mySeat]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'status'] = this.status;
      json[r'host'] = this.host;
    if (this.scheduledAt != null) {
      json[r'scheduledAt'] = this.scheduledAt!.toUtc().toIso8601String();
    } else {
      json[r'scheduledAt'] = null;
    }
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt!.toUtc().toIso8601String();
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

  /// Returns a new [GroupCard] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupCard? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "GroupCard[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "GroupCard[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "GroupCard[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "GroupCard[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "GroupCard[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "GroupCard[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "GroupCard[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "GroupCard[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "GroupCard[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "GroupCard[host]" has a null value in JSON.');
        assert(json.containsKey(r'scheduledAt'), 'Required key "GroupCard[scheduledAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "GroupCard[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'members'), 'Required key "GroupCard[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "GroupCard[members]" has a null value in JSON.');
        assert(json.containsKey(r'minMembers'), 'Required key "GroupCard[minMembers]" is missing from JSON.');
        assert(json[r'minMembers'] != null, 'Required key "GroupCard[minMembers]" has a null value in JSON.');
        assert(json.containsKey(r'maxMembers'), 'Required key "GroupCard[maxMembers]" is missing from JSON.');
        assert(json[r'maxMembers'] != null, 'Required key "GroupCard[maxMembers]" has a null value in JSON.');
        assert(json.containsKey(r'coinsPerMin'), 'Required key "GroupCard[coinsPerMin]" is missing from JSON.');
        assert(json[r'coinsPerMin'] != null, 'Required key "GroupCard[coinsPerMin]" has a null value in JSON.');
        assert(json.containsKey(r'mySeat'), 'Required key "GroupCard[mySeat]" is missing from JSON.');
        assert(json[r'mySeat'] != null, 'Required key "GroupCard[mySeat]" has a null value in JSON.');
        return true;
      }());

      return GroupCard(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: GroupCardStatusEnum.fromJson(json[r'status'])!,
        host: GroupCardHost.fromJson(json[r'host'])!,
        scheduledAt: mapDateTime(json, r'scheduledAt', r''),
        startedAt: mapDateTime(json, r'startedAt', r''),
        members: mapValueOfType<int>(json, r'members')!,
        minMembers: mapValueOfType<int>(json, r'minMembers')!,
        maxMembers: mapValueOfType<int>(json, r'maxMembers')!,
        coinsPerMin: mapValueOfType<int>(json, r'coinsPerMin')!,
        mySeat: GroupCardMySeatEnum.fromJson(json[r'mySeat'])!,
      );
    }
    return null;
  }

  static List<GroupCard> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCard>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCard.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupCard> mapFromJson(dynamic json) {
    final map = <String, GroupCard>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupCard.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupCard-objects as value to a dart map
  static Map<String, List<GroupCard>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GroupCard>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupCard.listFromJson(entry.value, growable: growable,);
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


enum GroupCardStatusEnum {
  scheduled._(r'scheduled'),
  lobby._(r'lobby'),
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const GroupCardStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GroupCardStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GroupCardStatusEnum? fromJson(dynamic value) => GroupCardStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GroupCardStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GroupCardStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCardStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCardStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GroupCardStatusEnum] to String,
/// and [decode] dynamic data back to [GroupCardStatusEnum].
class GroupCardStatusEnumTypeTransformer {
  factory GroupCardStatusEnumTypeTransformer() => _instance ??= const GroupCardStatusEnumTypeTransformer._();

  const GroupCardStatusEnumTypeTransformer._();

  String encode(GroupCardStatusEnum data) => data._value;

  /// Returns the instance of [GroupCardStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GroupCardStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GroupCardStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'scheduled': return GroupCardStatusEnum.scheduled;
        case r'lobby': return GroupCardStatusEnum.lobby;
        case r'live': return GroupCardStatusEnum.live;
        case r'ended': return GroupCardStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GroupCardStatusEnumTypeTransformer? _instance;
}



enum GroupCardMySeatEnum {
  none._(r'none'),
  booked._(r'booked'),
  joined._(r'joined'),
  ;

  /// Instantiate a new enum with the provided value.
  const GroupCardMySeatEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GroupCardMySeatEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GroupCardMySeatEnum? fromJson(dynamic value) => GroupCardMySeatEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GroupCardMySeatEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GroupCardMySeatEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GroupCardMySeatEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupCardMySeatEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GroupCardMySeatEnum] to String,
/// and [decode] dynamic data back to [GroupCardMySeatEnum].
class GroupCardMySeatEnumTypeTransformer {
  factory GroupCardMySeatEnumTypeTransformer() => _instance ??= const GroupCardMySeatEnumTypeTransformer._();

  const GroupCardMySeatEnumTypeTransformer._();

  String encode(GroupCardMySeatEnum data) => data._value;

  /// Returns the instance of [GroupCardMySeatEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GroupCardMySeatEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GroupCardMySeatEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'none': return GroupCardMySeatEnum.none;
        case r'booked': return GroupCardMySeatEnum.booked;
        case r'joined': return GroupCardMySeatEnum.joined;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GroupCardMySeatEnumTypeTransformer? _instance;
}


