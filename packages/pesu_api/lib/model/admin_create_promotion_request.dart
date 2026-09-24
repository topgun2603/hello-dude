//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminCreatePromotionRequest {
  /// Returns a new [AdminCreatePromotionRequest] instance.
  AdminCreatePromotionRequest({
    required this.title,
    this.body = '',
    this.highlight,
    this.badge,
    this.emoji,
    required this.ctaLabel,
    required this.ctaAction,
    required this.theme,
    required this.audience,
    required this.frequency,
    required this.confetti,
    required this.priority,
    required this.isActive,
    required this.startsAt,
    this.endsAt,
  });

  String title;

  String body;

  String? highlight;

  String? badge;

  String? emoji;

  String ctaLabel;

  /// Where the button goes inside the app
  AdminCreatePromotionRequestCtaActionEnum ctaAction;

  AdminCreatePromotionRequestThemeEnum theme;

  /// never_paid / paid = callers with no / at least one credited coin purchase
  AdminCreatePromotionRequestAudienceEnum audience;

  /// every_open = each time the app opens; daily = once per IST day; once = only ever once
  AdminCreatePromotionRequestFrequencyEnum frequency;

  bool confetti;

  /// Minimum value: 0
  /// Maximum value: 1000
  int priority;

  bool isActive;

  Object? startsAt;

  Object? endsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCreatePromotionRequest &&
    other.title == title &&
    other.body == body &&
    other.highlight == highlight &&
    other.badge == badge &&
    other.emoji == emoji &&
    other.ctaLabel == ctaLabel &&
    other.ctaAction == ctaAction &&
    other.theme == theme &&
    other.audience == audience &&
    other.frequency == frequency &&
    other.confetti == confetti &&
    other.priority == priority &&
    other.isActive == isActive &&
    other.startsAt == startsAt &&
    other.endsAt == endsAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (body.hashCode) +
    (highlight == null ? 0 : highlight!.hashCode) +
    (badge == null ? 0 : badge!.hashCode) +
    (emoji == null ? 0 : emoji!.hashCode) +
    (ctaLabel.hashCode) +
    (ctaAction.hashCode) +
    (theme.hashCode) +
    (audience.hashCode) +
    (frequency.hashCode) +
    (confetti.hashCode) +
    (priority.hashCode) +
    (isActive.hashCode) +
    (startsAt == null ? 0 : startsAt!.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode);

  @override
  String toString() => 'AdminCreatePromotionRequest[title=$title, body=$body, highlight=$highlight, badge=$badge, emoji=$emoji, ctaLabel=$ctaLabel, ctaAction=$ctaAction, theme=$theme, audience=$audience, frequency=$frequency, confetti=$confetti, priority=$priority, isActive=$isActive, startsAt=$startsAt, endsAt=$endsAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'body'] = this.body;
    if (this.highlight != null) {
      json[r'highlight'] = this.highlight;
    } else {
      json[r'highlight'] = null;
    }
    if (this.badge != null) {
      json[r'badge'] = this.badge;
    } else {
      json[r'badge'] = null;
    }
    if (this.emoji != null) {
      json[r'emoji'] = this.emoji;
    } else {
      json[r'emoji'] = null;
    }
      json[r'ctaLabel'] = this.ctaLabel;
      json[r'ctaAction'] = this.ctaAction;
      json[r'theme'] = this.theme;
      json[r'audience'] = this.audience;
      json[r'frequency'] = this.frequency;
      json[r'confetti'] = this.confetti;
      json[r'priority'] = this.priority;
      json[r'isActive'] = this.isActive;
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
    return json;
  }

  /// Returns a new [AdminCreatePromotionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCreatePromotionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'title'), 'Required key "AdminCreatePromotionRequest[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminCreatePromotionRequest[title]" has a null value in JSON.');
        assert(json.containsKey(r'ctaLabel'), 'Required key "AdminCreatePromotionRequest[ctaLabel]" is missing from JSON.');
        assert(json[r'ctaLabel'] != null, 'Required key "AdminCreatePromotionRequest[ctaLabel]" has a null value in JSON.');
        assert(json.containsKey(r'ctaAction'), 'Required key "AdminCreatePromotionRequest[ctaAction]" is missing from JSON.');
        assert(json[r'ctaAction'] != null, 'Required key "AdminCreatePromotionRequest[ctaAction]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminCreatePromotionRequest[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminCreatePromotionRequest[theme]" has a null value in JSON.');
        assert(json.containsKey(r'audience'), 'Required key "AdminCreatePromotionRequest[audience]" is missing from JSON.');
        assert(json[r'audience'] != null, 'Required key "AdminCreatePromotionRequest[audience]" has a null value in JSON.');
        assert(json.containsKey(r'frequency'), 'Required key "AdminCreatePromotionRequest[frequency]" is missing from JSON.');
        assert(json[r'frequency'] != null, 'Required key "AdminCreatePromotionRequest[frequency]" has a null value in JSON.');
        assert(json.containsKey(r'confetti'), 'Required key "AdminCreatePromotionRequest[confetti]" is missing from JSON.');
        assert(json[r'confetti'] != null, 'Required key "AdminCreatePromotionRequest[confetti]" has a null value in JSON.');
        assert(json.containsKey(r'priority'), 'Required key "AdminCreatePromotionRequest[priority]" is missing from JSON.');
        assert(json[r'priority'] != null, 'Required key "AdminCreatePromotionRequest[priority]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminCreatePromotionRequest[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminCreatePromotionRequest[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminCreatePromotionRequest[startsAt]" is missing from JSON.');
        return true;
      }());

      return AdminCreatePromotionRequest(
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body') ?? '',
        highlight: mapValueOfType<String>(json, r'highlight'),
        badge: mapValueOfType<String>(json, r'badge'),
        emoji: mapValueOfType<String>(json, r'emoji'),
        ctaLabel: mapValueOfType<String>(json, r'ctaLabel')!,
        ctaAction: AdminCreatePromotionRequestCtaActionEnum.fromJson(json[r'ctaAction'])!,
        theme: AdminCreatePromotionRequestThemeEnum.fromJson(json[r'theme'])!,
        audience: AdminCreatePromotionRequestAudienceEnum.fromJson(json[r'audience'])!,
        frequency: AdminCreatePromotionRequestFrequencyEnum.fromJson(json[r'frequency'])!,
        confetti: mapValueOfType<bool>(json, r'confetti')!,
        priority: mapValueOfType<int>(json, r'priority')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        startsAt: mapValueOfType<Object>(json, r'startsAt'),
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
      );
    }
    return null;
  }

  static List<AdminCreatePromotionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePromotionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePromotionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCreatePromotionRequest> mapFromJson(dynamic json) {
    final map = <String, AdminCreatePromotionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCreatePromotionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCreatePromotionRequest-objects as value to a dart map
  static Map<String, List<AdminCreatePromotionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCreatePromotionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCreatePromotionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'ctaLabel',
    'ctaAction',
    'theme',
    'audience',
    'frequency',
    'confetti',
    'priority',
    'isActive',
    'startsAt',
  };
}

/// Where the button goes inside the app
enum AdminCreatePromotionRequestCtaActionEnum {
  wallet._(r'wallet'),
  vip._(r'vip'),
  checkin._(r'checkin'),
  referral._(r'referral'),
  online._(r'online'),
  rooms._(r'rooms'),
  rewards._(r'rewards'),
  none._(r'none'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreatePromotionRequestCtaActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreatePromotionRequestCtaActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreatePromotionRequestCtaActionEnum? fromJson(dynamic value) => AdminCreatePromotionRequestCtaActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreatePromotionRequestCtaActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreatePromotionRequestCtaActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePromotionRequestCtaActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePromotionRequestCtaActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreatePromotionRequestCtaActionEnum] to String,
/// and [decode] dynamic data back to [AdminCreatePromotionRequestCtaActionEnum].
class AdminCreatePromotionRequestCtaActionEnumTypeTransformer {
  factory AdminCreatePromotionRequestCtaActionEnumTypeTransformer() => _instance ??= const AdminCreatePromotionRequestCtaActionEnumTypeTransformer._();

  const AdminCreatePromotionRequestCtaActionEnumTypeTransformer._();

  String encode(AdminCreatePromotionRequestCtaActionEnum data) => data._value;

  /// Returns the instance of [AdminCreatePromotionRequestCtaActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreatePromotionRequestCtaActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreatePromotionRequestCtaActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'wallet': return AdminCreatePromotionRequestCtaActionEnum.wallet;
        case r'vip': return AdminCreatePromotionRequestCtaActionEnum.vip;
        case r'checkin': return AdminCreatePromotionRequestCtaActionEnum.checkin;
        case r'referral': return AdminCreatePromotionRequestCtaActionEnum.referral;
        case r'online': return AdminCreatePromotionRequestCtaActionEnum.online;
        case r'rooms': return AdminCreatePromotionRequestCtaActionEnum.rooms;
        case r'rewards': return AdminCreatePromotionRequestCtaActionEnum.rewards;
        case r'none': return AdminCreatePromotionRequestCtaActionEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreatePromotionRequestCtaActionEnumTypeTransformer? _instance;
}



enum AdminCreatePromotionRequestThemeEnum {
  brand._(r'brand'),
  gold._(r'gold'),
  green._(r'green'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreatePromotionRequestThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreatePromotionRequestThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreatePromotionRequestThemeEnum? fromJson(dynamic value) => AdminCreatePromotionRequestThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreatePromotionRequestThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreatePromotionRequestThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePromotionRequestThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePromotionRequestThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreatePromotionRequestThemeEnum] to String,
/// and [decode] dynamic data back to [AdminCreatePromotionRequestThemeEnum].
class AdminCreatePromotionRequestThemeEnumTypeTransformer {
  factory AdminCreatePromotionRequestThemeEnumTypeTransformer() => _instance ??= const AdminCreatePromotionRequestThemeEnumTypeTransformer._();

  const AdminCreatePromotionRequestThemeEnumTypeTransformer._();

  String encode(AdminCreatePromotionRequestThemeEnum data) => data._value;

  /// Returns the instance of [AdminCreatePromotionRequestThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreatePromotionRequestThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreatePromotionRequestThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'brand': return AdminCreatePromotionRequestThemeEnum.brand;
        case r'gold': return AdminCreatePromotionRequestThemeEnum.gold;
        case r'green': return AdminCreatePromotionRequestThemeEnum.green;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreatePromotionRequestThemeEnumTypeTransformer? _instance;
}


/// never_paid / paid = callers with no / at least one credited coin purchase
enum AdminCreatePromotionRequestAudienceEnum {
  all._(r'all'),
  callers._(r'callers'),
  companions._(r'companions'),
  neverPaid._(r'never_paid'),
  paid._(r'paid'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreatePromotionRequestAudienceEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreatePromotionRequestAudienceEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreatePromotionRequestAudienceEnum? fromJson(dynamic value) => AdminCreatePromotionRequestAudienceEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreatePromotionRequestAudienceEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreatePromotionRequestAudienceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePromotionRequestAudienceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePromotionRequestAudienceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreatePromotionRequestAudienceEnum] to String,
/// and [decode] dynamic data back to [AdminCreatePromotionRequestAudienceEnum].
class AdminCreatePromotionRequestAudienceEnumTypeTransformer {
  factory AdminCreatePromotionRequestAudienceEnumTypeTransformer() => _instance ??= const AdminCreatePromotionRequestAudienceEnumTypeTransformer._();

  const AdminCreatePromotionRequestAudienceEnumTypeTransformer._();

  String encode(AdminCreatePromotionRequestAudienceEnum data) => data._value;

  /// Returns the instance of [AdminCreatePromotionRequestAudienceEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreatePromotionRequestAudienceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreatePromotionRequestAudienceEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'all': return AdminCreatePromotionRequestAudienceEnum.all;
        case r'callers': return AdminCreatePromotionRequestAudienceEnum.callers;
        case r'companions': return AdminCreatePromotionRequestAudienceEnum.companions;
        case r'never_paid': return AdminCreatePromotionRequestAudienceEnum.neverPaid;
        case r'paid': return AdminCreatePromotionRequestAudienceEnum.paid;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreatePromotionRequestAudienceEnumTypeTransformer? _instance;
}


/// every_open = each time the app opens; daily = once per IST day; once = only ever once
enum AdminCreatePromotionRequestFrequencyEnum {
  everyOpen._(r'every_open'),
  daily._(r'daily'),
  once._(r'once'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminCreatePromotionRequestFrequencyEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminCreatePromotionRequestFrequencyEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminCreatePromotionRequestFrequencyEnum? fromJson(dynamic value) => AdminCreatePromotionRequestFrequencyEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminCreatePromotionRequestFrequencyEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminCreatePromotionRequestFrequencyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCreatePromotionRequestFrequencyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCreatePromotionRequestFrequencyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminCreatePromotionRequestFrequencyEnum] to String,
/// and [decode] dynamic data back to [AdminCreatePromotionRequestFrequencyEnum].
class AdminCreatePromotionRequestFrequencyEnumTypeTransformer {
  factory AdminCreatePromotionRequestFrequencyEnumTypeTransformer() => _instance ??= const AdminCreatePromotionRequestFrequencyEnumTypeTransformer._();

  const AdminCreatePromotionRequestFrequencyEnumTypeTransformer._();

  String encode(AdminCreatePromotionRequestFrequencyEnum data) => data._value;

  /// Returns the instance of [AdminCreatePromotionRequestFrequencyEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminCreatePromotionRequestFrequencyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminCreatePromotionRequestFrequencyEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'every_open': return AdminCreatePromotionRequestFrequencyEnum.everyOpen;
        case r'daily': return AdminCreatePromotionRequestFrequencyEnum.daily;
        case r'once': return AdminCreatePromotionRequestFrequencyEnum.once;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminCreatePromotionRequestFrequencyEnumTypeTransformer? _instance;
}


