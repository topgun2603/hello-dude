//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PkBattleInput {
  /// Returns a new [PkBattleInput] instance.
  PkBattleInput({
    required this.id,
    required this.status,
    required this.a,
    required this.b,
    required this.endsAt,
    required this.winnerHostId,
  });

  String id;

  PkBattleInputStatusEnum status;

  PkSideInput a;

  PkSideInput b;

  Object? endsAt;

  String? winnerHostId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PkBattleInput &&
    other.id == id &&
    other.status == status &&
    other.a == a &&
    other.b == b &&
    other.endsAt == endsAt &&
    other.winnerHostId == winnerHostId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (a.hashCode) +
    (b.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (winnerHostId == null ? 0 : winnerHostId!.hashCode);

  @override
  String toString() => 'PkBattleInput[id=$id, status=$status, a=$a, b=$b, endsAt=$endsAt, winnerHostId=$winnerHostId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
      json[r'a'] = this.a;
      json[r'b'] = this.b;
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
    if (this.winnerHostId != null) {
      json[r'winnerHostId'] = this.winnerHostId;
    } else {
      json[r'winnerHostId'] = null;
    }
    return json;
  }

  /// Returns a new [PkBattleInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PkBattleInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PkBattleInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PkBattleInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PkBattleInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PkBattleInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'a'), 'Required key "PkBattleInput[a]" is missing from JSON.');
        assert(json[r'a'] != null, 'Required key "PkBattleInput[a]" has a null value in JSON.');
        assert(json.containsKey(r'b'), 'Required key "PkBattleInput[b]" is missing from JSON.');
        assert(json[r'b'] != null, 'Required key "PkBattleInput[b]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "PkBattleInput[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'winnerHostId'), 'Required key "PkBattleInput[winnerHostId]" is missing from JSON.');
        return true;
      }());

      return PkBattleInput(
        id: mapValueOfType<String>(json, r'id')!,
        status: PkBattleInputStatusEnum.fromJson(json[r'status'])!,
        a: PkSideInput.fromJson(json[r'a'])!,
        b: PkSideInput.fromJson(json[r'b'])!,
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
        winnerHostId: mapValueOfType<String>(json, r'winnerHostId'),
      );
    }
    return null;
  }

  static List<PkBattleInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkBattleInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkBattleInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PkBattleInput> mapFromJson(dynamic json) {
    final map = <String, PkBattleInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PkBattleInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PkBattleInput-objects as value to a dart map
  static Map<String, List<PkBattleInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PkBattleInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PkBattleInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'a',
    'b',
    'endsAt',
    'winnerHostId',
  };
}


enum PkBattleInputStatusEnum {
  invited._(r'invited'),
  active._(r'active'),
  ended._(r'ended'),
  declined._(r'declined'),
  expired._(r'expired'),
  cancelled._(r'cancelled'),
  ;

  /// Instantiate a new enum with the provided value.
  const PkBattleInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PkBattleInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PkBattleInputStatusEnum? fromJson(dynamic value) => PkBattleInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PkBattleInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PkBattleInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkBattleInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkBattleInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PkBattleInputStatusEnum] to String,
/// and [decode] dynamic data back to [PkBattleInputStatusEnum].
class PkBattleInputStatusEnumTypeTransformer {
  factory PkBattleInputStatusEnumTypeTransformer() => _instance ??= const PkBattleInputStatusEnumTypeTransformer._();

  const PkBattleInputStatusEnumTypeTransformer._();

  String encode(PkBattleInputStatusEnum data) => data._value;

  /// Returns the instance of [PkBattleInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PkBattleInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PkBattleInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'invited': return PkBattleInputStatusEnum.invited;
        case r'active': return PkBattleInputStatusEnum.active;
        case r'ended': return PkBattleInputStatusEnum.ended;
        case r'declined': return PkBattleInputStatusEnum.declined;
        case r'expired': return PkBattleInputStatusEnum.expired;
        case r'cancelled': return PkBattleInputStatusEnum.cancelled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PkBattleInputStatusEnumTypeTransformer? _instance;
}


