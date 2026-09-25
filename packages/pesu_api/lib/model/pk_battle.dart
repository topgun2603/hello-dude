//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PkBattle {
  /// Returns a new [PkBattle] instance.
  PkBattle({
    required this.id,
    required this.status,
    required this.a,
    required this.b,
    required this.endsAt,
    required this.winnerHostId,
  });

  String id;

  PkBattleStatusEnum status;

  PkSide a;

  PkSide b;

  DateTime? endsAt;

  String? winnerHostId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PkBattle &&
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
  String toString() => 'PkBattle[id=$id, status=$status, a=$a, b=$b, endsAt=$endsAt, winnerHostId=$winnerHostId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
      json[r'a'] = this.a;
      json[r'b'] = this.b;
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt!.toUtc().toIso8601String();
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

  /// Returns a new [PkBattle] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PkBattle? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PkBattle[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PkBattle[id]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "PkBattle[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "PkBattle[status]" has a null value in JSON.');
        assert(json.containsKey(r'a'), 'Required key "PkBattle[a]" is missing from JSON.');
        assert(json[r'a'] != null, 'Required key "PkBattle[a]" has a null value in JSON.');
        assert(json.containsKey(r'b'), 'Required key "PkBattle[b]" is missing from JSON.');
        assert(json[r'b'] != null, 'Required key "PkBattle[b]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "PkBattle[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'winnerHostId'), 'Required key "PkBattle[winnerHostId]" is missing from JSON.');
        return true;
      }());

      return PkBattle(
        id: mapValueOfType<String>(json, r'id')!,
        status: PkBattleStatusEnum.fromJson(json[r'status'])!,
        a: PkSide.fromJson(json[r'a'])!,
        b: PkSide.fromJson(json[r'b'])!,
        endsAt: mapDateTime(json, r'endsAt', r''),
        winnerHostId: mapValueOfType<String>(json, r'winnerHostId'),
      );
    }
    return null;
  }

  static List<PkBattle> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkBattle>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkBattle.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PkBattle> mapFromJson(dynamic json) {
    final map = <String, PkBattle>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PkBattle.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PkBattle-objects as value to a dart map
  static Map<String, List<PkBattle>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PkBattle>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PkBattle.listFromJson(entry.value, growable: growable,);
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


enum PkBattleStatusEnum {
  invited._(r'invited'),
  active._(r'active'),
  ended._(r'ended'),
  declined._(r'declined'),
  expired._(r'expired'),
  cancelled._(r'cancelled'),
  ;

  /// Instantiate a new enum with the provided value.
  const PkBattleStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PkBattleStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PkBattleStatusEnum? fromJson(dynamic value) => PkBattleStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PkBattleStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PkBattleStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkBattleStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkBattleStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PkBattleStatusEnum] to String,
/// and [decode] dynamic data back to [PkBattleStatusEnum].
class PkBattleStatusEnumTypeTransformer {
  factory PkBattleStatusEnumTypeTransformer() => _instance ??= const PkBattleStatusEnumTypeTransformer._();

  const PkBattleStatusEnumTypeTransformer._();

  String encode(PkBattleStatusEnum data) => data._value;

  /// Returns the instance of [PkBattleStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PkBattleStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PkBattleStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'invited': return PkBattleStatusEnum.invited;
        case r'active': return PkBattleStatusEnum.active;
        case r'ended': return PkBattleStatusEnum.ended;
        case r'declined': return PkBattleStatusEnum.declined;
        case r'expired': return PkBattleStatusEnum.expired;
        case r'cancelled': return PkBattleStatusEnum.cancelled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PkBattleStatusEnumTypeTransformer? _instance;
}


