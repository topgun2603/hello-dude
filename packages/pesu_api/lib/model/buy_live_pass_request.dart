//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class BuyLivePassRequest {
  /// Returns a new [BuyLivePassRequest] instance.
  BuyLivePassRequest({
    required this.minutes,
    required this.clientRef,
  });

  /// 15 or 60
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minutes;

  String clientRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BuyLivePassRequest &&
    other.minutes == minutes &&
    other.clientRef == clientRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minutes.hashCode) +
    (clientRef.hashCode);

  @override
  String toString() => 'BuyLivePassRequest[minutes=$minutes, clientRef=$clientRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'minutes'] = this.minutes;
      json[r'clientRef'] = this.clientRef;
    return json;
  }

  /// Returns a new [BuyLivePassRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BuyLivePassRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'minutes'), 'Required key "BuyLivePassRequest[minutes]" is missing from JSON.');
        assert(json[r'minutes'] != null, 'Required key "BuyLivePassRequest[minutes]" has a null value in JSON.');
        assert(json.containsKey(r'clientRef'), 'Required key "BuyLivePassRequest[clientRef]" is missing from JSON.');
        assert(json[r'clientRef'] != null, 'Required key "BuyLivePassRequest[clientRef]" has a null value in JSON.');
        return true;
      }());

      return BuyLivePassRequest(
        minutes: mapValueOfType<int>(json, r'minutes')!,
        clientRef: mapValueOfType<String>(json, r'clientRef')!,
      );
    }
    return null;
  }

  static List<BuyLivePassRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BuyLivePassRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BuyLivePassRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BuyLivePassRequest> mapFromJson(dynamic json) {
    final map = <String, BuyLivePassRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BuyLivePassRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BuyLivePassRequest-objects as value to a dart map
  static Map<String, List<BuyLivePassRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BuyLivePassRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BuyLivePassRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'minutes',
    'clientRef',
  };
}

