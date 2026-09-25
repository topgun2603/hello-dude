//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PkSide {
  /// Returns a new [PkSide] instance.
  PkSide({
    required this.liveId,
    required this.hostId,
    required this.hostName,
    required this.avatarId,
    required this.score,
  });

  String liveId;

  String hostId;

  String hostName;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int avatarId;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int score;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PkSide &&
    other.liveId == liveId &&
    other.hostId == hostId &&
    other.hostName == hostName &&
    other.avatarId == avatarId &&
    other.score == score;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (liveId.hashCode) +
    (hostId.hashCode) +
    (hostName.hashCode) +
    (avatarId.hashCode) +
    (score.hashCode);

  @override
  String toString() => 'PkSide[liveId=$liveId, hostId=$hostId, hostName=$hostName, avatarId=$avatarId, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'liveId'] = this.liveId;
      json[r'hostId'] = this.hostId;
      json[r'hostName'] = this.hostName;
      json[r'avatarId'] = this.avatarId;
      json[r'score'] = this.score;
    return json;
  }

  /// Returns a new [PkSide] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PkSide? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'liveId'), 'Required key "PkSide[liveId]" is missing from JSON.');
        assert(json[r'liveId'] != null, 'Required key "PkSide[liveId]" has a null value in JSON.');
        assert(json.containsKey(r'hostId'), 'Required key "PkSide[hostId]" is missing from JSON.');
        assert(json[r'hostId'] != null, 'Required key "PkSide[hostId]" has a null value in JSON.');
        assert(json.containsKey(r'hostName'), 'Required key "PkSide[hostName]" is missing from JSON.');
        assert(json[r'hostName'] != null, 'Required key "PkSide[hostName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "PkSide[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "PkSide[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "PkSide[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "PkSide[score]" has a null value in JSON.');
        return true;
      }());

      return PkSide(
        liveId: mapValueOfType<String>(json, r'liveId')!,
        hostId: mapValueOfType<String>(json, r'hostId')!,
        hostName: mapValueOfType<String>(json, r'hostName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        score: mapValueOfType<int>(json, r'score')!,
      );
    }
    return null;
  }

  static List<PkSide> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkSide>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkSide.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PkSide> mapFromJson(dynamic json) {
    final map = <String, PkSide>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PkSide.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PkSide-objects as value to a dart map
  static Map<String, List<PkSide>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PkSide>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PkSide.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'liveId',
    'hostId',
    'hostName',
    'avatarId',
    'score',
  };
}

