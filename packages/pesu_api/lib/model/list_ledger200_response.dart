//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListLedger200Response {
  /// Returns a new [ListLedger200Response] instance.
  ListLedger200Response({
    this.entries = const [],
    required this.nextBefore,
  });

  List<LedgerEntry> entries;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int? nextBefore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListLedger200Response &&
    _deepEquality.equals(other.entries, entries) &&
    other.nextBefore == nextBefore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (entries.hashCode) +
    (nextBefore == null ? 0 : nextBefore!.hashCode);

  @override
  String toString() => 'ListLedger200Response[entries=$entries, nextBefore=$nextBefore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'entries'] = this.entries;
    if (this.nextBefore != null) {
      json[r'nextBefore'] = this.nextBefore;
    } else {
      json[r'nextBefore'] = null;
    }
    return json;
  }

  /// Returns a new [ListLedger200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListLedger200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'entries'), 'Required key "ListLedger200Response[entries]" is missing from JSON.');
        assert(json[r'entries'] != null, 'Required key "ListLedger200Response[entries]" has a null value in JSON.');
        assert(json.containsKey(r'nextBefore'), 'Required key "ListLedger200Response[nextBefore]" is missing from JSON.');
        return true;
      }());

      return ListLedger200Response(
        entries: LedgerEntry.listFromJson(json[r'entries']),
        nextBefore: mapValueOfType<int>(json, r'nextBefore'),
      );
    }
    return null;
  }

  static List<ListLedger200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListLedger200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListLedger200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListLedger200Response> mapFromJson(dynamic json) {
    final map = <String, ListLedger200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListLedger200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListLedger200Response-objects as value to a dart map
  static Map<String, List<ListLedger200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListLedger200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListLedger200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'entries',
    'nextBefore',
  };
}

