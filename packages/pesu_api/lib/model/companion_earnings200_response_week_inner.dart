//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CompanionEarnings200ResponseWeekInner {
  /// Returns a new [CompanionEarnings200ResponseWeekInner] instance.
  CompanionEarnings200ResponseWeekInner({
    required this.date,
    required this.paise,
  });

  String date;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paise;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CompanionEarnings200ResponseWeekInner &&
    other.date == date &&
    other.paise == paise;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (paise.hashCode);

  @override
  String toString() => 'CompanionEarnings200ResponseWeekInner[date=$date, paise=$paise]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'paise'] = this.paise;
    return json;
  }

  /// Returns a new [CompanionEarnings200ResponseWeekInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CompanionEarnings200ResponseWeekInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'date'), 'Required key "CompanionEarnings200ResponseWeekInner[date]" is missing from JSON.');
        assert(json[r'date'] != null, 'Required key "CompanionEarnings200ResponseWeekInner[date]" has a null value in JSON.');
        assert(json.containsKey(r'paise'), 'Required key "CompanionEarnings200ResponseWeekInner[paise]" is missing from JSON.');
        assert(json[r'paise'] != null, 'Required key "CompanionEarnings200ResponseWeekInner[paise]" has a null value in JSON.');
        return true;
      }());

      return CompanionEarnings200ResponseWeekInner(
        date: mapValueOfType<String>(json, r'date')!,
        paise: mapValueOfType<int>(json, r'paise')!,
      );
    }
    return null;
  }

  static List<CompanionEarnings200ResponseWeekInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CompanionEarnings200ResponseWeekInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CompanionEarnings200ResponseWeekInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CompanionEarnings200ResponseWeekInner> mapFromJson(dynamic json) {
    final map = <String, CompanionEarnings200ResponseWeekInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CompanionEarnings200ResponseWeekInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CompanionEarnings200ResponseWeekInner-objects as value to a dart map
  static Map<String, List<CompanionEarnings200ResponseWeekInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CompanionEarnings200ResponseWeekInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CompanionEarnings200ResponseWeekInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'paise',
  };
}

