//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;

class ApiClient {
  ApiClient({this.basePath = 'http://localhost', this.authentication,});

  final String basePath;
  final Authentication? authentication;

  var _client = Client();
  final _defaultHeaderMap = <String, String>{};

  /// Returns the current HTTP [Client] instance to use in this class.
  ///
  /// The return value is guaranteed to never be null.
  Client get client => _client;

  /// Requests to use a new HTTP [Client] in this class.
  set client(Client newClient) {
    _client = newClient;
  }

  Map<String, String> get defaultHeaderMap => _defaultHeaderMap;

  void addDefaultHeader(String key, String value) {
     _defaultHeaderMap[key] = value;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType, {
    Future<void>? abortTrigger,
  }) async {
    await authentication?.applyToParams(queryParams, headerParams);

    headerParams.addAll(_defaultHeaderMap);
    if (contentType != null) {
      headerParams['Content-Type'] = contentType;
    }

    final urlEncodedQueryParams = queryParams.map((param) => '$param');
    final queryString = urlEncodedQueryParams.isNotEmpty ? '?${urlEncodedQueryParams.join('&')}' : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (
        body is MultipartFile && (contentType == null ||
        !contentType.toLowerCase().startsWith('multipart/form-data'))
      ) {
        final request = AbortableStreamedRequest(method, uri, abortTrigger: abortTrigger);
        request.headers.addAll(headerParams);
        request.contentLength = body.length;
        body.finalize().listen(
          request.sink.add,
          onDone: request.sink.close,
          // ignore: avoid_types_on_closure_parameters
          onError: (Object error, StackTrace trace) => request.sink.close(),
          cancelOnError: true,
        );
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      if (body is MultipartRequest) {
        final request = AbortableMultipartRequest(method, uri, abortTrigger: abortTrigger);
        request.fields.addAll(body.fields);
        request.files.addAll(body.files);
        request.headers.addAll(body.headers);
        request.headers.addAll(headerParams);
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      final msgBody = contentType == 'application/x-www-form-urlencoded'
        ? formParams
        : await serializeAsync(body);
      final nullableHeaderParams = headerParams.isEmpty ? null : headerParams;

      final request = AbortableRequest(method, uri, abortTrigger: abortTrigger);
      if (nullableHeaderParams != null) {
        request.headers.addAll(nullableHeaderParams);
      }
      if (msgBody is String && msgBody.isNotEmpty) {
        request.body = msgBody;
      } else if (msgBody is List<int> && msgBody.isNotEmpty) {
        request.bodyBytes = msgBody;
      } else if (msgBody is Map<String, String>) {
        request.bodyFields = msgBody;
      }
      final response = await _client.send(request);
      return Response.fromStream(response);
    } on SocketException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Socket operation failed: $method $path',
        error,
        trace,
      );
    } on TlsException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'TLS/SSL communication failed: $method $path',
        error,
        trace,
      );
    } on IOException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'I/O operation failed: $method $path',
        error,
        trace,
      );
    } on ClientException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'HTTP connection failed: $method $path',
        error,
        trace,
      );
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Exception occurred: $method $path',
        error,
        trace,
      );
    }
  }

  Future<dynamic> deserializeAsync(String value, String targetType, {bool growable = false,}) async =>
    // ignore: deprecated_member_use_from_same_package
    deserialize(value, targetType, growable: growable);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(String value, String targetType, {bool growable = false,}) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType = targetType.replaceAll(' ', ''); // ignore: parameter_assignments

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
      ? value
      : fromJson(json.decode(value), targetType, growable: growable);
  }

  // ignore: deprecated_member_use_from_same_package
  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  /// Returns a native instance of an OpenAPI class matching the [specified type][targetType].
  static dynamic fromJson(dynamic value, String targetType, {bool growable = false,}) {
    try {
      switch (targetType) {
        case 'String':
          return value is String ? value : value.toString();
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'bool':
          if (value is bool) {
            return value;
          }
          final valueString = '$value'.toLowerCase();
          return valueString == 'true' || valueString == '1';
        case 'DateTime':
          return value is DateTime ? value : DateTime.tryParse(value);
        case 'AcademyLesson':
          return AcademyLesson.fromJson(value);
        case 'AcademyLessonInput':
          return AcademyLessonInput.fromJson(value);
        case 'AcademyLessonInputQuizInner':
          return AcademyLessonInputQuizInner.fromJson(value);
        case 'AcademyLessonQuizInner':
          return AcademyLessonQuizInner.fromJson(value);
        case 'AddFavouriteRequest':
          return AddFavouriteRequest.fromJson(value);
        case 'AdminAddUserNoteRequest':
          return AdminAddUserNoteRequest.fromJson(value);
        case 'AdminAuditLog200ResponseInner':
          return AdminAuditLog200ResponseInner.fromJson(value);
        case 'AdminCallRate':
          return AdminCallRate.fromJson(value);
        case 'AdminCallRateInput':
          return AdminCallRateInput.fromJson(value);
        case 'AdminCoinPackage':
          return AdminCoinPackage.fromJson(value);
        case 'AdminCoinPackageInput':
          return AdminCoinPackageInput.fromJson(value);
        case 'AdminCreateGiftRequest':
          return AdminCreateGiftRequest.fromJson(value);
        case 'AdminCreatePackageRequest':
          return AdminCreatePackageRequest.fromJson(value);
        case 'AdminCreateRateRequest':
          return AdminCreateRateRequest.fromJson(value);
        case 'AdminDashboard200Response':
          return AdminDashboard200Response.fromJson(value);
        case 'AdminDashboard200ResponseActivityInner':
          return AdminDashboard200ResponseActivityInner.fromJson(value);
        case 'AdminDashboard200ResponseActivityInnerUser':
          return AdminDashboard200ResponseActivityInnerUser.fromJson(value);
        case 'AdminDashboard200ResponseByHourInner':
          return AdminDashboard200ResponseByHourInner.fromJson(value);
        case 'AdminDashboard200ResponseLanguagesInner':
          return AdminDashboard200ResponseLanguagesInner.fromJson(value);
        case 'AdminDashboard200ResponseLive':
          return AdminDashboard200ResponseLive.fromJson(value);
        case 'AdminDashboard200ResponsePendingPayouts':
          return AdminDashboard200ResponsePendingPayouts.fromJson(value);
        case 'AdminDashboard200ResponseToday':
          return AdminDashboard200ResponseToday.fromJson(value);
        case 'AdminDashboard200ResponseYesterday':
          return AdminDashboard200ResponseYesterday.fromJson(value);
        case 'AdminDecideRefundRequest':
          return AdminDecideRefundRequest.fromJson(value);
        case 'AdminGift':
          return AdminGift.fromJson(value);
        case 'AdminGiftInput':
          return AdminGiftInput.fromJson(value);
        case 'AdminKycCase':
          return AdminKycCase.fromJson(value);
        case 'AdminKycCaseAadhaar':
          return AdminKycCaseAadhaar.fromJson(value);
        case 'AdminKycCaseAcademy':
          return AdminKycCaseAcademy.fromJson(value);
        case 'AdminKycCaseInput':
          return AdminKycCaseInput.fromJson(value);
        case 'AdminKycCaseInputAadhaar':
          return AdminKycCaseInputAadhaar.fromJson(value);
        case 'AdminKycCaseInputAcademy':
          return AdminKycCaseInputAcademy.fromJson(value);
        case 'AdminKycDecisionRequest':
          return AdminKycDecisionRequest.fromJson(value);
        case 'AdminListPayouts200Response':
          return AdminListPayouts200Response.fromJson(value);
        case 'AdminListPayouts200ResponseTotals':
          return AdminListPayouts200ResponseTotals.fromJson(value);
        case 'AdminListSettings200ResponseInner':
          return AdminListSettings200ResponseInner.fromJson(value);
        case 'AdminListUsers200Response':
          return AdminListUsers200Response.fromJson(value);
        case 'AdminModerationFlag':
          return AdminModerationFlag.fromJson(value);
        case 'AdminModerationFlagCall':
          return AdminModerationFlagCall.fromJson(value);
        case 'AdminModerationFlagInput':
          return AdminModerationFlagInput.fromJson(value);
        case 'AdminModerationFlagInputCall':
          return AdminModerationFlagInputCall.fromJson(value);
        case 'AdminModerationFlagInputSubject':
          return AdminModerationFlagInputSubject.fromJson(value);
        case 'AdminModerationFlagSubject':
          return AdminModerationFlagSubject.fromJson(value);
        case 'AdminNote':
          return AdminNote.fromJson(value);
        case 'AdminNoteInput':
          return AdminNoteInput.fromJson(value);
        case 'AdminPayout':
          return AdminPayout.fromJson(value);
        case 'AdminPayoutCompanion':
          return AdminPayoutCompanion.fromJson(value);
        case 'AdminPayoutInput':
          return AdminPayoutInput.fromJson(value);
        case 'AdminPayoutInputCompanion':
          return AdminPayoutInputCompanion.fromJson(value);
        case 'AdminRefund':
          return AdminRefund.fromJson(value);
        case 'AdminRefundCall':
          return AdminRefundCall.fromJson(value);
        case 'AdminRefundCaller':
          return AdminRefundCaller.fromJson(value);
        case 'AdminRefundCompanion':
          return AdminRefundCompanion.fromJson(value);
        case 'AdminRefundInput':
          return AdminRefundInput.fromJson(value);
        case 'AdminRefundInputCall':
          return AdminRefundInputCall.fromJson(value);
        case 'AdminRefundInputCaller':
          return AdminRefundInputCaller.fromJson(value);
        case 'AdminRefundInputCompanion':
          return AdminRefundInputCompanion.fromJson(value);
        case 'AdminRejectPayoutRequest':
          return AdminRejectPayoutRequest.fromJson(value);
        case 'AdminReport':
          return AdminReport.fromJson(value);
        case 'AdminReportInput':
          return AdminReportInput.fromJson(value);
        case 'AdminReportInputReported':
          return AdminReportInputReported.fromJson(value);
        case 'AdminReportInputReporter':
          return AdminReportInputReporter.fromJson(value);
        case 'AdminReportReported':
          return AdminReportReported.fromJson(value);
        case 'AdminResolveModerationFlagRequest':
          return AdminResolveModerationFlagRequest.fromJson(value);
        case 'AdminResolveReportRequest':
          return AdminResolveReportRequest.fromJson(value);
        case 'AdminSendCoins200Response':
          return AdminSendCoins200Response.fromJson(value);
        case 'AdminSendCoinsRequest':
          return AdminSendCoinsRequest.fromJson(value);
        case 'AdminSendMessage200Response':
          return AdminSendMessage200Response.fromJson(value);
        case 'AdminSendMessageRequest':
          return AdminSendMessageRequest.fromJson(value);
        case 'AdminSetUserStatusRequest':
          return AdminSetUserStatusRequest.fromJson(value);
        case 'AdminSetVideoRequest':
          return AdminSetVideoRequest.fromJson(value);
        case 'AdminUpdateGiftRequest':
          return AdminUpdateGiftRequest.fromJson(value);
        case 'AdminUpdatePackageRequest':
          return AdminUpdatePackageRequest.fromJson(value);
        case 'AdminUpdateSettingRequest':
          return AdminUpdateSettingRequest.fromJson(value);
        case 'AdminUser':
          return AdminUser.fromJson(value);
        case 'AdminUserDetail':
          return AdminUserDetail.fromJson(value);
        case 'AdminUserDetailAuditInner':
          return AdminUserDetailAuditInner.fromJson(value);
        case 'AdminUserDetailCallsInner':
          return AdminUserDetailCallsInner.fromJson(value);
        case 'AdminUserDetailCompanion':
          return AdminUserDetailCompanion.fromJson(value);
        case 'AdminUserDetailInput':
          return AdminUserDetailInput.fromJson(value);
        case 'AdminUserDetailInputAuditInner':
          return AdminUserDetailInputAuditInner.fromJson(value);
        case 'AdminUserDetailInputCallsInner':
          return AdminUserDetailInputCallsInner.fromJson(value);
        case 'AdminUserDetailInputCompanion':
          return AdminUserDetailInputCompanion.fromJson(value);
        case 'AdminUserDetailInputLedgerInner':
          return AdminUserDetailInputLedgerInner.fromJson(value);
        case 'AdminUserDetailInputPayoutsInner':
          return AdminUserDetailInputPayoutsInner.fromJson(value);
        case 'AdminUserDetailInputPurchasesInner':
          return AdminUserDetailInputPurchasesInner.fromJson(value);
        case 'AdminUserDetailInputRefundsInner':
          return AdminUserDetailInputRefundsInner.fromJson(value);
        case 'AdminUserDetailInputReportsInner':
          return AdminUserDetailInputReportsInner.fromJson(value);
        case 'AdminUserDetailInputStats':
          return AdminUserDetailInputStats.fromJson(value);
        case 'AdminUserDetailLedgerInner':
          return AdminUserDetailLedgerInner.fromJson(value);
        case 'AdminUserDetailPayoutsInner':
          return AdminUserDetailPayoutsInner.fromJson(value);
        case 'AdminUserDetailPurchasesInner':
          return AdminUserDetailPurchasesInner.fromJson(value);
        case 'AdminUserDetailRefundsInner':
          return AdminUserDetailRefundsInner.fromJson(value);
        case 'AdminUserDetailReportsInner':
          return AdminUserDetailReportsInner.fromJson(value);
        case 'AdminUserDetailStats':
          return AdminUserDetailStats.fromJson(value);
        case 'AdminUserInput':
          return AdminUserInput.fromJson(value);
        case 'AnswerLessonQuiz200Response':
          return AnswerLessonQuiz200Response.fromJson(value);
        case 'AnswerLessonQuizRequest':
          return AnswerLessonQuizRequest.fromJson(value);
        case 'ApplyAsCompanionRequest':
          return ApplyAsCompanionRequest.fromJson(value);
        case 'BlockUserRequest':
          return BlockUserRequest.fromJson(value);
        case 'CallDetails':
          return CallDetails.fromJson(value);
        case 'CallDetailsGiftsInner':
          return CallDetailsGiftsInner.fromJson(value);
        case 'CallDetailsInput':
          return CallDetailsInput.fromJson(value);
        case 'CallDetailsInputGiftsInner':
          return CallDetailsInputGiftsInner.fromJson(value);
        case 'CallDetailsInputMinutesInner':
          return CallDetailsInputMinutesInner.fromJson(value);
        case 'CallDetailsMinutesInner':
          return CallDetailsMinutesInner.fromJson(value);
        case 'CallSummary':
          return CallSummary.fromJson(value);
        case 'CallSummaryInput':
          return CallSummaryInput.fromJson(value);
        case 'ChatItem':
          return ChatItem.fromJson(value);
        case 'ChatItemInput':
          return ChatItemInput.fromJson(value);
        case 'CheckIn':
          return CheckIn.fromJson(value);
        case 'CheckInDaysInner':
          return CheckInDaysInner.fromJson(value);
        case 'CheckInInput':
          return CheckInInput.fromJson(value);
        case 'CheckInInputDaysInner':
          return CheckInInputDaysInner.fromJson(value);
        case 'ClaimCheckIn200Response':
          return ClaimCheckIn200Response.fromJson(value);
        case 'CompanionEarnings200Response':
          return CompanionEarnings200Response.fromJson(value);
        case 'CompanionEarnings200ResponseWeekInner':
          return CompanionEarnings200ResponseWeekInner.fromJson(value);
        case 'CompanionHome200Response':
          return CompanionHome200Response.fromJson(value);
        case 'CompanionHome200ResponseRecentInner':
          return CompanionHome200ResponseRecentInner.fromJson(value);
        case 'CompanionHome200ResponseToday':
          return CompanionHome200ResponseToday.fromJson(value);
        case 'CompanionRates':
          return CompanionRates.fromJson(value);
        case 'CompanionRatesInput':
          return CompanionRatesInput.fromJson(value);
        case 'Conversation':
          return Conversation.fromJson(value);
        case 'ConversationInput':
          return ConversationInput.fromJson(value);
        case 'ConversationInputOther':
          return ConversationInputOther.fromJson(value);
        case 'ConversationOther':
          return ConversationOther.fromJson(value);
        case 'DeleteAccount200Response':
          return DeleteAccount200Response.fromJson(value);
        case 'DeleteAccountRequest':
          return DeleteAccountRequest.fromJson(value);
        case 'Favourite':
          return Favourite.fromJson(value);
        case 'FavouriteInput':
          return FavouriteInput.fromJson(value);
        case 'FlagVideoFrame201Response':
          return FlagVideoFrame201Response.fromJson(value);
        case 'FlagVideoFrame202Response':
          return FlagVideoFrame202Response.fromJson(value);
        case 'FlagVideoFrameRequest':
          return FlagVideoFrameRequest.fromJson(value);
        case 'GetAcademy200Response':
          return GetAcademy200Response.fromJson(value);
        case 'GetChatMessages200Response':
          return GetChatMessages200Response.fromJson(value);
        case 'GetCompanion200Response':
          return GetCompanion200Response.fromJson(value);
        case 'GetLegalPage200Response':
          return GetLegalPage200Response.fromJson(value);
        case 'GetReferral200Response':
          return GetReferral200Response.fromJson(value);
        case 'GetShareCard200Response':
          return GetShareCard200Response.fromJson(value);
        case 'GetWallet200Response':
          return GetWallet200Response.fromJson(value);
        case 'Gift':
          return Gift.fromJson(value);
        case 'GiftInput':
          return GiftInput.fromJson(value);
        case 'JoinInfo':
          return JoinInfo.fromJson(value);
        case 'JoinInfoInput':
          return JoinInfoInput.fromJson(value);
        case 'KycState':
          return KycState.fromJson(value);
        case 'KycStateAadhaar':
          return KycStateAadhaar.fromJson(value);
        case 'KycStateInput':
          return KycStateInput.fromJson(value);
        case 'KycStateInputAadhaar':
          return KycStateInputAadhaar.fromJson(value);
        case 'KycStateInputPan':
          return KycStateInputPan.fromJson(value);
        case 'KycStateInputSelfie':
          return KycStateInputSelfie.fromJson(value);
        case 'KycStateInputUpi':
          return KycStateInputUpi.fromJson(value);
        case 'KycStatePan':
          return KycStatePan.fromJson(value);
        case 'KycStateSelfie':
          return KycStateSelfie.fromJson(value);
        case 'KycStateUpi':
          return KycStateUpi.fromJson(value);
        case 'LedgerEntry':
          return LedgerEntry.fromJson(value);
        case 'LedgerEntryInput':
          return LedgerEntryInput.fromJson(value);
        case 'LegalBlock':
          return LegalBlock.fromJson(value);
        case 'LegalBlockInput':
          return LegalBlockInput.fromJson(value);
        case 'LegalCell':
          return LegalCell.fromJson(value);
        case 'LegalCellInput':
          return LegalCellInput.fromJson(value);
        case 'LegalRow':
          return LegalRow.fromJson(value);
        case 'LegalRowInput':
          return LegalRowInput.fromJson(value);
        case 'LegalSpan':
          return LegalSpan.fromJson(value);
        case 'LegalSpanInput':
          return LegalSpanInput.fromJson(value);
        case 'ListBlocks200ResponseInner':
          return ListBlocks200ResponseInner.fromJson(value);
        case 'ListCalls200Response':
          return ListCalls200Response.fromJson(value);
        case 'ListChats200Response':
          return ListChats200Response.fromJson(value);
        case 'ListCoinPackages200ResponseInner':
          return ListCoinPackages200ResponseInner.fromJson(value);
        case 'ListLanguages200ResponseInner':
          return ListLanguages200ResponseInner.fromJson(value);
        case 'ListLedger200Response':
          return ListLedger200Response.fromJson(value);
        case 'ListLegalPages200ResponseInner':
          return ListLegalPages200ResponseInner.fromJson(value);
        case 'ListNotifications200Response':
          return ListNotifications200Response.fromJson(value);
        case 'ListOnlineCompanions200Response':
          return ListOnlineCompanions200Response.fromJson(value);
        case 'MarkNotificationsReadRequest':
          return MarkNotificationsReadRequest.fromJson(value);
        case 'MatchCall201Response':
          return MatchCall201Response.fromJson(value);
        case 'MatchCallRequest':
          return MatchCallRequest.fromJson(value);
        case 'NotificationItem':
          return NotificationItem.fromJson(value);
        case 'NotificationItemInput':
          return NotificationItemInput.fromJson(value);
        case 'OnlineCompanion':
          return OnlineCompanion.fromJson(value);
        case 'OnlineCompanionInput':
          return OnlineCompanionInput.fromJson(value);
        case 'OtpVerifyResult':
          return OtpVerifyResult.fromJson(value);
        case 'OtpVerifyResultInput':
          return OtpVerifyResultInput.fromJson(value);
        case 'Party':
          return Party.fromJson(value);
        case 'PartyInput':
          return PartyInput.fromJson(value);
        case 'Payout':
          return Payout.fromJson(value);
        case 'PayoutInput':
          return PayoutInput.fromJson(value);
        case 'Profile':
          return Profile.fromJson(value);
        case 'ProfileCompanion':
          return ProfileCompanion.fromJson(value);
        case 'ProfileInput':
          return ProfileInput.fromJson(value);
        case 'ProfileInputCompanion':
          return ProfileInputCompanion.fromJson(value);
        case 'RateCallRequest':
          return RateCallRequest.fromJson(value);
        case 'RefreshTokensRequest':
          return RefreshTokensRequest.fromJson(value);
        case 'RefundRequest':
          return RefundRequest.fromJson(value);
        case 'RefundRequestInput':
          return RefundRequestInput.fromJson(value);
        case 'RegisterDeviceRequest':
          return RegisterDeviceRequest.fromJson(value);
        case 'ReportUser201Response':
          return ReportUser201Response.fromJson(value);
        case 'ReportUserRequest':
          return ReportUserRequest.fromJson(value);
        case 'RequestPayoutRequest':
          return RequestPayoutRequest.fromJson(value);
        case 'RequestRefundRequest':
          return RequestRefundRequest.fromJson(value);
        case 'SendChatMessageRequest':
          return SendChatMessageRequest.fromJson(value);
        case 'SendGift201Response':
          return SendGift201Response.fromJson(value);
        case 'SendGiftRequest':
          return SendGiftRequest.fromJson(value);
        case 'SendOtp200Response':
          return SendOtp200Response.fromJson(value);
        case 'SendOtpRequest':
          return SendOtpRequest.fromJson(value);
        case 'SetPresence200Response':
          return SetPresence200Response.fromJson(value);
        case 'SetPresenceRequest':
          return SetPresenceRequest.fromJson(value);
        case 'SetUpiRequest':
          return SetUpiRequest.fromJson(value);
        case 'SignUp201Response':
          return SignUp201Response.fromJson(value);
        case 'SignUpRequest':
          return SignUpRequest.fromJson(value);
        case 'StartCallRequest':
          return StartCallRequest.fromJson(value);
        case 'TokenPair':
          return TokenPair.fromJson(value);
        case 'TokenPairInput':
          return TokenPairInput.fromJson(value);
        case 'UnreadNotificationCount200Response':
          return UnreadNotificationCount200Response.fromJson(value);
        case 'UpdateMeRequest':
          return UpdateMeRequest.fromJson(value);
        case 'UploadAadhaarRequest':
          return UploadAadhaarRequest.fromJson(value);
        case 'UploadPanRequest':
          return UploadPanRequest.fromJson(value);
        case 'UploadSelfieRequest':
          return UploadSelfieRequest.fromJson(value);
        case 'VerifyOtpRequest':
          return VerifyOtpRequest.fromJson(value);
        default:
          dynamic match;
          if (value is List && (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toList(growable: growable);
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toSet();
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,)),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(HttpStatus.internalServerError, 'Exception during deserialization.', error, trace,);
    }
    throw ApiException(HttpStatus.internalServerError, 'Could not find a suitable class for deserialization',);
  }
}

/// Primarily intended for use in an isolate.
class DeserializationMessage {
  const DeserializationMessage({
    required this.json,
    required this.targetType,
    this.growable = false,
  });

  /// The JSON value to deserialize.
  final String json;

  /// Target type to deserialize to.
  final String targetType;

  /// Whether to make deserialized lists or maps growable.
  final bool growable;
}

/// Primarily intended for use in an isolate.
Future<dynamic> decodeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : json.decode(message.json);
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : ApiClient.fromJson(
        json.decode(message.json),
        targetType,
        growable: message.growable,
      );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async => value == null ? '' : json.encode(value);
