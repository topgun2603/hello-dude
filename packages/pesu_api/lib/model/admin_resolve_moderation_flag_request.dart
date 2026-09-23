//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminResolveModerationFlagRequest {
  /// Returns a new [AdminResolveModerationFlagRequest] instance.
  AdminResolveModerationFlagRequest({
    required this.decision,
    required this.note,
  });

  AdminResolveModerationFlagRequestDecisionEnum decision;

  String note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminResolveModerationFlagRequest &&
    other.decision == decision &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (note.hashCode);

  @override
  String toString() => 'AdminResolveModerationFlagRequest[decision=$decision, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
      json[r'note'] = this.note;
    return json;
  }

  /// Returns a new [AdminResolveModerationFlagRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminResolveModerationFlagRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "AdminResolveModerationFlagRequest[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AdminResolveModerationFlagRequest[decision]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminResolveModerationFlagRequest[note]" is missing from JSON.');
        assert(json[r'note'] != null, 'Required key "AdminResolveModerationFlagRequest[note]" has a null value in JSON.');
        return true;
      }());

      return AdminResolveModerationFlagRequest(
        decision: AdminResolveModerationFlagRequestDecisionEnum.fromJson(json[r'decision'])!,
        note: mapValueOfType<String>(json, r'note')!,
      );
    }
    return null;
  }

  static List<AdminResolveModerationFlagRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminResolveModerationFlagRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminResolveModerationFlagRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminResolveModerationFlagRequest> mapFromJson(dynamic json) {
    final map = <String, AdminResolveModerationFlagRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminResolveModerationFlagRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminResolveModerationFlagRequest-objects as value to a dart map
  static Map<String, List<AdminResolveModerationFlagRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminResolveModerationFlagRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminResolveModerationFlagRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'decision',
    'note',
  };
}


enum AdminResolveModerationFlagRequestDecisionEnum {
  dismiss._(r'dismiss'),
  suspend._(r'suspend'),
  ban._(r'ban'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminResolveModerationFlagRequestDecisionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminResolveModerationFlagRequestDecisionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminResolveModerationFlagRequestDecisionEnum? fromJson(dynamic value) => AdminResolveModerationFlagRequestDecisionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminResolveModerationFlagRequestDecisionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminResolveModerationFlagRequestDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminResolveModerationFlagRequestDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminResolveModerationFlagRequestDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminResolveModerationFlagRequestDecisionEnum] to String,
/// and [decode] dynamic data back to [AdminResolveModerationFlagRequestDecisionEnum].
class AdminResolveModerationFlagRequestDecisionEnumTypeTransformer {
  factory AdminResolveModerationFlagRequestDecisionEnumTypeTransformer() => _instance ??= const AdminResolveModerationFlagRequestDecisionEnumTypeTransformer._();

  const AdminResolveModerationFlagRequestDecisionEnumTypeTransformer._();

  String encode(AdminResolveModerationFlagRequestDecisionEnum data) => data._value;

  /// Returns the instance of [AdminResolveModerationFlagRequestDecisionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminResolveModerationFlagRequestDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminResolveModerationFlagRequestDecisionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dismiss': return AdminResolveModerationFlagRequestDecisionEnum.dismiss;
        case r'suspend': return AdminResolveModerationFlagRequestDecisionEnum.suspend;
        case r'ban': return AdminResolveModerationFlagRequestDecisionEnum.ban;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminResolveModerationFlagRequestDecisionEnumTypeTransformer? _instance;
}


