//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ListLegalPages200ResponseInner {
  /// Returns a new [ListLegalPages200ResponseInner] instance.
  ListLegalPages200ResponseInner({
    required this.id,
    required this.title,
    required this.url,
  });

  ListLegalPages200ResponseInnerIdEnum id;

  String title;

  String url;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListLegalPages200ResponseInner &&
    other.id == id &&
    other.title == title &&
    other.url == url;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (url.hashCode);

  @override
  String toString() => 'ListLegalPages200ResponseInner[id=$id, title=$title, url=$url]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'url'] = this.url;
    return json;
  }

  /// Returns a new [ListLegalPages200ResponseInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListLegalPages200ResponseInner? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ListLegalPages200ResponseInner[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ListLegalPages200ResponseInner[id]" has a null value in JSON.');
        assert(json.containsKey(r'title'), 'Required key "ListLegalPages200ResponseInner[title]" is missing from JSON.');
        assert(json[r'title'] != null, 'Required key "ListLegalPages200ResponseInner[title]" has a null value in JSON.');
        assert(json.containsKey(r'url'), 'Required key "ListLegalPages200ResponseInner[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "ListLegalPages200ResponseInner[url]" has a null value in JSON.');
        return true;
      }());

      return ListLegalPages200ResponseInner(
        id: ListLegalPages200ResponseInnerIdEnum.fromJson(json[r'id'])!,
        title: mapValueOfType<String>(json, r'title')!,
        url: mapValueOfType<String>(json, r'url')!,
      );
    }
    return null;
  }

  static List<ListLegalPages200ResponseInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListLegalPages200ResponseInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListLegalPages200ResponseInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListLegalPages200ResponseInner> mapFromJson(dynamic json) {
    final map = <String, ListLegalPages200ResponseInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListLegalPages200ResponseInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListLegalPages200ResponseInner-objects as value to a dart map
  static Map<String, List<ListLegalPages200ResponseInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListLegalPages200ResponseInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListLegalPages200ResponseInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'url',
  };
}


enum ListLegalPages200ResponseInnerIdEnum {
  terms._(r'terms'),
  privacy._(r'privacy'),
  community._(r'community'),
  grievance._(r'grievance'),
  deleteAccount._(r'delete-account'),
  ;

  /// Instantiate a new enum with the provided value.
  const ListLegalPages200ResponseInnerIdEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ListLegalPages200ResponseInnerIdEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ListLegalPages200ResponseInnerIdEnum? fromJson(dynamic value) => ListLegalPages200ResponseInnerIdEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ListLegalPages200ResponseInnerIdEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ListLegalPages200ResponseInnerIdEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListLegalPages200ResponseInnerIdEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListLegalPages200ResponseInnerIdEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ListLegalPages200ResponseInnerIdEnum] to String,
/// and [decode] dynamic data back to [ListLegalPages200ResponseInnerIdEnum].
class ListLegalPages200ResponseInnerIdEnumTypeTransformer {
  factory ListLegalPages200ResponseInnerIdEnumTypeTransformer() => _instance ??= const ListLegalPages200ResponseInnerIdEnumTypeTransformer._();

  const ListLegalPages200ResponseInnerIdEnumTypeTransformer._();

  String encode(ListLegalPages200ResponseInnerIdEnum data) => data._value;

  /// Returns the instance of [ListLegalPages200ResponseInnerIdEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ListLegalPages200ResponseInnerIdEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ListLegalPages200ResponseInnerIdEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'terms': return ListLegalPages200ResponseInnerIdEnum.terms;
        case r'privacy': return ListLegalPages200ResponseInnerIdEnum.privacy;
        case r'community': return ListLegalPages200ResponseInnerIdEnum.community;
        case r'grievance': return ListLegalPages200ResponseInnerIdEnum.grievance;
        case r'delete-account': return ListLegalPages200ResponseInnerIdEnum.deleteAccount;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ListLegalPages200ResponseInnerIdEnumTypeTransformer? _instance;
}


