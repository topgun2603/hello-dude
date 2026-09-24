//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class CompanionApi {
  CompanionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Submit quiz answers (option index per question). All must be right to pass.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] lessonId (required):
  ///
  /// * [AnswerLessonQuizRequest] answerLessonQuizRequest (required):
  Future<Response> answerLessonQuizWithHttpInfo(int lessonId, AnswerLessonQuizRequest answerLessonQuizRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/academy/{lessonId}/answers'
      .replaceAll('{lessonId}', lessonId.toString());

    // ignore: prefer_final_locals
    Object? postBody = answerLessonQuizRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Submit quiz answers (option index per question). All must be right to pass.
  ///
  /// Parameters:
  ///
  /// * [int] lessonId (required):
  ///
  /// * [AnswerLessonQuizRequest] answerLessonQuizRequest (required):
  Future<AnswerLessonQuiz200Response?> answerLessonQuiz(int lessonId, AnswerLessonQuizRequest answerLessonQuizRequest, { Future<void>? abortTrigger, }) async {
    final response = await answerLessonQuizWithHttpInfo(lessonId, answerLessonQuizRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AnswerLessonQuiz200Response',) as AnswerLessonQuiz200Response;
    
    }
    return null;
  }

  /// Become a companion. Switches the account to companion mode and returns new tokens.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApplyAsCompanionRequest] applyAsCompanionRequest (required):
  Future<Response> applyAsCompanionWithHttpInfo(ApplyAsCompanionRequest applyAsCompanionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/apply';

    // ignore: prefer_final_locals
    Object? postBody = applyAsCompanionRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Become a companion. Switches the account to companion mode and returns new tokens.
  ///
  /// Parameters:
  ///
  /// * [ApplyAsCompanionRequest] applyAsCompanionRequest (required):
  Future<SignUp201Response?> applyAsCompanion(ApplyAsCompanionRequest applyAsCompanionRequest, { Future<void>? abortTrigger, }) async {
    final response = await applyAsCompanionWithHttpInfo(applyAsCompanionRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SignUp201Response',) as SignUp201Response;
    
    }
    return null;
  }

  /// Balance, last 7 days and withdrawals
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> companionEarningsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/earnings';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Balance, last 7 days and withdrawals
  Future<CompanionEarnings200Response?> companionEarnings({ Future<void>? abortTrigger, }) async {
    final response = await companionEarningsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CompanionEarnings200Response',) as CompanionEarnings200Response;
    
    }
    return null;
  }

  /// Companion home: status and today's numbers (India time)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> companionHomeWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/home';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Companion home: status and today's numbers (India time)
  Future<CompanionHome200Response?> companionHome({ Future<void>? abortTrigger, }) async {
    final response = await companionHomeWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CompanionHome200Response',) as CompanionHome200Response;
    
    }
    return null;
  }

  /// Lessons, in order, with my progress (quiz answers are not included)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getAcademyWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/academy';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Lessons, in order, with my progress (quiz answers are not included)
  Future<GetAcademy200Response?> getAcademy({ Future<void>? abortTrigger, }) async {
    final response = await getAcademyWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetAcademy200Response',) as GetAcademy200Response;
    
    }
    return null;
  }

  /// Rewards screen: level, today's goal, online streak and bonuses
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCompanionRewardsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/rewards';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Rewards screen: level, today's goal, online streak and bonuses
  Future<GetCompanionRewards200Response?> getCompanionRewards({ Future<void>? abortTrigger, }) async {
    final response = await getCompanionRewardsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCompanionRewards200Response',) as GetCompanionRewards200Response;
    
    }
    return null;
  }

  /// Verification progress
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getKycWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/kyc';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Verification progress
  Future<KycState?> getKyc({ Future<void>? abortTrigger, }) async {
    final response = await getKycWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }

  /// Withdraw to UPI. The amount leaves the balance now; a failed payout is credited back.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RequestPayoutRequest] requestPayoutRequest (required):
  Future<Response> requestPayoutWithHttpInfo(RequestPayoutRequest requestPayoutRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/payouts';

    // ignore: prefer_final_locals
    Object? postBody = requestPayoutRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Withdraw to UPI. The amount leaves the balance now; a failed payout is credited back.
  ///
  /// Parameters:
  ///
  /// * [RequestPayoutRequest] requestPayoutRequest (required):
  Future<Payout?> requestPayout(RequestPayoutRequest requestPayoutRequest, { Future<void>? abortTrigger, }) async {
    final response = await requestPayoutWithHttpInfo(requestPayoutRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Payout',) as Payout;
    
    }
    return null;
  }

  /// Choose which calls to take: voice, video or both (video only once it's unlocked)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SetCompanionCallTypesRequest] setCompanionCallTypesRequest (required):
  Future<Response> setCompanionCallTypesWithHttpInfo(SetCompanionCallTypesRequest setCompanionCallTypesRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/call-types';

    // ignore: prefer_final_locals
    Object? postBody = setCompanionCallTypesRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Choose which calls to take: voice, video or both (video only once it's unlocked)
  ///
  /// Parameters:
  ///
  /// * [SetCompanionCallTypesRequest] setCompanionCallTypesRequest (required):
  Future<SetCompanionCallTypes200Response?> setCompanionCallTypes(SetCompanionCallTypesRequest setCompanionCallTypesRequest, { Future<void>? abortTrigger, }) async {
    final response = await setCompanionCallTypesWithHttpInfo(setCompanionCallTypesRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SetCompanionCallTypes200Response',) as SetCompanionCallTypes200Response;
    
    }
    return null;
  }

  /// Go online / offline. While online, call again every 60 s as a heartbeat.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SetPresenceRequest] setPresenceRequest (required):
  Future<Response> setPresenceWithHttpInfo(SetPresenceRequest setPresenceRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/presence';

    // ignore: prefer_final_locals
    Object? postBody = setPresenceRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Go online / offline. While online, call again every 60 s as a heartbeat.
  ///
  /// Parameters:
  ///
  /// * [SetPresenceRequest] setPresenceRequest (required):
  Future<SetPresence200Response?> setPresence(SetPresenceRequest setPresenceRequest, { Future<void>? abortTrigger, }) async {
    final response = await setPresenceWithHttpInfo(setPresenceRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SetPresence200Response',) as SetPresence200Response;
    
    }
    return null;
  }

  /// Step 3b / later: UPI ID for withdrawals
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SetUpiRequest] setUpiRequest (required):
  Future<Response> setUpiWithHttpInfo(SetUpiRequest setUpiRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/upi';

    // ignore: prefer_final_locals
    Object? postBody = setUpiRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Step 3b / later: UPI ID for withdrawals
  ///
  /// Parameters:
  ///
  /// * [SetUpiRequest] setUpiRequest (required):
  Future<KycState?> setUpi(SetUpiRequest setUpiRequest, { Future<void>? abortTrigger, }) async {
    final response = await setUpiWithHttpInfo(setUpiRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }

  /// Send everything for review
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> submitKycWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/kyc/submit';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Send everything for review
  Future<KycState?> submitKyc({ Future<void>? abortTrigger, }) async {
    final response = await submitKycWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }

  /// Step 1: Aadhaar offline e-KYC ZIP (from myaadhaar.uidai.gov.in) + its 4-character share code
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UploadAadhaarRequest] uploadAadhaarRequest (required):
  Future<Response> uploadAadhaarWithHttpInfo(UploadAadhaarRequest uploadAadhaarRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/kyc/aadhaar';

    // ignore: prefer_final_locals
    Object? postBody = uploadAadhaarRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Step 1: Aadhaar offline e-KYC ZIP (from myaadhaar.uidai.gov.in) + its 4-character share code
  ///
  /// Parameters:
  ///
  /// * [UploadAadhaarRequest] uploadAadhaarRequest (required):
  Future<KycState?> uploadAadhaar(UploadAadhaarRequest uploadAadhaarRequest, { Future<void>? abortTrigger, }) async {
    final response = await uploadAadhaarWithHttpInfo(uploadAadhaarRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }

  /// Step 3a: PAN number + photo of the card (needed for TDS)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UploadPanRequest] uploadPanRequest (required):
  Future<Response> uploadPanWithHttpInfo(UploadPanRequest uploadPanRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/kyc/pan';

    // ignore: prefer_final_locals
    Object? postBody = uploadPanRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Step 3a: PAN number + photo of the card (needed for TDS)
  ///
  /// Parameters:
  ///
  /// * [UploadPanRequest] uploadPanRequest (required):
  Future<KycState?> uploadPan(UploadPanRequest uploadPanRequest, { Future<void>? abortTrigger, }) async {
    final response = await uploadPanWithHttpInfo(uploadPanRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }

  /// Step 2: live selfie. The app runs the blink check (ML Kit) before sending.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UploadSelfieRequest] uploadSelfieRequest (required):
  Future<Response> uploadSelfieWithHttpInfo(UploadSelfieRequest uploadSelfieRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companion/kyc/selfie';

    // ignore: prefer_final_locals
    Object? postBody = uploadSelfieRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Step 2: live selfie. The app runs the blink check (ML Kit) before sending.
  ///
  /// Parameters:
  ///
  /// * [UploadSelfieRequest] uploadSelfieRequest (required):
  Future<KycState?> uploadSelfie(UploadSelfieRequest uploadSelfieRequest, { Future<void>? abortTrigger, }) async {
    final response = await uploadSelfieWithHttpInfo(uploadSelfieRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'KycState',) as KycState;
    
    }
    return null;
  }
}
