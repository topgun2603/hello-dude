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

  /// Add a staff member: they sign in to the panel with this phone number (OTP)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminAddStaffRequest] adminAddStaffRequest (required):
  Future<Response> adminAddStaffWithHttpInfo(AdminAddStaffRequest adminAddStaffRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/staff';

    // ignore: prefer_final_locals
    Object? postBody = adminAddStaffRequest;

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

  /// Add a staff member: they sign in to the panel with this phone number (OTP)
  ///
  /// Parameters:
  ///
  /// * [AdminAddStaffRequest] adminAddStaffRequest (required):
  Future<AdminStaff?> adminAddStaff(AdminAddStaffRequest adminAddStaffRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminAddStaffWithHttpInfo(adminAddStaffRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminStaff',) as AdminStaff;
    
    }
    return null;
  }

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

  /// Analytics for a date range (India time, both days included), with the previous period for comparison
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] from:
  ///   Default: 29 days before `to`
  ///
  /// * [String] to:
  ///   Default: today
  ///
  /// * [int] minRatings:
  ///   Ratings needed to appear in Top rated
  Future<Response> adminAnalyticsWithHttpInfo({ String? from, String? to, int? minRatings, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/analytics';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (from != null) {
      queryParams.addAll(_queryParams('', 'from', from));
    }
    if (to != null) {
      queryParams.addAll(_queryParams('', 'to', to));
    }
    if (minRatings != null) {
      queryParams.addAll(_queryParams('', 'minRatings', minRatings));
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

  /// Analytics for a date range (India time, both days included), with the previous period for comparison
  ///
  /// Parameters:
  ///
  /// * [String] from:
  ///   Default: 29 days before `to`
  ///
  /// * [String] to:
  ///   Default: today
  ///
  /// * [int] minRatings:
  ///   Ratings needed to appear in Top rated
  Future<AdminAnalytics?> adminAnalytics({ String? from, String? to, int? minRatings, Future<void>? abortTrigger, }) async {
    final response = await adminAnalyticsWithHttpInfo(from: from, to: to, minRatings: minRatings, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminAnalytics',) as AdminAnalytics;
    
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

  /// Create a bonus campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminCreateBonusCampaignRequest] adminCreateBonusCampaignRequest (required):
  Future<Response> adminCreateBonusCampaignWithHttpInfo(AdminCreateBonusCampaignRequest adminCreateBonusCampaignRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/bonus-campaigns';

    // ignore: prefer_final_locals
    Object? postBody = adminCreateBonusCampaignRequest;

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

  /// Create a bonus campaign
  ///
  /// Parameters:
  ///
  /// * [AdminCreateBonusCampaignRequest] adminCreateBonusCampaignRequest (required):
  Future<BonusCampaign?> adminCreateBonusCampaign(AdminCreateBonusCampaignRequest adminCreateBonusCampaignRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreateBonusCampaignWithHttpInfo(adminCreateBonusCampaignRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BonusCampaign',) as BonusCampaign;
    
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

  /// Performs an HTTP 'POST /v1/admin/promotions' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AdminCreatePromotionRequest] adminCreatePromotionRequest (required):
  Future<Response> adminCreatePromotionWithHttpInfo(AdminCreatePromotionRequest adminCreatePromotionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/promotions';

    // ignore: prefer_final_locals
    Object? postBody = adminCreatePromotionRequest;

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

  /// Parameters:
  ///
  /// * [AdminCreatePromotionRequest] adminCreatePromotionRequest (required):
  Future<AdminPromotion?> adminCreatePromotion(AdminCreatePromotionRequest adminCreatePromotionRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreatePromotionWithHttpInfo(adminCreatePromotionRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPromotion',) as AdminPromotion;
    
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

  /// Add a custom role
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminCreateRoleRequest] adminCreateRoleRequest (required):
  Future<Response> adminCreateRoleWithHttpInfo(AdminCreateRoleRequest adminCreateRoleRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/roles';

    // ignore: prefer_final_locals
    Object? postBody = adminCreateRoleRequest;

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

  /// Add a custom role
  ///
  /// Parameters:
  ///
  /// * [AdminCreateRoleRequest] adminCreateRoleRequest (required):
  Future<AdminRole?> adminCreateRole(AdminCreateRoleRequest adminCreateRoleRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminCreateRoleWithHttpInfo(adminCreateRoleRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminRole',) as AdminRole;
    
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

  /// Approve (it replaces their avatar everywhere) or reject with a reason they'll see
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminDecidePhotoRequest] adminDecidePhotoRequest (required):
  Future<Response> adminDecidePhotoWithHttpInfo(String userId, AdminDecidePhotoRequest adminDecidePhotoRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/photos/{userId}/decision'
      .replaceAll('{userId}', userId);

    // ignore: prefer_final_locals
    Object? postBody = adminDecidePhotoRequest;

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

  /// Approve (it replaces their avatar everywhere) or reject with a reason they'll see
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [AdminDecidePhotoRequest] adminDecidePhotoRequest (required):
  Future<String?> adminDecidePhoto(String userId, AdminDecidePhotoRequest adminDecidePhotoRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminDecidePhotoWithHttpInfo(userId, adminDecidePhotoRequest, abortTrigger: abortTrigger,);
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

  /// Delete a promotion and its view stats
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> adminDeletePromotionWithHttpInfo(int id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/promotions/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Delete a promotion and its view stats
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<String?> adminDeletePromotion(int id, { Future<void>? abortTrigger, }) async {
    final response = await adminDeletePromotionWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// Delete a custom role nobody has
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] code (required):
  Future<Response> adminDeleteRoleWithHttpInfo(String code, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/roles/{code}'
      .replaceAll('{code}', code);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Delete a custom role nobody has
  ///
  /// Parameters:
  ///
  /// * [String] code (required):
  Future<String?> adminDeleteRole(String code, { Future<void>? abortTrigger, }) async {
    final response = await adminDeleteRoleWithHttpInfo(code, abortTrigger: abortTrigger,);
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

  /// End or cancel a group now (moderation)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<Response> adminEndGroupWithHttpInfo(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/groups/{id}/end'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRevokeVipRequest;

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

  /// End or cancel a group now (moderation)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<String?> adminEndGroup(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminEndGroupWithHttpInfo(id, adminRevokeVipRequest, abortTrigger: abortTrigger,);
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

  /// End a live now (moderation)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<Response> adminEndLiveWithHttpInfo(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/lives/{id}/end'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRevokeVipRequest;

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

  /// End a live now (moderation)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<String?> adminEndLive(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminEndLiveWithHttpInfo(id, adminRevokeVipRequest, abortTrigger: abortTrigger,);
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

  /// End a room now (moderation)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<Response> adminEndRoomWithHttpInfo(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/rooms/{id}/end'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRevokeVipRequest;

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

  /// End a room now (moderation)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<String?> adminEndRoom(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminEndRoomWithHttpInfo(id, adminRevokeVipRequest, abortTrigger: abortTrigger,);
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

  /// Give a caller VIP for some days (extends an active VIP). Audited; the caller is notified.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminGrantVipRequest] adminGrantVipRequest (required):
  Future<Response> adminGrantVipWithHttpInfo(String id, AdminGrantVipRequest adminGrantVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/vip'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminGrantVipRequest;

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

  /// Give a caller VIP for some days (extends an active VIP). Audited; the caller is notified.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminGrantVipRequest] adminGrantVipRequest (required):
  Future<AdminGrantVip200Response?> adminGrantVip(String id, AdminGrantVipRequest adminGrantVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminGrantVipWithHttpInfo(id, adminGrantVipRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminGrantVip200Response',) as AdminGrantVip200Response;
    
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

  /// Time-window bonus campaigns for companions
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListBonusCampaignsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/bonus-campaigns';

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

  /// Time-window bonus campaigns for companions
  Future<List<BonusCampaign>?> adminListBonusCampaigns({ Future<void>? abortTrigger, }) async {
    final response = await adminListBonusCampaignsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<BonusCampaign>') as List)
        .cast<BonusCampaign>()
        .toList(growable: false);

    }
    return null;
  }

  /// Companion levels
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListCompanionLevelsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/companion-levels';

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

  /// Companion levels
  Future<List<CompanionLevel>?> adminListCompanionLevels({ Future<void>? abortTrigger, }) async {
    final response = await adminListCompanionLevelsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CompanionLevel>') as List)
        .cast<CompanionLevel>()
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

  /// Open groups, then the last 50 that ended
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListGroupsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/groups';

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

  /// Open groups, then the last 50 that ended
  Future<List<AdminGroup>?> adminListGroups({ Future<void>? abortTrigger, }) async {
    final response = await adminListGroupsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminGroup>') as List)
        .cast<AdminGroup>()
        .toList(growable: false);

    }
    return null;
  }

  /// Lives now, then the last 50 that ended
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListLivesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/lives';

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

  /// Lives now, then the last 50 that ended
  Future<List<AdminLive>?> adminListLives({ Future<void>? abortTrigger, }) async {
    final response = await adminListLivesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminLive>') as List)
        .cast<AdminLive>()
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

  /// Companion photos waiting for review, oldest first
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListPhotosWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/photos';

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

  /// Companion photos waiting for review, oldest first
  Future<List<PendingPhoto>?> adminListPhotos({ Future<void>? abortTrigger, }) async {
    final response = await adminListPhotosWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PendingPhoto>') as List)
        .cast<PendingPhoto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Offers popup: every promotion with its reach and taps
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListPromotionsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/promotions';

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

  /// Offers popup: every promotion with its reach and taps
  Future<List<AdminPromotion>?> adminListPromotions({ Future<void>? abortTrigger, }) async {
    final response = await adminListPromotionsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminPromotion>') as List)
        .cast<AdminPromotion>()
        .toList(growable: false);

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

  /// Roles and the permission catalogue (for the permission grid)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListRolesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/roles';

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

  /// Roles and the permission catalogue (for the permission grid)
  Future<AdminListRoles200Response?> adminListRoles({ Future<void>? abortTrigger, }) async {
    final response = await adminListRolesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminListRoles200Response',) as AdminListRoles200Response;
    
    }
    return null;
  }

  /// Live voice rooms
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListRoomsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/rooms';

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

  /// Live voice rooms
  Future<List<RoomCard>?> adminListRooms({ Future<void>? abortTrigger, }) async {
    final response = await adminListRoomsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RoomCard>') as List)
        .cast<RoomCard>()
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

  /// Everyone who can sign in to the admin panel
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListStaffWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/staff';

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

  /// Everyone who can sign in to the admin panel
  Future<List<AdminStaff>?> adminListStaff({ Future<void>? abortTrigger, }) async {
    final response = await adminListStaffWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminStaff>') as List)
        .cast<AdminStaff>()
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

  /// VIP plans (prices must match the Play Console products)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminListVipPlansWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/vip-plans';

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

  /// VIP plans (prices must match the Play Console products)
  Future<List<VipPlan>?> adminListVipPlans({ Future<void>? abortTrigger, }) async {
    final response = await adminListVipPlansWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<VipPlan>') as List)
        .cast<VipPlan>()
        .toList(growable: false);

    }
    return null;
  }

  /// The signed-in staff member, their role and permissions (the panel hides what they can't do)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminMeWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/me';

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

  /// The signed-in staff member, their role and permissions (the panel hides what they can't do)
  Future<AdminMe?> adminMe({ Future<void>? abortTrigger, }) async {
    final response = await adminMeWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminMe',) as AdminMe;
    
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
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<Response> adminRejectPayoutWithHttpInfo(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/payouts/{id}/reject'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRevokeVipRequest;

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
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<String?> adminRejectPayout(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminRejectPayoutWithHttpInfo(id, adminRevokeVipRequest, abortTrigger: abortTrigger,);
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

  /// End someone's VIP now (e.g. a mistaken grant). Play subscriptions must also be refunded in Play Console.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<Response> adminRevokeVipWithHttpInfo(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/users/{id}/vip/revoke'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminRevokeVipRequest;

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

  /// End someone's VIP now (e.g. a mistaken grant). Play subscriptions must also be refunded in Play Console.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminRevokeVipRequest] adminRevokeVipRequest (required):
  Future<String?> adminRevokeVip(String id, AdminRevokeVipRequest adminRevokeVipRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminRevokeVipWithHttpInfo(id, adminRevokeVipRequest, abortTrigger: abortTrigger,);
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

  /// Switch a promotion on or off
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminSetPromotionActiveRequest] adminSetPromotionActiveRequest (required):
  Future<Response> adminSetPromotionActiveWithHttpInfo(int id, AdminSetPromotionActiveRequest adminSetPromotionActiveRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/promotions/{id}/active'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminSetPromotionActiveRequest;

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

  /// Switch a promotion on or off
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminSetPromotionActiveRequest] adminSetPromotionActiveRequest (required):
  Future<AdminPromotion?> adminSetPromotionActive(int id, AdminSetPromotionActiveRequest adminSetPromotionActiveRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminSetPromotionActiveWithHttpInfo(id, adminSetPromotionActiveRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPromotion',) as AdminPromotion;
    
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

  /// Edit or switch off a bonus campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminCreateBonusCampaignRequest] adminCreateBonusCampaignRequest (required):
  Future<Response> adminUpdateBonusCampaignWithHttpInfo(int id, AdminCreateBonusCampaignRequest adminCreateBonusCampaignRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/bonus-campaigns/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminCreateBonusCampaignRequest;

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

  /// Edit or switch off a bonus campaign
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminCreateBonusCampaignRequest] adminCreateBonusCampaignRequest (required):
  Future<BonusCampaign?> adminUpdateBonusCampaign(int id, AdminCreateBonusCampaignRequest adminCreateBonusCampaignRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateBonusCampaignWithHttpInfo(id, adminCreateBonusCampaignRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BonusCampaign',) as BonusCampaign;
    
    }
    return null;
  }

  /// Change a level's name, thresholds or earnings boost (applies to calls that start after this)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] level (required):
  ///
  /// * [AdminUpdateCompanionLevelRequest] adminUpdateCompanionLevelRequest (required):
  Future<Response> adminUpdateCompanionLevelWithHttpInfo(int level, AdminUpdateCompanionLevelRequest adminUpdateCompanionLevelRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/companion-levels/{level}'
      .replaceAll('{level}', level.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminUpdateCompanionLevelRequest;

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

  /// Change a level's name, thresholds or earnings boost (applies to calls that start after this)
  ///
  /// Parameters:
  ///
  /// * [int] level (required):
  ///
  /// * [AdminUpdateCompanionLevelRequest] adminUpdateCompanionLevelRequest (required):
  Future<CompanionLevel?> adminUpdateCompanionLevel(int level, AdminUpdateCompanionLevelRequest adminUpdateCompanionLevelRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateCompanionLevelWithHttpInfo(level, adminUpdateCompanionLevelRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CompanionLevel',) as CompanionLevel;
    
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

  /// Performs an HTTP 'PUT /v1/admin/promotions/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminCreatePromotionRequest] adminCreatePromotionRequest (required):
  Future<Response> adminUpdatePromotionWithHttpInfo(int id, AdminCreatePromotionRequest adminCreatePromotionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/promotions/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminCreatePromotionRequest;

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
  /// * [AdminCreatePromotionRequest] adminCreatePromotionRequest (required):
  Future<AdminPromotion?> adminUpdatePromotion(int id, AdminCreatePromotionRequest adminCreatePromotionRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdatePromotionWithHttpInfo(id, adminCreatePromotionRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPromotion',) as AdminPromotion;
    
    }
    return null;
  }

  /// Edit a role's name, description and permissions (not the built-in Admin)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] code (required):
  ///
  /// * [AdminCreateRoleRequest] adminCreateRoleRequest (required):
  Future<Response> adminUpdateRoleWithHttpInfo(String code, AdminCreateRoleRequest adminCreateRoleRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/roles/{code}'
      .replaceAll('{code}', code);

    // ignore: prefer_final_locals
    Object? postBody = adminCreateRoleRequest;

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

  /// Edit a role's name, description and permissions (not the built-in Admin)
  ///
  /// Parameters:
  ///
  /// * [String] code (required):
  ///
  /// * [AdminCreateRoleRequest] adminCreateRoleRequest (required):
  Future<AdminRole?> adminUpdateRole(String code, AdminCreateRoleRequest adminCreateRoleRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateRoleWithHttpInfo(code, adminCreateRoleRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminRole',) as AdminRole;
    
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

  /// Change a staff member's role, or switch their access off/on
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminUpdateStaffRequest] adminUpdateStaffRequest (required):
  Future<Response> adminUpdateStaffWithHttpInfo(String id, AdminUpdateStaffRequest adminUpdateStaffRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/staff/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminUpdateStaffRequest;

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

  /// Change a staff member's role, or switch their access off/on
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminUpdateStaffRequest] adminUpdateStaffRequest (required):
  Future<AdminStaff?> adminUpdateStaff(String id, AdminUpdateStaffRequest adminUpdateStaffRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateStaffWithHttpInfo(id, adminUpdateStaffRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminStaff',) as AdminStaff;
    
    }
    return null;
  }

  /// Change a VIP plan's price, badge or visibility
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdateVipPlanRequest] adminUpdateVipPlanRequest (required):
  Future<Response> adminUpdateVipPlanWithHttpInfo(int id, AdminUpdateVipPlanRequest adminUpdateVipPlanRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/admin/vip-plans/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminUpdateVipPlanRequest;

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

  /// Change a VIP plan's price, badge or visibility
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpdateVipPlanRequest] adminUpdateVipPlanRequest (required):
  Future<VipPlan?> adminUpdateVipPlan(int id, AdminUpdateVipPlanRequest adminUpdateVipPlanRequest, { Future<void>? abortTrigger, }) async {
    final response = await adminUpdateVipPlanWithHttpInfo(id, adminUpdateVipPlanRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VipPlan',) as VipPlan;
    
    }
    return null;
  }
}
