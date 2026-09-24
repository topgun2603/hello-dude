//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class MyPhoto {
  /// Returns a new [MyPhoto] instance.
  MyPhoto({
    required this.status,
    required this.photoUrl,
    required this.pendingUrl,
    required this.rejectReason,
  });

  MyPhotoStatusEnum status;

  /// The approved photo others see
  String? photoUrl;

  /// Waiting for review
  String? pendingUrl;

  String? rejectReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MyPhoto &&
    other.status == status &&
    other.photoUrl == photoUrl &&
    other.pendingUrl == pendingUrl &&
    other.rejectReason == rejectReason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (pendingUrl == null ? 0 : pendingUrl!.hashCode) +
    (rejectReason == null ? 0 : rejectReason!.hashCode);

  @override
  String toString() => 'MyPhoto[status=$status, photoUrl=$photoUrl, pendingUrl=$pendingUrl, rejectReason=$rejectReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
    if (this.photoUrl != null) {
      json[r'photoUrl'] = this.photoUrl;
    } else {
      json[r'photoUrl'] = null;
    }
    if (this.pendingUrl != null) {
      json[r'pendingUrl'] = this.pendingUrl;
    } else {
      json[r'pendingUrl'] = null;
    }
    if (this.rejectReason != null) {
      json[r'rejectReason'] = this.rejectReason;
    } else {
      json[r'rejectReason'] = null;
    }
    return json;
  }

  /// Returns a new [MyPhoto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MyPhoto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "MyPhoto[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "MyPhoto[status]" has a null value in JSON.');
        assert(json.containsKey(r'photoUrl'), 'Required key "MyPhoto[photoUrl]" is missing from JSON.');
        assert(json.containsKey(r'pendingUrl'), 'Required key "MyPhoto[pendingUrl]" is missing from JSON.');
        assert(json.containsKey(r'rejectReason'), 'Required key "MyPhoto[rejectReason]" is missing from JSON.');
        return true;
      }());

      return MyPhoto(
        status: MyPhotoStatusEnum.fromJson(json[r'status'])!,
        photoUrl: mapValueOfType<String>(json, r'photoUrl'),
        pendingUrl: mapValueOfType<String>(json, r'pendingUrl'),
        rejectReason: mapValueOfType<String>(json, r'rejectReason'),
      );
    }
    return null;
  }

  static List<MyPhoto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyPhoto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyPhoto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MyPhoto> mapFromJson(dynamic json) {
    final map = <String, MyPhoto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MyPhoto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MyPhoto-objects as value to a dart map
  static Map<String, List<MyPhoto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MyPhoto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MyPhoto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'photoUrl',
    'pendingUrl',
    'rejectReason',
  };
}


enum MyPhotoStatusEnum {
  none._(r'none'),
  pending._(r'pending'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const MyPhotoStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [MyPhotoStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static MyPhotoStatusEnum? fromJson(dynamic value) => MyPhotoStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [MyPhotoStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<MyPhotoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyPhotoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyPhotoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MyPhotoStatusEnum] to String,
/// and [decode] dynamic data back to [MyPhotoStatusEnum].
class MyPhotoStatusEnumTypeTransformer {
  factory MyPhotoStatusEnumTypeTransformer() => _instance ??= const MyPhotoStatusEnumTypeTransformer._();

  const MyPhotoStatusEnumTypeTransformer._();

  String encode(MyPhotoStatusEnum data) => data._value;

  /// Returns the instance of [MyPhotoStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MyPhotoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is MyPhotoStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'none': return MyPhotoStatusEnum.none;
        case r'pending': return MyPhotoStatusEnum.pending;
        case r'approved': return MyPhotoStatusEnum.approved;
        case r'rejected': return MyPhotoStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static MyPhotoStatusEnumTypeTransformer? _instance;
}


