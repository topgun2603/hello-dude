//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsMargin {
  /// Returns a new [AdminAnalyticsMargin] instance.
  AdminAnalyticsMargin({
    required this.gstPct,
    required this.storeFeePct,
    required this.netRevenuePaise,
    required this.companionCostPaise,
    required this.infraPaise,
    required this.marginPaise,
    required this.marginPct,
    required this.targetPct,
  });

  num gstPct;

  num storeFeePct;

  /// Sales ÷ (1 + GST) × (1 − store fee)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int netRevenuePaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionCostPaise;

  /// Estimated LiveKit cost: (live viewer-minutes + 2 × group member-minutes + 2 × call minutes) × setting
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int infraPaise;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int marginPaise;

  num? marginPct;

  /// Setting analytics.target_margin_pct
  num targetPct;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsMargin &&
    other.gstPct == gstPct &&
    other.storeFeePct == storeFeePct &&
    other.netRevenuePaise == netRevenuePaise &&
    other.companionCostPaise == companionCostPaise &&
    other.infraPaise == infraPaise &&
    other.marginPaise == marginPaise &&
    other.marginPct == marginPct &&
    other.targetPct == targetPct;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (gstPct.hashCode) +
    (storeFeePct.hashCode) +
    (netRevenuePaise.hashCode) +
    (companionCostPaise.hashCode) +
    (infraPaise.hashCode) +
    (marginPaise.hashCode) +
    (marginPct == null ? 0 : marginPct!.hashCode) +
    (targetPct.hashCode);

  @override
  String toString() => 'AdminAnalyticsMargin[gstPct=$gstPct, storeFeePct=$storeFeePct, netRevenuePaise=$netRevenuePaise, companionCostPaise=$companionCostPaise, infraPaise=$infraPaise, marginPaise=$marginPaise, marginPct=$marginPct, targetPct=$targetPct]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'gstPct'] = this.gstPct;
      json[r'storeFeePct'] = this.storeFeePct;
      json[r'netRevenuePaise'] = this.netRevenuePaise;
      json[r'companionCostPaise'] = this.companionCostPaise;
      json[r'infraPaise'] = this.infraPaise;
      json[r'marginPaise'] = this.marginPaise;
    if (this.marginPct != null) {
      json[r'marginPct'] = this.marginPct;
    } else {
      json[r'marginPct'] = null;
    }
      json[r'targetPct'] = this.targetPct;
    return json;
  }

  /// Returns a new [AdminAnalyticsMargin] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsMargin? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'gstPct'), 'Required key "AdminAnalyticsMargin[gstPct]" is missing from JSON.');
        assert(json[r'gstPct'] != null, 'Required key "AdminAnalyticsMargin[gstPct]" has a null value in JSON.');
        assert(json.containsKey(r'storeFeePct'), 'Required key "AdminAnalyticsMargin[storeFeePct]" is missing from JSON.');
        assert(json[r'storeFeePct'] != null, 'Required key "AdminAnalyticsMargin[storeFeePct]" has a null value in JSON.');
        assert(json.containsKey(r'netRevenuePaise'), 'Required key "AdminAnalyticsMargin[netRevenuePaise]" is missing from JSON.');
        assert(json[r'netRevenuePaise'] != null, 'Required key "AdminAnalyticsMargin[netRevenuePaise]" has a null value in JSON.');
        assert(json.containsKey(r'companionCostPaise'), 'Required key "AdminAnalyticsMargin[companionCostPaise]" is missing from JSON.');
        assert(json[r'companionCostPaise'] != null, 'Required key "AdminAnalyticsMargin[companionCostPaise]" has a null value in JSON.');
        assert(json.containsKey(r'infraPaise'), 'Required key "AdminAnalyticsMargin[infraPaise]" is missing from JSON.');
        assert(json[r'infraPaise'] != null, 'Required key "AdminAnalyticsMargin[infraPaise]" has a null value in JSON.');
        assert(json.containsKey(r'marginPaise'), 'Required key "AdminAnalyticsMargin[marginPaise]" is missing from JSON.');
        assert(json[r'marginPaise'] != null, 'Required key "AdminAnalyticsMargin[marginPaise]" has a null value in JSON.');
        assert(json.containsKey(r'marginPct'), 'Required key "AdminAnalyticsMargin[marginPct]" is missing from JSON.');
        assert(json.containsKey(r'targetPct'), 'Required key "AdminAnalyticsMargin[targetPct]" is missing from JSON.');
        assert(json[r'targetPct'] != null, 'Required key "AdminAnalyticsMargin[targetPct]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsMargin(
        gstPct: num.parse('${json[r'gstPct']}'),
        storeFeePct: num.parse('${json[r'storeFeePct']}'),
        netRevenuePaise: mapValueOfType<int>(json, r'netRevenuePaise')!,
        companionCostPaise: mapValueOfType<int>(json, r'companionCostPaise')!,
        infraPaise: mapValueOfType<int>(json, r'infraPaise')!,
        marginPaise: mapValueOfType<int>(json, r'marginPaise')!,
        marginPct: json[r'marginPct'] == null
            ? null
            : num.parse('${json[r'marginPct']}'),
        targetPct: num.parse('${json[r'targetPct']}'),
      );
    }
    return null;
  }

  static List<AdminAnalyticsMargin> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsMargin>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsMargin.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsMargin> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsMargin>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsMargin.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsMargin-objects as value to a dart map
  static Map<String, List<AdminAnalyticsMargin>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsMargin>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsMargin.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'gstPct',
    'storeFeePct',
    'netRevenuePaise',
    'companionCostPaise',
    'infraPaise',
    'marginPaise',
    'marginPct',
    'targetPct',
  };
}

