//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminNote {
  /// Returns a new [AdminNote] instance.
  AdminNote({
    required this.id,
    required this.createdAt,
    required this.author,
    required this.body,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  DateTime createdAt;

  String author;

  String body;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminNote &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.author == author &&
    other.body == body;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (author.hashCode) +
    (body.hashCode);

  @override
  String toString() => 'AdminNote[id=$id, createdAt=$createdAt, author=$author, body=$body]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'author'] = this.author;
      json[r'body'] = this.body;
    return json;
  }

  /// Returns a new [AdminNote] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminNote? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminNote[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminNote[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminNote[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminNote[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'author'), 'Required key "AdminNote[author]" is missing from JSON.');
        assert(json[r'author'] != null, 'Required key "AdminNote[author]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AdminNote[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminNote[body]" has a null value in JSON.');
        return true;
      }());

      return AdminNote(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        author: mapValueOfType<String>(json, r'author')!,
        body: mapValueOfType<String>(json, r'body')!,
      );
    }
    return null;
  }

  static List<AdminNote> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminNote>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminNote.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminNote> mapFromJson(dynamic json) {
    final map = <String, AdminNote>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminNote.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminNote-objects as value to a dart map
  static Map<String, List<AdminNote>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminNote>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminNote.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'author',
    'body',
  };
}

