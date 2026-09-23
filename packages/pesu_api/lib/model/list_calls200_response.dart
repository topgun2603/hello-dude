//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListCalls200Response {
  /// Returns a new [ListCalls200Response] instance.
  ListCalls200Response({
    this.calls = const [],
    required this.nextBefore,
  });

  List<CallSummary> calls;

  DateTime? nextBefore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListCalls200Response &&
    _deepEquality.equals(other.calls, calls) &&
    other.nextBefore == nextBefore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calls.hashCode) +
    (nextBefore == null ? 0 : nextBefore!.hashCode);

  @override
  String toString() => 'ListCalls200Response[calls=$calls, nextBefore=$nextBefore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'calls'] = this.calls;
    if (this.nextBefore != null) {
      json[r'nextBefore'] = this.nextBefore!.toUtc().toIso8601String();
    } else {
      json[r'nextBefore'] = null;
    }
    return json;
  }

  /// Returns a new [ListCalls200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListCalls200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'calls'), 'Required key "ListCalls200Response[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "ListCalls200Response[calls]" has a null value in JSON.');
        assert(json.containsKey(r'nextBefore'), 'Required key "ListCalls200Response[nextBefore]" is missing from JSON.');
        return true;
      }());

      return ListCalls200Response(
        calls: CallSummary.listFromJson(json[r'calls']),
        nextBefore: mapDateTime(json, r'nextBefore', r''),
      );
    }
    return null;
  }

  static List<ListCalls200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListCalls200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListCalls200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListCalls200Response> mapFromJson(dynamic json) {
    final map = <String, ListCalls200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListCalls200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListCalls200Response-objects as value to a dart map
  static Map<String, List<ListCalls200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListCalls200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListCalls200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'calls',
    'nextBefore',
  };
}

