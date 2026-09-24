//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveHostHeartbeat200Response {
  /// Returns a new [LiveHostHeartbeat200Response] instance.
  LiveHostHeartbeat200Response({
    required this.status,
    required this.viewers,
    required this.earnedPaise,
    required this.paidMinutes,
  });

  LiveHostHeartbeat200ResponseStatusEnum status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int viewers;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int earnedPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paidMinutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveHostHeartbeat200Response &&
    other.status == status &&
    other.viewers == viewers &&
    other.earnedPaise == earnedPaise &&
    other.paidMinutes == paidMinutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (viewers.hashCode) +
    (earnedPaise.hashCode) +
    (paidMinutes.hashCode);

  @override
  String toString() => 'LiveHostHeartbeat200Response[status=$status, viewers=$viewers, earnedPaise=$earnedPaise, paidMinutes=$paidMinutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
      json[r'viewers'] = this.viewers;
      json[r'earnedPaise'] = this.earnedPaise;
      json[r'paidMinutes'] = this.paidMinutes;
    return json;
  }

  /// Returns a new [LiveHostHeartbeat200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveHostHeartbeat200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "LiveHostHeartbeat200Response[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "LiveHostHeartbeat200Response[status]" has a null value in JSON.');
        assert(json.containsKey(r'viewers'), 'Required key "LiveHostHeartbeat200Response[viewers]" is missing from JSON.');
        assert(json[r'viewers'] != null, 'Required key "LiveHostHeartbeat200Response[viewers]" has a null value in JSON.');
        assert(json.containsKey(r'earnedPaise'), 'Required key "LiveHostHeartbeat200Response[earnedPaise]" is missing from JSON.');
        assert(json[r'earnedPaise'] != null, 'Required key "LiveHostHeartbeat200Response[earnedPaise]" has a null value in JSON.');
        assert(json.containsKey(r'paidMinutes'), 'Required key "LiveHostHeartbeat200Response[paidMinutes]" is missing from JSON.');
        assert(json[r'paidMinutes'] != null, 'Required key "LiveHostHeartbeat200Response[paidMinutes]" has a null value in JSON.');
        return true;
      }());

      return LiveHostHeartbeat200Response(
        status: LiveHostHeartbeat200ResponseStatusEnum.fromJson(json[r'status'])!,
        viewers: mapValueOfType<int>(json, r'viewers')!,
        earnedPaise: mapValueOfType<int>(json, r'earnedPaise')!,
        paidMinutes: mapValueOfType<int>(json, r'paidMinutes')!,
      );
    }
    return null;
  }

  static List<LiveHostHeartbeat200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveHostHeartbeat200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveHostHeartbeat200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveHostHeartbeat200Response> mapFromJson(dynamic json) {
    final map = <String, LiveHostHeartbeat200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveHostHeartbeat200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveHostHeartbeat200Response-objects as value to a dart map
  static Map<String, List<LiveHostHeartbeat200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveHostHeartbeat200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveHostHeartbeat200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'viewers',
    'earnedPaise',
    'paidMinutes',
  };
}


enum LiveHostHeartbeat200ResponseStatusEnum {
  live._(r'live'),
  ended._(r'ended'),
  ;

  /// Instantiate a new enum with the provided value.
  const LiveHostHeartbeat200ResponseStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LiveHostHeartbeat200ResponseStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LiveHostHeartbeat200ResponseStatusEnum? fromJson(dynamic value) => LiveHostHeartbeat200ResponseStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LiveHostHeartbeat200ResponseStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LiveHostHeartbeat200ResponseStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveHostHeartbeat200ResponseStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveHostHeartbeat200ResponseStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LiveHostHeartbeat200ResponseStatusEnum] to String,
/// and [decode] dynamic data back to [LiveHostHeartbeat200ResponseStatusEnum].
class LiveHostHeartbeat200ResponseStatusEnumTypeTransformer {
  factory LiveHostHeartbeat200ResponseStatusEnumTypeTransformer() => _instance ??= const LiveHostHeartbeat200ResponseStatusEnumTypeTransformer._();

  const LiveHostHeartbeat200ResponseStatusEnumTypeTransformer._();

  String encode(LiveHostHeartbeat200ResponseStatusEnum data) => data._value;

  /// Returns the instance of [LiveHostHeartbeat200ResponseStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LiveHostHeartbeat200ResponseStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LiveHostHeartbeat200ResponseStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return LiveHostHeartbeat200ResponseStatusEnum.live;
        case r'ended': return LiveHostHeartbeat200ResponseStatusEnum.ended;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LiveHostHeartbeat200ResponseStatusEnumTypeTransformer? _instance;
}


