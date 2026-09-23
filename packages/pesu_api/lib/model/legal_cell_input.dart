//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LegalCellInput {
  /// Returns a new [LegalCellInput] instance.
  LegalCellInput({
    this.spans = const [],
  });

  List<LegalSpanInput> spans;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalCellInput &&
    _deepEquality.equals(other.spans, spans);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (spans.hashCode);

  @override
  String toString() => 'LegalCellInput[spans=$spans]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'spans'] = this.spans;
    return json;
  }

  /// Returns a new [LegalCellInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalCellInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'spans'), 'Required key "LegalCellInput[spans]" is missing from JSON.');
        assert(json[r'spans'] != null, 'Required key "LegalCellInput[spans]" has a null value in JSON.');
        return true;
      }());

      return LegalCellInput(
        spans: LegalSpanInput.listFromJson(json[r'spans']),
      );
    }
    return null;
  }

  static List<LegalCellInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalCellInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalCellInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalCellInput> mapFromJson(dynamic json) {
    final map = <String, LegalCellInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalCellInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalCellInput-objects as value to a dart map
  static Map<String, List<LegalCellInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalCellInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalCellInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'spans',
  };
}

