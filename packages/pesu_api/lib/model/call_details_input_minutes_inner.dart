//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallDetailsInputMinutesInner {
  /// Returns a new [CallDetailsInputMinutesInner] instance.
  CallDetailsInputMinutesInner({
    required this.minuteNo,
    required this.coins,
    required this.paise,
    required this.chargedAt,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minuteNo;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paise;

  Object? chargedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallDetailsInputMinutesInner &&
    other.minuteNo == minuteNo &&
    other.coins == coins &&
    other.paise == paise &&
    other.chargedAt == chargedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minuteNo.hashCode) +
    (coins.hashCode) +
    (paise.hashCode) +
    (chargedAt == null ? 0 : chargedAt!.hashCode);

  @override
  String toString() => 'CallDetailsInputMinutesInner[minuteNo=$minuteNo, coins=$coins, paise=$paise, chargedAt=$chargedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'minuteNo'] = this.minuteNo;
      json[r'coins'] = this.coins;
      json[r'paise'] = this.paise;
    if (this.chargedAt != null) {
      json[r'chargedAt'] = this.chargedAt;
    } else {
      json[r'chargedAt'] = null;
    }
    return json;
  }

  /// Returns a new [CallDetailsInputMinutesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDetailsInputMinutesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'minuteNo'), 'Required key "CallDetailsInputMinutesInner[minuteNo]" is missing from JSON.');
        assert(json[r'minuteNo'] != null, 'Required key "CallDetailsInputMinutesInner[minuteNo]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "CallDetailsInputMinutesInner[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "CallDetailsInputMinutesInner[coins]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "CallDetailsInputMinutesInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "CallDetailsInputMinutesInner[paise]" has a null value in JSON.');
        assert(json.containsKey(r'chargedAt'), 'Required key "CallDetailsInputMinutesInner[chargedAt]" is missing from JSON.');
        return true;
      }());

      return CallDetailsInputMinutesInner(
        minuteNo: mapValueOfType<int>(json, r'minuteNo')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        paise: mapValueOfType<int>(json, r'paise')!,
        chargedAt: mapValueOfType<Object>(json, r'chargedAt'),
      );
    }
    return null;
  }

  static List<CallDetailsInputMinutesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallDetailsInputMinutesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDetailsInputMinutesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDetailsInputMinutesInner> mapFromJson(dynamic json) {
    final map = <String, CallDetailsInputMinutesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDetailsInputMinutesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDetailsInputMinutesInner-objects as value to a dart map
  static Map<String, List<CallDetailsInputMinutesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallDetailsInputMinutesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDetailsInputMinutesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'minuteNo',
    'coins',
    'paise',
    'chargedAt',
  };
}

