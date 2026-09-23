//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class Conversation {
  /// Returns a new [Conversation] instance.
  Conversation({
    required this.id,
    required this.other,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unread,
    required this.canMessage,
  });

  String id;

  ConversationOther other;

  String? lastMessage;

  DateTime? lastMessageAt;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int unread;

  bool canMessage;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Conversation &&
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
  String toString() => 'Conversation[id=$id, other=$other, lastMessage=$lastMessage, lastMessageAt=$lastMessageAt, unread=$unread, canMessage=$canMessage]';

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
      json[r'lastMessageAt'] = this.lastMessageAt!.toUtc().toIso8601String();
    } else {
      json[r'lastMessageAt'] = null;
    }
      json[r'unread'] = this.unread;
      json[r'canMessage'] = this.canMessage;
    return json;
  }

  /// Returns a new [Conversation] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Conversation? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "Conversation[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "Conversation[id]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "Conversation[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "Conversation[other]" has a null value in JSON.');
        assert(json.containsKey(r'lastMessage'), 'Required key "Conversation[lastMessage]" is missing from JSON.');
        assert(json.containsKey(r'lastMessageAt'), 'Required key "Conversation[lastMessageAt]" is missing from JSON.');
        assert(json.containsKey(r'unread'), 'Required key "Conversation[unread]" is missing from JSON.');
        assert(json[r'unread'] != null, 'Required key "Conversation[unread]" has a null value in JSON.');
        assert(json.containsKey(r'canMessage'), 'Required key "Conversation[canMessage]" is missing from JSON.');
        assert(json[r'canMessage'] != null, 'Required key "Conversation[canMessage]" has a null value in JSON.');
        return true;
      }());

      return Conversation(
        id: mapValueOfType<String>(json, r'id')!,
        other: ConversationOther.fromJson(json[r'other'])!,
        lastMessage: mapValueOfType<String>(json, r'lastMessage'),
        lastMessageAt: mapDateTime(json, r'lastMessageAt', r''),
        unread: mapValueOfType<int>(json, r'unread')!,
        canMessage: mapValueOfType<bool>(json, r'canMessage')!,
      );
    }
    return null;
  }

  static List<Conversation> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Conversation>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Conversation.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Conversation> mapFromJson(dynamic json) {
    final map = <String, Conversation>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Conversation.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Conversation-objects as value to a dart map
  static Map<String, List<Conversation>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Conversation>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Conversation.listFromJson(entry.value, growable: growable,);
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

