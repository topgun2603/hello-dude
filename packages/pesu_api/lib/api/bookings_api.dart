//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class BookingsApi {
  BookingsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Caller cancels; the held coins come back in full
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Response> cancelBookingWithHttpInfo(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings/{id}/cancel'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = confirmBookingRequest;

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

  /// Caller cancels; the held coins come back in full
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Booking?> cancelBooking(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    final response = await cancelBookingWithHttpInfo(id, confirmBookingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Booking',) as Booking;
    
    }
    return null;
  }

  /// Companion accepts the booked time
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Response> confirmBookingWithHttpInfo(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings/{id}/confirm'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = confirmBookingRequest;

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

  /// Companion accepts the booked time
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Booking?> confirmBooking(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    final response = await confirmBookingWithHttpInfo(id, confirmBookingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Booking',) as Booking;
    
    }
    return null;
  }

  /// Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateBookingRequest] createBookingRequest (required):
  Future<Response> createBookingWithHttpInfo(CreateBookingRequest createBookingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings';

    // ignore: prefer_final_locals
    Object? postBody = createBookingRequest;

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

  /// Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.
  ///
  /// Parameters:
  ///
  /// * [CreateBookingRequest] createBookingRequest (required):
  Future<CreateBooking201Response?> createBooking(CreateBookingRequest createBookingRequest, { Future<void>? abortTrigger, }) async {
    final response = await createBookingWithHttpInfo(createBookingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CreateBooking201Response',) as CreateBooking201Response;
    
    }
    return null;
  }

  /// Companion declines; the caller's coins come back
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Response> declineBookingWithHttpInfo(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings/{id}/decline'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = confirmBookingRequest;

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

  /// Companion declines; the caller's coins come back
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Booking?> declineBooking(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    final response = await declineBookingWithHttpInfo(id, confirmBookingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Booking',) as Booking;
    
    }
    return null;
  }

  /// Bookable times for the next few days (IST), and the durations offered
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> getBookingSlotsWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/companions/{id}/slots'
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

  /// Bookable times for the next few days (IST), and the durations offered
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<GetBookingSlots200Response?> getBookingSlots(String id, { Future<void>? abortTrigger, }) async {
    final response = await getBookingSlotsWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetBookingSlots200Response',) as GetBookingSlots200Response;
    
    }
    return null;
  }

  /// My bookings: upcoming (and in progress) first, then the last 30 days
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listBookingsWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings';

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

  /// My bookings: upcoming (and in progress) first, then the last 30 days
  Future<ListBookings200Response?> listBookings({ Future<void>? abortTrigger, }) async {
    final response = await listBookingsWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListBookings200Response',) as ListBookings200Response;
    
    }
    return null;
  }

  /// Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Response> startBookingWithHttpInfo(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/bookings/{id}/start'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = confirmBookingRequest;

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

  /// Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ConfirmBookingRequest] confirmBookingRequest (required):
  Future<Booking?> startBooking(String id, ConfirmBookingRequest confirmBookingRequest, { Future<void>? abortTrigger, }) async {
    final response = await startBookingWithHttpInfo(id, confirmBookingRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Booking',) as Booking;
    
    }
    return null;
  }
}
