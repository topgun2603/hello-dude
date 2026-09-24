//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetCoinHistory200Response {
  /// Returns a new [GetCoinHistory200Response] instance.
  GetCoinHistory200Response({
    this.items = const [],
    required this.nextCursor,
    required this.summary,
  });

  List<CoinHistoryItem> items;

  String? nextCursor;

  CoinHistorySummary summary;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCoinHistory200Response &&
    _deepEquality.equals(other.items, items) &&
    other.nextCursor == nextCursor &&
    other.summary == summary;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (items.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode) +
    (summary.hashCode);

  @override
  String toString() => 'GetCoinHistory200Response[items=$items, nextCursor=$nextCursor, summary=$summary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
      json[r'summary'] = this.summary;
    return json;
  }

  /// Returns a new [GetCoinHistory200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCoinHistory200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "GetCoinHistory200Response[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "GetCoinHistory200Response[items]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "GetCoinHistory200Response[nextCursor]" is missing from JSON.');
        assert(json.containsKey(r'summary'), 'Required key "GetCoinHistory200Response[summary]" is missing from JSON.');
        assert(json[r'summary'] != null, 'Required key "GetCoinHistory200Response[summary]" has a null value in JSON.');
        return true;
      }());

      return GetCoinHistory200Response(
        items: CoinHistoryItem.listFromJson(json[r'items']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
        summary: CoinHistorySummary.fromJson(json[r'summary'])!,
      );
    }
    return null;
  }

  static List<GetCoinHistory200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCoinHistory200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCoinHistory200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCoinHistory200Response> mapFromJson(dynamic json) {
    final map = <String, GetCoinHistory200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCoinHistory200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCoinHistory200Response-objects as value to a dart map
  static Map<String, List<GetCoinHistory200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCoinHistory200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCoinHistory200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'nextCursor',
    'summary',
  };
}

