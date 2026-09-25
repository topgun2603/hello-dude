//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class WalletApi {
  WalletApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Start buying a coin pack with Razorpay: creates the order the app opens checkout for
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateRazorpayOrderRequest] createRazorpayOrderRequest (required):
  Future<Response> createRazorpayOrderWithHttpInfo(CreateRazorpayOrderRequest createRazorpayOrderRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/payments/razorpay/order';

    // ignore: prefer_final_locals
    Object? postBody = createRazorpayOrderRequest;

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

  /// Start buying a coin pack with Razorpay: creates the order the app opens checkout for
  ///
  /// Parameters:
  ///
  /// * [CreateRazorpayOrderRequest] createRazorpayOrderRequest (required):
  Future<RazorpayOrder?> createRazorpayOrder(CreateRazorpayOrderRequest createRazorpayOrderRequest, { Future<void>? abortTrigger, }) async {
    final response = await createRazorpayOrderWithHttpInfo(createRazorpayOrderRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RazorpayOrder',) as RazorpayOrder;
    
    }
    return null;
  }

  /// Coin history for people: one line per call (all its minutes), gifts, top-ups, bonuses, refunds; with totals for the same filters
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] filter:
  ///   Leave out for all
  ///
  /// * [Object] from:
  ///
  /// * [Object] to:
  ///
  /// * [String] cursor:
  ///   nextCursor from the previous page
  ///
  /// * [int] limit:
  Future<Response> getCoinHistoryWithHttpInfo({ String? filter, Object? from, Object? to, String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/wallet/history';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (from != null) {
      queryParams.addAll(_queryParams('', 'from', from));
    }
    if (to != null) {
      queryParams.addAll(_queryParams('', 'to', to));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
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

  /// Coin history for people: one line per call (all its minutes), gifts, top-ups, bonuses, refunds; with totals for the same filters
  ///
  /// Parameters:
  ///
  /// * [String] filter:
  ///   Leave out for all
  ///
  /// * [Object] from:
  ///
  /// * [Object] to:
  ///
  /// * [String] cursor:
  ///   nextCursor from the previous page
  ///
  /// * [int] limit:
  Future<GetCoinHistory200Response?> getCoinHistory({ String? filter, Object? from, Object? to, String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final response = await getCoinHistoryWithHttpInfo(filter: filter, from: from, to: to, cursor: cursor, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCoinHistory200Response',) as GetCoinHistory200Response;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /v1/wallet' operation and returns the [Response].
  Future<Response> getWalletWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/wallet';

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

  Future<GetWallet200Response?> getWallet({ Future<void>? abortTrigger, }) async {
    final response = await getWalletWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetWallet200Response',) as GetWallet200Response;
    
    }
    return null;
  }

  /// Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listCoinPackagesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/coin-packages';

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

  /// Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.
  Future<List<ListCoinPackages200ResponseInner>?> listCoinPackages({ Future<void>? abortTrigger, }) async {
    final response = await listCoinPackagesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ListCoinPackages200ResponseInner>') as List)
        .cast<ListCoinPackages200ResponseInner>()
        .toList(growable: false);

    }
    return null;
  }

  /// Every coin in or out, newest first. Page with `before` = last id seen.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] kind:
  ///
  /// * [int] before:
  ///
  /// * [int] limit:
  Future<Response> listLedgerWithHttpInfo({ String? kind, int? before, int? limit, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/wallet/ledger';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (kind != null) {
      queryParams.addAll(_queryParams('', 'kind', kind));
    }
    if (before != null) {
      queryParams.addAll(_queryParams('', 'before', before));
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

  /// Every coin in or out, newest first. Page with `before` = last id seen.
  ///
  /// Parameters:
  ///
  /// * [String] kind:
  ///
  /// * [int] before:
  ///
  /// * [int] limit:
  Future<ListLedger200Response?> listLedger({ String? kind, int? before, int? limit, Future<void>? abortTrigger, }) async {
    final response = await listLedgerWithHttpInfo(kind: kind, before: before, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListLedger200Response',) as ListLedger200Response;
    
    }
    return null;
  }

  /// After checkout: the server checks Razorpay's signature and the payment, then credits the coins (once)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [VerifyRazorpayPaymentRequest] verifyRazorpayPaymentRequest (required):
  Future<Response> verifyRazorpayPaymentWithHttpInfo(VerifyRazorpayPaymentRequest verifyRazorpayPaymentRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/payments/razorpay/verify';

    // ignore: prefer_final_locals
    Object? postBody = verifyRazorpayPaymentRequest;

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

  /// After checkout: the server checks Razorpay's signature and the payment, then credits the coins (once)
  ///
  /// Parameters:
  ///
  /// * [VerifyRazorpayPaymentRequest] verifyRazorpayPaymentRequest (required):
  Future<PurchaseResult?> verifyRazorpayPayment(VerifyRazorpayPaymentRequest verifyRazorpayPaymentRequest, { Future<void>? abortTrigger, }) async {
    final response = await verifyRazorpayPaymentWithHttpInfo(verifyRazorpayPaymentRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PurchaseResult',) as PurchaseResult;
    
    }
    return null;
  }
}
