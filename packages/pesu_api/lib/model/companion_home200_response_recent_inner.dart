//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionHome200ResponseRecentInner {
  /// Returns a new [CompanionHome200ResponseRecentInner] instance.
  CompanionHome200ResponseRecentInner({
    required this.callId,
    required this.callerName,
    required this.callerAvatarId,
    required this.type,
    required this.status,
    required this.startedAt,
    required this.durationSeconds,
    required this.earnedPaise,
  });

  String callId;

  String callerName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int callerAvatarId;

  CompanionHome200ResponseRecentInnerTypeEnum type;

  String status;

  DateTime? startedAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? durationSeconds;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earnedPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionHome200ResponseRecentInner &&
    other.callId == callId &&
    other.callerName == callerName &&
    other.callerAvatarId == callerAvatarId &&
    other.type == type &&
    other.status == status &&
    other.startedAt == startedAt &&
    other.durationSeconds == durationSeconds &&
    other.earnedPaise == earnedPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callId.hashCode) +
    (callerName.hashCode) +
    (callerAvatarId.hashCode) +
    (type.hashCode) +
    (status.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (durationSeconds == null ? 0 : durationSeconds!.hashCode) +
    (earnedPaise.hashCode);

  @override
  String toString() => 'CompanionHome200ResponseRecentInner[callId=$callId, callerName=$callerName, callerAvatarId=$callerAvatarId, type=$type, status=$status, startedAt=$startedAt, durationSeconds=$durationSeconds, earnedPaise=$earnedPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'callId'] = this.callId;
      json[r'callerName'] = this.callerName;
      json[r'callerAvatarId'] = this.callerAvatarId;
      json[r'type'] = this.type;
      json[r'status'] = this.status;
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt!.toUtc().toIso8601String();
    } else {
      json[r'startedAt'] = null;
    }
    if (this.durationSeconds != null) {
      json[r'durationSeconds'] = this.durationSeconds;
    } else {
      json[r'durationSeconds'] = null;
    }
      json[r'earnedPaise'] = this.earnedPaise;
    return json;
  }

  /// Returns a new [CompanionHome200ResponseRecentInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionHome200ResponseRecentInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'callId'), 'Required key "CompanionHome200ResponseRecentInner[callId]" is missing from JSON.');
        assert(json[r'callId'] != null, 'Required key "CompanionHome200ResponseRecentInner[callId]" has a null value in JSON.');
        assert(json.containsKey(r'callerName'), 'Required key "CompanionHome200ResponseRecentInner[callerName]" is missing from JSON.');
        assert(json[r'callerName'] != null, 'Required key "CompanionHome200ResponseRecentInner[callerName]" has a null value in JSON.');
        assert(json.containsKey(r'callerAvatarId'), 'Required key "CompanionHome200ResponseRecentInner[callerAvatarId]" is missing from JSON.');
        assert(json[r'callerAvatarId'] != null, 'Required key "CompanionHome200ResponseRecentInner[callerAvatarId]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "CompanionHome200ResponseRecentInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "CompanionHome200ResponseRecentInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CompanionHome200ResponseRecentInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CompanionHome200ResponseRecentInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "CompanionHome200ResponseRecentInner[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "CompanionHome200ResponseRecentInner[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'earnedPaise'), 'Required key "CompanionHome200ResponseRecentInner[earnedPaise]" is missing from JSON.');
        assert(json[r'earnedPaise'] != null, 'Required key "CompanionHome200ResponseRecentInner[earnedPaise]" has a null value in JSON.');
        return true;
      }());

      return CompanionHome200ResponseRecentInner(
        callId: mapValueOfType<String>(json, r'callId')!,
        callerName: mapValueOfType<String>(json, r'callerName')!,
        callerAvatarId: mapValueOfType<int>(json, r'callerAvatarId')!,
        type: CompanionHome200ResponseRecentInnerTypeEnum.fromJson(json[r'type'])!,
        status: mapValueOfType<String>(json, r'status')!,
        startedAt: mapDateTime(json, r'startedAt', r''),
        durationSeconds: mapValueOfType<int>(json, r'durationSeconds'),
        earnedPaise: mapValueOfType<int>(json, r'earnedPaise')!,
      );
    }
    return null;
  }

  static List<CompanionHome200ResponseRecentInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionHome200ResponseRecentInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionHome200ResponseRecentInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionHome200ResponseRecentInner> mapFromJson(dynamic json) {
    final map = <String, CompanionHome200ResponseRecentInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionHome200ResponseRecentInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionHome200ResponseRecentInner-objects as value to a dart map
  static Map<String, List<CompanionHome200ResponseRecentInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionHome200ResponseRecentInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionHome200ResponseRecentInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'callId',
    'callerName',
    'callerAvatarId',
    'type',
    'status',
    'startedAt',
    'durationSeconds',
    'earnedPaise',
  };
}


enum CompanionHome200ResponseRecentInnerTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const CompanionHome200ResponseRecentInnerTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CompanionHome200ResponseRecentInnerTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CompanionHome200ResponseRecentInnerTypeEnum? fromJson(dynamic value) => CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CompanionHome200ResponseRecentInnerTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CompanionHome200ResponseRecentInnerTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionHome200ResponseRecentInnerTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionHome200ResponseRecentInnerTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CompanionHome200ResponseRecentInnerTypeEnum] to String,
/// and [decode] dynamic data back to [CompanionHome200ResponseRecentInnerTypeEnum].
class CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer {
  factory CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer() => _instance ??= const CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer._();

  const CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer._();

  String encode(CompanionHome200ResponseRecentInnerTypeEnum data) => data._value;

  /// Returns the instance of [CompanionHome200ResponseRecentInnerTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CompanionHome200ResponseRecentInnerTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CompanionHome200ResponseRecentInnerTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return CompanionHome200ResponseRecentInnerTypeEnum.audio;
        case r'video': return CompanionHome200ResponseRecentInnerTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CompanionHome200ResponseRecentInnerTypeEnumTypeTransformer? _instance;
}


