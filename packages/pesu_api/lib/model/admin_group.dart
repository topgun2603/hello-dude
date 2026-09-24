//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminGroup {
  /// Returns a new [AdminGroup] instance.
  AdminGroup({
    required this.id,
    required this.title,
    required this.language,
    required this.status,
    required this.host,
    required this.members,
    required this.paidMinutes,
    required this.minuteCoins,
    required this.giftCoins,
    required this.openFlags,
    required this.scheduledAt,
    required this.startedAt,
    required this.endedAt,
    required this.endReason,
  });

  String id;

  String title;

  String language;

  AdminGroupStatusEnum status;

  RoomCardHost host;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int members;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paidMinutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minuteCoins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftCoins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int openFlags;

  DateTime? scheduledAt;

  DateTime? startedAt;

  DateTime? endedAt;

  String? endReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminGroup &&
    other.id == id &&
    other.title == title &&
    other.language == language &&
    other.status == status &&
    other.host == host &&
    other.members == members &&
    other.paidMinutes == paidMinutes &&
    other.minuteCoins == minuteCoins &&
    other.giftCoins == giftCoins &&
    other.openFlags == openFlags &&
    other.scheduledAt == scheduledAt &&
    other.startedAt == startedAt &&
    other.endedAt == endedAt &&
    other.endReason == endReason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (language.hashCode) +
    (status.hashCode) +
    (host.hashCode) +
    (members.hashCode) +
    (paidMinutes.hashCode) +
    (minuteCoins.hashCode) +
    (giftCoins.hashCode) +
    (openFlags.hashCode) +
    (scheduledAt == null ? 0 : scheduledAt!.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (endedAt == null ? 0 : endedAt!.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode);

  @override
  String toString() => 'AdminGroup[id=$id, title=$title, language=$language, status=$status, host=$host, members=$members, paidMinutes=$paidMinutes, minuteCoins=$minuteCoins, giftCoins=$giftCoins, openFlags=$openFlags, scheduledAt=$scheduledAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'status'] = this.status;
      json[r'host'] = this.host;
      json[r'members'] = this.members;
      json[r'paidMinutes'] = this.paidMinutes;
      json[r'minuteCoins'] = this.minuteCoins;
      json[r'giftCoins'] = this.giftCoins;
      json[r'openFlags'] = this.openFlags;
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
    if (this.endedAt != null) {
      json[r'endedAt'] = this.endedAt!.toUtc().toIso8601String();
    } else {
      json[r'endedAt'] = null;
    }
    if (this.endReason != null) {
      json[r'endReason'] = this.endReason;
    } else {
      json[r'endReason'] = null;
    }
    return json;
  }

  /// Returns a new [AdminGroup] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminGroup? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminGroup[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminGroup[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminGroup[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminGroup[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminGroup[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminGroup[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminGroup[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminGroup[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "AdminGroup[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "AdminGroup[host]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "AdminGroup[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "AdminGroup[members]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "AdminGroup[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "AdminGroup[paidMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'minuteCoins'), 'Required key "AdminGroup[minuteCoins]" is missing from JSON.');
        assert(json[r'minuteCoins'] != null, 'Required key "AdminGroup[minuteCoins]" has a null value in JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminGroup[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminGroup[giftCoins]" has a null value in JSON.');
        assert(json.containsKey(r'openFlags'), 'Required key "AdminGroup[openFlags]" is missing from JSON.');
        assert(json[r'openFlags'] != null, 'Required key "AdminGroup[openFlags]" has a null value in JSON.');
        assert(json.containsKey(r'scheduledAt'), 'Required key "AdminGroup[scheduledAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "AdminGroup[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "AdminGroup[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminGroup[endReason]" is missing from JSON.');
        return true;
      }());

      return AdminGroup(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: AdminGroupStatusEnum.fromJson(json[r'status'])!,
        host: RoomCardHost.fromJson(json[r'host'])!,
        members: mapValueOfType<int>(json, r'members')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
        minuteCoins: mapValueOfType<int>(json, r'minuteCoins')!,
        giftCoins: mapValueOfType<int>(json, r'giftCoins')!,
        openFlags: mapValueOfType<int>(json, r'openFlags')!,
        scheduledAt: mapDateTime(json, r'scheduledAt', r''),
        startedAt: mapDateTime(json, r'startedAt', r''),
        endedAt: mapDateTime(json, r'endedAt', r''),
        endReason: mapValueOfType<String>(json, r'endReason'),
      );
    }
    return null;
  }

  static List<AdminGroup> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminGroup>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminGroup.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminGroup> mapFromJson(dynamic json) {
    final map = <String, AdminGroup>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminGroup.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminGroup-objects as value to a dart map
  static Map<String, List<AdminGroup>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminGroup>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminGroup.listFromJson(entry.value, growable: growable,);
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
    'members',
    'paidMinutes',
    'minuteCoins',
    'giftCoins',
    'openFlags',
    'scheduledAt',
    'startedAt',
    'endedAt',
    'endReason',
  };
}


enum AdminGroupStatusEnum {
  scheduled._(r'scheduled'),
  lobby._(r'lobby'),
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminGroupStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminGroupStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminGroupStatusEnum? fromJson(dynamic value) => AdminGroupStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminGroupStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminGroupStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminGroupStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminGroupStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminGroupStatusEnum] to String,
/// and [decode] dynamic data back to [AdminGroupStatusEnum].
class AdminGroupStatusEnumTypeTransformer {
  factory AdminGroupStatusEnumTypeTransformer() => _instance ??= const AdminGroupStatusEnumTypeTransformer._();

  const AdminGroupStatusEnumTypeTransformer._();

  String encode(AdminGroupStatusEnum data) => data._value;

  /// Returns the instance of [AdminGroupStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminGroupStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminGroupStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'scheduled': return AdminGroupStatusEnum.scheduled;
        case r'lobby': return AdminGroupStatusEnum.lobby;
        case r'live': return AdminGroupStatusEnum.live;
        case r'ended': return AdminGroupStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminGroupStatusEnumTypeTransformer? _instance;
}


