//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class KycStateInput {
  /// Returns a new [KycStateInput] instance.
  KycStateInput({
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

  KycStateInputStatusEnum status;

  String? rejectReason;

  /// After a rejection: what to send again. Once all are sent, it goes back to review by itself.
  List<KycStateInputRedoEnum> redo;

  KycStateInputAge age;

  KycStateInputSelfie selfie;

  KycStateInputVoice voice;

  KycStateInputPan pan;

  KycStateInputUpi upi;

  bool videoEnabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycStateInput &&
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
  String toString() => 'KycStateInput[status=$status, rejectReason=$rejectReason, redo=$redo, age=$age, selfie=$selfie, voice=$voice, pan=$pan, upi=$upi, videoEnabled=$videoEnabled]';

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

  /// Returns a new [KycStateInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycStateInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'), 'Required key "KycStateInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "KycStateInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'rejectReason'), 'Required key "KycStateInput[rejectReason]" is missing from JSON.');
        assert(json.containsKey(r'redo'), 'Required key "KycStateInput[redo]" is missing from JSON.');
        assert(json[r'redo'] != null, 'Required key "KycStateInput[redo]" has a null value in JSON.');
        assert(json.containsKey(r'age'), 'Required key "KycStateInput[age]" is missing from JSON.');
        assert(json[r'age'] != null, 'Required key "KycStateInput[age]" has a null value in JSON.');
        assert(json.containsKey(r'selfie'), 'Required key "KycStateInput[selfie]" is missing from JSON.');
        assert(json[r'selfie'] != null, 'Required key "KycStateInput[selfie]" has a null value in JSON.');
        assert(json.containsKey(r'voice'), 'Required key "KycStateInput[voice]" is missing from JSON.');
        assert(json[r'voice'] != null, 'Required key "KycStateInput[voice]" has a null value in JSON.');
        assert(json.containsKey(r'pan'), 'Required key "KycStateInput[pan]" is missing from JSON.');
        assert(json[r'pan'] != null, 'Required key "KycStateInput[pan]" has a null value in JSON.');
        assert(json.containsKey(r'upi'), 'Required key "KycStateInput[upi]" is missing from JSON.');
        assert(json[r'upi'] != null, 'Required key "KycStateInput[upi]" has a null value in JSON.');
        assert(json.containsKey(r'videoEnabled'), 'Required key "KycStateInput[videoEnabled]" is missing from JSON.');
        assert(json[r'videoEnabled'] != null, 'Required key "KycStateInput[videoEnabled]" has a null value in JSON.');
        return true;
      }());

      return KycStateInput(
        status: KycStateInputStatusEnum.fromJson(json[r'status'])!,
        rejectReason: mapValueOfType<String>(json, r'rejectReason'),
        redo: KycStateInputRedoEnum.listFromJson(json[r'redo']),
        age: KycStateInputAge.fromJson(json[r'age'])!,
        selfie: KycStateInputSelfie.fromJson(json[r'selfie'])!,
        voice: KycStateInputVoice.fromJson(json[r'voice'])!,
        pan: KycStateInputPan.fromJson(json[r'pan'])!,
        upi: KycStateInputUpi.fromJson(json[r'upi'])!,
        videoEnabled: mapValueOfType<bool>(json, r'videoEnabled')!,
      );
    }
    return null;
  }

  static List<KycStateInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycStateInput> mapFromJson(dynamic json) {
    final map = <String, KycStateInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycStateInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycStateInput-objects as value to a dart map
  static Map<String, List<KycStateInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycStateInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycStateInput.listFromJson(entry.value, growable: growable,);
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


enum KycStateInputStatusEnum {
  inProgress._(r'in_progress'),
  submitted._(r'submitted'),
  approved._(r'approved'),
  rejected._(r'rejected'),
  ;

  /// Instantiate a new enum with the provided value.
  const KycStateInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [KycStateInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static KycStateInputStatusEnum? fromJson(dynamic value) => KycStateInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [KycStateInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<KycStateInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [KycStateInputStatusEnum] to String,
/// and [decode] dynamic data back to [KycStateInputStatusEnum].
class KycStateInputStatusEnumTypeTransformer {
  factory KycStateInputStatusEnumTypeTransformer() => _instance ??= const KycStateInputStatusEnumTypeTransformer._();

  const KycStateInputStatusEnumTypeTransformer._();

  String encode(KycStateInputStatusEnum data) => data._value;

  /// Returns the instance of [KycStateInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  KycStateInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is KycStateInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'in_progress': return KycStateInputStatusEnum.inProgress;
        case r'submitted': return KycStateInputStatusEnum.submitted;
        case r'approved': return KycStateInputStatusEnum.approved;
        case r'rejected': return KycStateInputStatusEnum.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static KycStateInputStatusEnumTypeTransformer? _instance;
}



enum KycStateInputRedoEnum {
  age._(r'age'),
  selfie._(r'selfie'),
  voice._(r'voice'),
  pan._(r'pan'),
  upi._(r'upi'),
  ;

  /// Instantiate a new enum with the provided value.
  const KycStateInputRedoEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [KycStateInputRedoEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static KycStateInputRedoEnum? fromJson(dynamic value) => KycStateInputRedoEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [KycStateInputRedoEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<KycStateInputRedoEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycStateInputRedoEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycStateInputRedoEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [KycStateInputRedoEnum] to String,
/// and [decode] dynamic data back to [KycStateInputRedoEnum].
class KycStateInputRedoEnumTypeTransformer {
  factory KycStateInputRedoEnumTypeTransformer() => _instance ??= const KycStateInputRedoEnumTypeTransformer._();

  const KycStateInputRedoEnumTypeTransformer._();

  String encode(KycStateInputRedoEnum data) => data._value;

  /// Returns the instance of [KycStateInputRedoEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  KycStateInputRedoEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is KycStateInputRedoEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'age': return KycStateInputRedoEnum.age;
        case r'selfie': return KycStateInputRedoEnum.selfie;
        case r'voice': return KycStateInputRedoEnum.voice;
        case r'pan': return KycStateInputRedoEnum.pan;
        case r'upi': return KycStateInputRedoEnum.upi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static KycStateInputRedoEnumTypeTransformer? _instance;
}


