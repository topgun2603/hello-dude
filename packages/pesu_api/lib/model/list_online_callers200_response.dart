//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListOnlineCallers200Response {
  /// Returns a new [ListOnlineCallers200Response] instance.
  ListOnlineCallers200Response({
    this.callers = const [],
    required this.canInvite,
  });

  List<OnlineCaller> callers;

  /// You're online and free
  bool canInvite;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListOnlineCallers200Response &&
    _deepEquality.equals(other.callers, callers) &&
    other.canInvite == canInvite;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callers.hashCode) +
    (canInvite.hashCode);

  @override
  String toString() => 'ListOnlineCallers200Response[callers=$callers, canInvite=$canInvite]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'callers'] = this.callers;
      json[r'canInvite'] = this.canInvite;
    return json;
  }

  /// Returns a new [ListOnlineCallers200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListOnlineCallers200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'callers'), 'Required key "ListOnlineCallers200Response[callers]" is missing from JSON.');
        assert(json[r'callers'] != null, 'Required key "ListOnlineCallers200Response[callers]" has a null value in JSON.');
        assert(json.containsKey(r'canInvite'), 'Required key "ListOnlineCallers200Response[canInvite]" is missing from JSON.');
        assert(json[r'canInvite'] != null, 'Required key "ListOnlineCallers200Response[canInvite]" has a null value in JSON.');
        return true;
      }());

      return ListOnlineCallers200Response(
        callers: OnlineCaller.listFromJson(json[r'callers']),
        canInvite: mapValueOfType<bool>(json, r'canInvite')!,
      );
    }
    return null;
  }

  static List<ListOnlineCallers200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListOnlineCallers200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListOnlineCallers200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListOnlineCallers200Response> mapFromJson(dynamic json) {
    final map = <String, ListOnlineCallers200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListOnlineCallers200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListOnlineCallers200Response-objects as value to a dart map
  static Map<String, List<ListOnlineCallers200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListOnlineCallers200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListOnlineCallers200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'callers',
    'canInvite',
  };
}

