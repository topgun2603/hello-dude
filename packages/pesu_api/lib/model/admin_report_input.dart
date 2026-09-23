//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminReportInput {
  /// Returns a new [AdminReportInput] instance.
  AdminReportInput({
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

  Object? createdAt;

  String reason;

  String? details;

  String status;

  String? callId;

  AdminReportInputReporter reporter;

  AdminReportInputReported reported;

  String? resolutionNote;

  Object? resolvedAt;

  AdminReportInputRecordingEnum? recording;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminReportInput &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
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
  String toString() => 'AdminReportInput[id=$id, createdAt=$createdAt, reason=$reason, details=$details, status=$status, callId=$callId, reporter=$reporter, reported=$reported, resolutionNote=$resolutionNote, resolvedAt=$resolvedAt, recording=$recording]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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
      json[r'resolvedAt'] = this.resolvedAt;
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

  /// Returns a new [AdminReportInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminReportInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminReportInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminReportInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminReportInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'reason'), 'Required key "AdminReportInput[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "AdminReportInput[reason]" has a null value in JSON.');
        assert(json.containsKey(r'details'), 'Required key "AdminReportInput[details]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminReportInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminReportInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "AdminReportInput[callId]" is missing from JSON.');
        assert(json.containsKey(r'reporter'), 'Required key "AdminReportInput[reporter]" is missing from JSON.');
        assert(json[r'reporter'] != null, 'Required key "AdminReportInput[reporter]" has a null value in JSON.');
        assert(json.containsKey(r'reported'), 'Required key "AdminReportInput[reported]" is missing from JSON.');
        assert(json[r'reported'] != null, 'Required key "AdminReportInput[reported]" has a null value in JSON.');
        assert(json.containsKey(r'resolutionNote'), 'Required key "AdminReportInput[resolutionNote]" is missing from JSON.');
        assert(json.containsKey(r'resolvedAt'), 'Required key "AdminReportInput[resolvedAt]" is missing from JSON.');
        assert(json.containsKey(r'recording'), 'Required key "AdminReportInput[recording]" is missing from JSON.');
        return true;
      }());

      return AdminReportInput(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        reason: mapValueOfType<String>(json, r'reason')!,
        details: mapValueOfType<String>(json, r'details'),
        status: mapValueOfType<String>(json, r'status')!,
        callId: mapValueOfType<String>(json, r'callId'),
        reporter: AdminReportInputReporter.fromJson(json[r'reporter'])!,
        reported: AdminReportInputReported.fromJson(json[r'reported'])!,
        resolutionNote: mapValueOfType<String>(json, r'resolutionNote'),
        resolvedAt: mapValueOfType<Object>(json, r'resolvedAt'),
        recording: AdminReportInputRecordingEnum.fromJson(json[r'recording']),
      );
    }
    return null;
  }

  static List<AdminReportInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminReportInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminReportInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminReportInput> mapFromJson(dynamic json) {
    final map = <String, AdminReportInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminReportInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminReportInput-objects as value to a dart map
  static Map<String, List<AdminReportInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminReportInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminReportInput.listFromJson(entry.value, growable: growable,);
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


enum AdminReportInputRecordingEnum {
  recording._(r'recording'),
  ready._(r'ready'),
  failed._(r'failed'),
  deleted._(r'deleted'),
  disabled._(r'disabled'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminReportInputRecordingEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminReportInputRecordingEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminReportInputRecordingEnum? fromJson(dynamic value) => AdminReportInputRecordingEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminReportInputRecordingEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminReportInputRecordingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminReportInputRecordingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminReportInputRecordingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminReportInputRecordingEnum] to String,
/// and [decode] dynamic data back to [AdminReportInputRecordingEnum].
class AdminReportInputRecordingEnumTypeTransformer {
  factory AdminReportInputRecordingEnumTypeTransformer() => _instance ??= const AdminReportInputRecordingEnumTypeTransformer._();

  const AdminReportInputRecordingEnumTypeTransformer._();

  String encode(AdminReportInputRecordingEnum data) => data._value;

  /// Returns the instance of [AdminReportInputRecordingEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminReportInputRecordingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminReportInputRecordingEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'recording': return AdminReportInputRecordingEnum.recording;
        case r'ready': return AdminReportInputRecordingEnum.ready;
        case r'failed': return AdminReportInputRecordingEnum.failed;
        case r'deleted': return AdminReportInputRecordingEnum.deleted;
        case r'disabled': return AdminReportInputRecordingEnum.disabled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminReportInputRecordingEnumTypeTransformer? _instance;
}


