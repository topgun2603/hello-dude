//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class PhotosApi {
  PhotosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Remove my photo (and any waiting for review); the avatar shows again
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> deleteMyPhotoWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/photo';

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

  /// Remove my photo (and any waiting for review); the avatar shows again
  Future<MyPhoto?> deleteMyPhoto({ Future<void>? abortTrigger, }) async {
    final response = await deleteMyPhotoWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyPhoto',) as MyPhoto;
    
    }
    return null;
  }

  /// My profile photo and its review status
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getMyPhotoWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/photo';

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

  /// My profile photo and its review status
  Future<MyPhoto?> getMyPhoto({ Future<void>? abortTrigger, }) async {
    final response = await getMyPhotoWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyPhoto',) as MyPhoto;
    
    }
    return null;
  }

  /// A profile photo, through a signed URL from the API (never linked directly)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] exp (required):
  ///
  /// * [String] sig (required):
  ///
  /// * [String] userId (required):
  ///
  /// * [String] file (required):
  Future<Response> getPhotoWithHttpInfo(int exp, String sig, String userId, String file, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/photos/{userId}/{file}'
      .replaceAll('{userId}', userId)
      .replaceAll('{file}', file);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'exp', exp));
      queryParams.addAll(_queryParams('', 'sig', sig));

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

  /// A profile photo, through a signed URL from the API (never linked directly)
  ///
  /// Parameters:
  ///
  /// * [int] exp (required):
  ///
  /// * [String] sig (required):
  ///
  /// * [String] userId (required):
  ///
  /// * [String] file (required):
  Future<void> getPhoto(int exp, String sig, String userId, String file, { Future<void>? abortTrigger, }) async {
    final response = await getPhotoWithHttpInfo(exp, sig, userId, file, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Upload a profile photo (companions). It's cleaned (metadata removed) and shown after an admin approves it; until then your current photo or avatar stays.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UploadMyPhotoRequest] uploadMyPhotoRequest (required):
  Future<Response> uploadMyPhotoWithHttpInfo(UploadMyPhotoRequest uploadMyPhotoRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/me/photo';

    // ignore: prefer_final_locals
    Object? postBody = uploadMyPhotoRequest;

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

  /// Upload a profile photo (companions). It's cleaned (metadata removed) and shown after an admin approves it; until then your current photo or avatar stays.
  ///
  /// Parameters:
  ///
  /// * [UploadMyPhotoRequest] uploadMyPhotoRequest (required):
  Future<MyPhoto?> uploadMyPhoto(UploadMyPhotoRequest uploadMyPhotoRequest, { Future<void>? abortTrigger, }) async {
    final response = await uploadMyPhotoWithHttpInfo(uploadMyPhotoRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyPhoto',) as MyPhoto;
    
    }
    return null;
  }
}
