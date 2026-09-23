//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class DeleteAccountRequest {
  /// Returns a new [DeleteAccountRequest] instance.
  DeleteAccountRequest({
    required this.confirm,
  });

  DeleteAccountRequestConfirmEnum confirm;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeleteAccountRequest &&
    other.confirm == confirm;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (confirm.hashCode);

  @override
  String toString() => 'DeleteAccountRequest[confirm=$confirm]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'confirm'] = this.confirm;
    return json;
  }

  /// Returns a new [DeleteAccountRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DeleteAccountRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'confirm'), 'Required key "DeleteAccountRequest[confirm]" is missing from JSON.');
        assert(json[r'confirm'] != null, 'Required key "DeleteAccountRequest[confirm]" has a null value in JSON.');
        return true;
      }());

      return DeleteAccountRequest(
        confirm: DeleteAccountRequestConfirmEnum.fromJson(json[r'confirm'])!,
      );
    }
    return null;
  }

  static List<DeleteAccountRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeleteAccountRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeleteAccountRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DeleteAccountRequest> mapFromJson(dynamic json) {
    final map = <String, DeleteAccountRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DeleteAccountRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DeleteAccountRequest-objects as value to a dart map
  static Map<String, List<DeleteAccountRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DeleteAccountRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DeleteAccountRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'confirm',
  };
}


enum DeleteAccountRequestConfirmEnum {
  DELETE._(r'DELETE'),
  ;

  /// Instantiate a new enum with the provided value.
  const DeleteAccountRequestConfirmEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [DeleteAccountRequestConfirmEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static DeleteAccountRequestConfirmEnum? fromJson(dynamic value) => DeleteAccountRequestConfirmEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [DeleteAccountRequestConfirmEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<DeleteAccountRequestConfirmEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeleteAccountRequestConfirmEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeleteAccountRequestConfirmEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DeleteAccountRequestConfirmEnum] to String,
/// and [decode] dynamic data back to [DeleteAccountRequestConfirmEnum].
class DeleteAccountRequestConfirmEnumTypeTransformer {
  factory DeleteAccountRequestConfirmEnumTypeTransformer() => _instance ??= const DeleteAccountRequestConfirmEnumTypeTransformer._();

  const DeleteAccountRequestConfirmEnumTypeTransformer._();

  String encode(DeleteAccountRequestConfirmEnum data) => data._value;

  /// Returns the instance of [DeleteAccountRequestConfirmEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DeleteAccountRequestConfirmEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is DeleteAccountRequestConfirmEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'DELETE': return DeleteAccountRequestConfirmEnum.DELETE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static DeleteAccountRequestConfirmEnumTypeTransformer? _instance;
}


