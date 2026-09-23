//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminModerationFlagInput {
  /// Returns a new [AdminModerationFlagInput] instance.
  AdminModerationFlagInput({
    required this.id,
    required this.createdAt,
    required this.score,
    required this.status,
    required this.note,
    required this.reviewedAt,
    required this.reviewer,
    required this.hasFrame,
    required this.call,
    required this.subject,
    required this.detectedBy,
  });

  String id;

  Object? createdAt;

  /// Model confidence 0–1 that the frame shows nudity
  num score;

  AdminModerationFlagInputStatusEnum status;

  String? note;

  Object? reviewedAt;

  String? reviewer;

  /// false once deleted under the retention policy
  bool hasFrame;

  AdminModerationFlagInputCall call;

  AdminModerationFlagInputSubject subject;

  AdminReportInputReporter detectedBy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminModerationFlagInput &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.score == score &&
    other.status == status &&
    other.note == note &&
    other.reviewedAt == reviewedAt &&
    other.reviewer == reviewer &&
    other.hasFrame == hasFrame &&
    other.call == call &&
    other.subject == subject &&
    other.detectedBy == detectedBy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (score.hashCode) +
    (status.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (reviewedAt == null ? 0 : reviewedAt!.hashCode) +
    (reviewer == null ? 0 : reviewer!.hashCode) +
    (hasFrame.hashCode) +
    (call.hashCode) +
    (subject.hashCode) +
    (detectedBy.hashCode);

  @override
  String toString() => 'AdminModerationFlagInput[id=$id, createdAt=$createdAt, score=$score, status=$status, note=$note, reviewedAt=$reviewedAt, reviewer=$reviewer, hasFrame=$hasFrame, call=$call, subject=$subject, detectedBy=$detectedBy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
      json[r'score'] = this.score;
      json[r'status'] = this.status;
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    if (this.reviewedAt != null) {
      json[r'reviewedAt'] = this.reviewedAt;
    } else {
      json[r'reviewedAt'] = null;
    }
    if (this.reviewer != null) {
      json[r'reviewer'] = this.reviewer;
    } else {
      json[r'reviewer'] = null;
    }
      json[r'hasFrame'] = this.hasFrame;
      json[r'call'] = this.call;
      json[r'subject'] = this.subject;
      json[r'detectedBy'] = this.detectedBy;
    return json;
  }

  /// Returns a new [AdminModerationFlagInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminModerationFlagInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminModerationFlagInput[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminModerationFlagInput[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminModerationFlagInput[createdAt]" is missing from JSON.');
        assert(json.containsKey(r'score'), 'Required key "AdminModerationFlagInput[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "AdminModerationFlagInput[score]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminModerationFlagInput[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminModerationFlagInput[status]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminModerationFlagInput[note]" is missing from JSON.');
        assert(json.containsKey(r'reviewedAt'), 'Required key "AdminModerationFlagInput[reviewedAt]" is missing from JSON.');
        assert(json.containsKey(r'reviewer'), 'Required key "AdminModerationFlagInput[reviewer]" is missing from JSON.');
        assert(json.containsKey(r'hasFrame'), 'Required key "AdminModerationFlagInput[hasFrame]" is missing from JSON.');
        assert(json[r'hasFrame'] != null, 'Required key "AdminModerationFlagInput[hasFrame]" has a null value in JSON.');
        assert(json.containsKey(r'call'), 'Required key "AdminModerationFlagInput[call]" is missing from JSON.');
        assert(json[r'call'] != null, 'Required key "AdminModerationFlagInput[call]" has a null value in JSON.');
        assert(json.containsKey(r'subject'), 'Required key "AdminModerationFlagInput[subject]" is missing from JSON.');
        assert(json[r'subject'] != null, 'Required key "AdminModerationFlagInput[subject]" has a null value in JSON.');
        assert(json.containsKey(r'detectedBy'), 'Required key "AdminModerationFlagInput[detectedBy]" is missing from JSON.');
        assert(json[r'detectedBy'] != null, 'Required key "AdminModerationFlagInput[detectedBy]" has a null value in JSON.');
        return true;
      }());

      return AdminModerationFlagInput(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<Object>(json, r'createdAt'),
        score: num.parse('${json[r'score']}'),
        status: AdminModerationFlagInputStatusEnum.fromJson(json[r'status'])!,
        note: mapValueOfType<String>(json, r'note'),
        reviewedAt: mapValueOfType<Object>(json, r'reviewedAt'),
        reviewer: mapValueOfType<String>(json, r'reviewer'),
        hasFrame: mapValueOfType<bool>(json, r'hasFrame')!,
        call: AdminModerationFlagInputCall.fromJson(json[r'call'])!,
        subject: AdminModerationFlagInputSubject.fromJson(json[r'subject'])!,
        detectedBy: AdminReportInputReporter.fromJson(json[r'detectedBy'])!,
      );
    }
    return null;
  }

  static List<AdminModerationFlagInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminModerationFlagInput> mapFromJson(dynamic json) {
    final map = <String, AdminModerationFlagInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminModerationFlagInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminModerationFlagInput-objects as value to a dart map
  static Map<String, List<AdminModerationFlagInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminModerationFlagInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminModerationFlagInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'score',
    'status',
    'note',
    'reviewedAt',
    'reviewer',
    'hasFrame',
    'call',
    'subject',
    'detectedBy',
  };
}


enum AdminModerationFlagInputStatusEnum {
  open._(r'open'),
  dismissed._(r'dismissed'),
  actioned._(r'actioned'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminModerationFlagInputStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminModerationFlagInputStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminModerationFlagInputStatusEnum? fromJson(dynamic value) => AdminModerationFlagInputStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminModerationFlagInputStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminModerationFlagInputStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagInputStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagInputStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminModerationFlagInputStatusEnum] to String,
/// and [decode] dynamic data back to [AdminModerationFlagInputStatusEnum].
class AdminModerationFlagInputStatusEnumTypeTransformer {
  factory AdminModerationFlagInputStatusEnumTypeTransformer() => _instance ??= const AdminModerationFlagInputStatusEnumTypeTransformer._();

  const AdminModerationFlagInputStatusEnumTypeTransformer._();

  String encode(AdminModerationFlagInputStatusEnum data) => data._value;

  /// Returns the instance of [AdminModerationFlagInputStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminModerationFlagInputStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminModerationFlagInputStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'open': return AdminModerationFlagInputStatusEnum.open;
        case r'dismissed': return AdminModerationFlagInputStatusEnum.dismissed;
        case r'actioned': return AdminModerationFlagInputStatusEnum.actioned;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminModerationFlagInputStatusEnumTypeTransformer? _instance;
}


