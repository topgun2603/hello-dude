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
        case 'AdminAddStaffRequest':
          return AdminAddStaffRequest.fromJson(value);
        case 'AdminAddUserNoteRequest':
          return AdminAddUserNoteRequest.fromJson(value);
        case 'AdminAnalytics':
          return AdminAnalytics.fromJson(value);
        case 'AdminAnalyticsByHourInner':
          return AdminAnalyticsByHourInner.fromJson(value);
        case 'AdminAnalyticsByLanguageInner':
          return AdminAnalyticsByLanguageInner.fromJson(value);
        case 'AdminAnalyticsByTypeInner':
          return AdminAnalyticsByTypeInner.fromJson(value);
        case 'AdminAnalyticsDailyInner':
          return AdminAnalyticsDailyInner.fromJson(value);
        case 'AdminAnalyticsInput':
          return AdminAnalyticsInput.fromJson(value);
        case 'AdminAnalyticsInputByHourInner':
          return AdminAnalyticsInputByHourInner.fromJson(value);
        case 'AdminAnalyticsInputByLanguageInner':
          return AdminAnalyticsInputByLanguageInner.fromJson(value);
        case 'AdminAnalyticsInputByTypeInner':
          return AdminAnalyticsInputByTypeInner.fromJson(value);
        case 'AdminAnalyticsInputDailyInner':
          return AdminAnalyticsInputDailyInner.fromJson(value);
        case 'AdminAnalyticsInputMargin':
          return AdminAnalyticsInputMargin.fromJson(value);
        case 'AdminAnalyticsInputMostActiveInner':
          return AdminAnalyticsInputMostActiveInner.fromJson(value);
        case 'AdminAnalyticsInputMostReportedInner':
          return AdminAnalyticsInputMostReportedInner.fromJson(value);
        case 'AdminAnalyticsInputPrevious':
          return AdminAnalyticsInputPrevious.fromJson(value);
        case 'AdminAnalyticsInputRange':
          return AdminAnalyticsInputRange.fromJson(value);
        case 'AdminAnalyticsInputTopEarnersInner':
          return AdminAnalyticsInputTopEarnersInner.fromJson(value);
        case 'AdminAnalyticsInputTopRatedInner':
          return AdminAnalyticsInputTopRatedInner.fromJson(value);
        case 'AdminAnalyticsInputTopSpendersInner':
          return AdminAnalyticsInputTopSpendersInner.fromJson(value);
        case 'AdminAnalyticsMargin':
          return AdminAnalyticsMargin.fromJson(value);
        case 'AdminAnalyticsMostActiveInner':
          return AdminAnalyticsMostActiveInner.fromJson(value);
        case 'AdminAnalyticsMostReportedInner':
          return AdminAnalyticsMostReportedInner.fromJson(value);
        case 'AdminAnalyticsPrevious':
          return AdminAnalyticsPrevious.fromJson(value);
        case 'AdminAnalyticsRange':
          return AdminAnalyticsRange.fromJson(value);
        case 'AdminAnalyticsTopEarnersInner':
          return AdminAnalyticsTopEarnersInner.fromJson(value);
        case 'AdminAnalyticsTopRatedInner':
          return AdminAnalyticsTopRatedInner.fromJson(value);
        case 'AdminAnalyticsTopSpendersInner':
          return AdminAnalyticsTopSpendersInner.fromJson(value);
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
        case 'AdminCreateBonusCampaignRequest':
          return AdminCreateBonusCampaignRequest.fromJson(value);
        case 'AdminCreateEventRequest':
          return AdminCreateEventRequest.fromJson(value);
        case 'AdminCreateGiftRequest':
          return AdminCreateGiftRequest.fromJson(value);
        case 'AdminCreatePackageRequest':
          return AdminCreatePackageRequest.fromJson(value);
        case 'AdminCreatePromotionRequest':
          return AdminCreatePromotionRequest.fromJson(value);
        case 'AdminCreateRateRequest':
          return AdminCreateRateRequest.fromJson(value);
        case 'AdminCreateRoleRequest':
          return AdminCreateRoleRequest.fromJson(value);
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
        case 'AdminDecidePhotoRequest':
          return AdminDecidePhotoRequest.fromJson(value);
        case 'AdminDecideRefundRequest':
          return AdminDecideRefundRequest.fromJson(value);
        case 'AdminEvent':
          return AdminEvent.fromJson(value);
        case 'AdminEventInput':
          return AdminEventInput.fromJson(value);
        case 'AdminGift':
          return AdminGift.fromJson(value);
        case 'AdminGiftInput':
          return AdminGiftInput.fromJson(value);
        case 'AdminGrantVip200Response':
          return AdminGrantVip200Response.fromJson(value);
        case 'AdminGrantVipRequest':
          return AdminGrantVipRequest.fromJson(value);
        case 'AdminGroup':
          return AdminGroup.fromJson(value);
        case 'AdminGroupInput':
          return AdminGroupInput.fromJson(value);
        case 'AdminKycCase':
          return AdminKycCase.fromJson(value);
        case 'AdminKycCaseAadhaar':
          return AdminKycCaseAadhaar.fromJson(value);
        case 'AdminKycCaseDeclared':
          return AdminKycCaseDeclared.fromJson(value);
        case 'AdminKycCaseInput':
          return AdminKycCaseInput.fromJson(value);
        case 'AdminKycCaseInputAadhaar':
          return AdminKycCaseInputAadhaar.fromJson(value);
        case 'AdminKycCaseInputAcademy':
          return AdminKycCaseInputAcademy.fromJson(value);
        case 'AdminKycCaseInputDeclared':
          return AdminKycCaseInputDeclared.fromJson(value);
        case 'AdminKycCaseInputVoice':
          return AdminKycCaseInputVoice.fromJson(value);
        case 'AdminKycCaseVoice':
          return AdminKycCaseVoice.fromJson(value);
        case 'AdminKycDecisionRequest':
          return AdminKycDecisionRequest.fromJson(value);
        case 'AdminListPayouts200Response':
          return AdminListPayouts200Response.fromJson(value);
        case 'AdminListPayouts200ResponseTotals':
          return AdminListPayouts200ResponseTotals.fromJson(value);
        case 'AdminListRoles200Response':
          return AdminListRoles200Response.fromJson(value);
        case 'AdminListRoles200ResponsePermissionsInner':
          return AdminListRoles200ResponsePermissionsInner.fromJson(value);
        case 'AdminListSettings200ResponseInner':
          return AdminListSettings200ResponseInner.fromJson(value);
        case 'AdminListUsers200Response':
          return AdminListUsers200Response.fromJson(value);
        case 'AdminLive':
          return AdminLive.fromJson(value);
        case 'AdminLiveInput':
          return AdminLiveInput.fromJson(value);
        case 'AdminMe':
          return AdminMe.fromJson(value);
        case 'AdminMeInput':
          return AdminMeInput.fromJson(value);
        case 'AdminModerationFlag':
          return AdminModerationFlag.fromJson(value);
        case 'AdminModerationFlagCall':
          return AdminModerationFlagCall.fromJson(value);
        case 'AdminModerationFlagDetectedBy':
          return AdminModerationFlagDetectedBy.fromJson(value);
        case 'AdminModerationFlagInput':
          return AdminModerationFlagInput.fromJson(value);
        case 'AdminModerationFlagInputCall':
          return AdminModerationFlagInputCall.fromJson(value);
        case 'AdminModerationFlagInputDetectedBy':
          return AdminModerationFlagInputDetectedBy.fromJson(value);
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
        case 'AdminPromotion':
          return AdminPromotion.fromJson(value);
        case 'AdminPromotionInput':
          return AdminPromotionInput.fromJson(value);
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
        case 'AdminReportReporter':
          return AdminReportReporter.fromJson(value);
        case 'AdminResolveModerationFlagRequest':
          return AdminResolveModerationFlagRequest.fromJson(value);
        case 'AdminResolveReportRequest':
          return AdminResolveReportRequest.fromJson(value);
        case 'AdminRevokeVipRequest':
          return AdminRevokeVipRequest.fromJson(value);
        case 'AdminRole':
          return AdminRole.fromJson(value);
        case 'AdminRoleInput':
          return AdminRoleInput.fromJson(value);
        case 'AdminSendCoins200Response':
          return AdminSendCoins200Response.fromJson(value);
        case 'AdminSendCoinsRequest':
          return AdminSendCoinsRequest.fromJson(value);
        case 'AdminSendMessage200Response':
          return AdminSendMessage200Response.fromJson(value);
        case 'AdminSendMessageRequest':
          return AdminSendMessageRequest.fromJson(value);
        case 'AdminSetPromotionActiveRequest':
          return AdminSetPromotionActiveRequest.fromJson(value);
        case 'AdminSetUserStatusRequest':
          return AdminSetUserStatusRequest.fromJson(value);
        case 'AdminSetVideoRequest':
          return AdminSetVideoRequest.fromJson(value);
        case 'AdminStaff':
          return AdminStaff.fromJson(value);
        case 'AdminStaffInput':
          return AdminStaffInput.fromJson(value);
        case 'AdminUpdateCallerLevelRequest':
          return AdminUpdateCallerLevelRequest.fromJson(value);
        case 'AdminUpdateCompanionLevelRequest':
          return AdminUpdateCompanionLevelRequest.fromJson(value);
        case 'AdminUpdateGiftRequest':
          return AdminUpdateGiftRequest.fromJson(value);
        case 'AdminUpdatePackageRequest':
          return AdminUpdatePackageRequest.fromJson(value);
        case 'AdminUpdateSettingRequest':
          return AdminUpdateSettingRequest.fromJson(value);
        case 'AdminUpdateStaffRequest':
          return AdminUpdateStaffRequest.fromJson(value);
        case 'AdminUpdateVipPlanRequest':
          return AdminUpdateVipPlanRequest.fromJson(value);
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
        case 'AdminUserDetailInputReportsInnerOther':
          return AdminUserDetailInputReportsInnerOther.fromJson(value);
        case 'AdminUserDetailInputStats':
          return AdminUserDetailInputStats.fromJson(value);
        case 'AdminUserDetailInputVip':
          return AdminUserDetailInputVip.fromJson(value);
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
        case 'AdminUserDetailReportsInnerOther':
          return AdminUserDetailReportsInnerOther.fromJson(value);
        case 'AdminUserDetailStats':
          return AdminUserDetailStats.fromJson(value);
        case 'AdminUserDetailVip':
          return AdminUserDetailVip.fromJson(value);
        case 'AdminUserInput':
          return AdminUserInput.fromJson(value);
        case 'AnalyticsTotals':
          return AnalyticsTotals.fromJson(value);
        case 'AnalyticsTotalsInput':
          return AnalyticsTotalsInput.fromJson(value);
        case 'AnswerLessonQuiz200Response':
          return AnswerLessonQuiz200Response.fromJson(value);
        case 'AnswerLessonQuizRequest':
          return AnswerLessonQuizRequest.fromJson(value);
        case 'AppEvent':
          return AppEvent.fromJson(value);
        case 'AppEventInput':
          return AppEventInput.fromJson(value);
        case 'ApplyAsCompanionRequest':
          return ApplyAsCompanionRequest.fromJson(value);
        case 'BlockUserRequest':
          return BlockUserRequest.fromJson(value);
        case 'BonusCampaign':
          return BonusCampaign.fromJson(value);
        case 'BonusCampaignInput':
          return BonusCampaignInput.fromJson(value);
        case 'Booking':
          return Booking.fromJson(value);
        case 'BookingInput':
          return BookingInput.fromJson(value);
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
        case 'CallHistorySummary':
          return CallHistorySummary.fromJson(value);
        case 'CallHistorySummaryInput':
          return CallHistorySummaryInput.fromJson(value);
        case 'CallSummary':
          return CallSummary.fromJson(value);
        case 'CallSummaryInput':
          return CallSummaryInput.fromJson(value);
        case 'CallerLevel':
          return CallerLevel.fromJson(value);
        case 'CallerLevelInput':
          return CallerLevelInput.fromJson(value);
        case 'ChallengePkRequest':
          return ChallengePkRequest.fromJson(value);
        case 'ChatItem':
          return ChatItem.fromJson(value);
        case 'ChatItemInput':
          return ChatItemInput.fromJson(value);
        case 'ChatRequest':
          return ChatRequest.fromJson(value);
        case 'ChatRequestInput':
          return ChatRequestInput.fromJson(value);
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
        case 'CoinHistoryItem':
          return CoinHistoryItem.fromJson(value);
        case 'CoinHistoryItemInput':
          return CoinHistoryItemInput.fromJson(value);
        case 'CoinHistorySummary':
          return CoinHistorySummary.fromJson(value);
        case 'CoinHistorySummaryInput':
          return CoinHistorySummaryInput.fromJson(value);
        case 'CompanionBonus':
          return CompanionBonus.fromJson(value);
        case 'CompanionBonusInput':
          return CompanionBonusInput.fromJson(value);
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
        case 'CompanionLevel':
          return CompanionLevel.fromJson(value);
        case 'CompanionLevelInput':
          return CompanionLevelInput.fromJson(value);
        case 'CompanionRates':
          return CompanionRates.fromJson(value);
        case 'CompanionRatesInput':
          return CompanionRatesInput.fromJson(value);
        case 'ConfirmBookingRequest':
          return ConfirmBookingRequest.fromJson(value);
        case 'ConfirmCompanionAgeRequest':
          return ConfirmCompanionAgeRequest.fromJson(value);
        case 'Conversation':
          return Conversation.fromJson(value);
        case 'ConversationInput':
          return ConversationInput.fromJson(value);
        case 'ConversationInputOther':
          return ConversationInputOther.fromJson(value);
        case 'ConversationOther':
          return ConversationOther.fromJson(value);
        case 'CreateBooking201Response':
          return CreateBooking201Response.fromJson(value);
        case 'CreateBookingRequest':
          return CreateBookingRequest.fromJson(value);
        case 'CreateGroupRequest':
          return CreateGroupRequest.fromJson(value);
        case 'CreateRazorpayOrderRequest':
          return CreateRazorpayOrderRequest.fromJson(value);
        case 'DeleteAccount200Response':
          return DeleteAccount200Response.fromJson(value);
        case 'DeleteAccountRequest':
          return DeleteAccountRequest.fromJson(value);
        case 'Favourite':
          return Favourite.fromJson(value);
        case 'FavouriteInput':
          return FavouriteInput.fromJson(value);
        case 'FlagGroupFrameRequest':
          return FlagGroupFrameRequest.fromJson(value);
        case 'FlagLiveFrameRequest':
          return FlagLiveFrameRequest.fromJson(value);
        case 'FlagVideoFrame201Response':
          return FlagVideoFrame201Response.fromJson(value);
        case 'FlagVideoFrame202Response':
          return FlagVideoFrame202Response.fromJson(value);
        case 'FlagVideoFrameRequest':
          return FlagVideoFrameRequest.fromJson(value);
        case 'GetAcademy200Response':
          return GetAcademy200Response.fromJson(value);
        case 'GetBookingSlots200Response':
          return GetBookingSlots200Response.fromJson(value);
        case 'GetBookingSlots200ResponseDaysInner':
          return GetBookingSlots200ResponseDaysInner.fromJson(value);
        case 'GetBookingSlots200ResponseDaysInnerSlotsInner':
          return GetBookingSlots200ResponseDaysInnerSlotsInner.fromJson(value);
        case 'GetChatMessages200Response':
          return GetChatMessages200Response.fromJson(value);
        case 'GetCoinHistory200Response':
          return GetCoinHistory200Response.fromJson(value);
        case 'GetCompanion200Response':
          return GetCompanion200Response.fromJson(value);
        case 'GetCompanionRewards200Response':
          return GetCompanionRewards200Response.fromJson(value);
        case 'GetCompanionRewards200ResponseAcademy':
          return GetCompanionRewards200ResponseAcademy.fromJson(value);
        case 'GetCurrentEvent200Response':
          return GetCurrentEvent200Response.fromJson(value);
        case 'GetCurrentPromotion200Response':
          return GetCurrentPromotion200Response.fromJson(value);
        case 'GetLeaderboard200Response':
          return GetLeaderboard200Response.fromJson(value);
        case 'GetLegalPage200Response':
          return GetLegalPage200Response.fromJson(value);
        case 'GetMyLevel200Response':
          return GetMyLevel200Response.fromJson(value);
        case 'GetMyLevel200ResponseNext':
          return GetMyLevel200ResponseNext.fromJson(value);
        case 'GetPk200Response':
          return GetPk200Response.fromJson(value);
        case 'GetPk200ResponseOther':
          return GetPk200ResponseOther.fromJson(value);
        case 'GetReferral200Response':
          return GetReferral200Response.fromJson(value);
        case 'GetShareCard200Response':
          return GetShareCard200Response.fromJson(value);
        case 'GetVip200Response':
          return GetVip200Response.fromJson(value);
        case 'GetVip200ResponseWeeklyGift':
          return GetVip200ResponseWeeklyGift.fromJson(value);
        case 'GetWallet200Response':
          return GetWallet200Response.fromJson(value);
        case 'Gift':
          return Gift.fromJson(value);
        case 'GiftInput':
          return GiftInput.fromJson(value);
        case 'GroupCard':
          return GroupCard.fromJson(value);
        case 'GroupCardHost':
          return GroupCardHost.fromJson(value);
        case 'GroupCardInput':
          return GroupCardInput.fromJson(value);
        case 'GroupCardInputHost':
          return GroupCardInputHost.fromJson(value);
        case 'GroupHeartbeat200Response':
          return GroupHeartbeat200Response.fromJson(value);
        case 'GroupHostState':
          return GroupHostState.fromJson(value);
        case 'GroupHostStateInput':
          return GroupHostStateInput.fromJson(value);
        case 'GroupJoin':
          return GroupJoin.fromJson(value);
        case 'GroupJoinInput':
          return GroupJoinInput.fromJson(value);
        case 'GroupRoom':
          return GroupRoom.fromJson(value);
        case 'GroupRoomInput':
          return GroupRoomInput.fromJson(value);
        case 'InviteCaller201Response':
          return InviteCaller201Response.fromJson(value);
        case 'InviteCallerRequest':
          return InviteCallerRequest.fromJson(value);
        case 'JoinGroupRequest':
          return JoinGroupRequest.fromJson(value);
        case 'JoinInfo':
          return JoinInfo.fromJson(value);
        case 'JoinInfoInput':
          return JoinInfoInput.fromJson(value);
        case 'JoinLiveRequest':
          return JoinLiveRequest.fromJson(value);
        case 'KycState':
          return KycState.fromJson(value);
        case 'KycStateAge':
          return KycStateAge.fromJson(value);
        case 'KycStateInput':
          return KycStateInput.fromJson(value);
        case 'KycStateInputAge':
          return KycStateInputAge.fromJson(value);
        case 'KycStateInputPan':
          return KycStateInputPan.fromJson(value);
        case 'KycStateInputSelfie':
          return KycStateInputSelfie.fromJson(value);
        case 'KycStateInputUpi':
          return KycStateInputUpi.fromJson(value);
        case 'KycStateInputVoice':
          return KycStateInputVoice.fromJson(value);
        case 'KycStatePan':
          return KycStatePan.fromJson(value);
        case 'KycStateSelfie':
          return KycStateSelfie.fromJson(value);
        case 'KycStateUpi':
          return KycStateUpi.fromJson(value);
        case 'KycStateVoice':
          return KycStateVoice.fromJson(value);
        case 'LeaderboardEntry':
          return LeaderboardEntry.fromJson(value);
        case 'LeaderboardEntryInput':
          return LeaderboardEntryInput.fromJson(value);
        case 'LeaderboardEntryInputUser':
          return LeaderboardEntryInputUser.fromJson(value);
        case 'LeaderboardEntryUser':
          return LeaderboardEntryUser.fromJson(value);
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
        case 'ListBookings200Response':
          return ListBookings200Response.fromJson(value);
        case 'ListCalls200Response':
          return ListCalls200Response.fromJson(value);
        case 'ListChatRequests200Response':
          return ListChatRequests200Response.fromJson(value);
        case 'ListChats200Response':
          return ListChats200Response.fromJson(value);
        case 'ListCoinPackages200ResponseInner':
          return ListCoinPackages200ResponseInner.fromJson(value);
        case 'ListGroups200Response':
          return ListGroups200Response.fromJson(value);
        case 'ListLanguages200ResponseInner':
          return ListLanguages200ResponseInner.fromJson(value);
        case 'ListLedger200Response':
          return ListLedger200Response.fromJson(value);
        case 'ListLegalPages200ResponseInner':
          return ListLegalPages200ResponseInner.fromJson(value);
        case 'ListLives200Response':
          return ListLives200Response.fromJson(value);
        case 'ListNotifications200Response':
          return ListNotifications200Response.fromJson(value);
        case 'ListOnlineCallers200Response':
          return ListOnlineCallers200Response.fromJson(value);
        case 'ListOnlineCompanions200Response':
          return ListOnlineCompanions200Response.fromJson(value);
        case 'LiveAccess':
          return LiveAccess.fromJson(value);
        case 'LiveAccessInput':
          return LiveAccessInput.fromJson(value);
        case 'LiveCard':
          return LiveCard.fromJson(value);
        case 'LiveCardHost':
          return LiveCardHost.fromJson(value);
        case 'LiveCardInput':
          return LiveCardInput.fromJson(value);
        case 'LiveCardInputHost':
          return LiveCardInputHost.fromJson(value);
        case 'LiveChatHistory':
          return LiveChatHistory.fromJson(value);
        case 'LiveChatHistoryInput':
          return LiveChatHistoryInput.fromJson(value);
        case 'LiveChatHistoryInputMessagesInner':
          return LiveChatHistoryInputMessagesInner.fromJson(value);
        case 'LiveChatHistoryMessagesInner':
          return LiveChatHistoryMessagesInner.fromJson(value);
        case 'LiveHostHeartbeat200Response':
          return LiveHostHeartbeat200Response.fromJson(value);
        case 'LiveJoin':
          return LiveJoin.fromJson(value);
        case 'LiveJoinInput':
          return LiveJoinInput.fromJson(value);
        case 'LivePricing':
          return LivePricing.fromJson(value);
        case 'LivePricingInput':
          return LivePricingInput.fromJson(value);
        case 'LogPromotionEventRequest':
          return LogPromotionEventRequest.fromJson(value);
        case 'MarkNotificationsReadRequest':
          return MarkNotificationsReadRequest.fromJson(value);
        case 'MatchCall201Response':
          return MatchCall201Response.fromJson(value);
        case 'MatchCallRequest':
          return MatchCallRequest.fromJson(value);
        case 'MyPhoto':
          return MyPhoto.fromJson(value);
        case 'MyPhotoInput':
          return MyPhotoInput.fromJson(value);
        case 'NotificationItem':
          return NotificationItem.fromJson(value);
        case 'NotificationItemInput':
          return NotificationItemInput.fromJson(value);
        case 'OnlineCaller':
          return OnlineCaller.fromJson(value);
        case 'OnlineCallerInput':
          return OnlineCallerInput.fromJson(value);
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
        case 'PendingPhoto':
          return PendingPhoto.fromJson(value);
        case 'PendingPhotoInput':
          return PendingPhotoInput.fromJson(value);
        case 'PendingPhotoInputUser':
          return PendingPhotoInputUser.fromJson(value);
        case 'PendingPhotoUser':
          return PendingPhotoUser.fromJson(value);
        case 'PkBattle':
          return PkBattle.fromJson(value);
        case 'PkBattleInput':
          return PkBattleInput.fromJson(value);
        case 'PkSide':
          return PkSide.fromJson(value);
        case 'PkSideInput':
          return PkSideInput.fromJson(value);
        case 'Profile':
          return Profile.fromJson(value);
        case 'ProfileCompanion':
          return ProfileCompanion.fromJson(value);
        case 'ProfileInput':
          return ProfileInput.fromJson(value);
        case 'ProfileInputCompanion':
          return ProfileInputCompanion.fromJson(value);
        case 'Promotion':
          return Promotion.fromJson(value);
        case 'PromotionInput':
          return PromotionInput.fromJson(value);
        case 'PurchaseResult':
          return PurchaseResult.fromJson(value);
        case 'PurchaseResultInput':
          return PurchaseResultInput.fromJson(value);
        case 'RaiseHandRequest':
          return RaiseHandRequest.fromJson(value);
        case 'RateCallRequest':
          return RateCallRequest.fromJson(value);
        case 'RazorpayOrder':
          return RazorpayOrder.fromJson(value);
        case 'RazorpayOrderInput':
          return RazorpayOrderInput.fromJson(value);
        case 'RefreshTokensRequest':
          return RefreshTokensRequest.fromJson(value);
        case 'RefundRequest':
          return RefundRequest.fromJson(value);
        case 'RefundRequestInput':
          return RefundRequestInput.fromJson(value);
        case 'RegisterDeviceRequest':
          return RegisterDeviceRequest.fromJson(value);
        case 'ReportInGroupRequest':
          return ReportInGroupRequest.fromJson(value);
        case 'ReportUser201Response':
          return ReportUser201Response.fromJson(value);
        case 'ReportUserRequest':
          return ReportUserRequest.fromJson(value);
        case 'RequestPayoutRequest':
          return RequestPayoutRequest.fromJson(value);
        case 'RequestRefundRequest':
          return RequestRefundRequest.fromJson(value);
        case 'RoomCard':
          return RoomCard.fromJson(value);
        case 'RoomCardHost':
          return RoomCardHost.fromJson(value);
        case 'RoomCardInput':
          return RoomCardInput.fromJson(value);
        case 'RoomCardInputHost':
          return RoomCardInputHost.fromJson(value);
        case 'RoomJoin':
          return RoomJoin.fromJson(value);
        case 'RoomJoinInput':
          return RoomJoinInput.fromJson(value);
        case 'RoomMember':
          return RoomMember.fromJson(value);
        case 'RoomMemberInput':
          return RoomMemberInput.fromJson(value);
        case 'RoomState':
          return RoomState.fromJson(value);
        case 'RoomStateInput':
          return RoomStateInput.fromJson(value);
        case 'RoomToken200Response':
          return RoomToken200Response.fromJson(value);
        case 'SendChatMessageRequest':
          return SendChatMessageRequest.fromJson(value);
        case 'SendChatRequestRequest':
          return SendChatRequestRequest.fromJson(value);
        case 'SendGift201Response':
          return SendGift201Response.fromJson(value);
        case 'SendGiftRequest':
          return SendGiftRequest.fromJson(value);
        case 'SendLiveGiftRequest':
          return SendLiveGiftRequest.fromJson(value);
        case 'SendOtp200Response':
          return SendOtp200Response.fromJson(value);
        case 'SendOtpRequest':
          return SendOtpRequest.fromJson(value);
        case 'SendRoomGift201Response':
          return SendRoomGift201Response.fromJson(value);
        case 'SendRoomGiftRequest':
          return SendRoomGiftRequest.fromJson(value);
        case 'SendRoomMessageRequest':
          return SendRoomMessageRequest.fromJson(value);
        case 'SendRoomReactionRequest':
          return SendRoomReactionRequest.fromJson(value);
        case 'SetCompanionCallTypes200Response':
          return SetCompanionCallTypes200Response.fromJson(value);
        case 'SetCompanionCallTypesRequest':
          return SetCompanionCallTypesRequest.fromJson(value);
        case 'SetPresence200Response':
          return SetPresence200Response.fromJson(value);
        case 'SetPresenceRequest':
          return SetPresenceRequest.fromJson(value);
        case 'SetRoomStageRequest':
          return SetRoomStageRequest.fromJson(value);
        case 'SetUpiRequest':
          return SetUpiRequest.fromJson(value);
        case 'SignInWithFirebaseRequest':
          return SignInWithFirebaseRequest.fromJson(value);
        case 'SignUp201Response':
          return SignUp201Response.fromJson(value);
        case 'SignUpRequest':
          return SignUpRequest.fromJson(value);
        case 'StartCallRequest':
          return StartCallRequest.fromJson(value);
        case 'StartLiveRequest':
          return StartLiveRequest.fromJson(value);
        case 'StartRoomRequest':
          return StartRoomRequest.fromJson(value);
        case 'TokenPair':
          return TokenPair.fromJson(value);
        case 'TokenPairInput':
          return TokenPairInput.fromJson(value);
        case 'UnreadNotificationCount200Response':
          return UnreadNotificationCount200Response.fromJson(value);
        case 'UpdateMeRequest':
          return UpdateMeRequest.fromJson(value);
        case 'UploadLiveSnapshotRequest':
          return UploadLiveSnapshotRequest.fromJson(value);
        case 'UploadMyPhotoRequest':
          return UploadMyPhotoRequest.fromJson(value);
        case 'UploadPanRequest':
          return UploadPanRequest.fromJson(value);
        case 'UploadSelfieRequest':
          return UploadSelfieRequest.fromJson(value);
        case 'UploadVoiceIntroRequest':
          return UploadVoiceIntroRequest.fromJson(value);
        case 'UserBadge':
          return UserBadge.fromJson(value);
        case 'UserBadgeInput':
          return UserBadgeInput.fromJson(value);
        case 'VerifyCallConnected200Response':
          return VerifyCallConnected200Response.fromJson(value);
        case 'VerifyOtpRequest':
          return VerifyOtpRequest.fromJson(value);
        case 'VerifyRazorpayPaymentRequest':
          return VerifyRazorpayPaymentRequest.fromJson(value);
        case 'VipPlan':
          return VipPlan.fromJson(value);
        case 'VipPlanInput':
          return VipPlanInput.fromJson(value);
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
