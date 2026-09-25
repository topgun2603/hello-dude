//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycState {
  /// Returns a new [KycState] instance.
  KycState({
    required this.status,
    required this.rejectReason,
    this.redo = const [],
    required this.age,
    required this.selfie,
    required this.voice,
    required this.pan,
    required this.upi,
    required this.videoEnabled,
  });

  KycStateStatusEnum status;

  String? rejectReason;

  /// After a rejection: what to send again. Once all are sent, it goes back to review by itself.
  List<KycStateRedoEnum> redo;

  KycStateAge age;

  KycStateSelfie selfie;

  KycStateVoice voice;

  KycStatePan pan;

  KycStateUpi upi;

  bool videoEnabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycState &&
    other.status == status &&
    other.rejectReason == rejectReason &&
    _deepEquality.equals(other.redo, redo) &&
    other.age == age &&
    other.selfie == selfie &&
    other.voice == voice &&
    other.pan == pan &&
    other.upi == upi &&
    other.videoEnabled == videoEnabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (rejectReason == null ? 0 : rejectReason!.hashCode) +
    (redo.hashCode) +
    (age.hashCode) +
    (selfie.hashCode) +
    (voice.hashCode) +
    (pan.hashCode) +
    (upi.hashCode) +
    (videoEnabled.hashCode);

  @override
  String toString() => 'KycState[status=$status, rejectReason=$rejectReason, redo=$redo, age=$age, selfie=$selfie, voice=$voice, pan=$pan, upi=$upi, videoEnabled=$videoEnabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
    if (this.rejectReason != null) {
      json[r'rejectReason'] = this.rejectReason;
    } else {
      json[r'rejectReason'] = null;
    }
      json[r'redo'] = this.redo;
      json[r'age'] = this.age;
      json[r'selfie'] = this.selfie;
      json[r'voice'] = this.voice;
      json[r'pan'] = this.pan;
      json[r'upi'] = this.upi;
      json[r'videoEnabled'] = this.videoEnabled;
    return json;
  }

  /// Returns a new [KycState] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycState? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "KycState[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "KycState[status]" has a null value in JSON.');
        assert(json.containsKey(r'rejectReason'), 'Required key "KycState[rejectReason]" is missing from JSON.');
        assert(json.containsKey(r'redo'), 'Required key "KycState[redo]" is missing from JSON.');
        assert(json[r'redo'] != null, 'Required key "KycState[redo]" has a null value in JSON.');
        assert(json.containsKey(r'age'), 'Required key "KycState[age]" is missing from JSON.');
        assert(json[r'age'] != null, 'Required key "KycState[age]" has a null value in JSON.');
        assert(json.containsKey(r'selfie'), 'Required key "KycState[selfie]" is missing from JSON.');
        assert(json[r'selfie'] != null, 'Required key "KycState[selfie]" has a null value in JSON.');
        assert(json.containsKey(r'voice'), 'Required key "KycState[voice]" is missing from JSON.');
        assert(json[r'voice'] != null, 'Required key "KycState[voice]" has a null value in JSON.');
        assert(json.containsKey(r'pan'), 'Required key "KycState[pan]" is missing from JSON.');
        assert(json[r'pan'] != null, 'Required key "KycState[pan]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "KycState[upi]" is missing from JSON.');
        assert(json[r'upi'] != null, 'Required key "KycState[upi]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "KycState[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "KycState[videoEnabled]" has a null value in JSON.');
        return true;
      }());

      return KycState(
        status: KycStateStatusEnum.fromJson(json[r'status'])!,
        rejectReason: mapValueOfType<String>(json, r'rejectReason'),
        redo: KycStateRedoEnum.listFromJson(json[r'redo']),
        age: KycStateAge.fromJson(json[r'age'])!,
        selfie: KycStateSelfie.fromJson(json[r'selfie'])!,
        voice: KycStateVoice.fromJson(json[r'voice'])!,
        pan: KycStatePan.fromJson(json[r'pan'])!,
        upi: KycStateUpi.fromJson(json[r'upi'])!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
      );
    }
    return null;
  }

  static List<KycState> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycState>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycState.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycState> mapFromJson(dynamic json) {
    final map = <String, KycState>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycState.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycState-objects as value to a dart map
  static Map<String, List<KycState>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycState>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycState.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'rejectReason',
    'redo',
    'age',
    'selfie',
    'voice',
    'pan',
    'upi',
    'videoEnabled',
  };
}


enum KycStateStatusEnum {
  inProgress._(r'in_progress'),
  submitted._(r'submitted'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const KycStateStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [KycStateStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static KycStateStatusEnum? fromJson(dynamic value) => KycStateStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [KycStateStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<KycStateStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [KycStateStatusEnum] to String,
/// and [decode] dynamic data back to [KycStateStatusEnum].
class KycStateStatusEnumTypeTransformer {
  factory KycStateStatusEnumTypeTransformer() => _instance ??= const KycStateStatusEnumTypeTransformer._();

  const KycStateStatusEnumTypeTransformer._();

  String encode(KycStateStatusEnum data) => data._value;

  /// Returns the instance of [KycStateStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  KycStateStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is KycStateStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'in_progress': return KycStateStatusEnum.inProgress;
        case r'submitted': return KycStateStatusEnum.submitted;
        case r'approved': return KycStateStatusEnum.approved;
        case r'rejected': return KycStateStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static KycStateStatusEnumTypeTransformer? _instance;
}



enum KycStateRedoEnum {
  age._(r'age'),
  selfie._(r'selfie'),
  voice._(r'voice'),
  pan._(r'pan'),
  upi._(r'upi'),
  ;

  /// Instantiate a new enum with the provided value.
  const KycStateRedoEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [KycStateRedoEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static KycStateRedoEnum? fromJson(dynamic value) => KycStateRedoEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [KycStateRedoEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<KycStateRedoEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateRedoEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateRedoEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [KycStateRedoEnum] to String,
/// and [decode] dynamic data back to [KycStateRedoEnum].
class KycStateRedoEnumTypeTransformer {
  factory KycStateRedoEnumTypeTransformer() => _instance ??= const KycStateRedoEnumTypeTransformer._();

  const KycStateRedoEnumTypeTransformer._();

  String encode(KycStateRedoEnum data) => data._value;

  /// Returns the instance of [KycStateRedoEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  KycStateRedoEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is KycStateRedoEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'age': return KycStateRedoEnum.age;
        case r'selfie': return KycStateRedoEnum.selfie;
        case r'voice': return KycStateRedoEnum.voice;
        case r'pan': return KycStateRedoEnum.pan;
        case r'upi': return KycStateRedoEnum.upi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static KycStateRedoEnumTypeTransformer? _instance;
}


