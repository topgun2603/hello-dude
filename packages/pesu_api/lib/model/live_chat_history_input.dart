//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveChatHistoryInput {
  /// Returns a new [LiveChatHistoryInput] instance.
  LiveChatHistoryInput({
    this.messages = const [],
  });

  List<LiveChatHistoryInputMessagesInner> messages;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveChatHistoryInput &&
    _deepEquality.equals(other.messages, messages);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (messages.hashCode);

  @override
  String toString() => 'LiveChatHistoryInput[messages=$messages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'messages'] = this.messages;
    return json;
  }

  /// Returns a new [LiveChatHistoryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveChatHistoryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'messages'), 'Required key "LiveChatHistoryInput[messages]" is missing from JSON.');
        assert(json[r'messages'] != null, 'Required key "LiveChatHistoryInput[messages]" has a null value in JSON.');
        return true;
      }());

      return LiveChatHistoryInput(
        messages: LiveChatHistoryInputMessagesInner.listFromJson(json[r'messages']),
      );
    }
    return null;
  }

  static List<LiveChatHistoryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveChatHistoryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveChatHistoryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveChatHistoryInput> mapFromJson(dynamic json) {
    final map = <String, LiveChatHistoryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveChatHistoryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveChatHistoryInput-objects as value to a dart map
  static Map<String, List<LiveChatHistoryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveChatHistoryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveChatHistoryInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'messages',
  };
}

