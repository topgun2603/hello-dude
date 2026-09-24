//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ReportInGroupRequest {
  /// Returns a new [ReportInGroupRequest] instance.
  ReportInGroupRequest({
    required this.userId,
    required this.reason,
    this.details,
    this.remove,
  });

  String userId;

  ReportInGroupRequestReasonEnum reason;

  String? details;

  /// Host only: remove them from the group
  bool? remove;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportInGroupRequest &&
    other.userId == userId &&
    other.reason == reason &&
    other.details == details &&
    other.remove == remove;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (remove == null ? 0 : remove!.hashCode);

  @override
  String toString() => 'ReportInGroupRequest[userId=$userId, reason=$reason, details=$details, remove=$remove]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'reason'] = this.reason;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
    if (this.remove != null) {
      json[r'remove'] = this.remove;
    } else {
      json[r'remove'] = null;
    }
    return json;
  }

  /// Returns a new [ReportInGroupRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportInGroupRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'userId'), 'Required key "ReportInGroupRequest[userId]" is missing from JSON.');
        assert(json[r'userId'] != null, 'Required key "ReportInGroupRequest[userId]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "ReportInGroupRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "ReportInGroupRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return ReportInGroupRequest(
        userId: mapValueOfType<String>(json, r'userId')!,
        reason: ReportInGroupRequestReasonEnum.fromJson(json[r'reason'])!,
        details: mapValueOfType<String>(json, r'details'),
        remove: mapValueOfType<bool>(json, r'remove'),
      );
    }
    return null;
  }

  static List<ReportInGroupRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportInGroupRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportInGroupRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportInGroupRequest> mapFromJson(dynamic json) {
    final map = <String, ReportInGroupRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportInGroupRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportInGroupRequest-objects as value to a dart map
  static Map<String, List<ReportInGroupRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportInGroupRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportInGroupRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'userId',
    'reason',
  };
}


enum ReportInGroupRequestReasonEnum {
  abuse._(r'abuse'),
  sexualContent._(r'sexual_content'),
  spam._(r'spam'),
  underage._(r'underage'),
  fraud._(r'fraud'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReportInGroupRequestReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReportInGroupRequestReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReportInGroupRequestReasonEnum? fromJson(dynamic value) => ReportInGroupRequestReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReportInGroupRequestReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReportInGroupRequestReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportInGroupRequestReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportInGroupRequestReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReportInGroupRequestReasonEnum] to String,
/// and [decode] dynamic data back to [ReportInGroupRequestReasonEnum].
class ReportInGroupRequestReasonEnumTypeTransformer {
  factory ReportInGroupRequestReasonEnumTypeTransformer() => _instance ??= const ReportInGroupRequestReasonEnumTypeTransformer._();

  const ReportInGroupRequestReasonEnumTypeTransformer._();

  String encode(ReportInGroupRequestReasonEnum data) => data._value;

  /// Returns the instance of [ReportInGroupRequestReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReportInGroupRequestReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReportInGroupRequestReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'abuse': return ReportInGroupRequestReasonEnum.abuse;
        case r'sexual_content': return ReportInGroupRequestReasonEnum.sexualContent;
        case r'spam': return ReportInGroupRequestReasonEnum.spam;
        case r'underage': return ReportInGroupRequestReasonEnum.underage;
        case r'fraud': return ReportInGroupRequestReasonEnum.fraud;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReportInGroupRequestReasonEnumTypeTransformer? _instance;
}


