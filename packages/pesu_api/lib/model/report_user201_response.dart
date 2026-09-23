//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ReportUser201Response {
  /// Returns a new [ReportUser201Response] instance.
  ReportUser201Response({
    required this.reportId,
    required this.recording,
  });

  String reportId;

  ReportUser201ResponseRecordingEnum recording;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportUser201Response &&
    other.reportId == reportId &&
    other.recording == recording;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reportId.hashCode) +
    (recording.hashCode);

  @override
  String toString() => 'ReportUser201Response[reportId=$reportId, recording=$recording]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reportId'] = this.reportId;
      json[r'recording'] = this.recording;
    return json;
  }

  /// Returns a new [ReportUser201Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportUser201Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reportId'), 'Required key "ReportUser201Response[reportId]" is missing from JSON.');
        assert(json[r'reportId'] != null, 'Required key "ReportUser201Response[reportId]" has a null value in JSON.');
        assert(json.containsKey(r'recording'), 'Required key "ReportUser201Response[recording]" is missing from JSON.');
        assert(json[r'recording'] != null, 'Required key "ReportUser201Response[recording]" has a null value in JSON.');
        return true;
      }());

      return ReportUser201Response(
        reportId: mapValueOfType<String>(json, r'reportId')!,
        recording: ReportUser201ResponseRecordingEnum.fromJson(json[r'recording'])!,
      );
    }
    return null;
  }

  static List<ReportUser201Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportUser201Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportUser201Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportUser201Response> mapFromJson(dynamic json) {
    final map = <String, ReportUser201Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportUser201Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportUser201Response-objects as value to a dart map
  static Map<String, List<ReportUser201Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportUser201Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportUser201Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reportId',
    'recording',
  };
}


enum ReportUser201ResponseRecordingEnum {
  started._(r'started'),
  notLive._(r'not_live'),
  disabled._(r'disabled'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReportUser201ResponseRecordingEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReportUser201ResponseRecordingEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReportUser201ResponseRecordingEnum? fromJson(dynamic value) => ReportUser201ResponseRecordingEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReportUser201ResponseRecordingEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReportUser201ResponseRecordingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportUser201ResponseRecordingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportUser201ResponseRecordingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReportUser201ResponseRecordingEnum] to String,
/// and [decode] dynamic data back to [ReportUser201ResponseRecordingEnum].
class ReportUser201ResponseRecordingEnumTypeTransformer {
  factory ReportUser201ResponseRecordingEnumTypeTransformer() => _instance ??= const ReportUser201ResponseRecordingEnumTypeTransformer._();

  const ReportUser201ResponseRecordingEnumTypeTransformer._();

  String encode(ReportUser201ResponseRecordingEnum data) => data._value;

  /// Returns the instance of [ReportUser201ResponseRecordingEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReportUser201ResponseRecordingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReportUser201ResponseRecordingEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'started': return ReportUser201ResponseRecordingEnum.started;
        case r'not_live': return ReportUser201ResponseRecordingEnum.notLive;
        case r'disabled': return ReportUser201ResponseRecordingEnum.disabled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReportUser201ResponseRecordingEnumTypeTransformer? _instance;
}


