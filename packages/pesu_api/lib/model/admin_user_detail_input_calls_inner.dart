//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminUserDetailInputCallsInner {
  /// Returns a new [AdminUserDetailInputCallsInner] instance.
  AdminUserDetailInputCallsInner({
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

  Object? createdAt;

  AdminUserDetailInputCallsInnerTypeEnum type;

  String status;

  String language;

  AdminUserDetailInputCallsInnerDirectionEnum direction;

  AdminRefundInputCompanion other;

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
  bool operator ==(Object other) => identical(this, other) || other is AdminUserDetailInputCallsInner &&
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
    (createdAt == null ? 0 : createdAt!.hashCode) +
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
  String toString() => 'AdminUserDetailInputCallsInner[id=$id, createdAt=$createdAt, type=$type, status=$status, language=$language, direction=$direction, other=$other, seconds=$seconds, minutes=$minutes, coins=$coins, paise=$paise, endReason=$endReason, stars=$stars, giftCoins=$giftCoins]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
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

  /// Returns a new [AdminUserDetailInputCallsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminUserDetailInputCallsInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminUserDetailInputCallsInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminUserDetailInputCallsInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminUserDetailInputCallsInner[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'type'), 'Required key "AdminUserDetailInputCallsInner[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "AdminUserDetailInputCallsInner[type]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminUserDetailInputCallsInner[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminUserDetailInputCallsInner[status]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "AdminUserDetailInputCallsInner[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "AdminUserDetailInputCallsInner[language]" has a null value in JSON.');
        assert(json.containsKey(r'direction'), 'Required key "AdminUserDetailInputCallsInner[direction]" is missing from JSON.');
        assert(json[r'direction'] != null, 'Required key "AdminUserDetailInputCallsInner[direction]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "AdminUserDetailInputCallsInner[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "AdminUserDetailInputCallsInner[other]" has a null value in JSON.');
        assert(json.containsKey(r'seconds'), 'Required key "AdminUserDetailInputCallsInner[seconds]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "AdminUserDetailInputCallsInner[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "AdminUserDetailInputCallsInner[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "AdminUserDetailInputCallsInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "AdminUserDetailInputCallsInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "AdminUserDetailInputCallsInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "AdminUserDetailInputCallsInner[paise]" has a null value in JSON.');
        assert(json.containsKey(r'endReason'), 'Required key "AdminUserDetailInputCallsInner[endReason]" is missing from JSON.');
        assert(json.containsKey(r'stars'), 'Required key "AdminUserDetailInputCallsInner[stars]" is missing from JSON.');
        assert(json.containsKey(r'giftCoins'), 'Required key "AdminUserDetailInputCallsInner[giftCoins]" is missing from JSON.');
        assert(json[r'giftCoins'] != null, 'Required key "AdminUserDetailInputCallsInner[giftCoins]" has a null value in JSON.');
        return true;
      }());

      return AdminUserDetailInputCallsInner(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        type: AdminUserDetailInputCallsInnerTypeEnum.fromJson(json[r'type'])!,
        status: mapValueOfType<String>(json, r'status')!,
        language: mapValueOfType<String>(json, r'language')!,
        direction: AdminUserDetailInputCallsInnerDirectionEnum.fromJson(json[r'direction'])!,
        other: AdminRefundInputCompanion.fromJson(json[r'other'])!,
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

  static List<AdminUserDetailInputCallsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputCallsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputCallsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminUserDetailInputCallsInner> mapFromJson(dynamic json) {
    final map = <String, AdminUserDetailInputCallsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminUserDetailInputCallsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminUserDetailInputCallsInner-objects as value to a dart map
  static Map<String, List<AdminUserDetailInputCallsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminUserDetailInputCallsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminUserDetailInputCallsInner.listFromJson(entry.value, growable: growable,);
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


enum AdminUserDetailInputCallsInnerTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputCallsInnerTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputCallsInnerTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputCallsInnerTypeEnum? fromJson(dynamic value) => AdminUserDetailInputCallsInnerTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputCallsInnerTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputCallsInnerTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputCallsInnerTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputCallsInnerTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputCallsInnerTypeEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputCallsInnerTypeEnum].
class AdminUserDetailInputCallsInnerTypeEnumTypeTransformer {
  factory AdminUserDetailInputCallsInnerTypeEnumTypeTransformer() => _instance ??= const AdminUserDetailInputCallsInnerTypeEnumTypeTransformer._();

  const AdminUserDetailInputCallsInnerTypeEnumTypeTransformer._();

  String encode(AdminUserDetailInputCallsInnerTypeEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputCallsInnerTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputCallsInnerTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputCallsInnerTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return AdminUserDetailInputCallsInnerTypeEnum.audio;
        case r'video': return AdminUserDetailInputCallsInnerTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputCallsInnerTypeEnumTypeTransformer? _instance;
}



enum AdminUserDetailInputCallsInnerDirectionEnum {
  outgoing._(r'outgoing'),
  incoming._(r'incoming'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminUserDetailInputCallsInnerDirectionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminUserDetailInputCallsInnerDirectionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminUserDetailInputCallsInnerDirectionEnum? fromJson(dynamic value) => AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminUserDetailInputCallsInnerDirectionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminUserDetailInputCallsInnerDirectionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminUserDetailInputCallsInnerDirectionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminUserDetailInputCallsInnerDirectionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminUserDetailInputCallsInnerDirectionEnum] to String,
/// and [decode] dynamic data back to [AdminUserDetailInputCallsInnerDirectionEnum].
class AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer {
  factory AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer() => _instance ??= const AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer._();

  const AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer._();

  String encode(AdminUserDetailInputCallsInnerDirectionEnum data) => data._value;

  /// Returns the instance of [AdminUserDetailInputCallsInnerDirectionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminUserDetailInputCallsInnerDirectionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminUserDetailInputCallsInnerDirectionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'outgoing': return AdminUserDetailInputCallsInnerDirectionEnum.outgoing;
        case r'incoming': return AdminUserDetailInputCallsInnerDirectionEnum.incoming;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminUserDetailInputCallsInnerDirectionEnumTypeTransformer? _instance;
}


