//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInput {
  /// Returns a new [AdminAnalyticsInput] instance.
  AdminAnalyticsInput({
    required this.range,
    required this.previous,
    required this.totals,
    required this.previousTotals,
    required this.margin,
    this.daily = const [],
    this.byLanguage = const [],
    this.byType = const [],
    this.byHour = const [],
    this.topRated = const [],
    this.mostActive = const [],
    this.topEarners = const [],
    this.topSpenders = const [],
    this.mostReported = const [],
  });

  AdminAnalyticsInputRange range;

  AdminAnalyticsInputPrevious previous;

  AnalyticsTotalsInput totals;

  AnalyticsTotalsInput previousTotals;

  AdminAnalyticsInputMargin margin;

  List<AdminAnalyticsInputDailyInner> daily;

  List<AdminAnalyticsInputByLanguageInner> byLanguage;

  List<AdminAnalyticsInputByTypeInner> byType;

  List<AdminAnalyticsInputByHourInner> byHour;

  List<AdminAnalyticsInputTopRatedInner> topRated;

  List<AdminAnalyticsInputMostActiveInner> mostActive;

  List<AdminAnalyticsInputTopEarnersInner> topEarners;

  List<AdminAnalyticsInputTopSpendersInner> topSpenders;

  List<AdminAnalyticsInputMostReportedInner> mostReported;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInput &&
    other.range == range &&
    other.previous == previous &&
    other.totals == totals &&
    other.previousTotals == previousTotals &&
    other.margin == margin &&
    _deepEquality.equals(other.daily, daily) &&
    _deepEquality.equals(other.byLanguage, byLanguage) &&
    _deepEquality.equals(other.byType, byType) &&
    _deepEquality.equals(other.byHour, byHour) &&
    _deepEquality.equals(other.topRated, topRated) &&
    _deepEquality.equals(other.mostActive, mostActive) &&
    _deepEquality.equals(other.topEarners, topEarners) &&
    _deepEquality.equals(other.topSpenders, topSpenders) &&
    _deepEquality.equals(other.mostReported, mostReported);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (range.hashCode) +
    (previous.hashCode) +
    (totals.hashCode) +
    (previousTotals.hashCode) +
    (margin.hashCode) +
    (daily.hashCode) +
    (byLanguage.hashCode) +
    (byType.hashCode) +
    (byHour.hashCode) +
    (topRated.hashCode) +
    (mostActive.hashCode) +
    (topEarners.hashCode) +
    (topSpenders.hashCode) +
    (mostReported.hashCode);

  @override
  String toString() => 'AdminAnalyticsInput[range=$range, previous=$previous, totals=$totals, previousTotals=$previousTotals, margin=$margin, daily=$daily, byLanguage=$byLanguage, byType=$byType, byHour=$byHour, topRated=$topRated, mostActive=$mostActive, topEarners=$topEarners, topSpenders=$topSpenders, mostReported=$mostReported]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'range'] = this.range;
      json[r'previous'] = this.previous;
      json[r'totals'] = this.totals;
      json[r'previousTotals'] = this.previousTotals;
      json[r'margin'] = this.margin;
      json[r'daily'] = this.daily;
      json[r'byLanguage'] = this.byLanguage;
      json[r'byType'] = this.byType;
      json[r'byHour'] = this.byHour;
      json[r'topRated'] = this.topRated;
      json[r'mostActive'] = this.mostActive;
      json[r'topEarners'] = this.topEarners;
      json[r'topSpenders'] = this.topSpenders;
      json[r'mostReported'] = this.mostReported;
    return json;
  }

  /// Returns a new [AdminAnalyticsInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'range'), 'Required key "AdminAnalyticsInput[range]" is missing from JSON.');
        assert(json[r'range'] != null, 'Required key "AdminAnalyticsInput[range]" has a null value in JSON.');
        assert(json.containsKey(r'previous'), 'Required key "AdminAnalyticsInput[previous]" is missing from JSON.');
        assert(json[r'previous'] != null, 'Required key "AdminAnalyticsInput[previous]" has a null value in JSON.');
        assert(json.containsKey(r'totals'), 'Required key "AdminAnalyticsInput[totals]" is missing from JSON.');
        assert(json[r'totals'] != null, 'Required key "AdminAnalyticsInput[totals]" has a null value in JSON.');
        assert(json.containsKey(r'previousTotals'), 'Required key "AdminAnalyticsInput[previousTotals]" is missing from JSON.');
        assert(json[r'previousTotals'] != null, 'Required key "AdminAnalyticsInput[previousTotals]" has a null value in JSON.');
        assert(json.containsKey(r'margin'), 'Required key "AdminAnalyticsInput[margin]" is missing from JSON.');
        assert(json[r'margin'] != null, 'Required key "AdminAnalyticsInput[margin]" has a null value in JSON.');
        assert(json.containsKey(r'daily'), 'Required key "AdminAnalyticsInput[daily]" is missing from JSON.');
        assert(json[r'daily'] != null, 'Required key "AdminAnalyticsInput[daily]" has a null value in JSON.');
        assert(json.containsKey(r'byLanguage'), 'Required key "AdminAnalyticsInput[byLanguage]" is missing from JSON.');
        assert(json[r'byLanguage'] != null, 'Required key "AdminAnalyticsInput[byLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'byType'), 'Required key "AdminAnalyticsInput[byType]" is missing from JSON.');
        assert(json[r'byType'] != null, 'Required key "AdminAnalyticsInput[byType]" has a null value in JSON.');
        assert(json.containsKey(r'byHour'), 'Required key "AdminAnalyticsInput[byHour]" is missing from JSON.');
        assert(json[r'byHour'] != null, 'Required key "AdminAnalyticsInput[byHour]" has a null value in JSON.');
        assert(json.containsKey(r'topRated'), 'Required key "AdminAnalyticsInput[topRated]" is missing from JSON.');
        assert(json[r'topRated'] != null, 'Required key "AdminAnalyticsInput[topRated]" has a null value in JSON.');
        assert(json.containsKey(r'mostActive'), 'Required key "AdminAnalyticsInput[mostActive]" is missing from JSON.');
        assert(json[r'mostActive'] != null, 'Required key "AdminAnalyticsInput[mostActive]" has a null value in JSON.');
        assert(json.containsKey(r'topEarners'), 'Required key "AdminAnalyticsInput[topEarners]" is missing from JSON.');
        assert(json[r'topEarners'] != null, 'Required key "AdminAnalyticsInput[topEarners]" has a null value in JSON.');
        assert(json.containsKey(r'topSpenders'), 'Required key "AdminAnalyticsInput[topSpenders]" is missing from JSON.');
        assert(json[r'topSpenders'] != null, 'Required key "AdminAnalyticsInput[topSpenders]" has a null value in JSON.');
        assert(json.containsKey(r'mostReported'), 'Required key "AdminAnalyticsInput[mostReported]" is missing from JSON.');
        assert(json[r'mostReported'] != null, 'Required key "AdminAnalyticsInput[mostReported]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInput(
        range: AdminAnalyticsInputRange.fromJson(json[r'range'])!,
        previous: AdminAnalyticsInputPrevious.fromJson(json[r'previous'])!,
        totals: AnalyticsTotalsInput.fromJson(json[r'totals'])!,
        previousTotals: AnalyticsTotalsInput.fromJson(json[r'previousTotals'])!,
        margin: AdminAnalyticsInputMargin.fromJson(json[r'margin'])!,
        daily: AdminAnalyticsInputDailyInner.listFromJson(json[r'daily']),
        byLanguage: AdminAnalyticsInputByLanguageInner.listFromJson(json[r'byLanguage']),
        byType: AdminAnalyticsInputByTypeInner.listFromJson(json[r'byType']),
        byHour: AdminAnalyticsInputByHourInner.listFromJson(json[r'byHour']),
        topRated: AdminAnalyticsInputTopRatedInner.listFromJson(json[r'topRated']),
        mostActive: AdminAnalyticsInputMostActiveInner.listFromJson(json[r'mostActive']),
        topEarners: AdminAnalyticsInputTopEarnersInner.listFromJson(json[r'topEarners']),
        topSpenders: AdminAnalyticsInputTopSpendersInner.listFromJson(json[r'topSpenders']),
        mostReported: AdminAnalyticsInputMostReportedInner.listFromJson(json[r'mostReported']),
      );
    }
    return null;
  }

  static List<AdminAnalyticsInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInput> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInput-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'range',
    'previous',
    'totals',
    'previousTotals',
    'margin',
    'daily',
    'byLanguage',
    'byType',
    'byHour',
    'topRated',
    'mostActive',
    'topEarners',
    'topSpenders',
    'mostReported',
  };
}

