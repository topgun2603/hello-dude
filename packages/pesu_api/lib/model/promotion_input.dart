//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PromotionInput {
  /// Returns a new [PromotionInput] instance.
  PromotionInput({
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
  PromotionInputCtaActionEnum ctaAction;

  PromotionInputThemeEnum theme;

  bool confetti;

  /// Show a countdown when set
  Object? endsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PromotionInput &&
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
  String toString() => 'PromotionInput[id=$id, title=$title, body=$body, highlight=$highlight, badge=$badge, emoji=$emoji, ctaLabel=$ctaLabel, ctaAction=$ctaAction, theme=$theme, confetti=$confetti, endsAt=$endsAt]';

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
    return json;
  }

  /// Returns a new [PromotionInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PromotionInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PromotionInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PromotionInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "PromotionInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "PromotionInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "PromotionInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "PromotionInput[body]" has a null value in JSON.');
        assert(json.containsKey(r'highlight'), 'Required key "PromotionInput[highlight]" is missing from JSON.');
        assert(json.containsKey(r'badge'), 'Required key "PromotionInput[badge]" is missing from JSON.');
        assert(json.containsKey(r'emoji'), 'Required key "PromotionInput[emoji]" is missing from JSON.');
        assert(json.containsKey(r'ctaLabel'), 'Required key "PromotionInput[ctaLabel]" is missing from JSON.');
        assert(json[r'ctaLabel'] != null, 'Required key "PromotionInput[ctaLabel]" has a null value in JSON.');
        assert(json.containsKey(r'ctaAction'), 'Required key "PromotionInput[ctaAction]" is missing from JSON.');
        assert(json[r'ctaAction'] != null, 'Required key "PromotionInput[ctaAction]" has a null value in JSON.');
        assert(json.containsKey(r'theme'), 'Required key "PromotionInput[theme]" is missing from JSON.');
        assert(json[r'theme'] != null, 'Required key "PromotionInput[theme]" has a null value in JSON.');
        assert(json.containsKey(r'confetti'), 'Required key "PromotionInput[confetti]" is missing from JSON.');
        assert(json[r'confetti'] != null, 'Required key "PromotionInput[confetti]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "PromotionInput[endsAt]" is missing from JSON.');
        return true;
      }());

      return PromotionInput(
        id: mapValueOfType<int>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        highlight: mapValueOfType<String>(json, r'highlight'),
        badge: mapValueOfType<String>(json, r'badge'),
        emoji: mapValueOfType<String>(json, r'emoji'),
        ctaLabel: mapValueOfType<String>(json, r'ctaLabel')!,
        ctaAction: PromotionInputCtaActionEnum.fromJson(json[r'ctaAction'])!,
        theme: PromotionInputThemeEnum.fromJson(json[r'theme'])!,
        confetti: mapValueOfType<bool>(json, r'confetti')!,
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
      );
    }
    return null;
  }

  static List<PromotionInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PromotionInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PromotionInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PromotionInput> mapFromJson(dynamic json) {
    final map = <String, PromotionInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PromotionInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PromotionInput-objects as value to a dart map
  static Map<String, List<PromotionInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PromotionInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PromotionInput.listFromJson(entry.value, growable: growable,);
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
enum PromotionInputCtaActionEnum {
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
  const PromotionInputCtaActionEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PromotionInputCtaActionEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PromotionInputCtaActionEnum? fromJson(dynamic value) => PromotionInputCtaActionEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PromotionInputCtaActionEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PromotionInputCtaActionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PromotionInputCtaActionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PromotionInputCtaActionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PromotionInputCtaActionEnum] to String,
/// and [decode] dynamic data back to [PromotionInputCtaActionEnum].
class PromotionInputCtaActionEnumTypeTransformer {
  factory PromotionInputCtaActionEnumTypeTransformer() => _instance ??= const PromotionInputCtaActionEnumTypeTransformer._();

  const PromotionInputCtaActionEnumTypeTransformer._();

  String encode(PromotionInputCtaActionEnum data) => data._value;

  /// Returns the instance of [PromotionInputCtaActionEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PromotionInputCtaActionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PromotionInputCtaActionEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'wallet': return PromotionInputCtaActionEnum.wallet;
        case r'vip': return PromotionInputCtaActionEnum.vip;
        case r'checkin': return PromotionInputCtaActionEnum.checkin;
        case r'referral': return PromotionInputCtaActionEnum.referral;
        case r'online': return PromotionInputCtaActionEnum.online;
        case r'rooms': return PromotionInputCtaActionEnum.rooms;
        case r'rewards': return PromotionInputCtaActionEnum.rewards;
        case r'none': return PromotionInputCtaActionEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PromotionInputCtaActionEnumTypeTransformer? _instance;
}



enum PromotionInputThemeEnum {
  brand._(r'brand'),
  gold._(r'gold'),
  green._(r'green'),
  ;

  /// Instantiate a new enum with the provided value.
  const PromotionInputThemeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [PromotionInputThemeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static PromotionInputThemeEnum? fromJson(dynamic value) => PromotionInputThemeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [PromotionInputThemeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<PromotionInputThemeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PromotionInputThemeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PromotionInputThemeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PromotionInputThemeEnum] to String,
/// and [decode] dynamic data back to [PromotionInputThemeEnum].
class PromotionInputThemeEnumTypeTransformer {
  factory PromotionInputThemeEnumTypeTransformer() => _instance ??= const PromotionInputThemeEnumTypeTransformer._();

  const PromotionInputThemeEnumTypeTransformer._();

  String encode(PromotionInputThemeEnum data) => data._value;

  /// Returns the instance of [PromotionInputThemeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PromotionInputThemeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is PromotionInputThemeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'brand': return PromotionInputThemeEnum.brand;
        case r'gold': return PromotionInputThemeEnum.gold;
        case r'green': return PromotionInputThemeEnum.green;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static PromotionInputThemeEnumTypeTransformer? _instance;
}


