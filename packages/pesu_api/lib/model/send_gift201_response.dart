//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendGift201Response {
  /// Returns a new [SendGift201Response] instance.
  SendGift201Response({
    required this.gift,
    required this.coinsLeft,
  });

  Gift gift;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsLeft;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendGift201Response &&
    other.gift == gift &&
    other.coinsLeft == coinsLeft;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (gift.hashCode) +
    (coinsLeft.hashCode);

  @override
  String toString() => 'SendGift201Response[gift=$gift, coinsLeft=$coinsLeft]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'gift'] = this.gift;
      json[r'coinsLeft'] = this.coinsLeft;
    return json;
  }

  /// Returns a new [SendGift201Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendGift201Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'gift'), 'Required key "SendGift201Response[gift]" is missing from JSON.');
        assert(json[r'gift'] != null, 'Required key "SendGift201Response[gift]" has a null value in JSON.');
        assert(json.containsKey(r'coinsLeft'), 'Required key "SendGift201Response[coinsLeft]" is missing from JSON.');
        assert(json[r'coinsLeft'] != null, 'Required key "SendGift201Response[coinsLeft]" has a null value in JSON.');
        return true;
      }());

      return SendGift201Response(
        gift: Gift.fromJson(json[r'gift'])!,
        coinsLeft: mapValueOfType<int>(json, r'coinsLeft')!,
      );
    }
    return null;
  }

  static List<SendGift201Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendGift201Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendGift201Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendGift201Response> mapFromJson(dynamic json) {
    final map = <String, SendGift201Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendGift201Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendGift201Response-objects as value to a dart map
  static Map<String, List<SendGift201Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendGift201Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendGift201Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'gift',
    'coinsLeft',
  };
}

