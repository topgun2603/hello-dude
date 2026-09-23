//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ChatItem {
  /// Returns a new [ChatItem] instance.
  ChatItem({
    required this.kind,
    required this.id,
    required this.senderId,
    required this.body,
    required this.callType,
    required this.callMinutes,
    required this.at,
  });

  ChatItemKindEnum kind;

  /// message id, or call id for call entries
  String id;

  String? senderId;

  String? body;

  ChatItemCallTypeEnum? callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? callMinutes;

  DateTime at;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatItem &&
    other.kind == kind &&
    other.id == id &&
    other.senderId == senderId &&
    other.body == body &&
    other.callType == callType &&
    other.callMinutes == callMinutes &&
    other.at == at;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (id.hashCode) +
    (senderId == null ? 0 : senderId!.hashCode) +
    (body == null ? 0 : body!.hashCode) +
    (callType == null ? 0 : callType!.hashCode) +
    (callMinutes == null ? 0 : callMinutes!.hashCode) +
    (at.hashCode);

  @override
  String toString() => 'ChatItem[kind=$kind, id=$id, senderId=$senderId, body=$body, callType=$callType, callMinutes=$callMinutes, at=$at]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
      json[r'id'] = this.id;
    if (this.senderId != null) {
      json[r'senderId'] = this.senderId;
    } else {
      json[r'senderId'] = null;
    }
    if (this.body != null) {
      json[r'body'] = this.body;
    } else {
      json[r'body'] = null;
    }
    if (this.callType != null) {
      json[r'callType'] = this.callType;
    } else {
      json[r'callType'] = null;
    }
    if (this.callMinutes != null) {
      json[r'callMinutes'] = this.callMinutes;
    } else {
      json[r'callMinutes'] = null;
    }
      json[r'at'] = this.at.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ChatItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "ChatItem[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "ChatItem[kind]" has a null value in JSON.');
        assert(json.containsKey(r'id'), 'Required key "ChatItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ChatItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'senderId'), 'Required key "ChatItem[senderId]" is missing from JSON.');
        assert(json.containsKey(r'body'), 'Required key "ChatItem[body]" is missing from JSON.');
        assert(json.containsKey(r'callType'), 'Required key "ChatItem[callType]" is missing from JSON.');
        assert(json.containsKey(r'callMinutes'), 'Required key "ChatItem[callMinutes]" is missing from JSON.');
        assert(json.containsKey(r'at'), 'Required key "ChatItem[at]" is missing from JSON.');
        assert(json[r'at'] != null, 'Required key "ChatItem[at]" has a null value in JSON.');
        return true;
      }());

      return ChatItem(
        kind: ChatItemKindEnum.fromJson(json[r'kind'])!,
        id: mapValueOfType<String>(json, r'id')!,
        senderId: mapValueOfType<String>(json, r'senderId'),
        body: mapValueOfType<String>(json, r'body'),
        callType: ChatItemCallTypeEnum.fromJson(json[r'callType']),
        callMinutes: mapValueOfType<int>(json, r'callMinutes'),
        at: mapDateTime(json, r'at', r'')!,
      );
    }
    return null;
  }

  static List<ChatItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatItem> mapFromJson(dynamic json) {
    final map = <String, ChatItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatItem-objects as value to a dart map
  static Map<String, List<ChatItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'id',
    'senderId',
    'body',
    'callType',
    'callMinutes',
    'at',
  };
}


enum ChatItemKindEnum {
  message._(r'message'),
  call._(r'call'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatItemKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatItemKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatItemKindEnum? fromJson(dynamic value) => ChatItemKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatItemKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatItemKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItemKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItemKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatItemKindEnum] to String,
/// and [decode] dynamic data back to [ChatItemKindEnum].
class ChatItemKindEnumTypeTransformer {
  factory ChatItemKindEnumTypeTransformer() => _instance ??= const ChatItemKindEnumTypeTransformer._();

  const ChatItemKindEnumTypeTransformer._();

  String encode(ChatItemKindEnum data) => data._value;

  /// Returns the instance of [ChatItemKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatItemKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatItemKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'message': return ChatItemKindEnum.message;
        case r'call': return ChatItemKindEnum.call;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatItemKindEnumTypeTransformer? _instance;
}



enum ChatItemCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatItemCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatItemCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatItemCallTypeEnum? fromJson(dynamic value) => ChatItemCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatItemCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatItemCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItemCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItemCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatItemCallTypeEnum] to String,
/// and [decode] dynamic data back to [ChatItemCallTypeEnum].
class ChatItemCallTypeEnumTypeTransformer {
  factory ChatItemCallTypeEnumTypeTransformer() => _instance ??= const ChatItemCallTypeEnumTypeTransformer._();

  const ChatItemCallTypeEnumTypeTransformer._();

  String encode(ChatItemCallTypeEnum data) => data._value;

  /// Returns the instance of [ChatItemCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatItemCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatItemCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return ChatItemCallTypeEnum.audio;
        case r'video': return ChatItemCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatItemCallTypeEnumTypeTransformer? _instance;
}


