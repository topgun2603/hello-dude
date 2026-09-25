//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionEarnings200Response {
  /// Returns a new [CompanionEarnings200Response] instance.
  CompanionEarnings200Response({
    required this.availablePaise,
    required this.upi,
    required this.minWithdrawalPaise,
    required this.tdsBps,
    required this.panOnFile,
    required this.tdsWithPanBps,
    required this.tdsNoPanBps,
    required this.canWithdraw,
    required this.blockedReason,
    this.week = const [],
    this.payouts = const [],
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int availablePaise;

  String? upi;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minWithdrawalPaise;

  /// TDS on your withdrawals now (higher without a PAN)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsBps;

  bool panOnFile;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsWithPanBps;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int tdsNoPanBps;

  bool canWithdraw;

  String? blockedReason;

  List<CompanionEarnings200ResponseWeekInner> week;

  List<Payout> payouts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionEarnings200Response &&
    other.availablePaise == availablePaise &&
    other.upi == upi &&
    other.minWithdrawalPaise == minWithdrawalPaise &&
    other.tdsBps == tdsBps &&
    other.panOnFile == panOnFile &&
    other.tdsWithPanBps == tdsWithPanBps &&
    other.tdsNoPanBps == tdsNoPanBps &&
    other.canWithdraw == canWithdraw &&
    other.blockedReason == blockedReason &&
    _deepEquality.equals(other.week, week) &&
    _deepEquality.equals(other.payouts, payouts);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (availablePaise.hashCode) +
    (upi == null ? 0 : upi!.hashCode) +
    (minWithdrawalPaise.hashCode) +
    (tdsBps.hashCode) +
    (panOnFile.hashCode) +
    (tdsWithPanBps.hashCode) +
    (tdsNoPanBps.hashCode) +
    (canWithdraw.hashCode) +
    (blockedReason == null ? 0 : blockedReason!.hashCode) +
    (week.hashCode) +
    (payouts.hashCode);

  @override
  String toString() => 'CompanionEarnings200Response[availablePaise=$availablePaise, upi=$upi, minWithdrawalPaise=$minWithdrawalPaise, tdsBps=$tdsBps, panOnFile=$panOnFile, tdsWithPanBps=$tdsWithPanBps, tdsNoPanBps=$tdsNoPanBps, canWithdraw=$canWithdraw, blockedReason=$blockedReason, week=$week, payouts=$payouts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'availablePaise'] = this.availablePaise;
    if (this.upi != null) {
      json[r'upi'] = this.upi;
    } else {
      json[r'upi'] = null;
    }
      json[r'minWithdrawalPaise'] = this.minWithdrawalPaise;
      json[r'tdsBps'] = this.tdsBps;
      json[r'panOnFile'] = this.panOnFile;
      json[r'tdsWithPanBps'] = this.tdsWithPanBps;
      json[r'tdsNoPanBps'] = this.tdsNoPanBps;
      json[r'canWithdraw'] = this.canWithdraw;
    if (this.blockedReason != null) {
      json[r'blockedReason'] = this.blockedReason;
    } else {
      json[r'blockedReason'] = null;
    }
      json[r'week'] = this.week;
      json[r'payouts'] = this.payouts;
    return json;
  }

  /// Returns a new [CompanionEarnings200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionEarnings200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'availablePaise'), 'Required key "CompanionEarnings200Response[availablePaise]" is missing from JSON.');
        assert(json[r'availablePaise'] != null, 'Required key "CompanionEarnings200Response[availablePaise]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "CompanionEarnings200Response[upi]" is missing from JSON.');
        assert(json.containsKey(r'minWithdrawalPaise'), 'Required key "CompanionEarnings200Response[minWithdrawalPaise]" is missing from JSON.');
        assert(json[r'minWithdrawalPaise'] != null, 'Required key "CompanionEarnings200Response[minWithdrawalPaise]" has a null value in JSON.');
        assert(json.containsKey(r'tdsBps'), 'Required key "CompanionEarnings200Response[tdsBps]" is missing from JSON.');
        assert(json[r'tdsBps'] != null, 'Required key "CompanionEarnings200Response[tdsBps]" has a null value in JSON.');
        assert(json.containsKey(r'panOnFile'), 'Required key "CompanionEarnings200Response[panOnFile]" is missing from JSON.');
        assert(json[r'panOnFile'] != null, 'Required key "CompanionEarnings200Response[panOnFile]" has a null value in JSON.');
        assert(json.containsKey(r'tdsWithPanBps'), 'Required key "CompanionEarnings200Response[tdsWithPanBps]" is missing from JSON.');
        assert(json[r'tdsWithPanBps'] != null, 'Required key "CompanionEarnings200Response[tdsWithPanBps]" has a null value in JSON.');
        assert(json.containsKey(r'tdsNoPanBps'), 'Required key "CompanionEarnings200Response[tdsNoPanBps]" is missing from JSON.');
        assert(json[r'tdsNoPanBps'] != null, 'Required key "CompanionEarnings200Response[tdsNoPanBps]" has a null value in JSON.');
        assert(json.containsKey(r'canWithdraw'), 'Required key "CompanionEarnings200Response[canWithdraw]" is missing from JSON.');
        assert(json[r'canWithdraw'] != null, 'Required key "CompanionEarnings200Response[canWithdraw]" has a null value in JSON.');
        assert(json.containsKey(r'blockedReason'), 'Required key "CompanionEarnings200Response[blockedReason]" is missing from JSON.');
        assert(json.containsKey(r'week'), 'Required key "CompanionEarnings200Response[week]" is missing from JSON.');
        assert(json[r'week'] != null, 'Required key "CompanionEarnings200Response[week]" has a null value in JSON.');
        assert(json.containsKey(r'payouts'), 'Required key "CompanionEarnings200Response[payouts]" is missing from JSON.');
        assert(json[r'payouts'] != null, 'Required key "CompanionEarnings200Response[payouts]" has a null value in JSON.');
        return true;
      }());

      return CompanionEarnings200Response(
        availablePaise: mapValueOfType<int>(json, r'availablePaise')!,
        upi: mapValueOfType<String>(json, r'upi'),
        minWithdrawalPaise: mapValueOfType<int>(json, r'minWithdrawalPaise')!,
        tdsBps: mapValueOfType<int>(json, r'tdsBps')!,
        panOnFile: mapValueOfType<bool>(json, r'panOnFile')!,
        tdsWithPanBps: mapValueOfType<int>(json, r'tdsWithPanBps')!,
        tdsNoPanBps: mapValueOfType<int>(json, r'tdsNoPanBps')!,
        canWithdraw: mapValueOfType<bool>(json, r'canWithdraw')!,
        blockedReason: mapValueOfType<String>(json, r'blockedReason'),
        week: CompanionEarnings200ResponseWeekInner.listFromJson(json[r'week']),
        payouts: Payout.listFromJson(json[r'payouts']),
      );
    }
    return null;
  }

  static List<CompanionEarnings200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionEarnings200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionEarnings200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionEarnings200Response> mapFromJson(dynamic json) {
    final map = <String, CompanionEarnings200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionEarnings200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionEarnings200Response-objects as value to a dart map
  static Map<String, List<CompanionEarnings200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionEarnings200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionEarnings200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'availablePaise',
    'upi',
    'minWithdrawalPaise',
    'tdsBps',
    'panOnFile',
    'tdsWithPanBps',
    'tdsNoPanBps',
    'canWithdraw',
    'blockedReason',
    'week',
    'payouts',
  };
}

