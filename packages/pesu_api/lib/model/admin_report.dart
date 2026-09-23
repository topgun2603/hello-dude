//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminReport {
  /// Returns a new [AdminReport] instance.
  AdminReport({
    required this.id,
    required this.createdAt,
    required this.reason,
    required this.details,
    required this.status,
    required this.callId,
    required this.reporter,
    required this.reported,
    required this.resolutionNote,
    required this.resolvedAt,
    required this.recording,
  });

  String id;

  DateTime createdAt;

  String reason;

  String? details;

  String status;

  String? callId;

  AdminDashboard200ResponseActivityInnerUser reporter;

  AdminReportReported reported;

  String? resolutionNote;

  DateTime? resolvedAt;

  AdminReportRecordingEnum? recording;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminReport &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.reason == reason &&
    other.details == details &&
    other.status == status &&
    other.callId == callId &&
    other.reporter == reporter &&
    other.reported == reported &&
    other.resolutionNote == resolutionNote &&
    other.resolvedAt == resolvedAt &&
    other.recording == recording;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (status.hashCode) +
    (callId == null ? 0 : callId!.hashCode) +
    (reporter.hashCode) +
    (reported.hashCode) +
    (resolutionNote == null ? 0 : resolutionNote!.hashCode) +
    (resolvedAt == null ? 0 : resolvedAt!.hashCode) +
    (recording == null ? 0 : recording!.hashCode);

  @override
  String toString() => 'AdminReport[id=$id, createdAt=$createdAt, reason=$reason, details=$details, status=$status, callId=$callId, reporter=$reporter, reported=$reported, resolutionNote=$resolutionNote, resolvedAt=$resolvedAt, recording=$recording]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'reason'] = this.reason;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
      json[r'status'] = this.status;
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
      json[r'reporter'] = this.reporter;
      json[r'reported'] = this.reported;
    if (this.resolutionNote != null) {
      json[r'resolutionNote'] = this.resolutionNote;
    } else {
      json[r'resolutionNote'] = null;
    }
    if (this.resolvedAt != null) {
      json[r'resolvedAt'] = this.resolvedAt!.toUtc().toIso8601String();
    } else {
      json[r'resolvedAt'] = null;
    }
    if (this.recording != null) {
      json[r'recording'] = this.recording;
    } else {
      json[r'recording'] = null;
    }
    return json;
  }

  /// Returns a new [AdminReport] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminReport? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminReport[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminReport[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminReport[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminReport[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminReport[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminReport[reason]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminReport[details]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminReport[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminReport[status]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminReport[callId]" is missing from JSON.');
        assert(json.containsKey(r'reporter'), 'Required key "AdminReport[reporter]" is missing from JSON.');
        assert(json[r'reporter'] != null, 'Required key "AdminReport[reporter]" has a null value in JSON.');
        assert(json.containsKey(r'reported'), 'Required key "AdminReport[reported]" is missing from JSON.');
        assert(json[r'reported'] != null, 'Required key "AdminReport[reported]" has a null value in JSON.');
        assert(json.containsKey(r'resolutionNote'), 'Required key "AdminReport[resolutionNote]" is missing from JSON.');
        assert(json.containsKey(r'resolvedAt'), 'Required key "AdminReport[resolvedAt]" is missing from JSON.');
        assert(json.containsKey(r'recording'), 'Required key "AdminReport[recording]" is missing from JSON.');
        return true;
      }());

      return AdminReport(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        details: mapValueOfType<String>(json, r'details'),
        status: mapValueOfType<String>(json, r'status')!,
        callId: mapValueOfType<String>(json, r'callId'),
        reporter: AdminDashboard200ResponseActivityInnerUser.fromJson(json[r'reporter'])!,
        reported: AdminReportReported.fromJson(json[r'reported'])!,
        resolutionNote: mapValueOfType<String>(json, r'resolutionNote'),
        resolvedAt: mapDateTime(json, r'resolvedAt', r''),
        recording: AdminReportRecordingEnum.fromJson(json[r'recording']),
      );
    }
    return null;
  }

  static List<AdminReport> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminReport>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminReport.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminReport> mapFromJson(dynamic json) {
    final map = <String, AdminReport>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminReport.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminReport-objects as value to a dart map
  static Map<String, List<AdminReport>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminReport>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminReport.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'reason',
    'details',
    'status',
    'callId',
    'reporter',
    'reported',
    'resolutionNote',
    'resolvedAt',
    'recording',
  };
}


enum AdminReportRecordingEnum {
  recording._(r'recording'),
  ready._(r'ready'),
  failed._(r'failed'),
  deleted._(r'deleted'),
  disabled._(r'disabled'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminReportRecordingEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminReportRecordingEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminReportRecordingEnum? fromJson(dynamic value) => AdminReportRecordingEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminReportRecordingEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminReportRecordingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminReportRecordingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminReportRecordingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminReportRecordingEnum] to String,
/// and [decode] dynamic data back to [AdminReportRecordingEnum].
class AdminReportRecordingEnumTypeTransformer {
  factory AdminReportRecordingEnumTypeTransformer() => _instance ??= const AdminReportRecordingEnumTypeTransformer._();

  const AdminReportRecordingEnumTypeTransformer._();

  String encode(AdminReportRecordingEnum data) => data._value;

  /// Returns the instance of [AdminReportRecordingEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminReportRecordingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminReportRecordingEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'recording': return AdminReportRecordingEnum.recording;
        case r'ready': return AdminReportRecordingEnum.ready;
        case r'failed': return AdminReportRecordingEnum.failed;
        case r'deleted': return AdminReportRecordingEnum.deleted;
        case r'disabled': return AdminReportRecordingEnum.disabled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminReportRecordingEnumTypeTransformer? _instance;
}


