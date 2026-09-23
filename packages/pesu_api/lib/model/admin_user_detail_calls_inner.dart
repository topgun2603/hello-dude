//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailCallsInner {
  /// Returns a new [AdminUserDetailCallsInner] instance.
  AdminUserDetailCallsInner({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.status,
    required this.language,
    required this.direction,
    required this.other,
    required this.seconds,
    required this.minutes,
    required this.coins,
    required this.paise,
    required this.endReason,
    required this.stars,
    required this.giftCoins,
  });

  String id;

  DateTime createdAt;

  AdminUserDetailCallsInnerTypeEnum type;

  String status;

  String language;

  AdminUserDetailCallsInnerDirectionEnum direction;

  AdminRefundCompanion other;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? seconds;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paise;

  String? endReason;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? stars;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int giftCoins;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailCallsInner &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.type == type &&
    other.status == status &&
    other.language == language &&
    other.direction == direction &&
    other.other == other &&
    other.seconds == seconds &&
    other.minutes == minutes &&
    other.coins == coins &&
    other.paise == paise &&
    other.endReason == endReason &&
    other.stars == stars &&
    other.giftCoins == giftCoins;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (status.hashCode) +
    (language.hashCode) +
    (direction.hashCode) +
    (other.hashCode) +
    (seconds == null ? 0 : seconds!.hashCode) +
    (minutes.hashCode) +
    (coins.hashCode) +
    (paise.hashCode) +
    (endReason == null ? 0 : endReason!.hashCode) +
    (stars == null ? 0 : stars!.hashCode) +
    (giftCoins.hashCode);

  @override
  String toString() => 'AdminUserDetailCallsInner[id=$id, createdAt=$createdAt, type=$type, status=$status, language=$language, direction=$direction, other=$other, seconds=$seconds, minutes=$minutes, coins=$coins, paise=$paise, endReason=$endReason, stars=$stars, giftCoins=$giftCoins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
      json[r'status'] = this.status;
      json[r'language'] = this.language;
      json[r'direction'] = this.direction;
      json[r'other'] = this.other;
    if (this.seconds != null) {
      json[r'seconds'] = this.seconds;
    } else {
      json[r'seconds'] = null;
    }
      json[r'minutes'] = this.minutes;
      json[r'coins'] = this.coins;
      json[r'paise'] = this.paise;
    if (this.endReason != null) {
      json[r'endReason'] = this.endReason;
    } else {
      json[r'endReason'] = null;
    }
    if (this.stars != null) {
      json[r'stars'] = this.stars;
    } else {
      json[r'stars'] = null;
    }
      json[r'giftCoins'] = this.giftCoins;
    return json;
  }

  /// Returns a new [AdminUserDetailCallsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailCallsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailCallsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailCallsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailCallsInner[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminUserDetailCallsInner[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminUserDetailCallsInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminUserDetailCallsInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailCallsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailCallsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminUserDetailCallsInner[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminUserDetailCallsInner[language]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "AdminUserDetailCallsInner[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "AdminUserDetailCallsInner[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "AdminUserDetailCallsInner[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "AdminUserDetailCallsInner[other]" has a null value in JSON.');
        assert(json.containsKey(r'seconds'), 'Required key "AdminUserDetailCallsInner[seconds]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminUserDetailCallsInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminUserDetailCallsInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetailCallsInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetailCallsInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "AdminUserDetailCallsInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "AdminUserDetailCallsInner[paise]" has a null value in JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminUserDetailCallsInner[endReason]" is missing from JSON.');
        assert(json.containsKey(r'stars'), 'Required key "AdminUserDetailCallsInner[stars]" is missing from JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminUserDetailCallsInner[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminUserDetailCallsInner[giftCoins]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailCallsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        type: AdminUserDetailCallsInnerTypeEnum.fromJson(json[r'type'])!,
        status: mapValueOfType<String>(json, r'status')!,
        language: mapValueOfType<String>(json, r'language')!,
        direction: AdminUserDetailCallsInnerDirectionEnum.fromJson(json[r'direction'])!,
        other: AdminRefundCompanion.fromJson(json[r'other'])!,
        seconds: mapValueOfType<int>(json, r'seconds'),
        minutes: mapValueOfType<int>(json, r'minutes')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        paise: mapValueOfType<int>(json, r'paise')!,
        endReason: mapValueOfType<String>(json, r'endReason'),
        stars: mapValueOfType<int>(json, r'stars'),
        giftCoins: mapValueOfType<int>(json, r'giftCoins')!,
      );
    }
    return null;
  }

  static List<AdminUserDetailCallsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailCallsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailCallsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailCallsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailCallsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailCallsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailCallsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailCallsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailCallsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailCallsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'type',
    'status',
    'language',
    'direction',
    'other',
    'seconds',
    'minutes',
    'coins',
    'paise',
    'endReason',
    'stars',
    'giftCoins',
  };
}


enum AdminUserDetailCallsInnerTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailCallsInnerTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailCallsInnerTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailCallsInnerTypeEnum? fromJson(dynamic value) => AdminUserDetailCallsInnerTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailCallsInnerTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailCallsInnerTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailCallsInnerTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailCallsInnerTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailCallsInnerTypeEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailCallsInnerTypeEnum].
class AdminUserDetailCallsInnerTypeEnumTypeTransformer {
  factory AdminUserDetailCallsInnerTypeEnumTypeTransformer() => _instance ??= const AdminUserDetailCallsInnerTypeEnumTypeTransformer._();

  const AdminUserDetailCallsInnerTypeEnumTypeTransformer._();

  String encode(AdminUserDetailCallsInnerTypeEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailCallsInnerTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailCallsInnerTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailCallsInnerTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminUserDetailCallsInnerTypeEnum.audio;
        case r'video': return AdminUserDetailCallsInnerTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailCallsInnerTypeEnumTypeTransformer? _instance;
}



enum AdminUserDetailCallsInnerDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailCallsInnerDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailCallsInnerDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailCallsInnerDirectionEnum? fromJson(dynamic value) => AdminUserDetailCallsInnerDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailCallsInnerDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailCallsInnerDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailCallsInnerDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailCallsInnerDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailCallsInnerDirectionEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailCallsInnerDirectionEnum].
class AdminUserDetailCallsInnerDirectionEnumTypeTransformer {
  factory AdminUserDetailCallsInnerDirectionEnumTypeTransformer() => _instance ??= const AdminUserDetailCallsInnerDirectionEnumTypeTransformer._();

  const AdminUserDetailCallsInnerDirectionEnumTypeTransformer._();

  String encode(AdminUserDetailCallsInnerDirectionEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailCallsInnerDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailCallsInnerDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailCallsInnerDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return AdminUserDetailCallsInnerDirectionEnum.outgoing;
        case r'incoming': return AdminUserDetailCallsInnerDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailCallsInnerDirectionEnumTypeTransformer? _instance;
}


