//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ReportUserRequest {
  /// Returns a new [ReportUserRequest] instance.
  ReportUserRequest({
    required this.userId,
    this.callId,
    required this.reason,
    this.details,
    this.alsoBlock = true,
  });

  String userId;

  String? callId;

  ReportUserRequestReasonEnum reason;

  String? details;

  bool alsoBlock;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportUserRequest &&
    other.userId == userId &&
    other.callId == callId &&
    other.reason == reason &&
    other.details == details &&
    other.alsoBlock == alsoBlock;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (callId == null ? 0 : callId!.hashCode) +
    (reason.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (alsoBlock.hashCode);

  @override
  String toString() => 'ReportUserRequest[userId=$userId, callId=$callId, reason=$reason, details=$details, alsoBlock=$alsoBlock]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
      json[r'reason'] = this.reason;
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
      json[r'alsoBlock'] = this.alsoBlock;
    return json;
  }

  /// Returns a new [ReportUserRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportUserRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'userId'), 'Required key "ReportUserRequest[userId]" is missing from JSON.');
        assert(json[r'userId'] != null, 'Required key "ReportUserRequest[userId]" has a null value in JSON.');
        assert(json.containsKey(r'reason'), 'Required key "ReportUserRequest[reason]" is missing from JSON.');
        assert(json[r'reason'] != null, 'Required key "ReportUserRequest[reason]" has a null value in JSON.');
        return true;
      }());

      return ReportUserRequest(
        userId: mapValueOfType<String>(json, r'userId')!,
        callId: mapValueOfType<String>(json, r'callId'),
        reason: ReportUserRequestReasonEnum.fromJson(json[r'reason'])!,
        details: mapValueOfType<String>(json, r'details'),
        alsoBlock: mapValueOfType<bool>(json, r'alsoBlock') ?? true,
      );
    }
    return null;
  }

  static List<ReportUserRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportUserRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportUserRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportUserRequest> mapFromJson(dynamic json) {
    final map = <String, ReportUserRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportUserRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportUserRequest-objects as value to a dart map
  static Map<String, List<ReportUserRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportUserRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportUserRequest.listFromJson(entry.value, growable: growable,);
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


enum ReportUserRequestReasonEnum {
  abuse._(r'abuse'),
  sexualContent._(r'sexual_content'),
  spam._(r'spam'),
  underage._(r'underage'),
  fraud._(r'fraud'),
  offPlatform._(r'off_platform'),
  other._(r'other'),
  ;

  /// Instantiate a new enum with the provided value.
  const ReportUserRequestReasonEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ReportUserRequestReasonEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ReportUserRequestReasonEnum? fromJson(dynamic value) => ReportUserRequestReasonEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ReportUserRequestReasonEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ReportUserRequestReasonEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportUserRequestReasonEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportUserRequestReasonEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReportUserRequestReasonEnum] to String,
/// and [decode] dynamic data back to [ReportUserRequestReasonEnum].
class ReportUserRequestReasonEnumTypeTransformer {
  factory ReportUserRequestReasonEnumTypeTransformer() => _instance ??= const ReportUserRequestReasonEnumTypeTransformer._();

  const ReportUserRequestReasonEnumTypeTransformer._();

  String encode(ReportUserRequestReasonEnum data) => data._value;

  /// Returns the instance of [ReportUserRequestReasonEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReportUserRequestReasonEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ReportUserRequestReasonEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'abuse': return ReportUserRequestReasonEnum.abuse;
        case r'sexual_content': return ReportUserRequestReasonEnum.sexualContent;
        case r'spam': return ReportUserRequestReasonEnum.spam;
        case r'underage': return ReportUserRequestReasonEnum.underage;
        case r'fraud': return ReportUserRequestReasonEnum.fraud;
        case r'off_platform': return ReportUserRequestReasonEnum.offPlatform;
        case r'other': return ReportUserRequestReasonEnum.other;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ReportUserRequestReasonEnumTypeTransformer? _instance;
}


