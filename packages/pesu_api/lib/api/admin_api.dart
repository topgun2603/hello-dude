//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class AdminApi {
  AdminApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add a private admin note to a caller or companion
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminAddUserNoteRequest] adminAddUserNoteRequest (required):
  Future<Response> adminAddUserNoteWithHttpInfo(String id, AdminAddUserNoteRequest adminAddUserNoteRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/notes'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminAddUserNoteRequest;

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

  /// Add a private admin note to a caller or companion
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminAddUserNoteRequest] adminAddUserNoteRequest (required):
  Future<AdminNote?> adminAddUserNote(String id, AdminAddUserNoteRequest adminAddUserNoteRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminAddUserNoteWithHttpInfo(id, adminAddUserNoteRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminNote',) as AdminNote;
    
    }
    return null;
  }

  /// Approve and send to UPI. Failures are credited back to the companion automatically.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminApprovePayoutWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/payouts/{id}/approve'
      .replaceAll('{id}', id);

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

  /// Approve and send to UPI. Failures are credited back to the companion automatically.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminPayout?> adminApprovePayout(String id, { Future<void>? abortTrigger, }) async {
    final response = await adminApprovePayoutWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPayout',) as AdminPayout;
    
    }
    return null;
  }

  /// Latest admin actions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  Future<Response> adminAuditLogWithHttpInfo({ int? limit, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/audit';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

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

  /// Latest admin actions
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  Future<List<AdminAuditLog200ResponseInner>?> adminAuditLog({ int? limit, Future<void>? abortTrigger, }) async {
    final response = await adminAuditLogWithHttpInfo(limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminAuditLog200ResponseInner>') as List)
        .cast<AdminAuditLog200ResponseInner>()
        .toList(growable: false);

    }
    return null;
  }

  /// Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminCreateGiftRequest] adminCreateGiftRequest (required):
  Future<Response> adminCreateGiftWithHttpInfo(AdminCreateGiftRequest adminCreateGiftRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/gifts';

    // ignore: prefer_final_locals
    Object? postBody = adminCreateGiftRequest;

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

  /// Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).
  ///
  /// Parameters:
  ///
  /// * [AdminCreateGiftRequest] adminCreateGiftRequest (required):
  Future<AdminGift?> adminCreateGift(AdminCreateGiftRequest adminCreateGiftRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreateGiftWithHttpInfo(adminCreateGiftRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminGift',) as AdminGift;
    
    }
    return null;
  }

  /// Add a coin pack. Create the Google Play product with the same SKU first.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminCreatePackageRequest] adminCreatePackageRequest (required):
  Future<Response> adminCreatePackageWithHttpInfo(AdminCreatePackageRequest adminCreatePackageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/coin-packages';

    // ignore: prefer_final_locals
    Object? postBody = adminCreatePackageRequest;

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

  /// Add a coin pack. Create the Google Play product with the same SKU first.
  ///
  /// Parameters:
  ///
  /// * [AdminCreatePackageRequest] adminCreatePackageRequest (required):
  Future<AdminCoinPackage?> adminCreatePackage(AdminCreatePackageRequest adminCreatePackageRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreatePackageWithHttpInfo(adminCreatePackageRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCoinPackage',) as AdminCoinPackage;
    
    }
    return null;
  }

  /// Add a rate version. Calls already running keep their old rate.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminCreateRateRequest] adminCreateRateRequest (required):
  Future<Response> adminCreateRateWithHttpInfo(AdminCreateRateRequest adminCreateRateRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/rates';

    // ignore: prefer_final_locals
    Object? postBody = adminCreateRateRequest;

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

  /// Add a rate version. Calls already running keep their old rate.
  ///
  /// Parameters:
  ///
  /// * [AdminCreateRateRequest] adminCreateRateRequest (required):
  Future<AdminCallRate?> adminCreateRate(AdminCreateRateRequest adminCreateRateRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreateRateWithHttpInfo(adminCreateRateRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCallRate',) as AdminCallRate;
    
    }
    return null;
  }

  /// Live numbers and today's totals (India time)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminDashboardWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/dashboard';

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

  /// Live numbers and today's totals (India time)
  Future<AdminDashboard200Response?> adminDashboard({ Future<void>? abortTrigger, }) async {
    final response = await adminDashboardWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminDashboard200Response',) as AdminDashboard200Response;
    
    }
    return null;
  }

  /// Approve (all or part of the coins) or reject a refund request
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminDecideRefundRequest] adminDecideRefundRequest (required):
  Future<Response> adminDecideRefundWithHttpInfo(String id, AdminDecideRefundRequest adminDecideRefundRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/refunds/{id}/decide'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminDecideRefundRequest;

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

  /// Approve (all or part of the coins) or reject a refund request
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminDecideRefundRequest] adminDecideRefundRequest (required):
  Future<String?> adminDecideRefund(String id, AdminDecideRefundRequest adminDecideRefundRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminDecideRefundWithHttpInfo(id, adminDecideRefundRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// The flagged frame (decrypted). Every view is audit-logged.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminGetModerationFrameWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/moderation/{id}/frame'
      .replaceAll('{id}', id);

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

  /// The flagged frame (decrypted). Every view is audit-logged.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> adminGetModerationFrame(String id, { Future<void>? abortTrigger, }) async {
    final response = await adminGetModerationFrameWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Everything about one caller or companion: profile, wallets, calls, money and safety history
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminGetUserWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}'
      .replaceAll('{id}', id);

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

  /// Everything about one caller or companion: profile, wallets, calls, money and safety history
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminUserDetail?> adminGetUser(String id, { Future<void>? abortTrigger, }) async {
    final response = await adminGetUserWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminUserDetail',) as AdminUserDetail;
    
    }
    return null;
  }

  /// Approve (companion can go online) or reject with a reason the companion will see
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminKycDecisionRequest] adminKycDecisionRequest (required):
  Future<Response> adminKycDecisionWithHttpInfo(String userId, AdminKycDecisionRequest adminKycDecisionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/kyc/{userId}/decision'
      .replaceAll('{userId}', userId);

    // ignore: prefer_final_locals
    Object? postBody = adminKycDecisionRequest;

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

  /// Approve (companion can go online) or reject with a reason the companion will see
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminKycDecisionRequest] adminKycDecisionRequest (required):
  Future<String?> adminKycDecision(String userId, AdminKycDecisionRequest adminKycDecisionRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminKycDecisionWithHttpInfo(userId, adminKycDecisionRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Decrypted KYC image for side-by-side review. Every view is audit-logged.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [String] doc (required):
  Future<Response> adminKycFileWithHttpInfo(String userId, String doc, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/kyc/{userId}/files/{doc}'
      .replaceAll('{userId}', userId)
      .replaceAll('{doc}', doc);

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

  /// Decrypted KYC image for side-by-side review. Every view is audit-logged.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [String] doc (required):
  Future<void> adminKycFile(String userId, String doc, { Future<void>? abortTrigger, }) async {
    final response = await adminKycFileWithHttpInfo(userId, doc, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// KYC review queue (oldest first) or decided cases
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] status:
  Future<Response> adminKycQueueWithHttpInfo({ String? status, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/kyc';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

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

  /// KYC review queue (oldest first) or decided cases
  ///
  /// Parameters:
  ///
  /// * [String] status:
  Future<List<AdminKycCase>?> adminKycQueue({ String? status, Future<void>? abortTrigger, }) async {
    final response = await adminKycQueueWithHttpInfo(status: status, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminKycCase>') as List)
        .cast<AdminKycCase>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/gifts' operation and returns the [Response].
  Future<Response> adminListGiftsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/gifts';

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

  Future<List<AdminGift>?> adminListGifts({ Future<void>? abortTrigger, }) async {
    final response = await adminListGiftsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminGift>') as List)
        .cast<AdminGift>()
        .toList(growable: false);

    }
    return null;
  }

  /// Video frames flagged for nudity by the app, oldest open first
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  Future<Response> adminListModerationFlagsWithHttpInfo({ String? status, int? limit, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/moderation';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

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

  /// Video frames flagged for nudity by the app, oldest open first
  ///
  /// Parameters:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  Future<List<AdminModerationFlag>?> adminListModerationFlags({ String? status, int? limit, Future<void>? abortTrigger, }) async {
    final response = await adminListModerationFlagsWithHttpInfo(status: status, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminModerationFlag>') as List)
        .cast<AdminModerationFlag>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/coin-packages' operation and returns the [Response].
  Future<Response> adminListPackagesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/coin-packages';

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

  Future<List<AdminCoinPackage>?> adminListPackages({ Future<void>? abortTrigger, }) async {
    final response = await adminListPackagesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminCoinPackage>') as List)
        .cast<AdminCoinPackage>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/payouts' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] status:
  Future<Response> adminListPayoutsWithHttpInfo({ String? status, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/payouts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

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

  /// Parameters:
  ///
  /// * [String] status:
  Future<AdminListPayouts200Response?> adminListPayouts({ String? status, Future<void>? abortTrigger, }) async {
    final response = await adminListPayoutsWithHttpInfo(status: status, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminListPayouts200Response',) as AdminListPayouts200Response;
    
    }
    return null;
  }

  /// All call rates: current, scheduled and past
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListRatesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/rates';

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

  /// All call rates: current, scheduled and past
  Future<List<AdminCallRate>?> adminListRates({ Future<void>? abortTrigger, }) async {
    final response = await adminListRatesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminCallRate>') as List)
        .cast<AdminCallRate>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/refunds' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] status:
  Future<Response> adminListRefundsWithHttpInfo({ String? status, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/refunds';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

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

  /// Parameters:
  ///
  /// * [String] status:
  Future<List<AdminRefund>?> adminListRefunds({ String? status, Future<void>? abortTrigger, }) async {
    final response = await adminListRefundsWithHttpInfo(status: status, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminRefund>') as List)
        .cast<AdminRefund>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/reports' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  Future<Response> adminListReportsWithHttpInfo({ String? status, int? limit, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/reports';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

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

  /// Parameters:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  Future<List<AdminReport>?> adminListReports({ String? status, int? limit, Future<void>? abortTrigger, }) async {
    final response = await adminListReportsWithHttpInfo(status: status, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminReport>') as List)
        .cast<AdminReport>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/admin/settings' operation and returns the [Response].
  Future<Response> adminListSettingsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/settings';

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

  Future<List<AdminListSettings200ResponseInner>?> adminListSettings({ Future<void>? abortTrigger, }) async {
    final response = await adminListSettingsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminListSettings200ResponseInner>') as List)
        .cast<AdminListSettings200ResponseInner>()
        .toList(growable: false);

    }
    return null;
  }

  /// Search callers or companions by name or the last digits of their number
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] role:
  ///
  /// * [String] q:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  ///
  /// * [int] offset:
  Future<Response> adminListUsersWithHttpInfo({ String? role, String? q, String? status, int? limit, int? offset, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (role != null) {
      queryParams.addAll(_queryParams('', 'role', role));
    }
    if (q != null) {
      queryParams.addAll(_queryParams('', 'q', q));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (offset != null) {
      queryParams.addAll(_queryParams('', 'offset', offset));
    }

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

  /// Search callers or companions by name or the last digits of their number
  ///
  /// Parameters:
  ///
  /// * [String] role:
  ///
  /// * [String] q:
  ///
  /// * [String] status:
  ///
  /// * [int] limit:
  ///
  /// * [int] offset:
  Future<AdminListUsers200Response?> adminListUsers({ String? role, String? q, String? status, int? limit, int? offset, Future<void>? abortTrigger, }) async {
    final response = await adminListUsersWithHttpInfo(role: role, q: q, status: status, limit: limit, offset: offset, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminListUsers200Response',) as AdminListUsers200Response;
    
    }
    return null;
  }

  /// Reject a withdrawal; the amount goes back to the companion's balance
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRejectPayoutRequest] adminRejectPayoutRequest (required):
  Future<Response> adminRejectPayoutWithHttpInfo(String id, AdminRejectPayoutRequest adminRejectPayoutRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/payouts/{id}/reject'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRejectPayoutRequest;

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

  /// Reject a withdrawal; the amount goes back to the companion's balance
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRejectPayoutRequest] adminRejectPayoutRequest (required):
  Future<String?> adminRejectPayout(String id, AdminRejectPayoutRequest adminRejectPayoutRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminRejectPayoutWithHttpInfo(id, adminRejectPayoutRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminResolveModerationFlagRequest] adminResolveModerationFlagRequest (required):
  Future<Response> adminResolveModerationFlagWithHttpInfo(String id, AdminResolveModerationFlagRequest adminResolveModerationFlagRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/moderation/{id}/resolve'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminResolveModerationFlagRequest;

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

  /// Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminResolveModerationFlagRequest] adminResolveModerationFlagRequest (required):
  Future<String?> adminResolveModerationFlag(String id, AdminResolveModerationFlagRequest adminResolveModerationFlagRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminResolveModerationFlagWithHttpInfo(id, adminResolveModerationFlagRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Dismiss a report, or act on it by suspending the reported user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminResolveReportRequest] adminResolveReportRequest (required):
  Future<Response> adminResolveReportWithHttpInfo(String id, AdminResolveReportRequest adminResolveReportRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/reports/{id}/resolve'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminResolveReportRequest;

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

  /// Dismiss a report, or act on it by suspending the reported user
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminResolveReportRequest] adminResolveReportRequest (required):
  Future<String?> adminResolveReport(String id, AdminResolveReportRequest adminResolveReportRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminResolveReportWithHttpInfo(id, adminResolveReportRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSendCoinsRequest] adminSendCoinsRequest (required):
  Future<Response> adminSendCoinsWithHttpInfo(String id, AdminSendCoinsRequest adminSendCoinsRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/coins'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminSendCoinsRequest;

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

  /// Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSendCoinsRequest] adminSendCoinsRequest (required):
  Future<AdminSendCoins200Response?> adminSendCoins(String id, AdminSendCoinsRequest adminSendCoinsRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminSendCoinsWithHttpInfo(id, adminSendCoinsRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminSendCoins200Response',) as AdminSendCoins200Response;
    
    }
    return null;
  }

  /// Send a push notification to one caller or companion
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSendMessageRequest] adminSendMessageRequest (required):
  Future<Response> adminSendMessageWithHttpInfo(String id, AdminSendMessageRequest adminSendMessageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/message'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminSendMessageRequest;

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

  /// Send a push notification to one caller or companion
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSendMessageRequest] adminSendMessageRequest (required):
  Future<AdminSendMessage200Response?> adminSendMessage(String id, AdminSendMessageRequest adminSendMessageRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminSendMessageWithHttpInfo(id, adminSendMessageRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminSendMessage200Response',) as AdminSendMessage200Response;
    
    }
    return null;
  }

  /// Suspend, ban or reactivate an account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSetUserStatusRequest] adminSetUserStatusRequest (required):
  Future<Response> adminSetUserStatusWithHttpInfo(String id, AdminSetUserStatusRequest adminSetUserStatusRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/status'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminSetUserStatusRequest;

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

  /// Suspend, ban or reactivate an account
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminSetUserStatusRequest] adminSetUserStatusRequest (required):
  Future<String?> adminSetUserStatus(String id, AdminSetUserStatusRequest adminSetUserStatusRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminSetUserStatusWithHttpInfo(id, adminSetUserStatusRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Unlock or lock video calls for a companion (after academy + clean record)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminSetVideoRequest] adminSetVideoRequest (required):
  Future<Response> adminSetVideoWithHttpInfo(String userId, AdminSetVideoRequest adminSetVideoRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/companions/{userId}/video'
      .replaceAll('{userId}', userId);

    // ignore: prefer_final_locals
    Object? postBody = adminSetVideoRequest;

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

  /// Unlock or lock video calls for a companion (after academy + clean record)
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminSetVideoRequest] adminSetVideoRequest (required):
  Future<String?> adminSetVideo(String userId, AdminSetVideoRequest adminSetVideoRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminSetVideoWithHttpInfo(userId, adminSetVideoRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /v1/admin/gifts/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdateGiftRequest] adminUpdateGiftRequest (required):
  Future<Response> adminUpdateGiftWithHttpInfo(int id, AdminUpdateGiftRequest adminUpdateGiftRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/gifts/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminUpdateGiftRequest;

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

  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdateGiftRequest] adminUpdateGiftRequest (required):
  Future<AdminGift?> adminUpdateGift(int id, AdminUpdateGiftRequest adminUpdateGiftRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateGiftWithHttpInfo(id, adminUpdateGiftRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminGift',) as AdminGift;
    
    }
    return null;
  }

  /// Edit a coin pack. The Google Play product price must be changed to match in Play Console.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdatePackageRequest] adminUpdatePackageRequest (required):
  Future<Response> adminUpdatePackageWithHttpInfo(int id, AdminUpdatePackageRequest adminUpdatePackageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/coin-packages/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminUpdatePackageRequest;

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

  /// Edit a coin pack. The Google Play product price must be changed to match in Play Console.
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdatePackageRequest] adminUpdatePackageRequest (required):
  Future<AdminCoinPackage?> adminUpdatePackage(int id, AdminUpdatePackageRequest adminUpdatePackageRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdatePackageWithHttpInfo(id, adminUpdatePackageRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCoinPackage',) as AdminCoinPackage;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /v1/admin/settings/{key}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] key (required):
  ///
  /// * [AdminUpdateSettingRequest] adminUpdateSettingRequest (required):
  Future<Response> adminUpdateSettingWithHttpInfo(String key, AdminUpdateSettingRequest adminUpdateSettingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/settings/{key}'
      .replaceAll('{key}', key);

    // ignore: prefer_final_locals
    Object? postBody = adminUpdateSettingRequest;

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

  /// Parameters:
  ///
  /// * [String] key (required):
  ///
  /// * [AdminUpdateSettingRequest] adminUpdateSettingRequest (required):
  Future<String?> adminUpdateSetting(String key, AdminUpdateSettingRequest adminUpdateSettingRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateSettingWithHttpInfo(key, adminUpdateSettingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }
}
