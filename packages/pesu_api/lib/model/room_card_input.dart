//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RoomCardInput {
  /// Returns a new [RoomCardInput] instance.
  RoomCardInput({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryName,
    required this.language,
    required this.host,
    required this.listeners,
    this.faces = const [],
    required this.createdAt,
  });

  String id;

  String title;

  String category;

  String categoryName;

  String language;

  RoomCardInputHost host;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int listeners;

  /// A few people in the room, for the stacked avatars
  List<RoomCardInputHost> faces;

  Object? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomCardInput &&
    other.id == id &&
    other.title == title &&
    other.category == category &&
    other.categoryName == categoryName &&
    other.language == language &&
    other.host == host &&
    other.listeners == listeners &&
    _deepEquality.equals(other.faces, faces) &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (category.hashCode) +
    (categoryName.hashCode) +
    (language.hashCode) +
    (host.hashCode) +
    (listeners.hashCode) +
    (faces.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'RoomCardInput[id=$id, title=$title, category=$category, categoryName=$categoryName, language=$language, host=$host, listeners=$listeners, faces=$faces, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'category'] = this.category;
      json[r'categoryName'] = this.categoryName;
      json[r'language'] = this.language;
      json[r'host'] = this.host;
      json[r'listeners'] = this.listeners;
      json[r'faces'] = this.faces;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [RoomCardInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RoomCardInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RoomCardInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RoomCardInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "RoomCardInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "RoomCardInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "RoomCardInput[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "RoomCardInput[category]" has a null value in JSON.');
        assert(json.containsKey(r'categoryName'), 'Required key "RoomCardInput[categoryName]" is missing from JSON.');
        assert(json[r'categoryName'] != null, 'Required key "RoomCardInput[categoryName]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "RoomCardInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "RoomCardInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "RoomCardInput[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "RoomCardInput[host]" has a null value in JSON.');
        assert(json.containsKey(r'listeners'), 'Required key "RoomCardInput[listeners]" is missing from JSON.');
        assert(json[r'listeners'] != null, 'Required key "RoomCardInput[listeners]" has a null value in JSON.');
        assert(json.containsKey(r'faces'), 'Required key "RoomCardInput[faces]" is missing from JSON.');
        assert(json[r'faces'] != null, 'Required key "RoomCardInput[faces]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "RoomCardInput[createdAt]" is missing from JSON.');
        return true;
      }());

      return RoomCardInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        category: mapValueOfType<String>(json, r'category')!,
        categoryName: mapValueOfType<String>(json, r'categoryName')!,
        language: mapValueOfType<String>(json, r'language')!,
        host: RoomCardInputHost.fromJson(json[r'host'])!,
        listeners: mapValueOfType<int>(json, r'listeners')!,
        faces: RoomCardInputHost.listFromJson(json[r'faces']),
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<RoomCardInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RoomCardInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RoomCardInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RoomCardInput> mapFromJson(dynamic json) {
    final map = <String, RoomCardInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RoomCardInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RoomCardInput-objects as value to a dart map
  static Map<String, List<RoomCardInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RoomCardInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RoomCardInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'category',
    'categoryName',
    'language',
    'host',
    'listeners',
    'faces',
    'createdAt',
  };
}

