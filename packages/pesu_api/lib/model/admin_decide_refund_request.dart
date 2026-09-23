//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDecideRefundRequest {
  /// Returns a new [AdminDecideRefundRequest] instance.
  AdminDecideRefundRequest({
    required this.decision,
    this.coins,
    this.reverseCompanion = false,
    required this.note,
  });

  AdminDecideRefundRequestDecisionEnum decision;

  /// Default: everything eligible
  ///
  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int? coins;

  /// Also take the companion's share back
  bool reverseCompanion;

  String note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDecideRefundRequest &&
    other.decision == decision &&
    other.coins == coins &&
    other.reverseCompanion == reverseCompanion &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (coins == null ? 0 : coins!.hashCode) +
    (reverseCompanion.hashCode) +
    (note.hashCode);

  @override
  String toString() => 'AdminDecideRefundRequest[decision=$decision, coins=$coins, reverseCompanion=$reverseCompanion, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
    if (this.coins != null) {
      json[r'coins'] = this.coins;
    } else {
      json[r'coins'] = null;
    }
      json[r'reverseCompanion'] = this.reverseCompanion;
      json[r'note'] = this.note;
    return json;
  }

  /// Returns a new [AdminDecideRefundRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDecideRefundRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "AdminDecideRefundRequest[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AdminDecideRefundRequest[decision]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminDecideRefundRequest[note]" is missing from JSON.');
        assert(json[r'note'] != null, 'Required key "AdminDecideRefundRequest[note]" has a null value in JSON.');
        return true;
      }());

      return AdminDecideRefundRequest(
        decision: AdminDecideRefundRequestDecisionEnum.fromJson(json[r'decision'])!,
        coins: mapValueOfType<int>(json, r'coins'),
        reverseCompanion: mapValueOfType<bool>(json, r'reverseCompanion') ?? false,
        note: mapValueOfType<String>(json, r'note')!,
      );
    }
    return null;
  }

  static List<AdminDecideRefundRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDecideRefundRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDecideRefundRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDecideRefundRequest> mapFromJson(dynamic json) {
    final map = <String, AdminDecideRefundRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDecideRefundRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDecideRefundRequest-objects as value to a dart map
  static Map<String, List<AdminDecideRefundRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDecideRefundRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDecideRefundRequest.listFromJson(entry.value, growable: growable,);
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


enum AdminDecideRefundRequestDecisionEnum {
  approve._(r'approve'),
  reject._(r'reject'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminDecideRefundRequestDecisionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminDecideRefundRequestDecisionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminDecideRefundRequestDecisionEnum? fromJson(dynamic value) => AdminDecideRefundRequestDecisionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminDecideRefundRequestDecisionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminDecideRefundRequestDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDecideRefundRequestDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDecideRefundRequestDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDecideRefundRequestDecisionEnum] to String,
/// and [decode] dynamic data back to [AdminDecideRefundRequestDecisionEnum].
class AdminDecideRefundRequestDecisionEnumTypeTransformer {
  factory AdminDecideRefundRequestDecisionEnumTypeTransformer() => _instance ??= const AdminDecideRefundRequestDecisionEnumTypeTransformer._();

  const AdminDecideRefundRequestDecisionEnumTypeTransformer._();

  String encode(AdminDecideRefundRequestDecisionEnum data) => data._value;

  /// Returns the instance of [AdminDecideRefundRequestDecisionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDecideRefundRequestDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminDecideRefundRequestDecisionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'approve': return AdminDecideRefundRequestDecisionEnum.approve;
        case r'reject': return AdminDecideRefundRequestDecisionEnum.reject;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminDecideRefundRequestDecisionEnumTypeTransformer? _instance;
}


