//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveChatHistoryInputMessagesInner {
  /// Returns a new [LiveChatHistoryInputMessagesInner] instance.
  LiveChatHistoryInputMessagesInner({
    required this.userId,
    required this.displayName,
    required this.body,
    required this.isHost,
    required this.at,
  });

  String userId;

  String displayName;

  String body;

  bool isHost;

  String at;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveChatHistoryInputMessagesInner &&
    other.userId == userId &&
    other.displayName == displayName &&
    other.body == body &&
    other.isHost == isHost &&
    other.at == at;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (displayName.hashCode) +
    (body.hashCode) +
    (isHost.hashCode) +
    (at.hashCode);

  @override
  String toString() => 'LiveChatHistoryInputMessagesInner[userId=$userId, displayName=$displayName, body=$body, isHost=$isHost, at=$at]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'displayName'] = this.displayName;
      json[r'body'] = this.body;
      json[r'isHost'] = this.isHost;
      json[r'at'] = this.at;
    return json;
  }

  /// Returns a new [LiveChatHistoryInputMessagesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveChatHistoryInputMessagesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'userId'), 'Required key "LiveChatHistoryInputMessagesInner[userId]" is missing from JSON.');
        assert(json[r'userId'] != null, 'Required key "LiveChatHistoryInputMessagesInner[userId]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "LiveChatHistoryInputMessagesInner[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "LiveChatHistoryInputMessagesInner[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "LiveChatHistoryInputMessagesInner[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "LiveChatHistoryInputMessagesInner[body]" has a null value in JSON.');
        assert(json.containsKey(r'isHost'), 'Required key "LiveChatHistoryInputMessagesInner[isHost]" is missing from JSON.');
        assert(json[r'isHost'] != null, 'Required key "LiveChatHistoryInputMessagesInner[isHost]" has a null value in JSON.');
        assert(json.containsKey(r'at'), 'Required key "LiveChatHistoryInputMessagesInner[at]" is missing from JSON.');
        assert(json[r'at'] != null, 'Required key "LiveChatHistoryInputMessagesInner[at]" has a null value in JSON.');
        return true;
      }());

      return LiveChatHistoryInputMessagesInner(
        userId: mapValueOfType<String>(json, r'userId')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        body: mapValueOfType<String>(json, r'body')!,
        isHost: mapValueOfType<bool>(json, r'isHost')!,
        at: mapValueOfType<String>(json, r'at')!,
      );
    }
    return null;
  }

  static List<LiveChatHistoryInputMessagesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveChatHistoryInputMessagesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveChatHistoryInputMessagesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveChatHistoryInputMessagesInner> mapFromJson(dynamic json) {
    final map = <String, LiveChatHistoryInputMessagesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveChatHistoryInputMessagesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveChatHistoryInputMessagesInner-objects as value to a dart map
  static Map<String, List<LiveChatHistoryInputMessagesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveChatHistoryInputMessagesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveChatHistoryInputMessagesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'userId',
    'displayName',
    'body',
    'isHost',
    'at',
  };
}

