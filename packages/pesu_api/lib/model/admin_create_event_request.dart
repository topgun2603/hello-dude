//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreateEventRequest {
  /// Returns a new [AdminCreateEventRequest] instance.
  AdminCreateEventRequest({
    required this.name,
    this.tagline,
    required this.theme,
    required this.startsAt,
    required this.endsAt,
    this.giftIds = const [],
    this.active = true,
  });

  String name;

  String? tagline;

  AdminCreateEventRequestThemeEnum theme;

  Object? startsAt;

  Object? endsAt;

  List<int> giftIds;

  bool active;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreateEventRequest &&
    other.name == name &&
    other.tagline == tagline &&
    other.theme == theme &&
    other.startsAt == startsAt &&
    other.endsAt == endsAt &&
    _deepEquality.equals(other.giftIds, giftIds) &&
    other.active == active;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (tagline == null ? 0 : tagline!.hashCode) +
    (theme.hashCode) +
    (startsAt == null ? 0 : startsAt!.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (giftIds.hashCode) +
    (active.hashCode);

  @override
  String toString() => 'AdminCreateEventRequest[name=$name, tagline=$tagline, theme=$theme, startsAt=$startsAt, endsAt=$endsAt, giftIds=$giftIds, active=$active]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.tagline != null) {
      json[r'tagline'] = this.tagline;
    } else {
      json[r'tagline'] = null;
    }
      json[r'theme'] = this.theme;
    if (this.startsAt != null) {
      json[r'startsAt'] = this.startsAt;
    } else {
      json[r'startsAt'] = null;
    }
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
      json[r'giftIds'] = this.giftIds;
      json[r'active'] = this.active;
    return json;
  }

  /// Returns a new [AdminCreateEventRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreateEventRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "AdminCreateEventRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminCreateEventRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminCreateEventRequest[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminCreateEventRequest[theme]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminCreateEventRequest[startsAt]" is missing from JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AdminCreateEventRequest[endsAt]" is missing from JSON.');
        return true;
      }());

      return AdminCreateEventRequest(
        name: mapValueOfType<String>(json, r'name')!,
        tagline: mapValueOfType<String>(json, r'tagline'),
        theme: AdminCreateEventRequestThemeEnum.fromJson(json[r'theme'])!,
        startsAt: mapValueOfType<Object>(json, r'startsAt'),
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
        giftIds: json[r'giftIds'] is Iterable
            ? (json[r'giftIds'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        active: mapValueOfType<bool>(json, r'active') ?? true,
      );
    }
    return null;
  }

  static List<AdminCreateEventRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateEventRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateEventRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreateEventRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreateEventRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreateEventRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreateEventRequest-objects as value to a dart map
  static Map<String, List<AdminCreateEventRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreateEventRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreateEventRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'theme',
    'startsAt',
    'endsAt',
  };
}


enum AdminCreateEventRequestThemeEnum {
  festive._(r'festive'),
  pongal._(r'pongal'),
  diwali._(r'diwali'),
  onam._(r'onam'),
  holi._(r'holi'),
  love._(r'love'),
  cricket._(r'cricket'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreateEventRequestThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreateEventRequestThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreateEventRequestThemeEnum? fromJson(dynamic value) => AdminCreateEventRequestThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreateEventRequestThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreateEventRequestThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreateEventRequestThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreateEventRequestThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreateEventRequestThemeEnum] to String,
/// and [decode] dynamic data back to [AdminCreateEventRequestThemeEnum].
class AdminCreateEventRequestThemeEnumTypeTransformer {
  factory AdminCreateEventRequestThemeEnumTypeTransformer() => _instance ??= const AdminCreateEventRequestThemeEnumTypeTransformer._();

  const AdminCreateEventRequestThemeEnumTypeTransformer._();

  String encode(AdminCreateEventRequestThemeEnum data) => data._value;

  /// Returns the instance of [AdminCreateEventRequestThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreateEventRequestThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreateEventRequestThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'festive': return AdminCreateEventRequestThemeEnum.festive;
        case r'pongal': return AdminCreateEventRequestThemeEnum.pongal;
        case r'diwali': return AdminCreateEventRequestThemeEnum.diwali;
        case r'onam': return AdminCreateEventRequestThemeEnum.onam;
        case r'holi': return AdminCreateEventRequestThemeEnum.holi;
        case r'love': return AdminCreateEventRequestThemeEnum.love;
        case r'cricket': return AdminCreateEventRequestThemeEnum.cricket;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreateEventRequestThemeEnumTypeTransformer? _instance;
}


