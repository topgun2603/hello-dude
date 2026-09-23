//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LegalBlock {
  /// Returns a new [LegalBlock] instance.
  LegalBlock({
    required this.type,
    this.spans = const [],
    this.items = const [],
    this.head = const [],
    this.rows = const [],
  });

  LegalBlockTypeEnum type;

  /// h1, h2, p
  List<LegalSpan> spans;

  /// ul, ol
  List<LegalCell> items;

  /// table header cells
  List<LegalCell> head;

  /// table rows
  List<LegalRow> rows;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalBlock &&
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
  String toString() => 'LegalBlock[type=$type, spans=$spans, items=$items, head=$head, rows=$rows]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'spans'] = this.spans;
      json[r'items'] = this.items;
      json[r'head'] = this.head;
      json[r'rows'] = this.rows;
    return json;
  }

  /// Returns a new [LegalBlock] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalBlock? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'type'), 'Required key "LegalBlock[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "LegalBlock[type]" has a null value in JSON.');
        return true;
      }());

      return LegalBlock(
        type: LegalBlockTypeEnum.fromJson(json[r'type'])!,
        spans: LegalSpan.listFromJson(json[r'spans']),
        items: LegalCell.listFromJson(json[r'items']),
        head: LegalCell.listFromJson(json[r'head']),
        rows: LegalRow.listFromJson(json[r'rows']),
      );
    }
    return null;
  }

  static List<LegalBlock> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalBlock>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalBlock.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalBlock> mapFromJson(dynamic json) {
    final map = <String, LegalBlock>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalBlock.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalBlock-objects as value to a dart map
  static Map<String, List<LegalBlock>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalBlock>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalBlock.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
  };
}


enum LegalBlockTypeEnum {
  h1._(r'h1'),
  h2._(r'h2'),
  p._(r'p'),
  ul._(r'ul'),
  ol._(r'ol'),
  table._(r'table'),
  ;

  /// Instantiate a new enum with the provided value.
  const LegalBlockTypeEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [LegalBlockTypeEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static LegalBlockTypeEnum? fromJson(dynamic value) => LegalBlockTypeEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [LegalBlockTypeEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<LegalBlockTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalBlockTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalBlockTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LegalBlockTypeEnum] to String,
/// and [decode] dynamic data back to [LegalBlockTypeEnum].
class LegalBlockTypeEnumTypeTransformer {
  factory LegalBlockTypeEnumTypeTransformer() => _instance ??= const LegalBlockTypeEnumTypeTransformer._();

  const LegalBlockTypeEnumTypeTransformer._();

  String encode(LegalBlockTypeEnum data) => data._value;

  /// Returns the instance of [LegalBlockTypeEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LegalBlockTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is LegalBlockTypeEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'h1': return LegalBlockTypeEnum.h1;
        case r'h2': return LegalBlockTypeEnum.h2;
        case r'p': return LegalBlockTypeEnum.p;
        case r'ul': return LegalBlockTypeEnum.ul;
        case r'ol': return LegalBlockTypeEnum.ol;
        case r'table': return LegalBlockTypeEnum.table;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static LegalBlockTypeEnumTypeTransformer? _instance;
}


