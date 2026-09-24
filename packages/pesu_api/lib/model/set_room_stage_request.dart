//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SetRoomStageRequest {
  /// Returns a new [SetRoomStageRequest] instance.
  SetRoomStageRequest({
    required this.action,
  });

  SetRoomStageRequestActionEnum action;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SetRoomStageRequest &&
    other.action == action;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (action.hashCode);

  @override
  String toString() => 'SetRoomStageRequest[action=$action]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'action'] = this.action;
    return json;
  }

  /// Returns a new [SetRoomStageRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SetRoomStageRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'action'), 'Required key "SetRoomStageRequest[action]" is missing from JSON.');
        assert(json[r'action'] != null, 'Required key "SetRoomStageRequest[action]" has a null value in JSON.');
        return true;
      }());

      return SetRoomStageRequest(
        action: SetRoomStageRequestActionEnum.fromJson(json[r'action'])!,
      );
    }
    return null;
  }

  static List<SetRoomStageRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SetRoomStageRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetRoomStageRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SetRoomStageRequest> mapFromJson(dynamic json) {
    final map = <String, SetRoomStageRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SetRoomStageRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SetRoomStageRequest-objects as value to a dart map
  static Map<String, List<SetRoomStageRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SetRoomStageRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SetRoomStageRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'action',
  };
}


enum SetRoomStageRequestActionEnum {
  invite._(r'invite'),
  remove._(r'remove'),
  ;

  /// Instantiate a new enum with the provided value.
  const SetRoomStageRequestActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [SetRoomStageRequestActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static SetRoomStageRequestActionEnum? fromJson(dynamic value) => SetRoomStageRequestActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [SetRoomStageRequestActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<SetRoomStageRequestActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SetRoomStageRequestActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetRoomStageRequestActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SetRoomStageRequestActionEnum] to String,
/// and [decode] dynamic data back to [SetRoomStageRequestActionEnum].
class SetRoomStageRequestActionEnumTypeTransformer {
  factory SetRoomStageRequestActionEnumTypeTransformer() => _instance ??= const SetRoomStageRequestActionEnumTypeTransformer._();

  const SetRoomStageRequestActionEnumTypeTransformer._();

  String encode(SetRoomStageRequestActionEnum data) => data._value;

  /// Returns the instance of [SetRoomStageRequestActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SetRoomStageRequestActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is SetRoomStageRequestActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'invite': return SetRoomStageRequestActionEnum.invite;
        case r'remove': return SetRoomStageRequestActionEnum.remove;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static SetRoomStageRequestActionEnumTypeTransformer? _instance;
}


