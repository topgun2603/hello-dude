//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class OnlineCallerInput {
  /// Returns a new [OnlineCallerInput] instance.
  OnlineCallerInput({
    required this.id,
    required this.displayName,
    required this.avatarId,
    required this.language,
    required this.canPay,
    required this.isVip,
    required this.isNew,
    required this.inCall,
    required this.callsWithYou,
    required this.lastCallAt,
    required this.favouritedYou,
    required this.invitedRecently,
    required this.level,
    required this.levelName,
    required this.badge,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  String language;

  /// Has coins for a few minutes of a voice call with you
  bool canPay;

  bool isVip;

  /// Joined in the last 7 days
  bool isNew;

  bool inCall;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int callsWithYou;

  Object? lastCallAt;

  bool favouritedYou;

  /// You invited him in the last hour
  bool invitedRecently;

  /// Caller level (lifetime coins spent)
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int level;

  String levelName;

  /// Best active badge, e.g. '#2 fan this week'
  UserBadgeInput? badge;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineCallerInput &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId &&
    other.language == language &&
    other.canPay == canPay &&
    other.isVip == isVip &&
    other.isNew == isNew &&
    other.inCall == inCall &&
    other.callsWithYou == callsWithYou &&
    other.lastCallAt == lastCallAt &&
    other.favouritedYou == favouritedYou &&
    other.invitedRecently == invitedRecently &&
    other.level == level &&
    other.levelName == levelName &&
    other.badge == badge;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode) +
    (language.hashCode) +
    (canPay.hashCode) +
    (isVip.hashCode) +
    (isNew.hashCode) +
    (inCall.hashCode) +
    (callsWithYou.hashCode) +
    (lastCallAt == null ? 0 : lastCallAt!.hashCode) +
    (favouritedYou.hashCode) +
    (invitedRecently.hashCode) +
    (level.hashCode) +
    (levelName.hashCode) +
    (badge == null ? 0 : badge!.hashCode);

  @override
  String toString() => 'OnlineCallerInput[id=$id, displayName=$displayName, avatarId=$avatarId, language=$language, canPay=$canPay, isVip=$isVip, isNew=$isNew, inCall=$inCall, callsWithYou=$callsWithYou, lastCallAt=$lastCallAt, favouritedYou=$favouritedYou, invitedRecently=$invitedRecently, level=$level, levelName=$levelName, badge=$badge]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
      json[r'language'] = this.language;
      json[r'canPay'] = this.canPay;
      json[r'isVip'] = this.isVip;
      json[r'isNew'] = this.isNew;
      json[r'inCall'] = this.inCall;
      json[r'callsWithYou'] = this.callsWithYou;
    if (this.lastCallAt != null) {
      json[r'lastCallAt'] = this.lastCallAt;
    } else {
      json[r'lastCallAt'] = null;
    }
      json[r'favouritedYou'] = this.favouritedYou;
      json[r'invitedRecently'] = this.invitedRecently;
      json[r'level'] = this.level;
      json[r'levelName'] = this.levelName;
    if (this.badge != null) {
      json[r'badge'] = this.badge;
    } else {
      json[r'badge'] = null;
    }
    return json;
  }

  /// Returns a new [OnlineCallerInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineCallerInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "OnlineCallerInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "OnlineCallerInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "OnlineCallerInput[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "OnlineCallerInput[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "OnlineCallerInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "OnlineCallerInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "OnlineCallerInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "OnlineCallerInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'canPay'), 'Required key "OnlineCallerInput[canPay]" is missing from JSON.');
        assert(json[r'canPay'] != null, 'Required key "OnlineCallerInput[canPay]" has a null value in JSON.');
        assert(json.containsKey(r'isVip'), 'Required key "OnlineCallerInput[isVip]" is missing from JSON.');
        assert(json[r'isVip'] != null, 'Required key "OnlineCallerInput[isVip]" has a null value in JSON.');
        assert(json.containsKey(r'isNew'), 'Required key "OnlineCallerInput[isNew]" is missing from JSON.');
        assert(json[r'isNew'] != null, 'Required key "OnlineCallerInput[isNew]" has a null value in JSON.');
        assert(json.containsKey(r'inCall'), 'Required key "OnlineCallerInput[inCall]" is missing from JSON.');
        assert(json[r'inCall'] != null, 'Required key "OnlineCallerInput[inCall]" has a null value in JSON.');
        assert(json.containsKey(r'callsWithYou'), 'Required key "OnlineCallerInput[callsWithYou]" is missing from JSON.');
        assert(json[r'callsWithYou'] != null, 'Required key "OnlineCallerInput[callsWithYou]" has a null value in JSON.');
        assert(json.containsKey(r'lastCallAt'), 'Required key "OnlineCallerInput[lastCallAt]" is missing from JSON.');
        assert(json.containsKey(r'favouritedYou'), 'Required key "OnlineCallerInput[favouritedYou]" is missing from JSON.');
        assert(json[r'favouritedYou'] != null, 'Required key "OnlineCallerInput[favouritedYou]" has a null value in JSON.');
        assert(json.containsKey(r'invitedRecently'), 'Required key "OnlineCallerInput[invitedRecently]" is missing from JSON.');
        assert(json[r'invitedRecently'] != null, 'Required key "OnlineCallerInput[invitedRecently]" has a null value in JSON.');
        assert(json.containsKey(r'level'), 'Required key "OnlineCallerInput[level]" is missing from JSON.');
        assert(json[r'level'] != null, 'Required key "OnlineCallerInput[level]" has a null value in JSON.');
        assert(json.containsKey(r'levelName'), 'Required key "OnlineCallerInput[levelName]" is missing from JSON.');
        assert(json[r'levelName'] != null, 'Required key "OnlineCallerInput[levelName]" has a null value in JSON.');
        assert(json.containsKey(r'badge'), 'Required key "OnlineCallerInput[badge]" is missing from JSON.');
        return true;
      }());

      return OnlineCallerInput(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        language: mapValueOfType<String>(json, r'language')!,
        canPay: mapValueOfType<bool>(json, r'canPay')!,
        isVip: mapValueOfType<bool>(json, r'isVip')!,
        isNew: mapValueOfType<bool>(json, r'isNew')!,
        inCall: mapValueOfType<bool>(json, r'inCall')!,
        callsWithYou: mapValueOfType<int>(json, r'callsWithYou')!,
        lastCallAt: mapValueOfType<Object>(json, r'lastCallAt'),
        favouritedYou: mapValueOfType<bool>(json, r'favouritedYou')!,
        invitedRecently: mapValueOfType<bool>(json, r'invitedRecently')!,
        level: mapValueOfType<int>(json, r'level')!,
        levelName: mapValueOfType<String>(json, r'levelName')!,
        badge: UserBadgeInput.fromJson(json[r'badge']),
      );
    }
    return null;
  }

  static List<OnlineCallerInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineCallerInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineCallerInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineCallerInput> mapFromJson(dynamic json) {
    final map = <String, OnlineCallerInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineCallerInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineCallerInput-objects as value to a dart map
  static Map<String, List<OnlineCallerInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineCallerInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineCallerInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
    'language',
    'canPay',
    'isVip',
    'isNew',
    'inCall',
    'callsWithYou',
    'lastCallAt',
    'favouritedYou',
    'invitedRecently',
    'level',
    'levelName',
    'badge',
  };
}

