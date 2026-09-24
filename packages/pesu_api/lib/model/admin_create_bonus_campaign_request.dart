//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreateBonusCampaignRequest {
  /// Returns a new [AdminCreateBonusCampaignRequest] instance.
  AdminCreateBonusCampaignRequest({
    required this.title,
    required this.rewardPaise,
    required this.requiredMinutes,
    required this.windowStart,
    required this.windowEnd,
    this.weekdays = const [],
    required this.startsOn,
    this.endsOn,
    required this.isActive,
  });

  String title;

  /// Minimum value: 100
  /// Maximum value: 1000000
  int rewardPaise;

  /// Minimum value: 10
  /// Maximum value: 1440
  int requiredMinutes;

  /// Minimum value: 0
  /// Maximum value: 1439
  int windowStart;

  /// Minimum value: 1
  /// Maximum value: 1440
  int windowEnd;

  List<int> weekdays;

  String startsOn;

  String? endsOn;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreateBonusCampaignRequest &&
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
  String toString() => 'AdminCreateBonusCampaignRequest[title=$title, rewardPaise=$rewardPaise, requiredMinutes=$requiredMinutes, windowStart=$windowStart, windowEnd=$windowEnd, weekdays=$weekdays, startsOn=$startsOn, endsOn=$endsOn, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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

  /// Returns a new [AdminCreateBonusCampaignRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreateBonusCampaignRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'title'), 'Required key "AdminCreateBonusCampaignRequest[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminCreateBonusCampaignRequest[title]" has a null value in JSON.');
        assert(json.containsKey(r'rewardPaise'), 'Required key "AdminCreateBonusCampaignRequest[rewardPaise]" is missing from JSON.');
        assert(json[r'rewardPaise'] != null, 'Required key "AdminCreateBonusCampaignRequest[rewardPaise]" has a null value in JSON.');
        assert(json.containsKey(r'requiredMinutes'), 'Required key "AdminCreateBonusCampaignRequest[requiredMinutes]" is missing from JSON.');
        assert(json[r'requiredMinutes'] != null, 'Required key "AdminCreateBonusCampaignRequest[requiredMinutes]" has a null value in JSON.');
        assert(json.containsKey(r'windowStart'), 'Required key "AdminCreateBonusCampaignRequest[windowStart]" is missing from JSON.');
        assert(json[r'windowStart'] != null, 'Required key "AdminCreateBonusCampaignRequest[windowStart]" has a null value in JSON.');
        assert(json.containsKey(r'windowEnd'), 'Required key "AdminCreateBonusCampaignRequest[windowEnd]" is missing from JSON.');
        assert(json[r'windowEnd'] != null, 'Required key "AdminCreateBonusCampaignRequest[windowEnd]" has a null value in JSON.');
        assert(json.containsKey(r'weekdays'), 'Required key "AdminCreateBonusCampaignRequest[weekdays]" is missing from JSON.');
        assert(json[r'weekdays'] != null, 'Required key "AdminCreateBonusCampaignRequest[weekdays]" has a null value in JSON.');
        assert(json.containsKey(r'startsOn'), 'Required key "AdminCreateBonusCampaignRequest[startsOn]" is missing from JSON.');
        assert(json[r'startsOn'] != null, 'Required key "AdminCreateBonusCampaignRequest[startsOn]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminCreateBonusCampaignRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminCreateBonusCampaignRequest[isActive]" has a null value in JSON.');
        return true;
      }());

      return AdminCreateBonusCampaignRequest(
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

  static List<AdminCreateBonusCampaignRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateBonusCampaignRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateBonusCampaignRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreateBonusCampaignRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreateBonusCampaignRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreateBonusCampaignRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreateBonusCampaignRequest-objects as value to a dart map
  static Map<String, List<AdminCreateBonusCampaignRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreateBonusCampaignRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreateBonusCampaignRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'rewardPaise',
    'requiredMinutes',
    'windowStart',
    'windowEnd',
    'weekdays',
    'startsOn',
    'isActive',
  };
}

