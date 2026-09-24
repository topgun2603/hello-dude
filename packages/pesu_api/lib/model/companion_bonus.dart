//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionBonus {
  /// Returns a new [CompanionBonus] instance.
  CompanionBonus({
    required this.id,
    required this.title,
    required this.rewardPaise,
    required this.requiredMinutes,
    required this.windowStart,
    required this.windowEnd,
    required this.doneMinutes,
    required this.status,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String title;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int rewardPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int requiredMinutes;

  /// Minutes after IST midnight
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int windowStart;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int windowEnd;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int doneMinutes;

  CompanionBonusStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionBonus &&
    other.id == id &&
    other.title == title &&
    other.rewardPaise == rewardPaise &&
    other.requiredMinutes == requiredMinutes &&
    other.windowStart == windowStart &&
    other.windowEnd == windowEnd &&
    other.doneMinutes == doneMinutes &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (rewardPaise.hashCode) +
    (requiredMinutes.hashCode) +
    (windowStart.hashCode) +
    (windowEnd.hashCode) +
    (doneMinutes.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'CompanionBonus[id=$id, title=$title, rewardPaise=$rewardPaise, requiredMinutes=$requiredMinutes, windowStart=$windowStart, windowEnd=$windowEnd, doneMinutes=$doneMinutes, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'rewardPaise'] = this.rewardPaise;
      json[r'requiredMinutes'] = this.requiredMinutes;
      json[r'windowStart'] = this.windowStart;
      json[r'windowEnd'] = this.windowEnd;
      json[r'doneMinutes'] = this.doneMinutes;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [CompanionBonus] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionBonus? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CompanionBonus[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CompanionBonus[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "CompanionBonus[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "CompanionBonus[title]" has a null value in JSON.');
        assert(json.containsKey(r'rewardPaise'), 'Required key "CompanionBonus[rewardPaise]" is missing from JSON.');
        assert(json[r'rewardPaise'] != null, 'Required key "CompanionBonus[rewardPaise]" has a null value in JSON.');
        assert(json.containsKey(r'requiredMinutes'), 'Required key "CompanionBonus[requiredMinutes]" is missing from JSON.');
        assert(json[r'requiredMinutes'] != null, 'Required key "CompanionBonus[requiredMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'windowStart'), 'Required key "CompanionBonus[windowStart]" is missing from JSON.');
        assert(json[r'windowStart'] != null, 'Required key "CompanionBonus[windowStart]" has a null value in JSON.');
        assert(json.containsKey(r'windowEnd'), 'Required key "CompanionBonus[windowEnd]" is missing from JSON.');
        assert(json[r'windowEnd'] != null, 'Required key "CompanionBonus[windowEnd]" has a null value in JSON.');
        assert(json.containsKey(r'doneMinutes'), 'Required key "CompanionBonus[doneMinutes]" is missing from JSON.');
        assert(json[r'doneMinutes'] != null, 'Required key "CompanionBonus[doneMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CompanionBonus[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CompanionBonus[status]" has a null value in JSON.');
        return true;
      }());

      return CompanionBonus(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        rewardPaise: mapValueOfType<int>(json, r'rewardPaise')!,
        requiredMinutes: mapValueOfType<int>(json, r'requiredMinutes')!,
        windowStart: mapValueOfType<int>(json, r'windowStart')!,
        windowEnd: mapValueOfType<int>(json, r'windowEnd')!,
        doneMinutes: mapValueOfType<int>(json, r'doneMinutes')!,
        status: CompanionBonusStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<CompanionBonus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionBonus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionBonus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionBonus> mapFromJson(dynamic json) {
    final map = <String, CompanionBonus>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionBonus.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionBonus-objects as value to a dart map
  static Map<String, List<CompanionBonus>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionBonus>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionBonus.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'rewardPaise',
    'requiredMinutes',
    'windowStart',
    'windowEnd',
    'doneMinutes',
    'status',
  };
}


enum CompanionBonusStatusEnum {
  upcoming._(r'upcoming'),
  active._(r'active'),
  earned._(r'earned'),
  paid._(r'paid'),
  missed._(r'missed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CompanionBonusStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CompanionBonusStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CompanionBonusStatusEnum? fromJson(dynamic value) => CompanionBonusStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CompanionBonusStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CompanionBonusStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionBonusStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionBonusStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CompanionBonusStatusEnum] to String,
/// and [decode] dynamic data back to [CompanionBonusStatusEnum].
class CompanionBonusStatusEnumTypeTransformer {
  factory CompanionBonusStatusEnumTypeTransformer() => _instance ??= const CompanionBonusStatusEnumTypeTransformer._();

  const CompanionBonusStatusEnumTypeTransformer._();

  String encode(CompanionBonusStatusEnum data) => data._value;

  /// Returns the instance of [CompanionBonusStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CompanionBonusStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CompanionBonusStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'upcoming': return CompanionBonusStatusEnum.upcoming;
        case r'active': return CompanionBonusStatusEnum.active;
        case r'earned': return CompanionBonusStatusEnum.earned;
        case r'paid': return CompanionBonusStatusEnum.paid;
        case r'missed': return CompanionBonusStatusEnum.missed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CompanionBonusStatusEnumTypeTransformer? _instance;
}


