//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CheckInInputDaysInner {
  /// Returns a new [CheckInInputDaysInner] instance.
  CheckInInputDaysInner({
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

  CheckInInputDaysInnerStateEnum state;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckInInputDaysInner &&
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
  String toString() => 'CheckInInputDaysInner[day=$day, coins=$coins, state=$state]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
      json[r'coins'] = this.coins;
      json[r'state'] = this.state;
    return json;
  }

  /// Returns a new [CheckInInputDaysInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckInInputDaysInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'day'), 'Required key "CheckInInputDaysInner[day]" is missing from JSON.');
        assert(json[r'day'] != null, 'Required key "CheckInInputDaysInner[day]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "CheckInInputDaysInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "CheckInInputDaysInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'state'), 'Required key "CheckInInputDaysInner[state]" is missing from JSON.');
        assert(json[r'state'] != null, 'Required key "CheckInInputDaysInner[state]" has a null value in JSON.');
        return true;
      }());

      return CheckInInputDaysInner(
        day: mapValueOfType<int>(json, r'day')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        state: CheckInInputDaysInnerStateEnum.fromJson(json[r'state'])!,
      );
    }
    return null;
  }

  static List<CheckInInputDaysInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckInInputDaysInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckInInputDaysInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckInInputDaysInner> mapFromJson(dynamic json) {
    final map = <String, CheckInInputDaysInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckInInputDaysInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckInInputDaysInner-objects as value to a dart map
  static Map<String, List<CheckInInputDaysInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckInInputDaysInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckInInputDaysInner.listFromJson(entry.value, growable: growable,);
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


enum CheckInInputDaysInnerStateEnum {
  claimed._(r'claimed'),
  today._(r'today'),
  upcoming._(r'upcoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const CheckInInputDaysInnerStateEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CheckInInputDaysInnerStateEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CheckInInputDaysInnerStateEnum? fromJson(dynamic value) => CheckInInputDaysInnerStateEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CheckInInputDaysInnerStateEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CheckInInputDaysInnerStateEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckInInputDaysInnerStateEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckInInputDaysInnerStateEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CheckInInputDaysInnerStateEnum] to String,
/// and [decode] dynamic data back to [CheckInInputDaysInnerStateEnum].
class CheckInInputDaysInnerStateEnumTypeTransformer {
  factory CheckInInputDaysInnerStateEnumTypeTransformer() => _instance ??= const CheckInInputDaysInnerStateEnumTypeTransformer._();

  const CheckInInputDaysInnerStateEnumTypeTransformer._();

  String encode(CheckInInputDaysInnerStateEnum data) => data._value;

  /// Returns the instance of [CheckInInputDaysInnerStateEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CheckInInputDaysInnerStateEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CheckInInputDaysInnerStateEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'claimed': return CheckInInputDaysInnerStateEnum.claimed;
        case r'today': return CheckInInputDaysInnerStateEnum.today;
        case r'upcoming': return CheckInInputDaysInnerStateEnum.upcoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CheckInInputDaysInnerStateEnumTypeTransformer? _instance;
}


