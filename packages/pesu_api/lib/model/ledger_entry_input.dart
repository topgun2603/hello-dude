//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class LedgerEntryInput {
  /// Returns a new [LedgerEntryInput] instance.
  LedgerEntryInput({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.callId,
    required this.note,
    required this.createdAt,
  });

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int id;

  String type;

  /// Signed: negative = debit
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int amount;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int balanceAfter;

  String? callId;

  String? note;

  Object? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LedgerEntryInput &&
    other.id == id &&
    other.type == type &&
    other.amount == amount &&
    other.balanceAfter == balanceAfter &&
    other.callId == callId &&
    other.note == note &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode) +
    (amount.hashCode) +
    (balanceAfter.hashCode) +
    (callId == null ? 0 : callId!.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'LedgerEntryInput[id=$id, type=$type, amount=$amount, balanceAfter=$balanceAfter, callId=$callId, note=$note, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'amount'] = this.amount;
      json[r'balanceAfter'] = this.balanceAfter;
    if (this.callId != null) {
      json[r'callId'] = this.callId;
    } else {
      json[r'callId'] = null;
    }
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [LedgerEntryInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LedgerEntryInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "LedgerEntryInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "LedgerEntryInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "LedgerEntryInput[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "LedgerEntryInput[type]" has a null value in JSON.');
        assert(json.containsKey(r'amount'), 'Required key "LedgerEntryInput[amount]" is missing from JSON.');
        assert(json[r'amount'] != null, 'Required key "LedgerEntryInput[amount]" has a null value in JSON.');
        assert(json.containsKey(r'balanceAfter'), 'Required key "LedgerEntryInput[balanceAfter]" is missing from JSON.');
        assert(json[r'balanceAfter'] != null, 'Required key "LedgerEntryInput[balanceAfter]" has a null value in JSON.');
        assert(json.containsKey(r'callId'), 'Required key "LedgerEntryInput[callId]" is missing from JSON.');
        assert(json.containsKey(r'note'), 'Required key "LedgerEntryInput[note]" is missing from JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "LedgerEntryInput[createdAt]" is missing from JSON.');
        return true;
      }());

      return LedgerEntryInput(
        id: mapValueOfType<int>(json, r'id')!,
        type: mapValueOfType<String>(json, r'type')!,
        amount: mapValueOfType<int>(json, r'amount')!,
        balanceAfter: mapValueOfType<int>(json, r'balanceAfter')!,
        callId: mapValueOfType<String>(json, r'callId'),
        note: mapValueOfType<String>(json, r'note'),
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<LedgerEntryInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LedgerEntryInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LedgerEntryInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LedgerEntryInput> mapFromJson(dynamic json) {
    final map = <String, LedgerEntryInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LedgerEntryInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LedgerEntryInput-objects as value to a dart map
  static Map<String, List<LedgerEntryInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LedgerEntryInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LedgerEntryInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
    'amount',
    'balanceAfter',
    'callId',
    'note',
    'createdAt',
  };
}

