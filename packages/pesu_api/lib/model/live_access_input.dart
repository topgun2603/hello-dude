//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveAccessInput {
  /// Returns a new [LiveAccessInput] instance.
  LiveAccessInput({
    required this.kind,
    required this.endsAt,
    required this.minutes,
  });

  LiveAccessInputKindEnum kind;

  /// When the free preview ends
  Object? endsAt;

  /// Minutes paid for in this live so far
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveAccessInput &&
    other.kind == kind &&
    other.endsAt == endsAt &&
    other.minutes == minutes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (kind.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (minutes.hashCode);

  @override
  String toString() => 'LiveAccessInput[kind=$kind, endsAt=$endsAt, minutes=$minutes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'kind'] = this.kind;
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
      json[r'minutes'] = this.minutes;
    return json;
  }

  /// Returns a new [LiveAccessInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveAccessInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'kind'), 'Required key "LiveAccessInput[kind]" is missing from JSON.');
        assert(json[r'kind'] != null, 'Required key "LiveAccessInput[kind]" has a null value in JSON.');
        assert(json.containsKey(r'endsAt'), 'Required key "LiveAccessInput[endsAt]" is missing from JSON.');
        assert(json.containsKey(r'minutes'), 'Required key "LiveAccessInput[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "LiveAccessInput[minutes]" has a null value in JSON.');
        return true;
      }());

      return LiveAccessInput(
        kind: LiveAccessInputKindEnum.fromJson(json[r'kind'])!,
        endsAt: mapValueOfType<Object>(json, r'endsAt'),
        minutes: mapValueOfType<int>(json, r'minutes')!,
      );
    }
    return null;
  }

  static List<LiveAccessInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveAccessInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveAccessInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveAccessInput> mapFromJson(dynamic json) {
    final map = <String, LiveAccessInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveAccessInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveAccessInput-objects as value to a dart map
  static Map<String, List<LiveAccessInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveAccessInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveAccessInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'kind',
    'endsAt',
    'minutes',
  };
}


enum LiveAccessInputKindEnum {
  host._(r'host'),
  preview._(r'preview'),
  paying._(r'paying'),
  none._(r'none'),
  ;

  /// Instantiate a new enum with the provided value.
  const LiveAccessInputKindEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LiveAccessInputKindEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LiveAccessInputKindEnum? fromJson(dynamic value) => LiveAccessInputKindEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LiveAccessInputKindEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LiveAccessInputKindEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveAccessInputKindEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveAccessInputKindEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LiveAccessInputKindEnum] to String,
/// and [decode] dynamic data back to [LiveAccessInputKindEnum].
class LiveAccessInputKindEnumTypeTransformer {
  factory LiveAccessInputKindEnumTypeTransformer() => _instance ??= const LiveAccessInputKindEnumTypeTransformer._();

  const LiveAccessInputKindEnumTypeTransformer._();

  String encode(LiveAccessInputKindEnum data) => data._value;

  /// Returns the instance of [LiveAccessInputKindEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LiveAccessInputKindEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LiveAccessInputKindEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'host': return LiveAccessInputKindEnum.host;
        case r'preview': return LiveAccessInputKindEnum.preview;
        case r'paying': return LiveAccessInputKindEnum.paying;
        case r'none': return LiveAccessInputKindEnum.none;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LiveAccessInputKindEnumTypeTransformer? _instance;
}


