//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseLive {
  /// Returns a new [AdminDashboard200ResponseLive] instance.
  AdminDashboard200ResponseLive({
    required this.voiceCalls,
    required this.videoCalls,
    required this.ringing,
    required this.companionsOnline,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int voiceCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int videoCalls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ringing;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int companionsOnline;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseLive &&
    other.voiceCalls == voiceCalls &&
    other.videoCalls == videoCalls &&
    other.ringing == ringing &&
    other.companionsOnline == companionsOnline;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (voiceCalls.hashCode) +
    (videoCalls.hashCode) +
    (ringing.hashCode) +
    (companionsOnline.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseLive[voiceCalls=$voiceCalls, videoCalls=$videoCalls, ringing=$ringing, companionsOnline=$companionsOnline]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'voiceCalls'] = this.voiceCalls;
      json[r'videoCalls'] = this.videoCalls;
      json[r'ringing'] = this.ringing;
      json[r'companionsOnline'] = this.companionsOnline;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseLive] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseLive? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'voiceCalls'), 'Required key "AdminDashboard200ResponseLive[voiceCalls]" is missing from JSON.');
        assert(json[r'voiceCalls'] != null, 'Required key "AdminDashboard200ResponseLive[voiceCalls]" has a null value in JSON.');
        assert(json.containsKey(r'videoCalls'), 'Required key "AdminDashboard200ResponseLive[videoCalls]" is missing from JSON.');
        assert(json[r'videoCalls'] != null, 'Required key "AdminDashboard200ResponseLive[videoCalls]" has a null value in JSON.');
        assert(json.containsKey(r'ringing'), 'Required key "AdminDashboard200ResponseLive[ringing]" is missing from JSON.');
        assert(json[r'ringing'] != null, 'Required key "AdminDashboard200ResponseLive[ringing]" has a null value in JSON.');
        assert(json.containsKey(r'companionsOnline'), 'Required key "AdminDashboard200ResponseLive[companionsOnline]" is missing from JSON.');
        assert(json[r'companionsOnline'] != null, 'Required key "AdminDashboard200ResponseLive[companionsOnline]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseLive(
        voiceCalls: mapValueOfType<int>(json, r'voiceCalls')!,
        videoCalls: mapValueOfType<int>(json, r'videoCalls')!,
        ringing: mapValueOfType<int>(json, r'ringing')!,
        companionsOnline: mapValueOfType<int>(json, r'companionsOnline')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseLive> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseLive>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseLive.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseLive> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseLive>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseLive.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseLive-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseLive>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseLive>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseLive.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'voiceCalls',
    'videoCalls',
    'ringing',
    'companionsOnline',
  };
}

