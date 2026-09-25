//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ChatRequestInput {
  /// Returns a new [ChatRequestInput] instance.
  ChatRequestInput({
    required this.id,
    required this.other,
    required this.body,
    required this.status,
    required this.createdAt,
    required this.conversationId,
  });

  String id;

  ConversationInputOther other;

  String body;

  ChatRequestInputStatusEnum status;

  Object? createdAt;

  /// Set once accepted
  String? conversationId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatRequestInput &&
    other.id == id &&
    other.other == other &&
    other.body == body &&
    other.status == status &&
    other.createdAt == createdAt &&
    other.conversationId == conversationId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (other.hashCode) +
    (body.hashCode) +
    (status.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (conversationId == null ? 0 : conversationId!.hashCode);

  @override
  String toString() => 'ChatRequestInput[id=$id, other=$other, body=$body, status=$status, createdAt=$createdAt, conversationId=$conversationId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'other'] = this.other;
      json[r'body'] = this.body;
      json[r'status'] = this.status;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    if (this.conversationId != null) {
      json[r'conversationId'] = this.conversationId;
    } else {
      json[r'conversationId'] = null;
    }
    return json;
  }

  /// Returns a new [ChatRequestInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatRequestInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ChatRequestInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ChatRequestInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "ChatRequestInput[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "ChatRequestInput[other]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "ChatRequestInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "ChatRequestInput[body]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "ChatRequestInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "ChatRequestInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "ChatRequestInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'conversationId'), 'Required key "ChatRequestInput[conversationId]" is missing from JSON.');
        return true;
      }());

      return ChatRequestInput(
        id: mapValueOfType<String>(json, r'id')!,
        other: ConversationInputOther.fromJson(json[r'other'])!,
        body: mapValueOfType<String>(json, r'body')!,
        status: ChatRequestInputStatusEnum.fromJson(json[r'status'])!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        conversationId: mapValueOfType<String>(json, r'conversationId'),
      );
    }
    return null;
  }

  static List<ChatRequestInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatRequestInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatRequestInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatRequestInput> mapFromJson(dynamic json) {
    final map = <String, ChatRequestInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatRequestInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatRequestInput-objects as value to a dart map
  static Map<String, List<ChatRequestInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatRequestInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatRequestInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'other',
    'body',
    'status',
    'createdAt',
    'conversationId',
  };
}


enum ChatRequestInputStatusEnum {
  pending._(r'pending'),
  accepted._(r'accepted'),
  declined._(r'declined'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatRequestInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatRequestInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatRequestInputStatusEnum? fromJson(dynamic value) => ChatRequestInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatRequestInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatRequestInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatRequestInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatRequestInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatRequestInputStatusEnum] to String,
/// and [decode] dynamic data back to [ChatRequestInputStatusEnum].
class ChatRequestInputStatusEnumTypeTransformer {
  factory ChatRequestInputStatusEnumTypeTransformer() => _instance ??= const ChatRequestInputStatusEnumTypeTransformer._();

  const ChatRequestInputStatusEnumTypeTransformer._();

  String encode(ChatRequestInputStatusEnum data) => data._value;

  /// Returns the instance of [ChatRequestInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatRequestInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatRequestInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return ChatRequestInputStatusEnum.pending;
        case r'accepted': return ChatRequestInputStatusEnum.accepted;
        case r'declined': return ChatRequestInputStatusEnum.declined;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatRequestInputStatusEnumTypeTransformer? _instance;
}


