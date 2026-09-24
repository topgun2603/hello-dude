//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Promotion {
  /// Returns a new [Promotion] instance.
  Promotion({
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
  PromotionCtaActionEnum ctaAction;

  PromotionThemeEnum theme;

  bool confetti;

  /// Show a countdown when set
  DateTime? endsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Promotion &&
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
    other.endsAt == endsAt;

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
    (endsAt == null ? 0 : endsAt!.hashCode);

  @override
  String toString() => 'Promotion[id=$id, title=$title, body=$body, highlight=$highlight, badge=$badge, emoji=$emoji, ctaLabel=$ctaLabel, ctaAction=$ctaAction, theme=$theme, confetti=$confetti, endsAt=$endsAt]';

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
    return json;
  }

  /// Returns a new [Promotion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Promotion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Promotion[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Promotion[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "Promotion[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "Promotion[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "Promotion[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "Promotion[body]" has a null value in JSON.');
        assert(json.containsKey(r'highlight'), 'Required key "Promotion[highlight]" is missing from JSON.');
        assert(json.containsKey(r'badge'), 'Required key "Promotion[badge]" is missing from JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "Promotion[emoji]" is missing from JSON.');
        assert(json.containsKey(r'ctaLabel'), 'Required key "Promotion[ctaLabel]" is missing from JSON.');
        assert(json[r'ctaLabel'] != null, 'Required key "Promotion[ctaLabel]" has a null value in JSON.');
        assert(json.containsKey(r'ctaAction'), 'Required key "Promotion[ctaAction]" is missing from JSON.');
        assert(json[r'ctaAction'] != null, 'Required key "Promotion[ctaAction]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "Promotion[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "Promotion[theme]" has a null value in JSON.');
        assert(json.containsKey(r'confetti'), 'Required key "Promotion[confetti]" is missing from JSON.');
        assert(json[r'confetti'] != null, 'Required key "Promotion[confetti]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "Promotion[endsAt]" is missing from JSON.');
        return true;
      }());

      return Promotion(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        highlight: mapValueOfType<String>(json, r'highlight'),
        badge: mapValueOfType<String>(json, r'badge'),
        emoji: mapValueOfType<String>(json, r'emoji'),
        ctaLabel: mapValueOfType<String>(json, r'ctaLabel')!,
        ctaAction: PromotionCtaActionEnum.fromJson(json[r'ctaAction'])!,
        theme: PromotionThemeEnum.fromJson(json[r'theme'])!,
        confetti: mapValueOfType<bool>(json, r'confetti')!,
        endsAt: mapDateTime(json, r'endsAt', r''),
      );
    }
    return null;
  }

  static List<Promotion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Promotion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Promotion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Promotion> mapFromJson(dynamic json) {
    final map = <String, Promotion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Promotion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Promotion-objects as value to a dart map
  static Map<String, List<Promotion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Promotion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Promotion.listFromJson(entry.value, growable: growable,);
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
  };
}

/// Where the button goes inside the app
enum PromotionCtaActionEnum {
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
  const PromotionCtaActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PromotionCtaActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PromotionCtaActionEnum? fromJson(dynamic value) => PromotionCtaActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PromotionCtaActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PromotionCtaActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PromotionCtaActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PromotionCtaActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PromotionCtaActionEnum] to String,
/// and [decode] dynamic data back to [PromotionCtaActionEnum].
class PromotionCtaActionEnumTypeTransformer {
  factory PromotionCtaActionEnumTypeTransformer() => _instance ??= const PromotionCtaActionEnumTypeTransformer._();

  const PromotionCtaActionEnumTypeTransformer._();

  String encode(PromotionCtaActionEnum data) => data._value;

  /// Returns the instance of [PromotionCtaActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PromotionCtaActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PromotionCtaActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'wallet': return PromotionCtaActionEnum.wallet;
        case r'vip': return PromotionCtaActionEnum.vip;
        case r'checkin': return PromotionCtaActionEnum.checkin;
        case r'referral': return PromotionCtaActionEnum.referral;
        case r'online': return PromotionCtaActionEnum.online;
        case r'rooms': return PromotionCtaActionEnum.rooms;
        case r'rewards': return PromotionCtaActionEnum.rewards;
        case r'none': return PromotionCtaActionEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PromotionCtaActionEnumTypeTransformer? _instance;
}



enum PromotionThemeEnum {
  brand._(r'brand'),
  gold._(r'gold'),
  green._(r'green'),
  ;

  /// Instantiate a new enum with the provided value.
  const PromotionThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PromotionThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PromotionThemeEnum? fromJson(dynamic value) => PromotionThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PromotionThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PromotionThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PromotionThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PromotionThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PromotionThemeEnum] to String,
/// and [decode] dynamic data back to [PromotionThemeEnum].
class PromotionThemeEnumTypeTransformer {
  factory PromotionThemeEnumTypeTransformer() => _instance ??= const PromotionThemeEnumTypeTransformer._();

  const PromotionThemeEnumTypeTransformer._();

  String encode(PromotionThemeEnum data) => data._value;

  /// Returns the instance of [PromotionThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PromotionThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PromotionThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'brand': return PromotionThemeEnum.brand;
        case r'gold': return PromotionThemeEnum.gold;
        case r'green': return PromotionThemeEnum.green;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PromotionThemeEnumTypeTransformer? _instance;
}


