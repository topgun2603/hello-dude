//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminPromotionInput {
  /// Returns a new [AdminPromotionInput] instance.
  AdminPromotionInput({
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
  AdminPromotionInputCtaActionEnum ctaAction;

  AdminPromotionInputThemeEnum theme;

  bool confetti;

  /// Show a countdown when set
  Object? endsAt;

  /// never_paid / paid = callers with no / at least one credited coin purchase
  AdminPromotionInputAudienceEnum audience;

  /// every_open = each time the app opens; daily = once per IST day; once = only ever once
  AdminPromotionInputFrequencyEnum frequency;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int priority;

  bool isActive;

  Object? startsAt;

  AdminPromotionInputStatusEnum status;

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

  Object? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPromotionInput &&
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
    (startsAt == null ? 0 : startsAt!.hashCode) +
    (status.hashCode) +
    (shown.hashCode) +
    (clicked.hashCode) +
    (shownToday.hashCode) +
    (clickedToday.hashCode) +
    (reach.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'AdminPromotionInput[id=$id, title=$title, body=$body, highlight=$highlight, badge=$badge, emoji=$emoji, ctaLabel=$ctaLabel, ctaAction=$ctaAction, theme=$theme, confetti=$confetti, endsAt=$endsAt, audience=$audience, frequency=$frequency, priority=$priority, isActive=$isActive, startsAt=$startsAt, status=$status, shown=$shown, clicked=$clicked, shownToday=$shownToday, clickedToday=$clickedToday, reach=$reach, createdAt=$createdAt]';

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
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
      json[r'audience'] = this.audience;
      json[r'frequency'] = this.frequency;
      json[r'priority'] = this.priority;
      json[r'isActive'] = this.isActive;
    if (this.startsAt != null) {
      json[r'startsAt'] = this.startsAt;
    } else {
      json[r'startsAt'] = null;
    }
      json[r'status'] = this.status;
      json[r'shown'] = this.shown;
      json[r'clicked'] = this.clicked;
      json[r'shownToday'] = this.shownToday;
      json[r'clickedToday'] = this.clickedToday;
      json[r'reach'] = this.reach;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminPromotionInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPromotionInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminPromotionInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminPromotionInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "AdminPromotionInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "AdminPromotionInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AdminPromotionInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminPromotionInput[body]" has a null value in JSON.');
        assert(json.containsKey(r'highlight'), 'Required key "AdminPromotionInput[highlight]" is missing from JSON.');
        assert(json.containsKey(r'badge'), 'Required key "AdminPromotionInput[badge]" is missing from JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "AdminPromotionInput[emoji]" is missing from JSON.');
        assert(json.containsKey(r'ctaLabel'), 'Required key "AdminPromotionInput[ctaLabel]" is missing from JSON.');
        assert(json[r'ctaLabel'] != null, 'Required key "AdminPromotionInput[ctaLabel]" has a null value in JSON.');
        assert(json.containsKey(r'ctaAction'), 'Required key "AdminPromotionInput[ctaAction]" is missing from JSON.');
        assert(json[r'ctaAction'] != null, 'Required key "AdminPromotionInput[ctaAction]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "AdminPromotionInput[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "AdminPromotionInput[theme]" has a null value in JSON.');
        assert(json.containsKey(r'confetti'), 'Required key "AdminPromotionInput[confetti]" is missing from JSON.');
        assert(json[r'confetti'] != null, 'Required key "AdminPromotionInput[confetti]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "AdminPromotionInput[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'audience'), 'Required key "AdminPromotionInput[audience]" is missing from JSON.');
        assert(json[r'audience'] != null, 'Required key "AdminPromotionInput[audience]" has a null value in JSON.');
        assert(json.containsKey(r'frequency'), 'Required key "AdminPromotionInput[frequency]" is missing from JSON.');
        assert(json[r'frequency'] != null, 'Required key "AdminPromotionInput[frequency]" has a null value in JSON.');
        assert(json.containsKey(r'priority'), 'Required key "AdminPromotionInput[priority]" is missing from JSON.');
        assert(json[r'priority'] != null, 'Required key "AdminPromotionInput[priority]" has a null value in JSON.');
        assert(json.containsKey(r'isActive'), 'Required key "AdminPromotionInput[isActive]" is missing from JSON.');
        assert(json[r'isActive'] != null, 'Required key "AdminPromotionInput[isActive]" has a null value in JSON.');
        assert(json.containsKey(r'startsAt'), 'Required key "AdminPromotionInput[startsAt]" is missing from JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminPromotionInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminPromotionInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'shown'), 'Required key "AdminPromotionInput[shown]" is missing from JSON.');
        assert(json[r'shown'] != null, 'Required key "AdminPromotionInput[shown]" has a null value in JSON.');
        assert(json.containsKey(r'clicked'), 'Required key "AdminPromotionInput[clicked]" is missing from JSON.');
        assert(json[r'clicked'] != null, 'Required key "AdminPromotionInput[clicked]" has a null value in JSON.');
        assert(json.containsKey(r'shownToday'), 'Required key "AdminPromotionInput[shownToday]" is missing from JSON.');
        assert(json[r'shownToday'] != null, 'Required key "AdminPromotionInput[shownToday]" has a null value in JSON.');
        assert(json.containsKey(r'clickedToday'), 'Required key "AdminPromotionInput[clickedToday]" is missing from JSON.');
        assert(json[r'clickedToday'] != null, 'Required key "AdminPromotionInput[clickedToday]" has a null value in JSON.');
        assert(json.containsKey(r'reach'), 'Required key "AdminPromotionInput[reach]" is missing from JSON.');
        assert(json[r'reach'] != null, 'Required key "AdminPromotionInput[reach]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminPromotionInput[createdAt]" is missing from JSON.');
        return true;
      }());

      return AdminPromotionInput(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        highlight: mapValueOfType<String>(json, r'highlight'),
        badge: mapValueOfType<String>(json, r'badge'),
        emoji: mapValueOfType<String>(json, r'emoji'),
        ctaLabel: mapValueOfType<String>(json, r'ctaLabel')!,
        ctaAction: AdminPromotionInputCtaActionEnum.fromJson(json[r'ctaAction'])!,
        theme: AdminPromotionInputThemeEnum.fromJson(json[r'theme'])!,
        confetti: mapValueOfType<bool>(json, r'confetti')!,
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
        audience: AdminPromotionInputAudienceEnum.fromJson(json[r'audience'])!,
        frequency: AdminPromotionInputFrequencyEnum.fromJson(json[r'frequency'])!,
        priority: mapValueOfType<int>(json, r'priority')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        startsAt: mapValueOfType<Object>(json, r'startsAt'),
        status: AdminPromotionInputStatusEnum.fromJson(json[r'status'])!,
        shown: mapValueOfType<int>(json, r'shown')!,
        clicked: mapValueOfType<int>(json, r'clicked')!,
        shownToday: mapValueOfType<int>(json, r'shownToday')!,
        clickedToday: mapValueOfType<int>(json, r'clickedToday')!,
        reach: mapValueOfType<int>(json, r'reach')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<AdminPromotionInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPromotionInput> mapFromJson(dynamic json) {
    final map = <String, AdminPromotionInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPromotionInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPromotionInput-objects as value to a dart map
  static Map<String, List<AdminPromotionInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPromotionInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPromotionInput.listFromJson(entry.value, growable: growable,);
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
enum AdminPromotionInputCtaActionEnum {
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
  const AdminPromotionInputCtaActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionInputCtaActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionInputCtaActionEnum? fromJson(dynamic value) => AdminPromotionInputCtaActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionInputCtaActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionInputCtaActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInputCtaActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInputCtaActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionInputCtaActionEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionInputCtaActionEnum].
class AdminPromotionInputCtaActionEnumTypeTransformer {
  factory AdminPromotionInputCtaActionEnumTypeTransformer() => _instance ??= const AdminPromotionInputCtaActionEnumTypeTransformer._();

  const AdminPromotionInputCtaActionEnumTypeTransformer._();

  String encode(AdminPromotionInputCtaActionEnum data) => data._value;

  /// Returns the instance of [AdminPromotionInputCtaActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionInputCtaActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionInputCtaActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'wallet': return AdminPromotionInputCtaActionEnum.wallet;
        case r'vip': return AdminPromotionInputCtaActionEnum.vip;
        case r'checkin': return AdminPromotionInputCtaActionEnum.checkin;
        case r'referral': return AdminPromotionInputCtaActionEnum.referral;
        case r'online': return AdminPromotionInputCtaActionEnum.online;
        case r'rooms': return AdminPromotionInputCtaActionEnum.rooms;
        case r'rewards': return AdminPromotionInputCtaActionEnum.rewards;
        case r'none': return AdminPromotionInputCtaActionEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionInputCtaActionEnumTypeTransformer? _instance;
}



enum AdminPromotionInputThemeEnum {
  brand._(r'brand'),
  gold._(r'gold'),
  green._(r'green'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionInputThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionInputThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionInputThemeEnum? fromJson(dynamic value) => AdminPromotionInputThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionInputThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionInputThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInputThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInputThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionInputThemeEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionInputThemeEnum].
class AdminPromotionInputThemeEnumTypeTransformer {
  factory AdminPromotionInputThemeEnumTypeTransformer() => _instance ??= const AdminPromotionInputThemeEnumTypeTransformer._();

  const AdminPromotionInputThemeEnumTypeTransformer._();

  String encode(AdminPromotionInputThemeEnum data) => data._value;

  /// Returns the instance of [AdminPromotionInputThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionInputThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionInputThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'brand': return AdminPromotionInputThemeEnum.brand;
        case r'gold': return AdminPromotionInputThemeEnum.gold;
        case r'green': return AdminPromotionInputThemeEnum.green;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionInputThemeEnumTypeTransformer? _instance;
}


/// never_paid / paid = callers with no / at least one credited coin purchase
enum AdminPromotionInputAudienceEnum {
  all._(r'all'),
  callers._(r'callers'),
  companions._(r'companions'),
  neverPaid._(r'never_paid'),
  paid._(r'paid'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionInputAudienceEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionInputAudienceEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionInputAudienceEnum? fromJson(dynamic value) => AdminPromotionInputAudienceEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionInputAudienceEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionInputAudienceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInputAudienceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInputAudienceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionInputAudienceEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionInputAudienceEnum].
class AdminPromotionInputAudienceEnumTypeTransformer {
  factory AdminPromotionInputAudienceEnumTypeTransformer() => _instance ??= const AdminPromotionInputAudienceEnumTypeTransformer._();

  const AdminPromotionInputAudienceEnumTypeTransformer._();

  String encode(AdminPromotionInputAudienceEnum data) => data._value;

  /// Returns the instance of [AdminPromotionInputAudienceEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionInputAudienceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionInputAudienceEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'all': return AdminPromotionInputAudienceEnum.all;
        case r'callers': return AdminPromotionInputAudienceEnum.callers;
        case r'companions': return AdminPromotionInputAudienceEnum.companions;
        case r'never_paid': return AdminPromotionInputAudienceEnum.neverPaid;
        case r'paid': return AdminPromotionInputAudienceEnum.paid;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionInputAudienceEnumTypeTransformer? _instance;
}


/// every_open = each time the app opens; daily = once per IST day; once = only ever once
enum AdminPromotionInputFrequencyEnum {
  everyOpen._(r'every_open'),
  daily._(r'daily'),
  once._(r'once'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionInputFrequencyEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionInputFrequencyEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionInputFrequencyEnum? fromJson(dynamic value) => AdminPromotionInputFrequencyEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionInputFrequencyEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionInputFrequencyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInputFrequencyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInputFrequencyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionInputFrequencyEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionInputFrequencyEnum].
class AdminPromotionInputFrequencyEnumTypeTransformer {
  factory AdminPromotionInputFrequencyEnumTypeTransformer() => _instance ??= const AdminPromotionInputFrequencyEnumTypeTransformer._();

  const AdminPromotionInputFrequencyEnumTypeTransformer._();

  String encode(AdminPromotionInputFrequencyEnum data) => data._value;

  /// Returns the instance of [AdminPromotionInputFrequencyEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionInputFrequencyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionInputFrequencyEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'every_open': return AdminPromotionInputFrequencyEnum.everyOpen;
        case r'daily': return AdminPromotionInputFrequencyEnum.daily;
        case r'once': return AdminPromotionInputFrequencyEnum.once;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionInputFrequencyEnumTypeTransformer? _instance;
}



enum AdminPromotionInputStatusEnum {
  live._(r'live'),
  scheduled._(r'scheduled'),
  ended._(r'ended'),
  off._(r'off'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminPromotionInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminPromotionInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminPromotionInputStatusEnum? fromJson(dynamic value) => AdminPromotionInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminPromotionInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminPromotionInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPromotionInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPromotionInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPromotionInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminPromotionInputStatusEnum].
class AdminPromotionInputStatusEnumTypeTransformer {
  factory AdminPromotionInputStatusEnumTypeTransformer() => _instance ??= const AdminPromotionInputStatusEnumTypeTransformer._();

  const AdminPromotionInputStatusEnumTypeTransformer._();

  String encode(AdminPromotionInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminPromotionInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPromotionInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminPromotionInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'live': return AdminPromotionInputStatusEnum.live;
        case r'scheduled': return AdminPromotionInputStatusEnum.scheduled;
        case r'ended': return AdminPromotionInputStatusEnum.ended;
        case r'off': return AdminPromotionInputStatusEnum.off;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminPromotionInputStatusEnumTypeTransformer? _instance;
}


