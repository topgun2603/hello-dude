//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputRefundsInner {
  /// Returns a new [AdminUserDetailInputRefundsInner] instance.
  AdminUserDetailInputRefundsInner({
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

  Object? createdAt;

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
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputRefundsInner &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (callId.hashCode) +
    (reason.hashCode) +
    (status.hashCode) +
    (coinsEligible.hashCode) +
    (coinsRefunded.hashCode) +
    (byUser.hashCode);

  @override
  String toString() => 'AdminUserDetailInputRefundsInner[id=$id, createdAt=$createdAt, callId=$callId, reason=$reason, status=$status, coinsEligible=$coinsEligible, coinsRefunded=$coinsRefunded, byUser=$byUser]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'callId'] = this.callId;
      json[r'reason'] = this.reason;
      json[r'status'] = this.status;
      json[r'coinsEligible'] = this.coinsEligible;
      json[r'coinsRefunded'] = this.coinsRefunded;
      json[r'byUser'] = this.byUser;
    return json;
  }

  /// Returns a new [AdminUserDetailInputRefundsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputRefundsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputRefundsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputRefundsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputRefundsInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminUserDetailInputRefundsInner[callId]" is missing from JSON.');
        assert(json[r'callId'] != null, 'Required key "AdminUserDetailInputRefundsInner[callId]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminUserDetailInputRefundsInner[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminUserDetailInputRefundsInner[reason]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInputRefundsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInputRefundsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'coinsEligible'), 'Required key "AdminUserDetailInputRefundsInner[coinsEligible]" is missing from JSON.');
        assert(json[r'coinsEligible'] != null, 'Required key "AdminUserDetailInputRefundsInner[coinsEligible]" has a null value in JSON.');
        assert(json.containsKey(r'coinsRefunded'), 'Required key "AdminUserDetailInputRefundsInner[coinsRefunded]" is missing from JSON.');
        assert(json[r'coinsRefunded'] != null, 'Required key "AdminUserDetailInputRefundsInner[coinsRefunded]" has a null value in JSON.');
        assert(json.containsKey(r'byUser'), 'Required key "AdminUserDetailInputRefundsInner[byUser]" is missing from JSON.');
        assert(json[r'byUser'] != null, 'Required key "AdminUserDetailInputRefundsInner[byUser]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputRefundsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
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

  static List<AdminUserDetailInputRefundsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputRefundsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputRefundsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputRefundsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputRefundsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputRefundsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputRefundsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputRefundsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputRefundsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputRefundsInner.listFromJson(entry.value, growable: growable,);
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

