//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendRoomReactionRequest {
  /// Returns a new [SendRoomReactionRequest] instance.
  SendRoomReactionRequest({
    required this.emoji,
  });

  /// ❤️ 😂 👏 🔥 😮 🙏
  String emoji;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendRoomReactionRequest &&
    other.emoji == emoji;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (emoji.hashCode);

  @override
  String toString() => 'SendRoomReactionRequest[emoji=$emoji]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'emoji'] = this.emoji;
    return json;
  }

  /// Returns a new [SendRoomReactionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendRoomReactionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'emoji'), 'Required key "SendRoomReactionRequest[emoji]" is missing from JSON.');
        assert(json[r'emoji'] != null, 'Required key "SendRoomReactionRequest[emoji]" has a null value in JSON.');
        return true;
      }());

      return SendRoomReactionRequest(
        emoji: mapValueOfType<String>(json, r'emoji')!,
      );
    }
    return null;
  }

  static List<SendRoomReactionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendRoomReactionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendRoomReactionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendRoomReactionRequest> mapFromJson(dynamic json) {
    final map = <String, SendRoomReactionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendRoomReactionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendRoomReactionRequest-objects as value to a dart map
  static Map<String, List<SendRoomReactionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendRoomReactionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendRoomReactionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'emoji',
  };
}

