//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class CallHistorySummaryInput {
  /// Returns a new [CallHistorySummaryInput] instance.
  CallHistorySummaryInput({
    required this.calls,
    required this.connected,
    required this.missed,
    required this.talkSeconds,
    required this.coinsSpent,
    required this.paiseEarned,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int calls;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int connected;

  /// Not answered, declined or failed
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int missed;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int talkSeconds;

  /// Caller: coins charged minus refunds
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coinsSpent;

  /// Companion: earnings after reversals
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int paiseEarned;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallHistorySummaryInput &&
    other.calls == calls &&
    other.connected == connected &&
    other.missed == missed &&
    other.talkSeconds == talkSeconds &&
    other.coinsSpent == coinsSpent &&
    other.paiseEarned == paiseEarned;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calls.hashCode) +
    (connected.hashCode) +
    (missed.hashCode) +
    (talkSeconds.hashCode) +
    (coinsSpent.hashCode) +
    (paiseEarned.hashCode);

  @override
  String toString() => 'CallHistorySummaryInput[calls=$calls, connected=$connected, missed=$missed, talkSeconds=$talkSeconds, coinsSpent=$coinsSpent, paiseEarned=$paiseEarned]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'calls'] = this.calls;
      json[r'connected'] = this.connected;
      json[r'missed'] = this.missed;
      json[r'talkSeconds'] = this.talkSeconds;
      json[r'coinsSpent'] = this.coinsSpent;
      json[r'paiseEarned'] = this.paiseEarned;
    return json;
  }

  /// Returns a new [CallHistorySummaryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallHistorySummaryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'calls'), 'Required key "CallHistorySummaryInput[calls]" is missing from JSON.');
        assert(json[r'calls'] != null, 'Required key "CallHistorySummaryInput[calls]" has a null value in JSON.');
        assert(json.containsKey(r'connected'), 'Required key "CallHistorySummaryInput[connected]" is missing from JSON.');
        assert(json[r'connected'] != null, 'Required key "CallHistorySummaryInput[connected]" has a null value in JSON.');
        assert(json.containsKey(r'missed'), 'Required key "CallHistorySummaryInput[missed]" is missing from JSON.');
        assert(json[r'missed'] != null, 'Required key "CallHistorySummaryInput[missed]" has a null value in JSON.');
        assert(json.containsKey(r'talkSeconds'), 'Required key "CallHistorySummaryInput[talkSeconds]" is missing from JSON.');
        assert(json[r'talkSeconds'] != null, 'Required key "CallHistorySummaryInput[talkSeconds]" has a null value in JSON.');
        assert(json.containsKey(r'coinsSpent'), 'Required key "CallHistorySummaryInput[coinsSpent]" is missing from JSON.');
        assert(json[r'coinsSpent'] != null, 'Required key "CallHistorySummaryInput[coinsSpent]" has a null value in JSON.');
        assert(json.containsKey(r'paiseEarned'), 'Required key "CallHistorySummaryInput[paiseEarned]" is missing from JSON.');
        assert(json[r'paiseEarned'] != null, 'Required key "CallHistorySummaryInput[paiseEarned]" has a null value in JSON.');
        return true;
      }());

      return CallHistorySummaryInput(
        calls: mapValueOfType<int>(json, r'calls')!,
        connected: mapValueOfType<int>(json, r'connected')!,
        missed: mapValueOfType<int>(json, r'missed')!,
        talkSeconds: mapValueOfType<int>(json, r'talkSeconds')!,
        coinsSpent: mapValueOfType<int>(json, r'coinsSpent')!,
        paiseEarned: mapValueOfType<int>(json, r'paiseEarned')!,
      );
    }
    return null;
  }

  static List<CallHistorySummaryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallHistorySummaryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallHistorySummaryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallHistorySummaryInput> mapFromJson(dynamic json) {
    final map = <String, CallHistorySummaryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallHistorySummaryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallHistorySummaryInput-objects as value to a dart map
  static Map<String, List<CallHistorySummaryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallHistorySummaryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallHistorySummaryInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'calls',
    'connected',
    'missed',
    'talkSeconds',
    'coinsSpent',
    'paiseEarned',
  };
}

