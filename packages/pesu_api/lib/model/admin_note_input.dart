//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminNoteInput {
  /// Returns a new [AdminNoteInput] instance.
  AdminNoteInput({
    required this.id,
    required this.createdAt,
    required this.author,
    required this.body,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  Object? createdAt;

  String author;

  String body;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminNoteInput &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.author == author &&
    other.body == body;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (author.hashCode) +
    (body.hashCode);

  @override
  String toString() => 'AdminNoteInput[id=$id, createdAt=$createdAt, author=$author, body=$body]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'author'] = this.author;
      json[r'body'] = this.body;
    return json;
  }

  /// Returns a new [AdminNoteInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminNoteInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminNoteInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminNoteInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminNoteInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'author'), 'Required key "AdminNoteInput[author]" is missing from JSON.');
        assert(json[r'author'] != null, 'Required key "AdminNoteInput[author]" has a null value in JSON.');
        assert(json.containsKey(r'body'), 'Required key "AdminNoteInput[body]" is missing from JSON.');
        assert(json[r'body'] != null, 'Required key "AdminNoteInput[body]" has a null value in JSON.');
        return true;
      }());

      return AdminNoteInput(
        id: mapValueOfType<int>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        author: mapValueOfType<String>(json, r'author')!,
        body: mapValueOfType<String>(json, r'body')!,
      );
    }
    return null;
  }

  static List<AdminNoteInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminNoteInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminNoteInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminNoteInput> mapFromJson(dynamic json) {
    final map = <String, AdminNoteInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminNoteInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminNoteInput-objects as value to a dart map
  static Map<String, List<AdminNoteInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminNoteInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminNoteInput.listFromJson(entry.value, growable: growable,);
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

