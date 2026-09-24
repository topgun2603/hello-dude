//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetVip200Response {
  /// Returns a new [GetVip200Response] instance.
  GetVip200Response({
    required this.active,
    required this.expiresAt,
    required this.source_,
    required this.discountPct,
    required this.weeklyGift,
    this.plans = const [],
    required this.purchasable,
  });

  bool active;

  DateTime? expiresAt;

  GetVip200ResponseSource_Enum? source_;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int discountPct;

  GetVip200ResponseWeeklyGift? weeklyGift;

  List<VipPlan> plans;

  /// false until Google Play Billing is set up
  bool purchasable;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetVip200Response &&
    other.active == active &&
    other.expiresAt == expiresAt &&
    other.source_ == source_ &&
    other.discountPct == discountPct &&
    other.weeklyGift == weeklyGift &&
    _deepEquality.equals(other.plans, plans) &&
    other.purchasable == purchasable;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (active.hashCode) +
    (expiresAt == null ? 0 : expiresAt!.hashCode) +
    (source_ == null ? 0 : source_!.hashCode) +
    (discountPct.hashCode) +
    (weeklyGift == null ? 0 : weeklyGift!.hashCode) +
    (plans.hashCode) +
    (purchasable.hashCode);

  @override
  String toString() => 'GetVip200Response[active=$active, expiresAt=$expiresAt, source_=$source_, discountPct=$discountPct, weeklyGift=$weeklyGift, plans=$plans, purchasable=$purchasable]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'active'] = this.active;
    if (this.expiresAt != null) {
      json[r'expiresAt'] = this.expiresAt!.toUtc().toIso8601String();
    } else {
      json[r'expiresAt'] = null;
    }
    if (this.source_ != null) {
      json[r'source'] = this.source_;
    } else {
      json[r'source'] = null;
    }
      json[r'discountPct'] = this.discountPct;
    if (this.weeklyGift != null) {
      json[r'weeklyGift'] = this.weeklyGift;
    } else {
      json[r'weeklyGift'] = null;
    }
      json[r'plans'] = this.plans;
      json[r'purchasable'] = this.purchasable;
    return json;
  }

  /// Returns a new [GetVip200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetVip200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'active'), 'Required key "GetVip200Response[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "GetVip200Response[active]" has a null value in JSON.');
        assert(json.containsKey(r'expiresAt'), 'Required key "GetVip200Response[expiresAt]" is missing from JSON.');
        assert(json.containsKey(r'source'), 'Required key "GetVip200Response[source]" is missing from JSON.');
        assert(json.containsKey(r'discountPct'), 'Required key "GetVip200Response[discountPct]" is missing from JSON.');
        assert(json[r'discountPct'] != null, 'Required key "GetVip200Response[discountPct]" has a null value in JSON.');
        assert(json.containsKey(r'weeklyGift'), 'Required key "GetVip200Response[weeklyGift]" is missing from JSON.');
        assert(json.containsKey(r'plans'), 'Required key "GetVip200Response[plans]" is missing from JSON.');
        assert(json[r'plans'] != null, 'Required key "GetVip200Response[plans]" has a null value in JSON.');
        assert(json.containsKey(r'purchasable'), 'Required key "GetVip200Response[purchasable]" is missing from JSON.');
        assert(json[r'purchasable'] != null, 'Required key "GetVip200Response[purchasable]" has a null value in JSON.');
        return true;
      }());

      return GetVip200Response(
        active: mapValueOfType<bool>(json, r'active')!,
        expiresAt: mapDateTime(json, r'expiresAt', r''),
        source_: GetVip200ResponseSource_Enum.fromJson(json[r'source']),
        discountPct: mapValueOfType<int>(json, r'discountPct')!,
        weeklyGift: GetVip200ResponseWeeklyGift.fromJson(json[r'weeklyGift']),
        plans: VipPlan.listFromJson(json[r'plans']),
        purchasable: mapValueOfType<bool>(json, r'purchasable')!,
      );
    }
    return null;
  }

  static List<GetVip200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetVip200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetVip200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetVip200Response> mapFromJson(dynamic json) {
    final map = <String, GetVip200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetVip200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetVip200Response-objects as value to a dart map
  static Map<String, List<GetVip200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetVip200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetVip200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'active',
    'expiresAt',
    'source',
    'discountPct',
    'weeklyGift',
    'plans',
    'purchasable',
  };
}


enum GetVip200ResponseSource_Enum {
  play._(r'play'),
  admin._(r'admin'),
  ;

  /// Instantiate a new enum with the provided value.
  const GetVip200ResponseSource_Enum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GetVip200ResponseSource_Enum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GetVip200ResponseSource_Enum? fromJson(dynamic value) => GetVip200ResponseSource_EnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GetVip200ResponseSource_Enum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GetVip200ResponseSource_Enum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetVip200ResponseSource_Enum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetVip200ResponseSource_Enum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GetVip200ResponseSource_Enum] to String,
/// and [decode] dynamic data back to [GetVip200ResponseSource_Enum].
class GetVip200ResponseSource_EnumTypeTransformer {
  factory GetVip200ResponseSource_EnumTypeTransformer() => _instance ??= const GetVip200ResponseSource_EnumTypeTransformer._();

  const GetVip200ResponseSource_EnumTypeTransformer._();

  String encode(GetVip200ResponseSource_Enum data) => data._value;

  /// Returns the instance of [GetVip200ResponseSource_Enum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GetVip200ResponseSource_Enum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GetVip200ResponseSource_Enum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'play': return GetVip200ResponseSource_Enum.play;
        case r'admin': return GetVip200ResponseSource_Enum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GetVip200ResponseSource_EnumTypeTransformer? _instance;
}


