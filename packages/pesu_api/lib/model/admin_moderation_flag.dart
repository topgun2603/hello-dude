//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class AdminModerationFlag {
  /// Returns a new [AdminModerationFlag] instance.
  AdminModerationFlag({
    required this.id,
    required this.createdAt,
    required this.score,
    required this.status,
    required this.note,
    required this.reviewedAt,
    required this.reviewer,
    required this.hasFrame,
    required this.call,
    required this.liveId,
    required this.groupId,
    required this.subject,
    required this.detectedBy,
  });

  String id;

  DateTime createdAt;

  /// Model confidence 0–1 that the frame shows nudity
  num score;

  AdminModerationFlagStatusEnum status;

  String? note;

  DateTime? reviewedAt;

  String? reviewer;

  /// false once deleted under the retention policy
  bool hasFrame;

  AdminModerationFlagCall? call;

  String? liveId;

  String? groupId;

  AdminModerationFlagSubject subject;

  AdminReportReporter detectedBy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminModerationFlag &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.score == score &&
    other.status == status &&
    other.note == note &&
    other.reviewedAt == reviewedAt &&
    other.reviewer == reviewer &&
    other.hasFrame == hasFrame &&
    other.call == call &&
    other.liveId == liveId &&
    other.groupId == groupId &&
    other.subject == subject &&
    other.detectedBy == detectedBy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (score.hashCode) +
    (status.hashCode) +
    (note == null ? 0 : note!.hashCode) +
    (reviewedAt == null ? 0 : reviewedAt!.hashCode) +
    (reviewer == null ? 0 : reviewer!.hashCode) +
    (hasFrame.hashCode) +
    (call == null ? 0 : call!.hashCode) +
    (liveId == null ? 0 : liveId!.hashCode) +
    (groupId == null ? 0 : groupId!.hashCode) +
    (subject.hashCode) +
    (detectedBy.hashCode);

  @override
  String toString() => 'AdminModerationFlag[id=$id, createdAt=$createdAt, score=$score, status=$status, note=$note, reviewedAt=$reviewedAt, reviewer=$reviewer, hasFrame=$hasFrame, call=$call, liveId=$liveId, groupId=$groupId, subject=$subject, detectedBy=$detectedBy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'score'] = this.score;
      json[r'status'] = this.status;
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    if (this.reviewedAt != null) {
      json[r'reviewedAt'] = this.reviewedAt!.toUtc().toIso8601String();
    } else {
      json[r'reviewedAt'] = null;
    }
    if (this.reviewer != null) {
      json[r'reviewer'] = this.reviewer;
    } else {
      json[r'reviewer'] = null;
    }
      json[r'hasFrame'] = this.hasFrame;
    if (this.call != null) {
      json[r'call'] = this.call;
    } else {
      json[r'call'] = null;
    }
    if (this.liveId != null) {
      json[r'liveId'] = this.liveId;
    } else {
      json[r'liveId'] = null;
    }
    if (this.groupId != null) {
      json[r'groupId'] = this.groupId;
    } else {
      json[r'groupId'] = null;
    }
      json[r'subject'] = this.subject;
      json[r'detectedBy'] = this.detectedBy;
    return json;
  }

  /// Returns a new [AdminModerationFlag] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminModerationFlag? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdminModerationFlag[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdminModerationFlag[id]" has a null value in JSON.');
        assert(json.containsKey(r'createdAt'), 'Required key "AdminModerationFlag[createdAt]" is missing from JSON.');
        assert(json[r'createdAt'] != null, 'Required key "AdminModerationFlag[createdAt]" has a null value in JSON.');
        assert(json.containsKey(r'score'), 'Required key "AdminModerationFlag[score]" is missing from JSON.');
        assert(json[r'score'] != null, 'Required key "AdminModerationFlag[score]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "AdminModerationFlag[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "AdminModerationFlag[status]" has a null value in JSON.');
        assert(json.containsKey(r'note'), 'Required key "AdminModerationFlag[note]" is missing from JSON.');
        assert(json.containsKey(r'reviewedAt'), 'Required key "AdminModerationFlag[reviewedAt]" is missing from JSON.');
        assert(json.containsKey(r'reviewer'), 'Required key "AdminModerationFlag[reviewer]" is missing from JSON.');
        assert(json.containsKey(r'hasFrame'), 'Required key "AdminModerationFlag[hasFrame]" is missing from JSON.');
        assert(json[r'hasFrame'] != null, 'Required key "AdminModerationFlag[hasFrame]" has a null value in JSON.');
        assert(json.containsKey(r'call'), 'Required key "AdminModerationFlag[call]" is missing from JSON.');
        assert(json.containsKey(r'liveId'), 'Required key "AdminModerationFlag[liveId]" is missing from JSON.');
        assert(json.containsKey(r'groupId'), 'Required key "AdminModerationFlag[groupId]" is missing from JSON.');
        assert(json.containsKey(r'subject'), 'Required key "AdminModerationFlag[subject]" is missing from JSON.');
        assert(json[r'subject'] != null, 'Required key "AdminModerationFlag[subject]" has a null value in JSON.');
        assert(json.containsKey(r'detectedBy'), 'Required key "AdminModerationFlag[detectedBy]" is missing from JSON.');
        assert(json[r'detectedBy'] != null, 'Required key "AdminModerationFlag[detectedBy]" has a null value in JSON.');
        return true;
      }());

      return AdminModerationFlag(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        score: num.parse('${json[r'score']}'),
        status: AdminModerationFlagStatusEnum.fromJson(json[r'status'])!,
        note: mapValueOfType<String>(json, r'note'),
        reviewedAt: mapDateTime(json, r'reviewedAt', r''),
        reviewer: mapValueOfType<String>(json, r'reviewer'),
        hasFrame: mapValueOfType<bool>(json, r'hasFrame')!,
        call: AdminModerationFlagCall.fromJson(json[r'call']),
        liveId: mapValueOfType<String>(json, r'liveId'),
        groupId: mapValueOfType<String>(json, r'groupId'),
        subject: AdminModerationFlagSubject.fromJson(json[r'subject'])!,
        detectedBy: AdminReportReporter.fromJson(json[r'detectedBy'])!,
      );
    }
    return null;
  }

  static List<AdminModerationFlag> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlag>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlag.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminModerationFlag> mapFromJson(dynamic json) {
    final map = <String, AdminModerationFlag>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminModerationFlag.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminModerationFlag-objects as value to a dart map
  static Map<String, List<AdminModerationFlag>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminModerationFlag>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminModerationFlag.listFromJson(entry.value, growable: growable,);
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
    'liveId',
    'groupId',
    'subject',
    'detectedBy',
  };
}


enum AdminModerationFlagStatusEnum {
  open._(r'open'),
  dismissed._(r'dismissed'),
  actioned._(r'actioned'),
  ;

  /// Instantiate a new enum with the provided value.
  const AdminModerationFlagStatusEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [AdminModerationFlagStatusEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static AdminModerationFlagStatusEnum? fromJson(dynamic value) => AdminModerationFlagStatusEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [AdminModerationFlagStatusEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<AdminModerationFlagStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminModerationFlagStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminModerationFlagStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminModerationFlagStatusEnum] to String,
/// and [decode] dynamic data back to [AdminModerationFlagStatusEnum].
class AdminModerationFlagStatusEnumTypeTransformer {
  factory AdminModerationFlagStatusEnumTypeTransformer() => _instance ??= const AdminModerationFlagStatusEnumTypeTransformer._();

  const AdminModerationFlagStatusEnumTypeTransformer._();

  String encode(AdminModerationFlagStatusEnum data) => data._value;

  /// Returns the instance of [AdminModerationFlagStatusEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminModerationFlagStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is AdminModerationFlagStatusEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'open': return AdminModerationFlagStatusEnum.open;
        case r'dismissed': return AdminModerationFlagStatusEnum.dismissed;
        case r'actioned': return AdminModerationFlagStatusEnum.actioned;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static AdminModerationFlagStatusEnumTypeTransformer? _instance;
}


