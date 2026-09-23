//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class GetLegalPage200Response {
  /// Returns a new [GetLegalPage200Response] instance.
  GetLegalPage200Response({
    required this.id,
    required this.title,
    required this.draft,
    this.blocks = const [],
  });

  GetLegalPage200ResponseIdEnum id;

  String title;

  bool draft;

  List<LegalBlock> blocks;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetLegalPage200Response &&
    other.id == id &&
    other.title == title &&
    other.draft == draft &&
    _deepEquality.equals(other.blocks, blocks);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (draft.hashCode) +
    (blocks.hashCode);

  @override
  String toString() => 'GetLegalPage200Response[id=$id, title=$title, draft=$draft, blocks=$blocks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'draft'] = this.draft;
      json[r'blocks'] = this.blocks;
    return json;
  }

  /// Returns a new [GetLegalPage200Response] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetLegalPage200Response? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "GetLegalPage200Response[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "GetLegalPage200Response[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "GetLegalPage200Response[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "GetLegalPage200Response[title]" has a null value in JSON.');
        assert(json.containsKey(r'draft'), 'Required key "GetLegalPage200Response[draft]" is missing from JSON.');
        assert(json[r'draft'] != null, 'Required key "GetLegalPage200Response[draft]" has a null value in JSON.');
        assert(json.containsKey(r'blocks'), 'Required key "GetLegalPage200Response[blocks]" is missing from JSON.');
        assert(json[r'blocks'] != null, 'Required key "GetLegalPage200Response[blocks]" has a null value in JSON.');
        return true;
      }());

      return GetLegalPage200Response(
        id: GetLegalPage200ResponseIdEnum.fromJson(json[r'id'])!,
        title: mapValueOfType<String>(json, r'title')!,
        draft: mapValueOfType<bool>(json, r'draft')!,
        blocks: LegalBlock.listFromJson(json[r'blocks']),
      );
    }
    return null;
  }

  static List<GetLegalPage200Response> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetLegalPage200Response>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetLegalPage200Response.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetLegalPage200Response> mapFromJson(dynamic json) {
    final map = <String, GetLegalPage200Response>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetLegalPage200Response.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetLegalPage200Response-objects as value to a dart map
  static Map<String, List<GetLegalPage200Response>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetLegalPage200Response>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetLegalPage200Response.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'draft',
    'blocks',
  };
}


enum GetLegalPage200ResponseIdEnum {
  terms._(r'terms'),
  privacy._(r'privacy'),
  community._(r'community'),
  grievance._(r'grievance'),
  deleteAccount._(r'delete-account'),
  ;

  /// Instantiate a new enum with the provided value.
  const GetLegalPage200ResponseIdEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [GetLegalPage200ResponseIdEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static GetLegalPage200ResponseIdEnum? fromJson(dynamic value) => GetLegalPage200ResponseIdEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [GetLegalPage200ResponseIdEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<GetLegalPage200ResponseIdEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetLegalPage200ResponseIdEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetLegalPage200ResponseIdEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GetLegalPage200ResponseIdEnum] to String,
/// and [decode] dynamic data back to [GetLegalPage200ResponseIdEnum].
class GetLegalPage200ResponseIdEnumTypeTransformer {
  factory GetLegalPage200ResponseIdEnumTypeTransformer() => _instance ??= const GetLegalPage200ResponseIdEnumTypeTransformer._();

  const GetLegalPage200ResponseIdEnumTypeTransformer._();

  String encode(GetLegalPage200ResponseIdEnum data) => data._value;

  /// Returns the instance of [GetLegalPage200ResponseIdEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GetLegalPage200ResponseIdEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is GetLegalPage200ResponseIdEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'terms': return GetLegalPage200ResponseIdEnum.terms;
        case r'privacy': return GetLegalPage200ResponseIdEnum.privacy;
        case r'community': return GetLegalPage200ResponseIdEnum.community;
        case r'grievance': return GetLegalPage200ResponseIdEnum.grievance;
        case r'delete-account': return GetLegalPage200ResponseIdEnum.deleteAccount;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static GetLegalPage200ResponseIdEnumTypeTransformer? _instance;
}


