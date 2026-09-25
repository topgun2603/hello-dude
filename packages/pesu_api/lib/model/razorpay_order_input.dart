//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RazorpayOrderInput {
  /// Returns a new [RazorpayOrderInput] instance.
  RazorpayOrderInput({
    required this.orderId,
    required this.keyId,
    required this.amountPaise,
    required this.currency,
    required this.coins,
    required this.name,
    required this.description,
    required this.phone,
  });

  String orderId;

  String keyId;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int amountPaise;

  String currency;

  /// Coins incl. bonus
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int coins;

  String name;

  String description;

  /// Prefill for checkout
  String? phone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RazorpayOrderInput &&
    other.orderId == orderId &&
    other.keyId == keyId &&
    other.amountPaise == amountPaise &&
    other.currency == currency &&
    other.coins == coins &&
    other.name == name &&
    other.description == description &&
    other.phone == phone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (orderId.hashCode) +
    (keyId.hashCode) +
    (amountPaise.hashCode) +
    (currency.hashCode) +
    (coins.hashCode) +
    (name.hashCode) +
    (description.hashCode) +
    (phone == null ? 0 : phone!.hashCode);

  @override
  String toString() => 'RazorpayOrderInput[orderId=$orderId, keyId=$keyId, amountPaise=$amountPaise, currency=$currency, coins=$coins, name=$name, description=$description, phone=$phone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'orderId'] = this.orderId;
      json[r'keyId'] = this.keyId;
      json[r'amountPaise'] = this.amountPaise;
      json[r'currency'] = this.currency;
      json[r'coins'] = this.coins;
      json[r'name'] = this.name;
      json[r'description'] = this.description;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    return json;
  }

  /// Returns a new [RazorpayOrderInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RazorpayOrderInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'orderId'), 'Required key "RazorpayOrderInput[orderId]" is missing from JSON.');
        assert(json[r'orderId'] != null, 'Required key "RazorpayOrderInput[orderId]" has a null value in JSON.');
        assert(json.containsKey(r'keyId'), 'Required key "RazorpayOrderInput[keyId]" is missing from JSON.');
        assert(json[r'keyId'] != null, 'Required key "RazorpayOrderInput[keyId]" has a null value in JSON.');
        assert(json.containsKey(r'amountPaise'), 'Required key "RazorpayOrderInput[amountPaise]" is missing from JSON.');
        assert(json[r'amountPaise'] != null, 'Required key "RazorpayOrderInput[amountPaise]" has a null value in JSON.');
        assert(json.containsKey(r'currency'), 'Required key "RazorpayOrderInput[currency]" is missing from JSON.');
        assert(json[r'currency'] != null, 'Required key "RazorpayOrderInput[currency]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "RazorpayOrderInput[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "RazorpayOrderInput[coins]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "RazorpayOrderInput[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "RazorpayOrderInput[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "RazorpayOrderInput[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "RazorpayOrderInput[description]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "RazorpayOrderInput[phone]" is missing from JSON.');
        return true;
      }());

      return RazorpayOrderInput(
        orderId: mapValueOfType<String>(json, r'orderId')!,
        keyId: mapValueOfType<String>(json, r'keyId')!,
        amountPaise: mapValueOfType<int>(json, r'amountPaise')!,
        currency: mapValueOfType<String>(json, r'currency')!,
        coins: mapValueOfType<int>(json, r'coins')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        phone: mapValueOfType<String>(json, r'phone'),
      );
    }
    return null;
  }

  static List<RazorpayOrderInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RazorpayOrderInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RazorpayOrderInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RazorpayOrderInput> mapFromJson(dynamic json) {
    final map = <String, RazorpayOrderInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RazorpayOrderInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RazorpayOrderInput-objects as value to a dart map
  static Map<String, List<RazorpayOrderInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RazorpayOrderInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RazorpayOrderInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'orderId',
    'keyId',
    'amountPaise',
    'currency',
    'coins',
    'name',
    'description',
    'phone',
  };
}

