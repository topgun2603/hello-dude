//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class LivesApi {
  LivesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Host: end the live
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> endLiveWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/end'
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

  /// Host: end the live
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> endLive(String id, { Future<void>? abortTrigger, }) async {
    final response = await endLiveWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [FlagLiveFrameRequest] flagLiveFrameRequest (required):
  Future<Response> flagLiveFrameWithHttpInfo(String id, FlagLiveFrameRequest flagLiveFrameRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/moderation'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = flagLiveFrameRequest;

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

  /// A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [FlagLiveFrameRequest] flagLiveFrameRequest (required):
  Future<FlagVideoFrame201Response?> flagLiveFrame(String id, FlagLiveFrameRequest flagLiveFrameRequest, { Future<void>? abortTrigger, }) async {
    final response = await flagLiveFrameWithHttpInfo(id, flagLiveFrameRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FlagVideoFrame201Response',) as FlagVideoFrame201Response;
    
    }
    return null;
  }

  /// Watch. The first visit has a free preview. After it, send pay=true to keep watching at the per-minute price (the first minute is charged now, then one each minute you stay). 402 PAY_TO_WATCH / INSUFFICIENT_BALANCE otherwise.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [JoinLiveRequest] joinLiveRequest (required):
  Future<Response> joinLiveWithHttpInfo(String id, JoinLiveRequest joinLiveRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/join'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = joinLiveRequest;

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

  /// Watch. The first visit has a free preview. After it, send pay=true to keep watching at the per-minute price (the first minute is charged now, then one each minute you stay). 402 PAY_TO_WATCH / INSUFFICIENT_BALANCE otherwise.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [JoinLiveRequest] joinLiveRequest (required):
  Future<LiveJoin?> joinLive(String id, JoinLiveRequest joinLiveRequest, { Future<void>? abortTrigger, }) async {
    final response = await joinLiveWithHttpInfo(id, joinLiveRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LiveJoin',) as LiveJoin;
    
    }
    return null;
  }

  /// Viewer: stop watching (stops the per-minute charge)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> leaveLiveWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/leave'
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

  /// Viewer: stop watching (stops the per-minute charge)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> leaveLive(String id, { Future<void>? abortTrigger, }) async {
    final response = await leaveLiveWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// Live now (favourites first, then the busiest), with the price per minute
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] language:
  Future<Response> listLivesWithHttpInfo({ String? language, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (language != null) {
      queryParams.addAll(_queryParams('', 'language', language));
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

  /// Live now (favourites first, then the busiest), with the price per minute
  ///
  /// Parameters:
  ///
  /// * [String] language:
  Future<ListLives200Response?> listLives({ String? language, Future<void>? abortTrigger, }) async {
    final response = await listLivesWithHttpInfo(language: language, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListLives200Response',) as ListLives200Response;
    
    }
    return null;
  }

  /// Viewer: still watching (every 20 s). Returns your access.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> liveHeartbeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/heartbeat'
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

  /// Viewer: still watching (every 20 s). Returns your access.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<LiveAccess?> liveHeartbeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await liveHeartbeatWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LiveAccess',) as LiveAccess;
    
    }
    return null;
  }

  /// Host: still live (every 15 s). Returns viewers and what this live has earned.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> liveHostHeartbeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/host-heartbeat'
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

  /// Host: still live (every 15 s). Returns viewers and what this live has earned.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<LiveHostHeartbeat200Response?> liveHostHeartbeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await liveHostHeartbeatWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LiveHostHeartbeat200Response',) as LiveHostHeartbeat200Response;
    
    }
    return null;
  }

  /// Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendGiftRequest] sendGiftRequest (required):
  Future<Response> sendLiveGiftWithHttpInfo(String id, SendGiftRequest sendGiftRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/gifts'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendGiftRequest;

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

  /// Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendGiftRequest] sendGiftRequest (required):
  Future<SendRoomGift201Response?> sendLiveGift(String id, SendGiftRequest sendGiftRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendLiveGiftWithHttpInfo(id, sendGiftRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SendRoomGift201Response',) as SendRoomGift201Response;
    
    }
    return null;
  }

  /// Chat (paying viewers and the host; safety-filtered; one message every 2 s)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<Response> sendLiveMessageWithHttpInfo(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/messages'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendRoomMessageRequest;

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

  /// Chat (paying viewers and the host; safety-filtered; one message every 2 s)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<String?> sendLiveMessage(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendLiveMessageWithHttpInfo(id, sendRoomMessageRequest, abortTrigger: abortTrigger,);
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

  /// Send a reaction (anyone watching, preview included)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomReactionRequest] sendRoomReactionRequest (required):
  Future<Response> sendLiveReactionWithHttpInfo(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives/{id}/react'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendRoomReactionRequest;

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

  /// Send a reaction (anyone watching, preview included)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomReactionRequest] sendRoomReactionRequest (required):
  Future<String?> sendLiveReaction(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendLiveReactionWithHttpInfo(id, sendRoomReactionRequest, abortTrigger: abortTrigger,);
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

  /// Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [StartLiveRequest] startLiveRequest (required):
  Future<Response> startLiveWithHttpInfo(StartLiveRequest startLiveRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/lives';

    // ignore: prefer_final_locals
    Object? postBody = startLiveRequest;

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

  /// Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.
  ///
  /// Parameters:
  ///
  /// * [StartLiveRequest] startLiveRequest (required):
  Future<LiveJoin?> startLive(StartLiveRequest startLiveRequest, { Future<void>? abortTrigger, }) async {
    final response = await startLiveWithHttpInfo(startLiveRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LiveJoin',) as LiveJoin;
    
    }
    return null;
  }
}
