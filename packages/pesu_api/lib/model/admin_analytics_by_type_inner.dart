//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsByTypeInner {
  /// Returns a new [AdminAnalyticsByTypeInner] instance.
  AdminAnalyticsByTypeInner({
    required this.type,
    required this.calls,
    required this.minutes,
    required this.coins,
  });

  AdminAnalyticsByTypeInnerTypeEnum type;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsByTypeInner &&
    other.type == type &&
    other.calls == calls &&
    other.minutes == minutes &&
    other.coins == coins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (calls.hashCode) +
    (minutes.hashCode) +
    (coins.hashCode);

  @override
  String toString() => 'AdminAnalyticsByTypeInner[type=$type, calls=$calls, minutes=$minutes, coins=$coins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'calls'] = this.calls;
      json[r'minutes'] = this.minutes;
      json[r'coins'] = this.coins;
    return json;
  }

  /// Returns a new [AdminAnalyticsByTypeInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsByTypeInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'type'), 'Required key "AdminAnalyticsByTypeInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminAnalyticsByTypeInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsByTypeInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsByTypeInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminAnalyticsByTypeInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminAnalyticsByTypeInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminAnalyticsByTypeInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminAnalyticsByTypeInner[coins]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsByTypeInner(
        type: AdminAnalyticsByTypeInnerTypeEnum.fromJson(json[r'type'])!,
        calls: mapValueOfType<int>(json, r'calls')!,
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coins: mapValueOfType<int>(json, r'coins')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsByTypeInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsByTypeInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsByTypeInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsByTypeInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsByTypeInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsByTypeInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsByTypeInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsByTypeInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsByTypeInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsByTypeInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
    'calls',
    'minutes',
    'coins',
  };
}


enum AdminAnalyticsByTypeInnerTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminAnalyticsByTypeInnerTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminAnalyticsByTypeInnerTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminAnalyticsByTypeInnerTypeEnum? fromJson(dynamic value) => AdminAnalyticsByTypeInnerTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminAnalyticsByTypeInnerTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminAnalyticsByTypeInnerTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsByTypeInnerTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsByTypeInnerTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminAnalyticsByTypeInnerTypeEnum] to String,
/// and [decode] dynamic data back to [AdminAnalyticsByTypeInnerTypeEnum].
class AdminAnalyticsByTypeInnerTypeEnumTypeTransformer {
  factory AdminAnalyticsByTypeInnerTypeEnumTypeTransformer() => _instance ??= const AdminAnalyticsByTypeInnerTypeEnumTypeTransformer._();

  const AdminAnalyticsByTypeInnerTypeEnumTypeTransformer._();

  String encode(AdminAnalyticsByTypeInnerTypeEnum data) => data._value;

  /// Returns the instance of [AdminAnalyticsByTypeInnerTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminAnalyticsByTypeInnerTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminAnalyticsByTypeInnerTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminAnalyticsByTypeInnerTypeEnum.audio;
        case r'video': return AdminAnalyticsByTypeInnerTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminAnalyticsByTypeInnerTypeEnumTypeTransformer? _instance;
}


