//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsTopSpendersInner {
  /// Returns a new [AdminAnalyticsTopSpendersInner] instance.
  AdminAnalyticsTopSpendersInner({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.coinsSpent,
    required this.calls,
    required this.purchasesPaise,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int purchasesPaise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsTopSpendersInner &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.coinsSpent == coinsSpent &&
    other.calls == calls &&
    other.purchasesPaise == purchasesPaise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (coinsSpent.hashCode) +
    (calls.hashCode) +
    (purchasesPaise.hashCode);

  @override
  String toString() => 'AdminAnalyticsTopSpendersInner[id=$id, displayName=$displayName, avatarId=$avatarId, coinsSpent=$coinsSpent, calls=$calls, purchasesPaise=$purchasesPaise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'calls'] = this.calls;
      json[r'purchasesPaise'] = this.purchasesPaise;
    return json;
  }

  /// Returns a new [AdminAnalyticsTopSpendersInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsTopSpendersInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsTopSpendersInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsTopSpendersInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsTopSpendersInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsTopSpendersInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsTopSpendersInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsTopSpendersInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminAnalyticsTopSpendersInner[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminAnalyticsTopSpendersInner[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsTopSpendersInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsTopSpendersInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'purchasesPaise'), 'Required key "AdminAnalyticsTopSpendersInner[purchasesPaise]" is missing from JSON.');
        assert(json[r'purchasesPaise'] != null, 'Required key "AdminAnalyticsTopSpendersInner[purchasesPaise]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsTopSpendersInner(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        calls: mapValueOfType<int>(json, r'calls')!,
        purchasesPaise: mapValueOfType<int>(json, r'purchasesPaise')!,
      );
    }
    return null;
  }

  static List<AdminAnalyticsTopSpendersInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsTopSpendersInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsTopSpendersInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsTopSpendersInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsTopSpendersInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsTopSpendersInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsTopSpendersInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsTopSpendersInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsTopSpendersInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsTopSpendersInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'coinsSpent',
    'calls',
    'purchasesPaise',
  };
}

