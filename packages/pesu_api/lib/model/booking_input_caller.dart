//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class BookingInputCaller {
  /// Returns a new [BookingInputCaller] instance.
  BookingInputCaller({
    required this.id,
    required this.displayName,
    required this.avatarId,
  });

  String id;

  String displayName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingInputCaller &&
    other.id == id &&
    other.displayName == displayName &&
    other.avatarId == avatarId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (displayName.hashCode) +
    (avatarId.hashCode);

  @override
  String toString() => 'BookingInputCaller[id=$id, displayName=$displayName, avatarId=$avatarId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'displayName'] = this.displayName;
      json[r'avatarId'] = this.avatarId;
    return json;
  }

  /// Returns a new [BookingInputCaller] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingInputCaller? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "BookingInputCaller[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "BookingInputCaller[id]" has a null value in JSON.');
        assert(json.containsKey(r'displayName'), 'Required key "BookingInputCaller[displayName]" is missing from JSON.');
        assert(json[r'displayName'] != null, 'Required key "BookingInputCaller[displayName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "BookingInputCaller[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "BookingInputCaller[avatarId]" has a null value in JSON.');
        return true;
      }());

      return BookingInputCaller(
        id: mapValueOfType<String>(json, r'id')!,
        displayName: mapValueOfType<String>(json, r'displayName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
      );
    }
    return null;
  }

  static List<BookingInputCaller> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingInputCaller>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingInputCaller.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingInputCaller> mapFromJson(dynamic json) {
    final map = <String, BookingInputCaller>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingInputCaller.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingInputCaller-objects as value to a dart map
  static Map<String, List<BookingInputCaller>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingInputCaller>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingInputCaller.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'displayName',
    'avatarId',
  };
}

