//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminDashboard200ResponseLanguagesInner {
  /// Returns a new [AdminDashboard200ResponseLanguagesInner] instance.
  AdminDashboard200ResponseLanguagesInner({
    required this.code,
    required this.name,
    required this.online,
    required this.inCall,
    required this.ringing,
  });

  String code;

  String name;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int online;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int inCall;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int ringing;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboard200ResponseLanguagesInner &&
    other.code == code &&
    other.name == name &&
    other.online == online &&
    other.inCall == inCall &&
    other.ringing == ringing;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (name.hashCode) +
    (online.hashCode) +
    (inCall.hashCode) +
    (ringing.hashCode);

  @override
  String toString() => 'AdminDashboard200ResponseLanguagesInner[code=$code, name=$name, online=$online, inCall=$inCall, ringing=$ringing]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
      json[r'name'] = this.name;
      json[r'online'] = this.online;
      json[r'inCall'] = this.inCall;
      json[r'ringing'] = this.ringing;
    return json;
  }

  /// Returns a new [AdminDashboard200ResponseLanguagesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboard200ResponseLanguagesInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'), 'Required key "AdminDashboard200ResponseLanguagesInner[code]" is missing from JSON.');
        assert(json[r'code'] != null, 'Required key "AdminDashboard200ResponseLanguagesInner[code]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "AdminDashboard200ResponseLanguagesInner[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "AdminDashboard200ResponseLanguagesInner[name]" has a null value in JSON.');
        assert(json.containsKey(r'online'), 'Required key "AdminDashboard200ResponseLanguagesInner[online]" is missing from JSON.');
        assert(json[r'online'] != null, 'Required key "AdminDashboard200ResponseLanguagesInner[online]" has a null value in JSON.');
        assert(json.containsKey(r'inCall'), 'Required key "AdminDashboard200ResponseLanguagesInner[inCall]" is missing from JSON.');
        assert(json[r'inCall'] != null, 'Required key "AdminDashboard200ResponseLanguagesInner[inCall]" has a null value in JSON.');
        assert(json.containsKey(r'ringing'), 'Required key "AdminDashboard200ResponseLanguagesInner[ringing]" is missing from JSON.');
        assert(json[r'ringing'] != null, 'Required key "AdminDashboard200ResponseLanguagesInner[ringing]" has a null value in JSON.');
        return true;
      }());

      return AdminDashboard200ResponseLanguagesInner(
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        online: mapValueOfType<int>(json, r'online')!,
        inCall: mapValueOfType<int>(json, r'inCall')!,
        ringing: mapValueOfType<int>(json, r'ringing')!,
      );
    }
    return null;
  }

  static List<AdminDashboard200ResponseLanguagesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboard200ResponseLanguagesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboard200ResponseLanguagesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboard200ResponseLanguagesInner> mapFromJson(dynamic json) {
    final map = <String, AdminDashboard200ResponseLanguagesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboard200ResponseLanguagesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboard200ResponseLanguagesInner-objects as value to a dart map
  static Map<String, List<AdminDashboard200ResponseLanguagesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboard200ResponseLanguagesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboard200ResponseLanguagesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'name',
    'online',
    'inCall',
    'ringing',
  };
}

