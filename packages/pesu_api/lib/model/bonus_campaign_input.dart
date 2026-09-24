//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class BonusCampaignInput {
  /// Returns a new [BonusCampaignInput] instance.
  BonusCampaignInput({
    required this.id,
    required this.title,
    required this.rewardPaise,
    required this.requiredMinutes,
    required this.windowStart,
    required this.windowEnd,
    this.weekdays = const [],
    required this.startsOn,
    required this.endsOn,
    required this.isActive,
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

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int windowStart;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int windowEnd;

  List<int> weekdays;

  String startsOn;

  String? endsOn;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BonusCampaignInput &&
    other.id == id &&
    other.title == title &&
    other.rewardPaise == rewardPaise &&
    other.requiredMinutes == requiredMinutes &&
    other.windowStart == windowStart &&
    other.windowEnd == windowEnd &&
    _deepEquality.equals(other.weekdays, weekdays) &&
    other.startsOn == startsOn &&
    other.endsOn == endsOn &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (rewardPaise.hashCode) +
    (requiredMinutes.hashCode) +
    (windowStart.hashCode) +
    (windowEnd.hashCode) +
    (weekdays.hashCode) +
    (startsOn.hashCode) +
    (endsOn == null ? 0 : endsOn!.hashCode) +
    (isActive.hashCode);

  @override
  String toString() => 'BonusCampaignInput[id=$id, title=$title, rewardPaise=$rewardPaise, requiredMinutes=$requiredMinutes, windowStart=$windowStart, windowEnd=$windowEnd, weekdays=$weekdays, startsOn=$startsOn, endsOn=$endsOn, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'rewardPaise'] = this.rewardPaise;
      json[r'requiredMinutes'] = this.requiredMinutes;
      json[r'windowStart'] = this.windowStart;
      json[r'windowEnd'] = this.windowEnd;
      json[r'weekdays'] = this.weekdays;
      json[r'startsOn'] = this.startsOn;
    if (this.endsOn != null) {
      json[r'endsOn'] = this.endsOn;
    } else {
      json[r'endsOn'] = null;
    }
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [BonusCampaignInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BonusCampaignInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "BonusCampaignInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "BonusCampaignInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "BonusCampaignInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "BonusCampaignInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'rewardPaise'), 'Required key "BonusCampaignInput[rewardPaise]" is missing from JSON.');
        assert(json[r'rewardPaise'] != null, 'Required key "BonusCampaignInput[rewardPaise]" has a null value in JSON.');
        assert(json.containsKey(r'requiredMinutes'), 'Required key "BonusCampaignInput[requiredMinutes]" is missing from JSON.');
        assert(json[r'requiredMinutes'] != null, 'Required key "BonusCampaignInput[requiredMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'windowStart'), 'Required key "BonusCampaignInput[windowStart]" is missing from JSON.');
        assert(json[r'windowStart'] != null, 'Required key "BonusCampaignInput[windowStart]" has a null value in JSON.');
        assert(json.containsKey(r'windowEnd'), 'Required key "BonusCampaignInput[windowEnd]" is missing from JSON.');
        assert(json[r'windowEnd'] != null, 'Required key "BonusCampaignInput[windowEnd]" has a null value in JSON.');
        assert(json.containsKey(r'weekdays'), 'Required key "BonusCampaignInput[weekdays]" is missing from JSON.');
        assert(json[r'weekdays'] != null, 'Required key "BonusCampaignInput[weekdays]" has a null value in JSON.');
        assert(json.containsKey(r'startsOn'), 'Required key "BonusCampaignInput[startsOn]" is missing from JSON.');
        assert(json[r'startsOn'] != null, 'Required key "BonusCampaignInput[startsOn]" has a null value in JSON.');
        assert(json.containsKey(r'endsOn'), 'Required key "BonusCampaignInput[endsOn]" is missing from JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "BonusCampaignInput[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "BonusCampaignInput[isActive]" has a null value in JSON.');
        return true;
      }());

      return BonusCampaignInput(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        rewardPaise: mapValueOfType<int>(json, r'rewardPaise')!,
        requiredMinutes: mapValueOfType<int>(json, r'requiredMinutes')!,
        windowStart: mapValueOfType<int>(json, r'windowStart')!,
        windowEnd: mapValueOfType<int>(json, r'windowEnd')!,
        weekdays: json[r'weekdays'] is Iterable
            ? (json[r'weekdays'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        startsOn: mapValueOfType<String>(json, r'startsOn')!,
        endsOn: mapValueOfType<String>(json, r'endsOn'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
      );
    }
    return null;
  }

  static List<BonusCampaignInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BonusCampaignInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BonusCampaignInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BonusCampaignInput> mapFromJson(dynamic json) {
    final map = <String, BonusCampaignInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BonusCampaignInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BonusCampaignInput-objects as value to a dart map
  static Map<String, List<BonusCampaignInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BonusCampaignInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BonusCampaignInput.listFromJson(entry.value, growable: growable,);
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
    'weekdays',
    'startsOn',
    'endsOn',
    'isActive',
  };
}

