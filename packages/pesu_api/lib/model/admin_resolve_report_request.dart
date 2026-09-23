//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminResolveReportRequest {
  /// Returns a new [AdminResolveReportRequest] instance.
  AdminResolveReportRequest({
    required this.decision,
    required this.note,
  });

  AdminResolveReportRequestDecisionEnum decision;

  String note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminResolveReportRequest &&
    other.decision == decision &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (note.hashCode);

  @override
  String toString() => 'AdminResolveReportRequest[decision=$decision, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
      json[r'note'] = this.note;
    return json;
  }

  /// Returns a new [AdminResolveReportRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminResolveReportRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "AdminResolveReportRequest[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AdminResolveReportRequest[decision]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminResolveReportRequest[note]" is missing from JSON.');
        assert(json[r'note'] != null, 'Required key "AdminResolveReportRequest[note]" has a null value in JSON.');
        return true;
      }());

      return AdminResolveReportRequest(
        decision: AdminResolveReportRequestDecisionEnum.fromJson(json[r'decision'])!,
        note: mapValueOfType<String>(json, r'note')!,
      );
    }
    return null;
  }

  static List<AdminResolveReportRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminResolveReportRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminResolveReportRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminResolveReportRequest> mapFromJson(dynamic json) {
    final map = <String, AdminResolveReportRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminResolveReportRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminResolveReportRequest-objects as value to a dart map
  static Map<String, List<AdminResolveReportRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminResolveReportRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminResolveReportRequest.listFromJson(entry.value, growable: growable,);
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


enum AdminResolveReportRequestDecisionEnum {
  dismiss._(r'dismiss'),
  suspend._(r'suspend'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminResolveReportRequestDecisionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminResolveReportRequestDecisionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminResolveReportRequestDecisionEnum? fromJson(dynamic value) => AdminResolveReportRequestDecisionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminResolveReportRequestDecisionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminResolveReportRequestDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminResolveReportRequestDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminResolveReportRequestDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminResolveReportRequestDecisionEnum] to String,
/// and [decode] dynamic data back to [AdminResolveReportRequestDecisionEnum].
class AdminResolveReportRequestDecisionEnumTypeTransformer {
  factory AdminResolveReportRequestDecisionEnumTypeTransformer() => _instance ??= const AdminResolveReportRequestDecisionEnumTypeTransformer._();

  const AdminResolveReportRequestDecisionEnumTypeTransformer._();

  String encode(AdminResolveReportRequestDecisionEnum data) => data._value;

  /// Returns the instance of [AdminResolveReportRequestDecisionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminResolveReportRequestDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminResolveReportRequestDecisionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'dismiss': return AdminResolveReportRequestDecisionEnum.dismiss;
        case r'suspend': return AdminResolveReportRequestDecisionEnum.suspend;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminResolveReportRequestDecisionEnumTypeTransformer? _instance;
}


