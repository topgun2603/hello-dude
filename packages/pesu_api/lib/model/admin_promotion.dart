//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminPromotion {
  /// Returns a new [AdminPromotion] instance.
  AdminPromotion({
    required this.id,
    required this.title,
    required this.body,
    required this.highlight,
    required this.badge,
    required this.emoji,
    required this.ctaLabel,
    required this.ctaAction,
    required this.theme,
    required this.confetti,
    required this.endsAt,
    required this.audience,
    required this.frequency,
    required this.priority,
    required this.isActive,
    required this.startsAt,
    required this.status,
    required this.shown,
    required this.clicked,
    required this.shownToday,
    required this.clickedToday,
    required this.reach,
    required this.createdAt,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String title;

  String body;

  String? highlight;

  String? badge;

  String? emoji;

  String ctaLabel;

  /// Where the button goes inside the app
  AdminPromotionCtaActionEnum ctaAction;

  AdminPromotionThemeEnum theme;

  bool confetti;

  /// Show a countdown when set
  DateTime? endsAt;

  /// never_paid / paid = callers with no / at least one credited coin purchase
  AdminPromotionAudienceEnum audience;

  /// every_open = each time the app opens; daily = once per IST day; once = only ever once
  AdminPromotionFrequencyEnum frequency;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int priority;

  bool isActive;

  DateTime startsAt;

  AdminPromotionStatusEnum status;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int shown;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int clicked;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int shownToday;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int clickedToday;

  /// Different people who saw it
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int reach;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPromotion &&
    other.id == id &&
    other.title == title &&
    other.body == body &&
    other.highlight == highlight &&
    other.badge == badge &&
    other.emoji == emoji &&
    other.ctaLabel == ctaLabel &&
    other.ctaAction == ctaAction &&
    other.theme == theme &&
    other.confetti == confetti &&
    other.endsAt == endsAt &&
    other.audience == audience &&
    other.frequency == frequency &&
    other.priority == priority &&
    other.isActive == isActive &&
    other.startsAt == startsAt &&
    other.status == status &&
    other.shown == shown &&
    other.clicked == clicked &&
    other.shownToday == shownToday &&
    other.clickedToday == clickedToday &&
    other.reach == reach &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (highlight == null ? 0 : highlight!.hashCode) +
    (badge == null ? 0 : badge!.hashCode) +
    (emoji == null ? 0 : emoji!.hashCode) +
    (ctaLabel.hashCode) +
    (ctaAction.hashCode) +
    (theme.hashCode) +
    (confetti.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (audience.hashCode) +
    (frequency.hashCode) +
    (priority.hashCode) +
    (isActive.hashCode) +
    (startsAt.hashCode) +
    (status.hashCode) +
    (shown.hashCode) +
    (clicked.hashCode) +
    (shownToday.hashCode) +
    (clickedToday.hashCode) +
    (reach.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'AdminPromotion[id=$id, title=$title, body=$body, highlight=$highlight, badge=$badge, emoji=$emoji, ctaLabel=$ctaLabel, ctaAction=$ctaAction, theme=$theme, confetti=$confetti, endsAt=$endsAt, audience=$audience, frequency=$frequency, priority=$priority, isActive=$isActive, startsAt=$startsAt, status=$status, shown=$shown, clicked=$clicked, shownToday=$shownToday, clickedToday=$clickedToday, reach=$reach, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'confetti'] = this.confetti;
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt!.toUtc().toIso8601String();
    } else {
      json[r'endsAt'] = null;
    }
      json[r'audience'] = this.audience;
      json[r'frequency'] = this.frequency;
      json[r'priority'] = this.priority;
      json[r'isActive'] = this.isActive;
      json[r'startsAt'] = this.startsAt.toUtc().toIso8601String();
      json[r'status'] = this.status;
      json[r'shown'] = this.shown;
      json[r'clicked'] = this.clicked;
      json[r'shownToday'] = this.shownToday;
      json[r'clickedToday'] = this.clickedToday;
      json[r'reach'] = this.reach;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AdminPromotion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPromotion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminPromotion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminPromotion[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminPromotion[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminPromotion[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AdminPromotion[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminPromotion[body]" has a null value in JSON.');
        assert(json.containsKey(r'highlight'), 'Required key "AdminPromotion[highlight]" is missing from JSON.');
        assert(json.containsKey(r'badge'), 'Required key "AdminPromotion[badge]" is missing from JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "AdminPromotion[emoji]" is missing from JSON.');
        assert(json.containsKey(r'ctaLabel'), 'Required key "AdminPromotion[ctaLabel]" is missing from JSON.');
        assert(json[r'ctaLabel'] != null, 'Required key "AdminPromotion[ctaLabel]" has a null value in JSON.');
        assert(json.containsKey(r'ctaAction'), 'Required key "AdminPromotion[ctaAction]" is missing from JSON.');
        assert(json[r'ctaAction'] != null, 'Required key "AdminPromotion[ctaAction]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminPromotion[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminPromotion[theme]" has a null value in JSON.');
        assert(json.containsKey(r'confetti'), 'Required key "AdminPromotion[confetti]" is missing from JSON.');
        assert(json[r'confetti'] != null, 'Required key "AdminPromotion[confetti]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AdminPromotion[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'audience'), 'Required key "AdminPromotion[audience]" is missing from JSON.');
        assert(json[r'audience'] != null, 'Required key "AdminPromotion[audience]" has a null value in JSON.');
        assert(json.containsKey(r'frequency'), 'Required key "AdminPromotion[frequency]" is missing from JSON.');
        assert(json[r'frequency'] != null, 'Required key "AdminPromotion[frequency]" has a null value in JSON.');
        assert(json.containsKey(r'priority'), 'Required key "AdminPromotion[priority]" is missing from JSON.');
        assert(json[r'priority'] != null, 'Required key "AdminPromotion[priority]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminPromotion[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminPromotion[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminPromotion[startsAt]" is missing from JSON.');
        assert(json[r'startsAt'] != null, 'Required key "AdminPromotion[startsAt]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminPromotion[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminPromotion[status]" has a null value in JSON.');
        assert(json.containsKey(r'shown'), 'Required key "AdminPromotion[shown]" is missing from JSON.');
        assert(json[r'shown'] != null, 'Required key "AdminPromotion[shown]" has a null value in JSON.');
        assert(json.containsKey(r'clicked'), 'Required key "AdminPromotion[clicked]" is missing from JSON.');
        assert(json[r'clicked'] != null, 'Required key "AdminPromotion[clicked]" has a null value in JSON.');
        assert(json.containsKey(r'shownToday'), 'Required key "AdminPromotion[shownToday]" is missing from JSON.');
        assert(json[r'shownToday'] != null, 'Required key "AdminPromotion[shownToday]" has a null value in JSON.');
        assert(json.containsKey(r'clickedToday'), 'Required key "AdminPromotion[clickedToday]" is missing from JSON.');
        assert(json[r'clickedToday'] != null, 'Required key "AdminPromotion[clickedToday]" has a null value in JSON.');
        assert(json.containsKey(r'reach'), 'Required key "AdminPromotion[reach]" is missing from JSON.');
        assert(json[r'reach'] != null, 'Required key "AdminPromotion[reach]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminPromotion[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminPromotion[createdAt]" has a null value in JSON.');
        return true;
      }());

      return AdminPromotion(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        highlight: mapValueOfType<String>(json, r'highlight'),
        badge: mapValueOfType<String>(json, r'badge'),
        emoji: mapValueOfType<String>(json, r'emoji'),
        ctaLabel: mapValueOfType<String>(json, r'ctaLabel')!,
        ctaAction: AdminPromotionCtaActionEnum.fromJson(json[r'ctaAction'])!,
        theme: AdminPromotionThemeEnum.fromJson(json[r'theme'])!,
        confetti: mapValueOfType<bool>(json, r'confetti')!,
        endsAt: mapDateTime(json, r'endsAt', r''),
        audience: AdminPromotionAudienceEnum.fromJson(json[r'audience'])!,
        frequency: AdminPromotionFrequencyEnum.fromJson(json[r'frequency'])!,
        priority: mapValueOfType<int>(json, r'priority')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        startsAt: mapDateTime(json, r'startsAt', r'')!,
        status: AdminPromotionStatusEnum.fromJson(json[r'status'])!,
        shown: mapValueOfType<int>(json, r'shown')!,
        clicked: mapValueOfType<int>(json, r'clicked')!,
        shownToday: mapValueOfType<int>(json, r'shownToday')!,
        clickedToday: mapValueOfType<int>(json, r'clickedToday')!,
        reach: mapValueOfType<int>(json, r'reach')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<AdminPromotion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPromotion> mapFromJson(dynamic json) {
    final map = <String, AdminPromotion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPromotion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPromotion-objects as value to a dart map
  static Map<String, List<AdminPromotion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPromotion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPromotion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'body',
    'highlight',
    'badge',
    'emoji',
    'ctaLabel',
    'ctaAction',
    'theme',
    'confetti',
    'endsAt',
    'audience',
    'frequency',
    'priority',
    'isActive',
    'startsAt',
    'status',
    'shown',
    'clicked',
    'shownToday',
    'clickedToday',
    'reach',
    'createdAt',
  };
}

/// Where the button goes inside the app
enum AdminPromotionCtaActionEnum {
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
  const AdminPromotionCtaActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionCtaActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionCtaActionEnum? fromJson(dynamic value) => AdminPromotionCtaActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionCtaActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionCtaActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionCtaActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionCtaActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionCtaActionEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionCtaActionEnum].
class AdminPromotionCtaActionEnumTypeTransformer {
  factory AdminPromotionCtaActionEnumTypeTransformer() => _instance ??= const AdminPromotionCtaActionEnumTypeTransformer._();

  const AdminPromotionCtaActionEnumTypeTransformer._();

  String encode(AdminPromotionCtaActionEnum data) => data._value;

  /// Returns the instance of [AdminPromotionCtaActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionCtaActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionCtaActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'wallet': return AdminPromotionCtaActionEnum.wallet;
        case r'vip': return AdminPromotionCtaActionEnum.vip;
        case r'checkin': return AdminPromotionCtaActionEnum.checkin;
        case r'referral': return AdminPromotionCtaActionEnum.referral;
        case r'online': return AdminPromotionCtaActionEnum.online;
        case r'rooms': return AdminPromotionCtaActionEnum.rooms;
        case r'rewards': return AdminPromotionCtaActionEnum.rewards;
        case r'none': return AdminPromotionCtaActionEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionCtaActionEnumTypeTransformer? _instance;
}



enum AdminPromotionThemeEnum {
  brand._(r'brand'),
  gold._(r'gold'),
  green._(r'green'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionThemeEnum? fromJson(dynamic value) => AdminPromotionThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionThemeEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionThemeEnum].
class AdminPromotionThemeEnumTypeTransformer {
  factory AdminPromotionThemeEnumTypeTransformer() => _instance ??= const AdminPromotionThemeEnumTypeTransformer._();

  const AdminPromotionThemeEnumTypeTransformer._();

  String encode(AdminPromotionThemeEnum data) => data._value;

  /// Returns the instance of [AdminPromotionThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'brand': return AdminPromotionThemeEnum.brand;
        case r'gold': return AdminPromotionThemeEnum.gold;
        case r'green': return AdminPromotionThemeEnum.green;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionThemeEnumTypeTransformer? _instance;
}


/// never_paid / paid = callers with no / at least one credited coin purchase
enum AdminPromotionAudienceEnum {
  all._(r'all'),
  callers._(r'callers'),
  companions._(r'companions'),
  neverPaid._(r'never_paid'),
  paid._(r'paid'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionAudienceEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionAudienceEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionAudienceEnum? fromJson(dynamic value) => AdminPromotionAudienceEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionAudienceEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionAudienceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionAudienceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionAudienceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionAudienceEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionAudienceEnum].
class AdminPromotionAudienceEnumTypeTransformer {
  factory AdminPromotionAudienceEnumTypeTransformer() => _instance ??= const AdminPromotionAudienceEnumTypeTransformer._();

  const AdminPromotionAudienceEnumTypeTransformer._();

  String encode(AdminPromotionAudienceEnum data) => data._value;

  /// Returns the instance of [AdminPromotionAudienceEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionAudienceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionAudienceEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'all': return AdminPromotionAudienceEnum.all;
        case r'callers': return AdminPromotionAudienceEnum.callers;
        case r'companions': return AdminPromotionAudienceEnum.companions;
        case r'never_paid': return AdminPromotionAudienceEnum.neverPaid;
        case r'paid': return AdminPromotionAudienceEnum.paid;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionAudienceEnumTypeTransformer? _instance;
}


/// every_open = each time the app opens; daily = once per IST day; once = only ever once
enum AdminPromotionFrequencyEnum {
  everyOpen._(r'every_open'),
  daily._(r'daily'),
  once._(r'once'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionFrequencyEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionFrequencyEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionFrequencyEnum? fromJson(dynamic value) => AdminPromotionFrequencyEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionFrequencyEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionFrequencyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionFrequencyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionFrequencyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionFrequencyEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionFrequencyEnum].
class AdminPromotionFrequencyEnumTypeTransformer {
  factory AdminPromotionFrequencyEnumTypeTransformer() => _instance ??= const AdminPromotionFrequencyEnumTypeTransformer._();

  const AdminPromotionFrequencyEnumTypeTransformer._();

  String encode(AdminPromotionFrequencyEnum data) => data._value;

  /// Returns the instance of [AdminPromotionFrequencyEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionFrequencyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionFrequencyEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'every_open': return AdminPromotionFrequencyEnum.everyOpen;
        case r'daily': return AdminPromotionFrequencyEnum.daily;
        case r'once': return AdminPromotionFrequencyEnum.once;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionFrequencyEnumTypeTransformer? _instance;
}



enum AdminPromotionStatusEnum {
  live._(r'live'),
  scheduled._(r'scheduled'),
  ended._(r'ended'),
  off._(r'off'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionStatusEnum? fromJson(dynamic value) => AdminPromotionStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionStatusEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionStatusEnum].
class AdminPromotionStatusEnumTypeTransformer {
  factory AdminPromotionStatusEnumTypeTransformer() => _instance ??= const AdminPromotionStatusEnumTypeTransformer._();

  const AdminPromotionStatusEnumTypeTransformer._();

  String encode(AdminPromotionStatusEnum data) => data._value;

  /// Returns the instance of [AdminPromotionStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return AdminPromotionStatusEnum.live;
        case r'scheduled': return AdminPromotionStatusEnum.scheduled;
        case r'ended': return AdminPromotionStatusEnum.ended;
        case r'off': return AdminPromotionStatusEnum.off;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionStatusEnumTypeTransformer? _instance;
}


