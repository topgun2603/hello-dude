//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListNotifications200Response {
  /// Returns a new [ListNotifications200Response] instance.
  ListNotifications200Response({
    this.items = const [],
    required this.unread,
  });

  List<NotificationItem> items;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int unread;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListNotifications200Response &&
    _deepEquality.equals(other.items, items) &&
    other.unread == unread;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (items.hashCode) +
    (unread.hashCode);

  @override
  String toString() => 'ListNotifications200Response[items=$items, unread=$unread]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
      json[r'unread'] = this.unread;
    return json;
  }

  /// Returns a new [ListNotifications200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListNotifications200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "ListNotifications200Response[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "ListNotifications200Response[items]" has a null value in JSON.');
        assert(json.containsKey(r'unread'), 'Required key "ListNotifications200Response[unread]" is missing from JSON.');
        assert(json[r'unread'] != null, 'Required key "ListNotifications200Response[unread]" has a null value in JSON.');
        return true;
      }());

      return ListNotifications200Response(
        items: NotificationItem.listFromJson(json[r'items']),
        unread: mapValueOfType<int>(json, r'unread')!,
      );
    }
    return null;
  }

  static List<ListNotifications200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListNotifications200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListNotifications200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListNotifications200Response> mapFromJson(dynamic json) {
    final map = <String, ListNotifications200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListNotifications200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListNotifications200Response-objects as value to a dart map
  static Map<String, List<ListNotifications200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListNotifications200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListNotifications200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'unread',
  };
}

