//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ConversationInput {
  /// Returns a new [ConversationInput] instance.
  ConversationInput({
    required this.id,
    required this.other,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unread,
    required this.canMessage,
  });

  String id;

  ConversationInputOther other;

  String? lastMessage;

  Object? lastMessageAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int unread;

  bool canMessage;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversationInput &&
    other.id == id &&
    other.other == other &&
    other.lastMessage == lastMessage &&
    other.lastMessageAt == lastMessageAt &&
    other.unread == unread &&
    other.canMessage == canMessage;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (other.hashCode) +
    (lastMessage == null ? 0 : lastMessage!.hashCode) +
    (lastMessageAt == null ? 0 : lastMessageAt!.hashCode) +
    (unread.hashCode) +
    (canMessage.hashCode);

  @override
  String toString() => 'ConversationInput[id=$id, other=$other, lastMessage=$lastMessage, lastMessageAt=$lastMessageAt, unread=$unread, canMessage=$canMessage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'other'] = this.other;
    if (this.lastMessage != null) {
      json[r'lastMessage'] = this.lastMessage;
    } else {
      json[r'lastMessage'] = null;
    }
    if (this.lastMessageAt != null) {
      json[r'lastMessageAt'] = this.lastMessageAt;
    } else {
      json[r'lastMessageAt'] = null;
    }
      json[r'unread'] = this.unread;
      json[r'canMessage'] = this.canMessage;
    return json;
  }

  /// Returns a new [ConversationInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConversationInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ConversationInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ConversationInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "ConversationInput[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "ConversationInput[other]" has a null value in JSON.');
        assert(json.containsKey(r'lastMessage'), 'Required key "ConversationInput[lastMessage]" is missing from JSON.');
        assert(json.containsKey(r'lastMessageAt'), 'Required key "ConversationInput[lastMessageAt]" is missing from JSON.');
        assert(json.containsKey(r'unread'), 'Required key "ConversationInput[unread]" is missing from JSON.');
        assert(json[r'unread'] != null, 'Required key "ConversationInput[unread]" has a null value in JSON.');
        assert(json.containsKey(r'canMessage'), 'Required key "ConversationInput[canMessage]" is missing from JSON.');
        assert(json[r'canMessage'] != null, 'Required key "ConversationInput[canMessage]" has a null value in JSON.');
        return true;
      }());

      return ConversationInput(
        id: mapValueOfType<String>(json, r'id')!,
        other: ConversationInputOther.fromJson(json[r'other'])!,
        lastMessage: mapValueOfType<String>(json, r'lastMessage'),
        lastMessageAt: mapValueOfType<Object>(json, r'lastMessageAt'),
        unread: mapValueOfType<int>(json, r'unread')!,
        canMessage: mapValueOfType<bool>(json, r'canMessage')!,
      );
    }
    return null;
  }

  static List<ConversationInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversationInput> mapFromJson(dynamic json) {
    final map = <String, ConversationInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConversationInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversationInput-objects as value to a dart map
  static Map<String, List<ConversationInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversationInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversationInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'other',
    'lastMessage',
    'lastMessageAt',
    'unread',
    'canMessage',
  };
}

