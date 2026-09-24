//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminGroupInput {
  /// Returns a new [AdminGroupInput] instance.
  AdminGroupInput({
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

  AdminGroupInputStatusEnum status;

  RoomCardInputHost host;

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

  Object? scheduledAt;

  Object? startedAt;

  Object? endedAt;

  String? endReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminGroupInput &&
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
  String toString() => 'AdminGroupInput[id=$id, title=$title, language=$language, status=$status, host=$host, members=$members, paidMinutes=$paidMinutes, minuteCoins=$minuteCoins, giftCoins=$giftCoins, openFlags=$openFlags, scheduledAt=$scheduledAt, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason]';

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
      json[r'scheduledAt'] = this.scheduledAt;
    } else {
      json[r'scheduledAt'] = null;
    }
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt;
    } else {
      json[r'startedAt'] = null;
    }
    if (this.endedAt != null) {
      json[r'endedAt'] = this.endedAt;
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

  /// Returns a new [AdminGroupInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminGroupInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminGroupInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminGroupInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminGroupInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminGroupInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminGroupInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminGroupInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminGroupInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminGroupInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "AdminGroupInput[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "AdminGroupInput[host]" has a null value in JSON.');
        assert(json.containsKey(r'members'), 'Required key "AdminGroupInput[members]" is missing from JSON.');
        assert(json[r'members'] != null, 'Required key "AdminGroupInput[members]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "AdminGroupInput[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "AdminGroupInput[paidMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'minuteCoins'), 'Required key "AdminGroupInput[minuteCoins]" is missing from JSON.');
        assert(json[r'minuteCoins'] != null, 'Required key "AdminGroupInput[minuteCoins]" has a null value in JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminGroupInput[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminGroupInput[giftCoins]" has a null value in JSON.');
        assert(json.containsKey(r'openFlags'), 'Required key "AdminGroupInput[openFlags]" is missing from JSON.');
        assert(json[r'openFlags'] != null, 'Required key "AdminGroupInput[openFlags]" has a null value in JSON.');
        assert(json.containsKey(r'scheduledAt'), 'Required key "AdminGroupInput[scheduledAt]" is missing from JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "AdminGroupInput[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "AdminGroupInput[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminGroupInput[endReason]" is missing from JSON.');
        return true;
      }());

      return AdminGroupInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: AdminGroupInputStatusEnum.fromJson(json[r'status'])!,
        host: RoomCardInputHost.fromJson(json[r'host'])!,
        members: mapValueOfType<int>(json, r'members')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
        minuteCoins: mapValueOfType<int>(json, r'minuteCoins')!,
        giftCoins: mapValueOfType<int>(json, r'giftCoins')!,
        openFlags: mapValueOfType<int>(json, r'openFlags')!,
        scheduledAt: mapValueOfType<Object>(json, r'scheduledAt'),
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
        endedAt: mapValueOfType<Object>(json, r'endedAt'),
        endReason: mapValueOfType<String>(json, r'endReason'),
      );
    }
    return null;
  }

  static List<AdminGroupInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminGroupInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminGroupInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminGroupInput> mapFromJson(dynamic json) {
    final map = <String, AdminGroupInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminGroupInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminGroupInput-objects as value to a dart map
  static Map<String, List<AdminGroupInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminGroupInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminGroupInput.listFromJson(entry.value, growable: growable,);
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


enum AdminGroupInputStatusEnum {
  scheduled._(r'scheduled'),
  lobby._(r'lobby'),
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminGroupInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminGroupInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminGroupInputStatusEnum? fromJson(dynamic value) => AdminGroupInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminGroupInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminGroupInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminGroupInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminGroupInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminGroupInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminGroupInputStatusEnum].
class AdminGroupInputStatusEnumTypeTransformer {
  factory AdminGroupInputStatusEnumTypeTransformer() => _instance ??= const AdminGroupInputStatusEnumTypeTransformer._();

  const AdminGroupInputStatusEnumTypeTransformer._();

  String encode(AdminGroupInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminGroupInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminGroupInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminGroupInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'scheduled': return AdminGroupInputStatusEnum.scheduled;
        case r'lobby': return AdminGroupInputStatusEnum.lobby;
        case r'live': return AdminGroupInputStatusEnum.live;
        case r'ended': return AdminGroupInputStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminGroupInputStatusEnumTypeTransformer? _instance;
}


