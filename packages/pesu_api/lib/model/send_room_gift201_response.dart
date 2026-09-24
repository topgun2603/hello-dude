//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendRoomGift201Response {
  /// Returns a new [SendRoomGift201Response] instance.
  SendRoomGift201Response({
    required this.coinsLeft,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsLeft;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendRoomGift201Response &&
    other.coinsLeft == coinsLeft;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coinsLeft.hashCode);

  @override
  String toString() => 'SendRoomGift201Response[coinsLeft=$coinsLeft]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'coinsLeft'] = this.coinsLeft;
    return json;
  }

  /// Returns a new [SendRoomGift201Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendRoomGift201Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'coinsLeft'), 'Required key "SendRoomGift201Response[coinsLeft]" is missing from JSON.');
        assert(json[r'coinsLeft'] != null, 'Required key "SendRoomGift201Response[coinsLeft]" has a null value in JSON.');
        return true;
      }());

      return SendRoomGift201Response(
        coinsLeft: mapValueOfType<int>(json, r'coinsLeft')!,
      );
    }
    return null;
  }

  static List<SendRoomGift201Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendRoomGift201Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendRoomGift201Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendRoomGift201Response> mapFromJson(dynamic json) {
    final map = <String, SendRoomGift201Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendRoomGift201Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendRoomGift201Response-objects as value to a dart map
  static Map<String, List<SendRoomGift201Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendRoomGift201Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendRoomGift201Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coinsLeft',
  };
}

