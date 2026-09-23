//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LegalBlockInput {
  /// Returns a new [LegalBlockInput] instance.
  LegalBlockInput({
    required this.type,
    this.spans = const [],
    this.items = const [],
    this.head = const [],
    this.rows = const [],
  });

  LegalBlockInputTypeEnum type;

  /// h1, h2, p
  List<LegalSpanInput> spans;

  /// ul, ol
  List<LegalCellInput> items;

  /// table header cells
  List<LegalCellInput> head;

  /// table rows
  List<LegalRowInput> rows;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalBlockInput &&
    other.type == type &&
    _deepEquality.equals(other.spans, spans) &&
    _deepEquality.equals(other.items, items) &&
    _deepEquality.equals(other.head, head) &&
    _deepEquality.equals(other.rows, rows);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (spans.hashCode) +
    (items.hashCode) +
    (head.hashCode) +
    (rows.hashCode);

  @override
  String toString() => 'LegalBlockInput[type=$type, spans=$spans, items=$items, head=$head, rows=$rows]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'spans'] = this.spans;
      json[r'items'] = this.items;
      json[r'head'] = this.head;
      json[r'rows'] = this.rows;
    return json;
  }

  /// Returns a new [LegalBlockInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalBlockInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'type'), 'Required key "LegalBlockInput[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "LegalBlockInput[type]" has a null value in JSON.');
        return true;
      }());

      return LegalBlockInput(
        type: LegalBlockInputTypeEnum.fromJson(json[r'type'])!,
        spans: LegalSpanInput.listFromJson(json[r'spans']),
        items: LegalCellInput.listFromJson(json[r'items']),
        head: LegalCellInput.listFromJson(json[r'head']),
        rows: LegalRowInput.listFromJson(json[r'rows']),
      );
    }
    return null;
  }

  static List<LegalBlockInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalBlockInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalBlockInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalBlockInput> mapFromJson(dynamic json) {
    final map = <String, LegalBlockInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalBlockInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalBlockInput-objects as value to a dart map
  static Map<String, List<LegalBlockInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalBlockInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalBlockInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
  };
}


enum LegalBlockInputTypeEnum {
  h1._(r'h1'),
  h2._(r'h2'),
  p._(r'p'),
  ul._(r'ul'),
  ol._(r'ol'),
  table._(r'table'),
  ;

  /// Instantiate a new enum with the provided value.
  const LegalBlockInputTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LegalBlockInputTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LegalBlockInputTypeEnum? fromJson(dynamic value) => LegalBlockInputTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LegalBlockInputTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LegalBlockInputTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalBlockInputTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalBlockInputTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LegalBlockInputTypeEnum] to String,
/// and [decode] dynamic data back to [LegalBlockInputTypeEnum].
class LegalBlockInputTypeEnumTypeTransformer {
  factory LegalBlockInputTypeEnumTypeTransformer() => _instance ??= const LegalBlockInputTypeEnumTypeTransformer._();

  const LegalBlockInputTypeEnumTypeTransformer._();

  String encode(LegalBlockInputTypeEnum data) => data._value;

  /// Returns the instance of [LegalBlockInputTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LegalBlockInputTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LegalBlockInputTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'h1': return LegalBlockInputTypeEnum.h1;
        case r'h2': return LegalBlockInputTypeEnum.h2;
        case r'p': return LegalBlockInputTypeEnum.p;
        case r'ul': return LegalBlockInputTypeEnum.ul;
        case r'ol': return LegalBlockInputTypeEnum.ol;
        case r'table': return LegalBlockInputTypeEnum.table;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LegalBlockInputTypeEnumTypeTransformer? _instance;
}


