//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminLiveInput {
  /// Returns a new [AdminLiveInput] instance.
  AdminLiveInput({
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

  AdminLiveInputStatusEnum status;

  RoomCardInputHost host;

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

  Object? startedAt;

  Object? endedAt;

  String? endReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminLiveInput &&
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
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (endedAt == null ? 0 : endedAt!.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode);

  @override
  String toString() => 'AdminLiveInput[id=$id, title=$title, language=$language, status=$status, host=$host, viewers=$viewers, peakViewers=$peakViewers, paidMinutes=$paidMinutes, minuteCoins=$minuteCoins, giftCoins=$giftCoins, openFlags=$openFlags, startedAt=$startedAt, endedAt=$endedAt, endReason=$endReason]';

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

  /// Returns a new [AdminLiveInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminLiveInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminLiveInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminLiveInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminLiveInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminLiveInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminLiveInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminLiveInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminLiveInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminLiveInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "AdminLiveInput[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "AdminLiveInput[host]" has a null value in JSON.');
        assert(json.containsKey(r'viewers'), 'Required key "AdminLiveInput[viewers]" is missing from JSON.');
        assert(json[r'viewers'] != null, 'Required key "AdminLiveInput[viewers]" has a null value in JSON.');
        assert(json.containsKey(r'peakViewers'), 'Required key "AdminLiveInput[peakViewers]" is missing from JSON.');
        assert(json[r'peakViewers'] != null, 'Required key "AdminLiveInput[peakViewers]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "AdminLiveInput[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "AdminLiveInput[paidMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'minuteCoins'), 'Required key "AdminLiveInput[minuteCoins]" is missing from JSON.');
        assert(json[r'minuteCoins'] != null, 'Required key "AdminLiveInput[minuteCoins]" has a null value in JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminLiveInput[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminLiveInput[giftCoins]" has a null value in JSON.');
        assert(json.containsKey(r'openFlags'), 'Required key "AdminLiveInput[openFlags]" is missing from JSON.');
        assert(json[r'openFlags'] != null, 'Required key "AdminLiveInput[openFlags]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "AdminLiveInput[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'endedAt'), 'Required key "AdminLiveInput[endedAt]" is missing from JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminLiveInput[endReason]" is missing from JSON.');
        return true;
      }());

      return AdminLiveInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        status: AdminLiveInputStatusEnum.fromJson(json[r'status'])!,
        host: RoomCardInputHost.fromJson(json[r'host'])!,
        viewers: mapValueOfType<int>(json, r'viewers')!,
        peakViewers: mapValueOfType<int>(json, r'peakViewers')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
        minuteCoins: mapValueOfType<int>(json, r'minuteCoins')!,
        giftCoins: mapValueOfType<int>(json, r'giftCoins')!,
        openFlags: mapValueOfType<int>(json, r'openFlags')!,
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
        endedAt: mapValueOfType<Object>(json, r'endedAt'),
        endReason: mapValueOfType<String>(json, r'endReason'),
      );
    }
    return null;
  }

  static List<AdminLiveInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminLiveInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminLiveInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminLiveInput> mapFromJson(dynamic json) {
    final map = <String, AdminLiveInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminLiveInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminLiveInput-objects as value to a dart map
  static Map<String, List<AdminLiveInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminLiveInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminLiveInput.listFromJson(entry.value, growable: growable,);
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


enum AdminLiveInputStatusEnum {
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminLiveInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminLiveInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminLiveInputStatusEnum? fromJson(dynamic value) => AdminLiveInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminLiveInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminLiveInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminLiveInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminLiveInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminLiveInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminLiveInputStatusEnum].
class AdminLiveInputStatusEnumTypeTransformer {
  factory AdminLiveInputStatusEnumTypeTransformer() => _instance ??= const AdminLiveInputStatusEnumTypeTransformer._();

  const AdminLiveInputStatusEnumTypeTransformer._();

  String encode(AdminLiveInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminLiveInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminLiveInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminLiveInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return AdminLiveInputStatusEnum.live;
        case r'ended': return AdminLiveInputStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminLiveInputStatusEnumTypeTransformer? _instance;
}


