//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class PkSideInput {
  /// Returns a new [PkSideInput] instance.
  PkSideInput({
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
  bool operator ==(Object other) => identical(this, other) || other is PkSideInput &&
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
  String toString() => 'PkSideInput[liveId=$liveId, hostId=$hostId, hostName=$hostName, avatarId=$avatarId, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'liveId'] = this.liveId;
      json[r'hostId'] = this.hostId;
      json[r'hostName'] = this.hostName;
      json[r'avatarId'] = this.avatarId;
      json[r'score'] = this.score;
    return json;
  }

  /// Returns a new [PkSideInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PkSideInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'liveId'), 'Required key "PkSideInput[liveId]" is missing from JSON.');
        assert(json[r'liveId'] != null, 'Required key "PkSideInput[liveId]" has a null value in JSON.');
        assert(json.containsKey(r'hostId'), 'Required key "PkSideInput[hostId]" is missing from JSON.');
        assert(json[r'hostId'] != null, 'Required key "PkSideInput[hostId]" has a null value in JSON.');
        assert(json.containsKey(r'hostName'), 'Required key "PkSideInput[hostName]" is missing from JSON.');
        assert(json[r'hostName'] != null, 'Required key "PkSideInput[hostName]" has a null value in JSON.');
        assert(json.containsKey(r'avatarId'), 'Required key "PkSideInput[avatarId]" is missing from JSON.');
        assert(json[r'avatarId'] != null, 'Required key "PkSideInput[avatarId]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "PkSideInput[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "PkSideInput[score]" has a null value in JSON.');
        return true;
      }());

      return PkSideInput(
        liveId: mapValueOfType<String>(json, r'liveId')!,
        hostId: mapValueOfType<String>(json, r'hostId')!,
        hostName: mapValueOfType<String>(json, r'hostName')!,
        avatarId: mapValueOfType<int>(json, r'avatarId')!,
        score: mapValueOfType<int>(json, r'score')!,
      );
    }
    return null;
  }

  static List<PkSideInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PkSideInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PkSideInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PkSideInput> mapFromJson(dynamic json) {
    final map = <String, PkSideInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PkSideInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PkSideInput-objects as value to a dart map
  static Map<String, List<PkSideInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PkSideInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PkSideInput.listFromJson(entry.value, growable: growable,);
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

