//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LegalRowInput {
  /// Returns a new [LegalRowInput] instance.
  LegalRowInput({
    this.cells = const [],
  });

  List<LegalCellInput> cells;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalRowInput &&
    _deepEquality.equals(other.cells, cells);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (cells.hashCode);

  @override
  String toString() => 'LegalRowInput[cells=$cells]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'cells'] = this.cells;
    return json;
  }

  /// Returns a new [LegalRowInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalRowInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'cells'), 'Required key "LegalRowInput[cells]" is missing from JSON.');
        assert(json[r'cells'] != null, 'Required key "LegalRowInput[cells]" has a null value in JSON.');
        return true;
      }());

      return LegalRowInput(
        cells: LegalCellInput.listFromJson(json[r'cells']),
      );
    }
    return null;
  }

  static List<LegalRowInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalRowInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalRowInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalRowInput> mapFromJson(dynamic json) {
    final map = <String, LegalRowInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalRowInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalRowInput-objects as value to a dart map
  static Map<String, List<LegalRowInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalRowInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalRowInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cells',
  };
}

