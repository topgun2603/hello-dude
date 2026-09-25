//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ChatRequest {
  /// Returns a new [ChatRequest] instance.
  ChatRequest({
    required this.id,
    required this.other,
    required this.body,
    required this.status,
    required this.createdAt,
    required this.conversationId,
  });

  String id;

  ConversationOther other;

  String body;

  ChatRequestStatusEnum status;

  DateTime createdAt;

  /// Set once accepted
  String? conversationId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatRequest &&
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
    (createdAt.hashCode) +
    (conversationId == null ? 0 : conversationId!.hashCode);

  @override
  String toString() => 'ChatRequest[id=$id, other=$other, body=$body, status=$status, createdAt=$createdAt, conversationId=$conversationId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'other'] = this.other;
      json[r'body'] = this.body;
      json[r'status'] = this.status;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.conversationId != null) {
      json[r'conversationId'] = this.conversationId;
    } else {
      json[r'conversationId'] = null;
    }
    return json;
  }

  /// Returns a new [ChatRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ChatRequest[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ChatRequest[id]" has a null value in JSON.');
        assert(json.containsKey(r'other'), 'Required key "ChatRequest[other]" is missing from JSON.');
        assert(json[r'other'] != null, 'Required key "ChatRequest[other]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "ChatRequest[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "ChatRequest[body]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "ChatRequest[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "ChatRequest[status]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "ChatRequest[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "ChatRequest[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'conversationId'), 'Required key "ChatRequest[conversationId]" is missing from JSON.');
        return true;
      }());

      return ChatRequest(
        id: mapValueOfType<String>(json, r'id')!,
        other: ConversationOther.fromJson(json[r'other'])!,
        body: mapValueOfType<String>(json, r'body')!,
        status: ChatRequestStatusEnum.fromJson(json[r'status'])!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        conversationId: mapValueOfType<String>(json, r'conversationId'),
      );
    }
    return null;
  }

  static List<ChatRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatRequest> mapFromJson(dynamic json) {
    final map = <String, ChatRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatRequest-objects as value to a dart map
  static Map<String, List<ChatRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatRequest.listFromJson(entry.value, growable: growable,);
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


enum ChatRequestStatusEnum {
  pending._(r'pending'),
  accepted._(r'accepted'),
  declined._(r'declined'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatRequestStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatRequestStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatRequestStatusEnum? fromJson(dynamic value) => ChatRequestStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatRequestStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatRequestStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatRequestStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatRequestStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatRequestStatusEnum] to String,
/// and [decode] dynamic data back to [ChatRequestStatusEnum].
class ChatRequestStatusEnumTypeTransformer {
  factory ChatRequestStatusEnumTypeTransformer() => _instance ??= const ChatRequestStatusEnumTypeTransformer._();

  const ChatRequestStatusEnumTypeTransformer._();

  String encode(ChatRequestStatusEnum data) => data._value;

  /// Returns the instance of [ChatRequestStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatRequestStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatRequestStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'pending': return ChatRequestStatusEnum.pending;
        case r'accepted': return ChatRequestStatusEnum.accepted;
        case r'declined': return ChatRequestStatusEnum.declined;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatRequestStatusEnumTypeTransformer? _instance;
}


