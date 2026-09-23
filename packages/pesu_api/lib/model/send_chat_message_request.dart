//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class SendChatMessageRequest {
  /// Returns a new [SendChatMessageRequest] instance.
  SendChatMessageRequest({
    required this.body,
    required this.clientRef,
  });

  String body;

  String clientRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendChatMessageRequest &&
    other.body == body &&
    other.clientRef == clientRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (body.hashCode) +
    (clientRef.hashCode);

  @override
  String toString() => 'SendChatMessageRequest[body=$body, clientRef=$clientRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'body'] = this.body;
      json[r'clientRef'] = this.clientRef;
    return json;
  }

  /// Returns a new [SendChatMessageRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendChatMessageRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'body'), 'Required key "SendChatMessageRequest[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "SendChatMessageRequest[body]" has a null value in JSON.');
        assert(json.containsKey(r'clientRef'), 'Required key "SendChatMessageRequest[clientRef]" is missing from JSON.');
        assert(json[r'clientRef'] != null, 'Required key "SendChatMessageRequest[clientRef]" has a null value in JSON.');
        return true;
      }());

      return SendChatMessageRequest(
        body: mapValueOfType<String>(json, r'body')!,
        clientRef: mapValueOfType<String>(json, r'clientRef')!,
      );
    }
    return null;
  }

  static List<SendChatMessageRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendChatMessageRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendChatMessageRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendChatMessageRequest> mapFromJson(dynamic json) {
    final map = <String, SendChatMessageRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendChatMessageRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendChatMessageRequest-objects as value to a dart map
  static Map<String, List<SendChatMessageRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendChatMessageRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendChatMessageRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'body',
    'clientRef',
  };
}

