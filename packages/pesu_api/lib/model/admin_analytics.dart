//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalytics {
  /// Returns a new [AdminAnalytics] instance.
  AdminAnalytics({
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

  AdminAnalyticsRange range;

  AdminAnalyticsPrevious previous;

  AnalyticsTotals totals;

  AnalyticsTotals previousTotals;

  AdminAnalyticsMargin margin;

  List<AdminAnalyticsDailyInner> daily;

  List<AdminAnalyticsByLanguageInner> byLanguage;

  List<AdminAnalyticsByTypeInner> byType;

  List<AdminAnalyticsByHourInner> byHour;

  List<AdminAnalyticsTopRatedInner> topRated;

  List<AdminAnalyticsMostActiveInner> mostActive;

  List<AdminAnalyticsTopEarnersInner> topEarners;

  List<AdminAnalyticsTopSpendersInner> topSpenders;

  List<AdminAnalyticsMostReportedInner> mostReported;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalytics &&
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
  String toString() => 'AdminAnalytics[range=$range, previous=$previous, totals=$totals, previousTotals=$previousTotals, margin=$margin, daily=$daily, byLanguage=$byLanguage, byType=$byType, byHour=$byHour, topRated=$topRated, mostActive=$mostActive, topEarners=$topEarners, topSpenders=$topSpenders, mostReported=$mostReported]';

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

  /// Returns a new [AdminAnalytics] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalytics? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'range'), 'Required key "AdminAnalytics[range]" is missing from JSON.');
        assert(json[r'range'] != null, 'Required key "AdminAnalytics[range]" has a null value in JSON.');
        assert(json.containsKey(r'previous'), 'Required key "AdminAnalytics[previous]" is missing from JSON.');
        assert(json[r'previous'] != null, 'Required key "AdminAnalytics[previous]" has a null value in JSON.');
        assert(json.containsKey(r'totals'), 'Required key "AdminAnalytics[totals]" is missing from JSON.');
        assert(json[r'totals'] != null, 'Required key "AdminAnalytics[totals]" has a null value in JSON.');
        assert(json.containsKey(r'previousTotals'), 'Required key "AdminAnalytics[previousTotals]" is missing from JSON.');
        assert(json[r'previousTotals'] != null, 'Required key "AdminAnalytics[previousTotals]" has a null value in JSON.');
        assert(json.containsKey(r'margin'), 'Required key "AdminAnalytics[margin]" is missing from JSON.');
        assert(json[r'margin'] != null, 'Required key "AdminAnalytics[margin]" has a null value in JSON.');
        assert(json.containsKey(r'daily'), 'Required key "AdminAnalytics[daily]" is missing from JSON.');
        assert(json[r'daily'] != null, 'Required key "AdminAnalytics[daily]" has a null value in JSON.');
        assert(json.containsKey(r'byLanguage'), 'Required key "AdminAnalytics[byLanguage]" is missing from JSON.');
        assert(json[r'byLanguage'] != null, 'Required key "AdminAnalytics[byLanguage]" has a null value in JSON.');
        assert(json.containsKey(r'byType'), 'Required key "AdminAnalytics[byType]" is missing from JSON.');
        assert(json[r'byType'] != null, 'Required key "AdminAnalytics[byType]" has a null value in JSON.');
        assert(json.containsKey(r'byHour'), 'Required key "AdminAnalytics[byHour]" is missing from JSON.');
        assert(json[r'byHour'] != null, 'Required key "AdminAnalytics[byHour]" has a null value in JSON.');
        assert(json.containsKey(r'topRated'), 'Required key "AdminAnalytics[topRated]" is missing from JSON.');
        assert(json[r'topRated'] != null, 'Required key "AdminAnalytics[topRated]" has a null value in JSON.');
        assert(json.containsKey(r'mostActive'), 'Required key "AdminAnalytics[mostActive]" is missing from JSON.');
        assert(json[r'mostActive'] != null, 'Required key "AdminAnalytics[mostActive]" has a null value in JSON.');
        assert(json.containsKey(r'topEarners'), 'Required key "AdminAnalytics[topEarners]" is missing from JSON.');
        assert(json[r'topEarners'] != null, 'Required key "AdminAnalytics[topEarners]" has a null value in JSON.');
        assert(json.containsKey(r'topSpenders'), 'Required key "AdminAnalytics[topSpenders]" is missing from JSON.');
        assert(json[r'topSpenders'] != null, 'Required key "AdminAnalytics[topSpenders]" has a null value in JSON.');
        assert(json.containsKey(r'mostReported'), 'Required key "AdminAnalytics[mostReported]" is missing from JSON.');
        assert(json[r'mostReported'] != null, 'Required key "AdminAnalytics[mostReported]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalytics(
        range: AdminAnalyticsRange.fromJson(json[r'range'])!,
        previous: AdminAnalyticsPrevious.fromJson(json[r'previous'])!,
        totals: AnalyticsTotals.fromJson(json[r'totals'])!,
        previousTotals: AnalyticsTotals.fromJson(json[r'previousTotals'])!,
        margin: AdminAnalyticsMargin.fromJson(json[r'margin'])!,
        daily: AdminAnalyticsDailyInner.listFromJson(json[r'daily']),
        byLanguage: AdminAnalyticsByLanguageInner.listFromJson(json[r'byLanguage']),
        byType: AdminAnalyticsByTypeInner.listFromJson(json[r'byType']),
        byHour: AdminAnalyticsByHourInner.listFromJson(json[r'byHour']),
        topRated: AdminAnalyticsTopRatedInner.listFromJson(json[r'topRated']),
        mostActive: AdminAnalyticsMostActiveInner.listFromJson(json[r'mostActive']),
        topEarners: AdminAnalyticsTopEarnersInner.listFromJson(json[r'topEarners']),
        topSpenders: AdminAnalyticsTopSpendersInner.listFromJson(json[r'topSpenders']),
        mostReported: AdminAnalyticsMostReportedInner.listFromJson(json[r'mostReported']),
      );
    }
    return null;
  }

  static List<AdminAnalytics> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalytics>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalytics.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalytics> mapFromJson(dynamic json) {
    final map = <String, AdminAnalytics>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalytics.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalytics-objects as value to a dart map
  static Map<String, List<AdminAnalytics>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalytics>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalytics.listFromJson(entry.value, growable: growable,);
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

