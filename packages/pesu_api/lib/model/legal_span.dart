//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LegalSpan {
  /// Returns a new [LegalSpan] instance.
  LegalSpan({
    required this.text,
    this.bold,
    this.italic,
    this.href,
  });

  String text;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? bold;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? italic;

  /// Another legal page id (e.g. \"privacy\") or an absolute URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? href;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalSpan &&
    other.text == text &&
    other.bold == bold &&
    other.italic == italic &&
    other.href == href;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (text.hashCode) +
    (bold == null ? 0 : bold!.hashCode) +
    (italic == null ? 0 : italic!.hashCode) +
    (href == null ? 0 : href!.hashCode);

  @override
  String toString() => 'LegalSpan[text=$text, bold=$bold, italic=$italic, href=$href]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'text'] = this.text;
    if (this.bold != null) {
      json[r'bold'] = this.bold;
    } else {
      json[r'bold'] = null;
    }
    if (this.italic != null) {
      json[r'italic'] = this.italic;
    } else {
      json[r'italic'] = null;
    }
    if (this.href != null) {
      json[r'href'] = this.href;
    } else {
      json[r'href'] = null;
    }
    return json;
  }

  /// Returns a new [LegalSpan] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalSpan? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'text'), 'Required key "LegalSpan[text]" is missing from JSON.');
        assert(json[r'text'] != null, 'Required key "LegalSpan[text]" has a null value in JSON.');
        return true;
      }());

      return LegalSpan(
        text: mapValueOfType<String>(json, r'text')!,
        bold: mapValueOfType<bool>(json, r'bold'),
        italic: mapValueOfType<bool>(json, r'italic'),
        href: mapValueOfType<String>(json, r'href'),
      );
    }
    return null;
  }

  static List<LegalSpan> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalSpan>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalSpan.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalSpan> mapFromJson(dynamic json) {
    final map = <String, LegalSpan>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalSpan.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalSpan-objects as value to a dart map
  static Map<String, List<LegalSpan>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalSpan>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalSpan.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'text',
  };
}

