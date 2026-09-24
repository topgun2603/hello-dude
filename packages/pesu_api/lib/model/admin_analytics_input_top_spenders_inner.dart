//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminAnalyticsInputTopSpendersInner {
  /// Returns a new [AdminAnalyticsInputTopSpendersInner] instance.
  AdminAnalyticsInputTopSpendersInner({
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
  bool operator ==(Object other) => identical(this, other) || other is AdminAnalyticsInputTopSpendersInner &&
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
  String toString() => 'AdminAnalyticsInputTopSpendersInner[id=$id, displayName=$displayName, avatarId=$avatarId, coinsSpent=$coinsSpent, calls=$calls, purchasesPaise=$purchasesPaise]';

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

  /// Returns a new [AdminAnalyticsInputTopSpendersInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminAnalyticsInputTopSpendersInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminAnalyticsInputTopSpendersInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "AdminAnalyticsInputTopSpendersInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "AdminAnalyticsInputTopSpendersInner[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "AdminAnalyticsInputTopSpendersInner[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'calls'), 'Required key "AdminAnalyticsInputTopSpendersInner[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[calls]" has a null value in JSON.');
        assert(json.containsKey(r'purchasesPaise'), 'Required key "AdminAnalyticsInputTopSpendersInner[purchasesPaise]" is missing from JSON.');
        assert(json[r'purchasesPaise'] != null, 'Required key "AdminAnalyticsInputTopSpendersInner[purchasesPaise]" has a null value in JSON.');
        return true;
      }());

      return AdminAnalyticsInputTopSpendersInner(
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

  static List<AdminAnalyticsInputTopSpendersInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminAnalyticsInputTopSpendersInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminAnalyticsInputTopSpendersInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminAnalyticsInputTopSpendersInner> mapFromJson(dynamic json) {
    final map = <String, AdminAnalyticsInputTopSpendersInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminAnalyticsInputTopSpendersInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminAnalyticsInputTopSpendersInner-objects as value to a dart map
  static Map<String, List<AdminAnalyticsInputTopSpendersInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminAnalyticsInputTopSpendersInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminAnalyticsInputTopSpendersInner.listFromJson(entry.value, growable: growable,);
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

