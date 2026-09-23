//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200Response {
  /// Returns a new [AdminDashboard200Response] instance.
  AdminDashboard200Response({
    required this.live,
    required this.today,
    required this.yesterday,
    this.byHour = const [],
    this.languages = const [],
    required this.openReports,
    this.openReportsByReason = const {},
    required this.pendingKyc,
    required this.pendingPayouts,
    required this.flaggedPayouts,
    required this.billingExceptions,
    required this.openRefunds,
    required this.openModeration,
    this.activity = const [],
  });

  AdminDashboard200ResponseLive live;

  AdminDashboard200ResponseToday today;

  AdminDashboard200ResponseYesterday yesterday;

  List<AdminDashboard200ResponseByHourInner> byHour;

  List<AdminDashboard200ResponseLanguagesInner> languages;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int openReports;

  Map<String, int> openReportsByReason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int pendingKyc;

  AdminDashboard200ResponsePendingPayouts pendingPayouts;

  /// Requested payouts carrying at least one risk flag
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int flaggedPayouts;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int billingExceptions;

  /// Refund requests waiting for a decision
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int openRefunds;

  /// Video frames flagged for nudity, waiting for review
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int openModeration;

  /// Latest 8 events, newest first
  List<AdminDashboard200ResponseActivityInner> activity;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200Response &&
    other.live == live &&
    other.today == today &&
    other.yesterday == yesterday &&
    _deepEquality.equals(other.byHour, byHour) &&
    _deepEquality.equals(other.languages, languages) &&
    other.openReports == openReports &&
    _deepEquality.equals(other.openReportsByReason, openReportsByReason) &&
    other.pendingKyc == pendingKyc &&
    other.pendingPayouts == pendingPayouts &&
    other.flaggedPayouts == flaggedPayouts &&
    other.billingExceptions == billingExceptions &&
    other.openRefunds == openRefunds &&
    other.openModeration == openModeration &&
    _deepEquality.equals(other.activity, activity);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (live.hashCode) +
    (today.hashCode) +
    (yesterday.hashCode) +
    (byHour.hashCode) +
    (languages.hashCode) +
    (openReports.hashCode) +
    (openReportsByReason.hashCode) +
    (pendingKyc.hashCode) +
    (pendingPayouts.hashCode) +
    (flaggedPayouts.hashCode) +
    (billingExceptions.hashCode) +
    (openRefunds.hashCode) +
    (openModeration.hashCode) +
    (activity.hashCode);

  @override
  String toString() => 'AdminDashboard200Response[live=$live, today=$today, yesterday=$yesterday, byHour=$byHour, languages=$languages, openReports=$openReports, openReportsByReason=$openReportsByReason, pendingKyc=$pendingKyc, pendingPayouts=$pendingPayouts, flaggedPayouts=$flaggedPayouts, billingExceptions=$billingExceptions, openRefunds=$openRefunds, openModeration=$openModeration, activity=$activity]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'live'] = this.live;
      json[r'today'] = this.today;
      json[r'yesterday'] = this.yesterday;
      json[r'byHour'] = this.byHour;
      json[r'languages'] = this.languages;
      json[r'openReports'] = this.openReports;
      json[r'openReportsByReason'] = this.openReportsByReason;
      json[r'pendingKyc'] = this.pendingKyc;
      json[r'pendingPayouts'] = this.pendingPayouts;
      json[r'flaggedPayouts'] = this.flaggedPayouts;
      json[r'billingExceptions'] = this.billingExceptions;
      json[r'openRefunds'] = this.openRefunds;
      json[r'openModeration'] = this.openModeration;
      json[r'activity'] = this.activity;
    return json;
  }

  /// Returns a new [AdminDashboard200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'live'), 'Required key "AdminDashboard200Response[live]" is missing from JSON.');
        assert(json[r'live'] != null, 'Required key "AdminDashboard200Response[live]" has a null value in JSON.');
        assert(json.containsKey(r'today'), 'Required key "AdminDashboard200Response[today]" is missing from JSON.');
        assert(json[r'today'] != null, 'Required key "AdminDashboard200Response[today]" has a null value in JSON.');
        assert(json.containsKey(r'yesterday'), 'Required key "AdminDashboard200Response[yesterday]" is missing from JSON.');
        assert(json[r'yesterday'] != null, 'Required key "AdminDashboard200Response[yesterday]" has a null value in JSON.');
        assert(json.containsKey(r'byHour'), 'Required key "AdminDashboard200Response[byHour]" is missing from JSON.');
        assert(json[r'byHour'] != null, 'Required key "AdminDashboard200Response[byHour]" has a null value in JSON.');
        assert(json.containsKey(r'languages'), 'Required key "AdminDashboard200Response[languages]" is missing from JSON.');
        assert(json[r'languages'] != null, 'Required key "AdminDashboard200Response[languages]" has a null value in JSON.');
        assert(json.containsKey(r'openReports'), 'Required key "AdminDashboard200Response[openReports]" is missing from JSON.');
        assert(json[r'openReports'] != null, 'Required key "AdminDashboard200Response[openReports]" has a null value in JSON.');
        assert(json.containsKey(r'openReportsByReason'), 'Required key "AdminDashboard200Response[openReportsByReason]" is missing from JSON.');
        assert(json[r'openReportsByReason'] != null, 'Required key "AdminDashboard200Response[openReportsByReason]" has a null value in JSON.');
        assert(json.containsKey(r'pendingKyc'), 'Required key "AdminDashboard200Response[pendingKyc]" is missing from JSON.');
        assert(json[r'pendingKyc'] != null, 'Required key "AdminDashboard200Response[pendingKyc]" has a null value in JSON.');
        assert(json.containsKey(r'pendingPayouts'), 'Required key "AdminDashboard200Response[pendingPayouts]" is missing from JSON.');
        assert(json[r'pendingPayouts'] != null, 'Required key "AdminDashboard200Response[pendingPayouts]" has a null value in JSON.');
        assert(json.containsKey(r'flaggedPayouts'), 'Required key "AdminDashboard200Response[flaggedPayouts]" is missing from JSON.');
        assert(json[r'flaggedPayouts'] != null, 'Required key "AdminDashboard200Response[flaggedPayouts]" has a null value in JSON.');
        assert(json.containsKey(r'billingExceptions'), 'Required key "AdminDashboard200Response[billingExceptions]" is missing from JSON.');
        assert(json[r'billingExceptions'] != null, 'Required key "AdminDashboard200Response[billingExceptions]" has a null value in JSON.');
        assert(json.containsKey(r'openRefunds'), 'Required key "AdminDashboard200Response[openRefunds]" is missing from JSON.');
        assert(json[r'openRefunds'] != null, 'Required key "AdminDashboard200Response[openRefunds]" has a null value in JSON.');
        assert(json.containsKey(r'openModeration'), 'Required key "AdminDashboard200Response[openModeration]" is missing from JSON.');
        assert(json[r'openModeration'] != null, 'Required key "AdminDashboard200Response[openModeration]" has a null value in JSON.');
        assert(json.containsKey(r'activity'), 'Required key "AdminDashboard200Response[activity]" is missing from JSON.');
        assert(json[r'activity'] != null, 'Required key "AdminDashboard200Response[activity]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200Response(
        live: AdminDashboard200ResponseLive.fromJson(json[r'live'])!,
        today: AdminDashboard200ResponseToday.fromJson(json[r'today'])!,
        yesterday: AdminDashboard200ResponseYesterday.fromJson(json[r'yesterday'])!,
        byHour: AdminDashboard200ResponseByHourInner.listFromJson(json[r'byHour']),
        languages: AdminDashboard200ResponseLanguagesInner.listFromJson(json[r'languages']),
        openReports: mapValueOfType<int>(json, r'openReports')!,
        openReportsByReason: mapCastOfType<String, int>(json, r'openReportsByReason')!,
        pendingKyc: mapValueOfType<int>(json, r'pendingKyc')!,
        pendingPayouts: AdminDashboard200ResponsePendingPayouts.fromJson(json[r'pendingPayouts'])!,
        flaggedPayouts: mapValueOfType<int>(json, r'flaggedPayouts')!,
        billingExceptions: mapValueOfType<int>(json, r'billingExceptions')!,
        openRefunds: mapValueOfType<int>(json, r'openRefunds')!,
        openModeration: mapValueOfType<int>(json, r'openModeration')!,
        activity: AdminDashboard200ResponseActivityInner.listFromJson(json[r'activity']),
      );
    }
    return null;
  }

  static List<AdminDashboard200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200Response> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200Response-objects as value to a dart map
  static Map<String, List<AdminDashboard200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'live',
    'today',
    'yesterday',
    'byHour',
    'languages',
    'openReports',
    'openReportsByReason',
    'pendingKyc',
    'pendingPayouts',
    'flaggedPayouts',
    'billingExceptions',
    'openRefunds',
    'openModeration',
    'activity',
  };
}

