//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionBonusInput {
  /// Returns a new [CompanionBonusInput] instance.
  CompanionBonusInput({
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

  CompanionBonusInputStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionBonusInput &&
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
  String toString() => 'CompanionBonusInput[id=$id, title=$title, rewardPaise=$rewardPaise, requiredMinutes=$requiredMinutes, windowStart=$windowStart, windowEnd=$windowEnd, doneMinutes=$doneMinutes, status=$status]';

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

  /// Returns a new [CompanionBonusInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionBonusInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CompanionBonusInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CompanionBonusInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "CompanionBonusInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "CompanionBonusInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'rewardPaise'), 'Required key "CompanionBonusInput[rewardPaise]" is missing from JSON.');
        assert(json[r'rewardPaise'] != null, 'Required key "CompanionBonusInput[rewardPaise]" has a null value in JSON.');
        assert(json.containsKey(r'requiredMinutes'), 'Required key "CompanionBonusInput[requiredMinutes]" is missing from JSON.');
        assert(json[r'requiredMinutes'] != null, 'Required key "CompanionBonusInput[requiredMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'windowStart'), 'Required key "CompanionBonusInput[windowStart]" is missing from JSON.');
        assert(json[r'windowStart'] != null, 'Required key "CompanionBonusInput[windowStart]" has a null value in JSON.');
        assert(json.containsKey(r'windowEnd'), 'Required key "CompanionBonusInput[windowEnd]" is missing from JSON.');
        assert(json[r'windowEnd'] != null, 'Required key "CompanionBonusInput[windowEnd]" has a null value in JSON.');
        assert(json.containsKey(r'doneMinutes'), 'Required key "CompanionBonusInput[doneMinutes]" is missing from JSON.');
        assert(json[r'doneMinutes'] != null, 'Required key "CompanionBonusInput[doneMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "CompanionBonusInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "CompanionBonusInput[status]" has a null value in JSON.');
        return true;
      }());

      return CompanionBonusInput(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        rewardPaise: mapValueOfType<int>(json, r'rewardPaise')!,
        requiredMinutes: mapValueOfType<int>(json, r'requiredMinutes')!,
        windowStart: mapValueOfType<int>(json, r'windowStart')!,
        windowEnd: mapValueOfType<int>(json, r'windowEnd')!,
        doneMinutes: mapValueOfType<int>(json, r'doneMinutes')!,
        status: CompanionBonusInputStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<CompanionBonusInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionBonusInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionBonusInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionBonusInput> mapFromJson(dynamic json) {
    final map = <String, CompanionBonusInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionBonusInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionBonusInput-objects as value to a dart map
  static Map<String, List<CompanionBonusInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionBonusInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionBonusInput.listFromJson(entry.value, growable: growable,);
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


enum CompanionBonusInputStatusEnum {
  upcoming._(r'upcoming'),
  active._(r'active'),
  earned._(r'earned'),
  paid._(r'paid'),
  missed._(r'missed'),
  ;

  /// Instantiate a new enum with the provided value.
  const CompanionBonusInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CompanionBonusInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CompanionBonusInputStatusEnum? fromJson(dynamic value) => CompanionBonusInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CompanionBonusInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CompanionBonusInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionBonusInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionBonusInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CompanionBonusInputStatusEnum] to String,
/// and [decode] dynamic data back to [CompanionBonusInputStatusEnum].
class CompanionBonusInputStatusEnumTypeTransformer {
  factory CompanionBonusInputStatusEnumTypeTransformer() => _instance ??= const CompanionBonusInputStatusEnumTypeTransformer._();

  const CompanionBonusInputStatusEnumTypeTransformer._();

  String encode(CompanionBonusInputStatusEnum data) => data._value;

  /// Returns the instance of [CompanionBonusInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CompanionBonusInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CompanionBonusInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'upcoming': return CompanionBonusInputStatusEnum.upcoming;
        case r'active': return CompanionBonusInputStatusEnum.active;
        case r'earned': return CompanionBonusInputStatusEnum.earned;
        case r'paid': return CompanionBonusInputStatusEnum.paid;
        case r'missed': return CompanionBonusInputStatusEnum.missed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CompanionBonusInputStatusEnumTypeTransformer? _instance;
}


