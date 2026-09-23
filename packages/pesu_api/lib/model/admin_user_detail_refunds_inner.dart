//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailRefundsInner {
  /// Returns a new [AdminUserDetailRefundsInner] instance.
  AdminUserDetailRefundsInner({
    required this.id,
    required this.createdAt,
    required this.callId,
    required this.reason,
    required this.status,
    required this.coinsEligible,
    required this.coinsRefunded,
    required this.byUser,
  });

  String id;

  DateTime createdAt;

  String callId;

  String reason;

  String status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsEligible;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsRefunded;

  bool byUser;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailRefundsInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.callId == callId &&
    other.reason == reason &&
    other.status == status &&
    other.coinsEligible == coinsEligible &&
    other.coinsRefunded == coinsRefunded &&
    other.byUser == byUser;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (callId.hashCode) +
    (reason.hashCode) +
    (status.hashCode) +
    (coinsEligible.hashCode) +
    (coinsRefunded.hashCode) +
    (byUser.hashCode);

  @override
  String toString() => 'AdminUserDetailRefundsInner[id=$id, createdAt=$createdAt, callId=$callId, reason=$reason, status=$status, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, byUser=$byUser]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'callId'] = this.callId;
      json[r'reason'] = this.reason;
      json[r'status'] = this.status;
      json[r'coinsEligible'] = this.coinsEligible;
      json[r'coinsRefunded'] = this.coinsRefunded;
      json[r'byUser'] = this.byUser;
    return json;
  }

  /// Returns a new [AdminUserDetailRefundsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailRefundsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailRefundsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailRefundsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailRefundsInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailRefundsInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailRefundsInner[callId]" is missing from JSON.');
        assert(json[r'callId'] != null, 'Required key "AdminUserDetailRefundsInner[callId]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminUserDetailRefundsInner[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminUserDetailRefundsInner[reason]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailRefundsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailRefundsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "AdminUserDetailRefundsInner[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "AdminUserDetailRefundsInner[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "AdminUserDetailRefundsInner[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "AdminUserDetailRefundsInner[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'byUser'), 'Required key "AdminUserDetailRefundsInner[byUser]" is missing from JSON.');
        assert(json[r'byUser'] != null, 'Required key "AdminUserDetailRefundsInner[byUser]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailRefundsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        callId: mapValueOfType<String>(json, r'callId')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        status: mapValueOfType<String>(json, r'status')!,
        coinsEligible: mapValueOfType<int>(json, r'coinsEligible')!,
        coinsRefunded: mapValueOfType<int>(json, r'coinsRefunded')!,
        byUser: mapValueOfType<bool>(json, r'byUser')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailRefundsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailRefundsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailRefundsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailRefundsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailRefundsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailRefundsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailRefundsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailRefundsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailRefundsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailRefundsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'callId',
    'reason',
    'status',
    'coinsEligible',
    'coinsRefunded',
    'byUser',
  };
}

