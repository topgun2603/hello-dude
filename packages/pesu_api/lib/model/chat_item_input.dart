//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ChatItemInput {
  /// Returns a new [ChatItemInput] instance.
  ChatItemInput({
    required this.kind,
    required this.id,
    required this.senderId,
    required this.body,
    required this.callType,
    required this.callMinutes,
    required this.at,
  });

  ChatItemInputKindEnum kind;

  /// message id, or call id for call entries
  String id;

  String? senderId;

  String? body;

  ChatItemInputCallTypeEnum? callType;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? callMinutes;

  Object? at;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatItemInput &&
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
    (at == null ? 0 : at!.hashCode);

  @override
  String toString() => 'ChatItemInput[kind=$kind, id=$id, senderId=$senderId, body=$body, callType=$callType, callMinutes=$callMinutes, at=$at]';

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
    if (this.at != null) {
      json[r'at'] = this.at;
    } else {
      json[r'at'] = null;
    }
    return json;
  }

  /// Returns a new [ChatItemInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatItemInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "ChatItemInput[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "ChatItemInput[kind]" has a null value in JSON.');
        assert(json.containsKey(r'id'), 'Required key "ChatItemInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ChatItemInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'senderId'), 'Required key "ChatItemInput[senderId]" is missing from JSON.');
        assert(json.containsKey(r'body'), 'Required key "ChatItemInput[body]" is missing from JSON.');
        assert(json.containsKey(r'callType'), 'Required key "ChatItemInput[callType]" is missing from JSON.');
        assert(json.containsKey(r'callMinutes'), 'Required key "ChatItemInput[callMinutes]" is missing from JSON.');
        assert(json.containsKey(r'at'), 'Required key "ChatItemInput[at]" is missing from JSON.');
        return true;
      }());

      return ChatItemInput(
        kind: ChatItemInputKindEnum.fromJson(json[r'kind'])!,
        id: mapValueOfType<String>(json, r'id')!,
        senderId: mapValueOfType<String>(json, r'senderId'),
        body: mapValueOfType<String>(json, r'body'),
        callType: ChatItemInputCallTypeEnum.fromJson(json[r'callType']),
        callMinutes: mapValueOfType<int>(json, r'callMinutes'),
        at: mapValueOfType<Object>(json, r'at'),
      );
    }
    return null;
  }

  static List<ChatItemInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItemInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItemInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatItemInput> mapFromJson(dynamic json) {
    final map = <String, ChatItemInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatItemInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatItemInput-objects as value to a dart map
  static Map<String, List<ChatItemInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatItemInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatItemInput.listFromJson(entry.value, growable: growable,);
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


enum ChatItemInputKindEnum {
  message._(r'message'),
  call._(r'call'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatItemInputKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatItemInputKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatItemInputKindEnum? fromJson(dynamic value) => ChatItemInputKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatItemInputKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatItemInputKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItemInputKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItemInputKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatItemInputKindEnum] to String,
/// and [decode] dynamic data back to [ChatItemInputKindEnum].
class ChatItemInputKindEnumTypeTransformer {
  factory ChatItemInputKindEnumTypeTransformer() => _instance ??= const ChatItemInputKindEnumTypeTransformer._();

  const ChatItemInputKindEnumTypeTransformer._();

  String encode(ChatItemInputKindEnum data) => data._value;

  /// Returns the instance of [ChatItemInputKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatItemInputKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatItemInputKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'message': return ChatItemInputKindEnum.message;
        case r'call': return ChatItemInputKindEnum.call;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatItemInputKindEnumTypeTransformer? _instance;
}



enum ChatItemInputCallTypeEnum {
  audio._(r'audio'),
  video._(r'video'),
  ;

  /// Instantiate a new enum with the provided value.
  const ChatItemInputCallTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ChatItemInputCallTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ChatItemInputCallTypeEnum? fromJson(dynamic value) => ChatItemInputCallTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ChatItemInputCallTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ChatItemInputCallTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatItemInputCallTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatItemInputCallTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatItemInputCallTypeEnum] to String,
/// and [decode] dynamic data back to [ChatItemInputCallTypeEnum].
class ChatItemInputCallTypeEnumTypeTransformer {
  factory ChatItemInputCallTypeEnumTypeTransformer() => _instance ??= const ChatItemInputCallTypeEnumTypeTransformer._();

  const ChatItemInputCallTypeEnumTypeTransformer._();

  String encode(ChatItemInputCallTypeEnum data) => data._value;

  /// Returns the instance of [ChatItemInputCallTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatItemInputCallTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ChatItemInputCallTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'audio': return ChatItemInputCallTypeEnum.audio;
        case r'video': return ChatItemInputCallTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ChatItemInputCallTypeEnumTypeTransformer? _instance;
}


