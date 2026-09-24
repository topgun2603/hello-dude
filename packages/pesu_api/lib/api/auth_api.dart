//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class AuthApi {
  AuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /v1/auth/logout' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [RefreshTokensRequest] refreshTokensRequest (required):
  Future<Response> logoutWithHttpInfo(RefreshTokensRequest refreshTokensRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/logout';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokensRequest;

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
  /// * [RefreshTokensRequest] refreshTokensRequest (required):
  Future<String?> logout(RefreshTokensRequest refreshTokensRequest, { Future<void>? abortTrigger, }) async {
    final response = await logoutWithHttpInfo(refreshTokensRequest, abortTrigger: abortTrigger,);
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

  /// Swap a refresh token for a new token pair (the old one stops working)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RefreshTokensRequest] refreshTokensRequest (required):
  Future<Response> refreshTokensWithHttpInfo(RefreshTokensRequest refreshTokensRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokensRequest;

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

  /// Swap a refresh token for a new token pair (the old one stops working)
  ///
  /// Parameters:
  ///
  /// * [RefreshTokensRequest] refreshTokensRequest (required):
  Future<TokenPair?> refreshTokens(RefreshTokensRequest refreshTokensRequest, { Future<void>? abortTrigger, }) async {
    final response = await refreshTokensWithHttpInfo(refreshTokensRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TokenPair',) as TokenPair;
    
    }
    return null;
  }

  /// Send a 6-digit code to a mobile number
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SendOtpRequest] sendOtpRequest (required):
  Future<Response> sendOtpWithHttpInfo(SendOtpRequest sendOtpRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/otp/send';

    // ignore: prefer_final_locals
    Object? postBody = sendOtpRequest;

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

  /// Send a 6-digit code to a mobile number
  ///
  /// Parameters:
  ///
  /// * [SendOtpRequest] sendOtpRequest (required):
  Future<SendOtp200Response?> sendOtp(SendOtpRequest sendOtpRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendOtpWithHttpInfo(sendOtpRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SendOtp200Response',) as SendOtp200Response;
    
    }
    return null;
  }

  /// Mobile app sign-in: the app verified the number with Firebase Auth and sends its ID token. Indian (+91) mobiles only. Same result as otp/verify.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SignInWithFirebaseRequest] signInWithFirebaseRequest (required):
  Future<Response> signInWithFirebaseWithHttpInfo(SignInWithFirebaseRequest signInWithFirebaseRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/firebase';

    // ignore: prefer_final_locals
    Object? postBody = signInWithFirebaseRequest;

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

  /// Mobile app sign-in: the app verified the number with Firebase Auth and sends its ID token. Indian (+91) mobiles only. Same result as otp/verify.
  ///
  /// Parameters:
  ///
  /// * [SignInWithFirebaseRequest] signInWithFirebaseRequest (required):
  Future<OtpVerifyResult?> signInWithFirebase(SignInWithFirebaseRequest signInWithFirebaseRequest, { Future<void>? abortTrigger, }) async {
    final response = await signInWithFirebaseWithHttpInfo(signInWithFirebaseRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OtpVerifyResult',) as OtpVerifyResult;
    
    }
    return null;
  }

  /// Create the account after OTP (Main + Language screens)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SignUpRequest] signUpRequest (required):
  Future<Response> signUpWithHttpInfo(SignUpRequest signUpRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/signup';

    // ignore: prefer_final_locals
    Object? postBody = signUpRequest;

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

  /// Create the account after OTP (Main + Language screens)
  ///
  /// Parameters:
  ///
  /// * [SignUpRequest] signUpRequest (required):
  Future<SignUp201Response?> signUp(SignUpRequest signUpRequest, { Future<void>? abortTrigger, }) async {
    final response = await signUpWithHttpInfo(signUpRequest, abortTrigger: abortTrigger,);
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

  /// Verify the code. Existing users get tokens; new numbers get a signup token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [VerifyOtpRequest] verifyOtpRequest (required):
  Future<Response> verifyOtpWithHttpInfo(VerifyOtpRequest verifyOtpRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/auth/otp/verify';

    // ignore: prefer_final_locals
    Object? postBody = verifyOtpRequest;

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

  /// Verify the code. Existing users get tokens; new numbers get a signup token.
  ///
  /// Parameters:
  ///
  /// * [VerifyOtpRequest] verifyOtpRequest (required):
  Future<OtpVerifyResult?> verifyOtp(VerifyOtpRequest verifyOtpRequest, { Future<void>? abortTrigger, }) async {
    final response = await verifyOtpWithHttpInfo(verifyOtpRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OtpVerifyResult',) as OtpVerifyResult;
    
    }
    return null;
  }
}
