//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LiveCardInput {
  /// Returns a new [LiveCardInput] instance.
  LiveCardInput({
    required this.id,
    required this.title,
    required this.language,
    required this.host,
    required this.viewers,
    required this.startedAt,
  });

  String id;

  String title;

  String language;

  LiveCardInputHost host;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int viewers;

  Object? startedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiveCardInput &&
    other.id == id &&
    other.title == title &&
    other.language == language &&
    other.host == host &&
    other.viewers == viewers &&
    other.startedAt == startedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (language.hashCode) +
    (host.hashCode) +
    (viewers.hashCode) +
    (startedAt == null ? 0 : startedAt!.hashCode);

  @override
  String toString() => 'LiveCardInput[id=$id, title=$title, language=$language, host=$host, viewers=$viewers, startedAt=$startedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'language'] = this.language;
      json[r'host'] = this.host;
      json[r'viewers'] = this.viewers;
    if (this.startedAt != null) {
      json[r'startedAt'] = this.startedAt;
    } else {
      json[r'startedAt'] = null;
    }
    return json;
  }

  /// Returns a new [LiveCardInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiveCardInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "LiveCardInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "LiveCardInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "LiveCardInput[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "LiveCardInput[title]" has a null value in JSON.');
        assert(json.containsKey(r'language'), 'Required key "LiveCardInput[language]" is missing from JSON.');
        assert(json[r'language'] != null, 'Required key "LiveCardInput[language]" has a null value in JSON.');
        assert(json.containsKey(r'host'), 'Required key "LiveCardInput[host]" is missing from JSON.');
        assert(json[r'host'] != null, 'Required key "LiveCardInput[host]" has a null value in JSON.');
        assert(json.containsKey(r'viewers'), 'Required key "LiveCardInput[viewers]" is missing from JSON.');
        assert(json[r'viewers'] != null, 'Required key "LiveCardInput[viewers]" has a null value in JSON.');
        assert(json.containsKey(r'startedAt'), 'Required key "LiveCardInput[startedAt]" is missing from JSON.');
        return true;
      }());

      return LiveCardInput(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        language: mapValueOfType<String>(json, r'language')!,
        host: LiveCardInputHost.fromJson(json[r'host'])!,
        viewers: mapValueOfType<int>(json, r'viewers')!,
        startedAt: mapValueOfType<Object>(json, r'startedAt'),
      );
    }
    return null;
  }

  static List<LiveCardInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiveCardInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiveCardInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiveCardInput> mapFromJson(dynamic json) {
    final map = <String, LiveCardInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiveCardInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiveCardInput-objects as value to a dart map
  static Map<String, List<LiveCardInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiveCardInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiveCardInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'language',
    'host',
    'viewers',
    'startedAt',
  };
}

