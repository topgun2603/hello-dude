//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminRefundInputCall {
  /// Returns a new [AdminRefundInputCall] instance.
  AdminRefundInputCall({
    required this.id,
    required this.type,
    required this.startedAt,
    required this.durationSeconds,
    required this.minutesCharged,
    required this.endReason,
  });

  String id;

  String type;

  Object? startedAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? durationSeconds;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutesCharged;

  String? endReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRefundInputCall &&
    other.id == id &&
    other.type == type &&
    other.startedAt == startedAt &&
    other.durationSeconds == durationSeconds &&
    other.minutesCharged == minutesCharged &&
    other.endReason == endReason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode) +
    (durationSeconds == null ? 0 : durationSeconds!.hashCode) +
    (minutesCharged.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode);

  @override
  String toString() => 'AdminRefundInputCall[id=$id, type=$type, startedAt=$startedAt, durationSeconds=$durationSeconds, minutesCharged=$minutesCharged, endReason=$endReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt;
    } else {
      json[r'startedAt'] = null;
    }
    if (this.durationSeconds != null) {
      json[r'durationSeconds'] = this.durationSeconds;
    } else {
      json[r'durationSeconds'] = null;
    }
      json[r'minutesCharged'] = this.minutesCharged;
    if (this.endReason != null) {
      json[r'endReason'] = this.endReason;
    } else {
      json[r'endReason'] = null;
    }
    return json;
  }

  /// Returns a new [AdminRefundInputCall] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminRefundInputCall? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminRefundInputCall[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminRefundInputCall[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminRefundInputCall[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminRefundInputCall[type]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "AdminRefundInputCall[startedAt]" is missing from JSON.');
        assert(json.containsKey(r'durationSeconds'), 'Required key "AdminRefundInputCall[durationSeconds]" is missing from JSON.');
        assert(json.containsKey(r'minutesCharged'), 'Required key "AdminRefundInputCall[minutesCharged]" is missing from JSON.');
        assert(json[r'minutesCharged'] != null, 'Required key "AdminRefundInputCall[minutesCharged]" has a null value in JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminRefundInputCall[endReason]" is missing from JSON.');
        return true;
      }());

      return AdminRefundInputCall(
        id: mapValueOfType<String>(json, r'id')!,
        type: mapValueOfType<String>(json, r'type')!,
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
        durationSeconds: mapValueOfType<int>(json, r'durationSeconds'),
        minutesCharged: mapValueOfType<int>(json, r'minutesCharged')!,
        endReason: mapValueOfType<String>(json, r'endReason'),
      );
    }
    return null;
  }

  static List<AdminRefundInputCall> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminRefundInputCall>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminRefundInputCall.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminRefundInputCall> mapFromJson(dynamic json) {
    final map = <String, AdminRefundInputCall>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminRefundInputCall.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminRefundInputCall-objects as value to a dart map
  static Map<String, List<AdminRefundInputCall>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminRefundInputCall>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminRefundInputCall.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
    'startedAt',
    'durationSeconds',
    'minutesCharged',
    'endReason',
  };
}

