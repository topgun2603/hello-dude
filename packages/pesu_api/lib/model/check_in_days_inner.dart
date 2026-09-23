//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CheckInDaysInner {
  /// Returns a new [CheckInDaysInner] instance.
  CheckInDaysInner({
    required this.day,
    required this.coins,
    required this.state,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int day;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  CheckInDaysInnerStateEnum state;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckInDaysInner &&
    other.day == day &&
    other.coins == coins &&
    other.state == state;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (day.hashCode) +
    (coins.hashCode) +
    (state.hashCode);

  @override
  String toString() => 'CheckInDaysInner[day=$day, coins=$coins, state=$state]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
      json[r'coins'] = this.coins;
      json[r'state'] = this.state;
    return json;
  }

  /// Returns a new [CheckInDaysInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckInDaysInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'day'), 'Required key "CheckInDaysInner[day]" is missing from JSON.');
        assert(json[r'day'] != null, 'Required key "CheckInDaysInner[day]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "CheckInDaysInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "CheckInDaysInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'state'), 'Required key "CheckInDaysInner[state]" is missing from JSON.');
        assert(json[r'state'] != null, 'Required key "CheckInDaysInner[state]" has a null value in JSON.');
        return true;
      }());

      return CheckInDaysInner(
        day: mapValueOfType<int>(json, r'day')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        state: CheckInDaysInnerStateEnum.fromJson(json[r'state'])!,
      );
    }
    return null;
  }

  static List<CheckInDaysInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckInDaysInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckInDaysInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckInDaysInner> mapFromJson(dynamic json) {
    final map = <String, CheckInDaysInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckInDaysInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckInDaysInner-objects as value to a dart map
  static Map<String, List<CheckInDaysInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckInDaysInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckInDaysInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'day',
    'coins',
    'state',
  };
}


enum CheckInDaysInnerStateEnum {
  claimed._(r'claimed'),
  today._(r'today'),
  upcoming._(r'upcoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CheckInDaysInnerStateEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CheckInDaysInnerStateEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CheckInDaysInnerStateEnum? fromJson(dynamic value) => CheckInDaysInnerStateEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CheckInDaysInnerStateEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CheckInDaysInnerStateEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckInDaysInnerStateEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckInDaysInnerStateEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CheckInDaysInnerStateEnum] to String,
/// and [decode] dynamic data back to [CheckInDaysInnerStateEnum].
class CheckInDaysInnerStateEnumTypeTransformer {
  factory CheckInDaysInnerStateEnumTypeTransformer() => _instance ??= const CheckInDaysInnerStateEnumTypeTransformer._();

  const CheckInDaysInnerStateEnumTypeTransformer._();

  String encode(CheckInDaysInnerStateEnum data) => data._value;

  /// Returns the instance of [CheckInDaysInnerStateEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CheckInDaysInnerStateEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CheckInDaysInnerStateEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'claimed': return CheckInDaysInnerStateEnum.claimed;
        case r'today': return CheckInDaysInnerStateEnum.today;
        case r'upcoming': return CheckInDaysInnerStateEnum.upcoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CheckInDaysInnerStateEnumTypeTransformer? _instance;
}


