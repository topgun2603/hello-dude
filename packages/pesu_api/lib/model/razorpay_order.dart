//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class RazorpayOrder {
  /// Returns a new [RazorpayOrder] instance.
  RazorpayOrder({
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
  bool operator ==(Object other) => identical(this, other) || other is RazorpayOrder &&
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
  String toString() => 'RazorpayOrder[orderId=$orderId, keyId=$keyId, amountPaise=$amountPaise, currency=$currency, coins=$coins, name=$name, description=$description, phone=$phone]';

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

  /// Returns a new [RazorpayOrder] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RazorpayOrder? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'orderId'), 'Required key "RazorpayOrder[orderId]" is missing from JSON.');
        assert(json[r'orderId'] != null, 'Required key "RazorpayOrder[orderId]" has a null value in JSON.');
        assert(json.containsKey(r'keyId'), 'Required key "RazorpayOrder[keyId]" is missing from JSON.');
        assert(json[r'keyId'] != null, 'Required key "RazorpayOrder[keyId]" has a null value in JSON.');
        assert(json.containsKey(r'amountPaise'), 'Required key "RazorpayOrder[amountPaise]" is missing from JSON.');
        assert(json[r'amountPaise'] != null, 'Required key "RazorpayOrder[amountPaise]" has a null value in JSON.');
        assert(json.containsKey(r'currency'), 'Required key "RazorpayOrder[currency]" is missing from JSON.');
        assert(json[r'currency'] != null, 'Required key "RazorpayOrder[currency]" has a null value in JSON.');
        assert(json.containsKey(r'coins'), 'Required key "RazorpayOrder[coins]" is missing from JSON.');
        assert(json[r'coins'] != null, 'Required key "RazorpayOrder[coins]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "RazorpayOrder[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "RazorpayOrder[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "RazorpayOrder[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "RazorpayOrder[description]" has a null value in JSON.');
        assert(json.containsKey(r'phone'), 'Required key "RazorpayOrder[phone]" is missing from JSON.');
        return true;
      }());

      return RazorpayOrder(
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

  static List<RazorpayOrder> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RazorpayOrder>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RazorpayOrder.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RazorpayOrder> mapFromJson(dynamic json) {
    final map = <String, RazorpayOrder>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RazorpayOrder.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RazorpayOrder-objects as value to a dart map
  static Map<String, List<RazorpayOrder>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RazorpayOrder>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RazorpayOrder.listFromJson(entry.value, growable: growable,);
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

