//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminLive {
  /// Returns a new [AdminLive] instance.
  AdminLive({
    required this.id,
    required this.title,
    required this.language,
    required this.status,
    required this.host,
    required this.viewers,
    required this.peakViewers,
    required this.paidMinutes,
    required this.minuteCoins,
    required this.giftCoins,
    required this.openFlags,
    required this.startedAt,
    required this.endedAt,
    required this.endReason,
  });

  String id;

  String title;

  String language;

  AdminLiveStatusEnum status;

  RoomCardHost host;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int viewers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int peakViewers;

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

  DateTime startedAt;

  DateTime? endedAt;

  String? endReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminLive &&
    other.id == id &&
    other.title == title &&
    other.language == language &&
    other.status == status &&
    other.host == host &&
    other.viewers == viewers &&
    other.peakViewers == peakViewers &&
    other.paidMinutes == paidMinutes &&
    other.minuteCoins == minuteCoins &&
    other.giftCoins == giftCoins &&
    other.openFlags == openFlags &&
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
    (viewers.hashCode) +
    (peakViewers.hashCode) +
    (paidMinutes.hashCode) +
    (minuteCoins.hashCode) +
    (giftCoins.hashCode) +
    (openFlags.hashCode) +
    (startedAt.hashCode) +
    (endedAt == null ? 0 : endedAt!.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode);

  @override
  String toString() => 'AdminLive[id=$id, title=$title, language=$language, status=$status, host=$host, viewers=$viewers, peakViewers=$peakViewers, paidMinutes=$paidMinutes, minuteCoins=$minuteCoins, giftCoins=$giftCoins, openFlags=$openFlags, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'status'] = this.status;
      json[r'host'] = this.host;
      json[r'viewers'] = this.viewers;
      json[r'peakViewers'] = this.peakViewers;
      json[r'paidMinutes'] = this.paidMinutes;
      json[r'minuteCoins'] = this.minuteCoins;
      json[r'giftCoins'] = this.giftCoins;
      json[r'openFlags'] = this.openFlags;
      json[r'startedAt'] = this.startedAt.toUtc().toIso8601String();
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

  /// Returns a new [AdminLive] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminLive? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminLive[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminLive[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminLive[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminLive[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminLive[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminLive[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminLive[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminLive[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "AdminLive[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "AdminLive[host]" has a null value in JSON.');
        assert(json.containsKey(r'viewers'), 'Required key "AdminLive[viewers]" is missing from JSON.');
        assert(json[r'viewers'] != null, 'Required key "AdminLive[viewers]" has a null value in JSON.');
        assert(json.containsKey(r'peakViewers'), 'Required key "AdminLive[peakViewers]" is missing from JSON.');
        assert(json[r'peakViewers'] != null, 'Required key "AdminLive[peakViewers]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "AdminLive[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "AdminLive[paidMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'minuteCoins'), 'Required key "AdminLive[minuteCoins]" is missing from JSON.');
        assert(json[r'minuteCoins'] != null, 'Required key "AdminLive[minuteCoins]" has a null value in JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminLive[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminLive[giftCoins]" has a null value in JSON.');
        assert(json.containsKey(r'openFlags'), 'Required key "AdminLive[openFlags]" is missing from JSON.');
        assert(json[r'openFlags'] != null, 'Required key "AdminLive[openFlags]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "AdminLive[startedAt]" is missing from JSON.');
        assert(json[r'startedAt'] != null, 'Required key "AdminLive[startedAt]" has a null value in JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "AdminLive[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminLive[endReason]" is missing from JSON.');
        return true;
      }());

      return AdminLive(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: AdminLiveStatusEnum.fromJson(json[r'status'])!,
        host: RoomCardHost.fromJson(json[r'host'])!,
        viewers: mapValueOfType<int>(json, r'viewers')!,
        peakViewers: mapValueOfType<int>(json, r'peakViewers')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
        minuteCoins: mapValueOfType<int>(json, r'minuteCoins')!,
        giftCoins: mapValueOfType<int>(json, r'giftCoins')!,
        openFlags: mapValueOfType<int>(json, r'openFlags')!,
        startedAt: mapDateTime(json, r'startedAt', r'')!,
        endedAt: mapDateTime(json, r'endedAt', r''),
        endReason: mapValueOfType<String>(json, r'endReason'),
      );
    }
    return null;
  }

  static List<AdminLive> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminLive>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminLive.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminLive> mapFromJson(dynamic json) {
    final map = <String, AdminLive>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminLive.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminLive-objects as value to a dart map
  static Map<String, List<AdminLive>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminLive>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminLive.listFromJson(entry.value, growable: growable,);
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
    'viewers',
    'peakViewers',
    'paidMinutes',
    'minuteCoins',
    'giftCoins',
    'openFlags',
    'startedAt',
    'endedAt',
    'endReason',
  };
}


enum AdminLiveStatusEnum {
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminLiveStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminLiveStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminLiveStatusEnum? fromJson(dynamic value) => AdminLiveStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminLiveStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminLiveStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminLiveStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminLiveStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminLiveStatusEnum] to String,
/// and [decode] dynamic data back to [AdminLiveStatusEnum].
class AdminLiveStatusEnumTypeTransformer {
  factory AdminLiveStatusEnumTypeTransformer() => _instance ??= const AdminLiveStatusEnumTypeTransformer._();

  const AdminLiveStatusEnumTypeTransformer._();

  String encode(AdminLiveStatusEnum data) => data._value;

  /// Returns the instance of [AdminLiveStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminLiveStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminLiveStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return AdminLiveStatusEnum.live;
        case r'ended': return AdminLiveStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminLiveStatusEnumTypeTransformer? _instance;
}


