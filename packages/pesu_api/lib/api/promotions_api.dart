//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class PromotionsApi {
  PromotionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// The offer to show in the app-open bottom sheet, if any
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCurrentPromotionWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/promotions/current';

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

  /// The offer to show in the app-open bottom sheet, if any
  Future<GetCurrentPromotion200Response?> getCurrentPromotion({ Future<void>? abortTrigger, }) async {
    final response = await getCurrentPromotionWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetCurrentPromotion200Response',) as GetCurrentPromotion200Response;
    
    }
    return null;
  }

  /// The app showed the sheet, or the user tapped its button (drives frequency and admin stats)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [LogPromotionEventRequest] logPromotionEventRequest (required):
  Future<Response> logPromotionEventWithHttpInfo(int id, LogPromotionEventRequest logPromotionEventRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/promotions/{id}/events'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = logPromotionEventRequest;

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

  /// The app showed the sheet, or the user tapped its button (drives frequency and admin stats)
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [LogPromotionEventRequest] logPromotionEventRequest (required):
  Future<String?> logPromotionEvent(int id, LogPromotionEventRequest logPromotionEventRequest, { Future<void>? abortTrigger, }) async {
    final response = await logPromotionEventWithHttpInfo(id, logPromotionEventRequest, abortTrigger: abortTrigger,);
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
