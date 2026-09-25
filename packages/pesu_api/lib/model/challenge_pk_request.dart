//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ChallengePkRequest {
  /// Returns a new [ChallengePkRequest] instance.
  ChallengePkRequest({
    required this.opponentLiveId,
  });

  String opponentLiveId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChallengePkRequest &&
    other.opponentLiveId == opponentLiveId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (opponentLiveId.hashCode);

  @override
  String toString() => 'ChallengePkRequest[opponentLiveId=$opponentLiveId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'opponentLiveId'] = this.opponentLiveId;
    return json;
  }

  /// Returns a new [ChallengePkRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChallengePkRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'opponentLiveId'), 'Required key "ChallengePkRequest[opponentLiveId]" is missing from JSON.');
        assert(json[r'opponentLiveId'] != null, 'Required key "ChallengePkRequest[opponentLiveId]" has a null value in JSON.');
        return true;
      }());

      return ChallengePkRequest(
        opponentLiveId: mapValueOfType<String>(json, r'opponentLiveId')!,
      );
    }
    return null;
  }

  static List<ChallengePkRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChallengePkRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChallengePkRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChallengePkRequest> mapFromJson(dynamic json) {
    final map = <String, ChallengePkRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChallengePkRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChallengePkRequest-objects as value to a dart map
  static Map<String, List<ChallengePkRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChallengePkRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChallengePkRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'opponentLiveId',
  };
}

