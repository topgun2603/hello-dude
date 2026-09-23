//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionHome200Response {
  /// Returns a new [CompanionHome200Response] instance.
  CompanionHome200Response({
    required this.kycStatus,
    required this.videoEnabled,
    required this.online,
    required this.today,
    this.recent = const [],
  });

  CompanionHome200ResponseKycStatusEnum kycStatus;

  bool videoEnabled;

  bool online;

  CompanionHome200ResponseToday today;

  List<CompanionHome200ResponseRecentInner> recent;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionHome200Response &&
    other.kycStatus == kycStatus &&
    other.videoEnabled == videoEnabled &&
    other.online == online &&
    other.today == today &&
    _deepEquality.equals(other.recent, recent);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kycStatus.hashCode) +
    (videoEnabled.hashCode) +
    (online.hashCode) +
    (today.hashCode) +
    (recent.hashCode);

  @override
  String toString() => 'CompanionHome200Response[kycStatus=$kycStatus, videoEnabled=$videoEnabled, online=$online, today=$today, recent=$recent]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kycStatus'] = this.kycStatus;
      json[r'videoEnabled'] = this.videoEnabled;
      json[r'online'] = this.online;
      json[r'today'] = this.today;
      json[r'recent'] = this.recent;
    return json;
  }

  /// Returns a new [CompanionHome200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionHome200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kycStatus'), 'Required key "CompanionHome200Response[kycStatus]" is missing from JSON.');
        assert(json[r'kycStatus'] != null, 'Required key "CompanionHome200Response[kycStatus]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "CompanionHome200Response[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "CompanionHome200Response[videoEnabled]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "CompanionHome200Response[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "CompanionHome200Response[online]" has a null value in JSON.');
        assert(json.containsKey(r'today'), 'Required key "CompanionHome200Response[today]" is missing from JSON.');
        assert(json[r'today'] != null, 'Required key "CompanionHome200Response[today]" has a null value in JSON.');
        assert(json.containsKey(r'recent'), 'Required key "CompanionHome200Response[recent]" is missing from JSON.');
        assert(json[r'recent'] != null, 'Required key "CompanionHome200Response[recent]" has a null value in JSON.');
        return true;
      }());

      return CompanionHome200Response(
        kycStatus: CompanionHome200ResponseKycStatusEnum.fromJson(json[r'kycStatus'])!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
        online: mapValueOfType<bool>(json, r'online')!,
        today: CompanionHome200ResponseToday.fromJson(json[r'today'])!,
        recent: CompanionHome200ResponseRecentInner.listFromJson(json[r'recent']),
      );
    }
    return null;
  }

  static List<CompanionHome200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionHome200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionHome200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionHome200Response> mapFromJson(dynamic json) {
    final map = <String, CompanionHome200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionHome200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionHome200Response-objects as value to a dart map
  static Map<String, List<CompanionHome200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionHome200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionHome200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kycStatus',
    'videoEnabled',
    'online',
    'today',
    'recent',
  };
}


enum CompanionHome200ResponseKycStatusEnum {
  inProgress._(r'in_progress'),
  submitted._(r'submitted'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const CompanionHome200ResponseKycStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [CompanionHome200ResponseKycStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static CompanionHome200ResponseKycStatusEnum? fromJson(dynamic value) => CompanionHome200ResponseKycStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [CompanionHome200ResponseKycStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<CompanionHome200ResponseKycStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionHome200ResponseKycStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionHome200ResponseKycStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CompanionHome200ResponseKycStatusEnum] to String,
/// and [decode] dynamic data back to [CompanionHome200ResponseKycStatusEnum].
class CompanionHome200ResponseKycStatusEnumTypeTransformer {
  factory CompanionHome200ResponseKycStatusEnumTypeTransformer() => _instance ??= const CompanionHome200ResponseKycStatusEnumTypeTransformer._();

  const CompanionHome200ResponseKycStatusEnumTypeTransformer._();

  String encode(CompanionHome200ResponseKycStatusEnum data) => data._value;

  /// Returns the instance of [CompanionHome200ResponseKycStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CompanionHome200ResponseKycStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is CompanionHome200ResponseKycStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'in_progress': return CompanionHome200ResponseKycStatusEnum.inProgress;
        case r'submitted': return CompanionHome200ResponseKycStatusEnum.submitted;
        case r'approved': return CompanionHome200ResponseKycStatusEnum.approved;
        case r'rejected': return CompanionHome200ResponseKycStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static CompanionHome200ResponseKycStatusEnumTypeTransformer? _instance;
}


