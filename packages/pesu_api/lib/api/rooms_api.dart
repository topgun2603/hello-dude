//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class RoomsApi {
  RoomsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Current stage and members
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> getRoomWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}'
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

  /// Current stage and members
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<RoomState?> getRoom(String id, { Future<void>? abortTrigger, }) async {
    final response = await getRoomWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RoomState',) as RoomState;
    
    }
    return null;
  }

  /// Join as a listener (free). Rejoining keeps your role.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> joinRoomWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/join'
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

  /// Join as a listener (free). Rejoining keeps your role.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<RoomJoin?> joinRoom(String id, { Future<void>? abortTrigger, }) async {
    final response = await joinRoomWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RoomJoin',) as RoomJoin;
    
    }
    return null;
  }

  /// Leave. When the host leaves, the room ends.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> leaveRoomWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/leave'
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

  /// Leave. When the host leaves, the room ends.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> leaveRoom(String id, { Future<void>? abortTrigger, }) async {
    final response = await leaveRoomWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// Room categories (All + these)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listRoomCategoriesWithHttpInfo({ Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/room-categories';

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

  /// Room categories (All + these)
  Future<List<ListLanguages200ResponseInner>?> listRoomCategories({ Future<void>? abortTrigger, }) async {
    final response = await listRoomCategoriesWithHttpInfo(abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ListLanguages200ResponseInner>') as List)
        .cast<ListLanguages200ResponseInner>()
        .toList(growable: false);

    }
    return null;
  }

  /// Live rooms, biggest first (optionally one category / language)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] category:
  ///
  /// * [String] language:
  Future<Response> listRoomsWithHttpInfo({ String? category, String? language, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (category != null) {
      queryParams.addAll(_queryParams('', 'category', category));
    }
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

  /// Live rooms, biggest first (optionally one category / language)
  ///
  /// Parameters:
  ///
  /// * [String] category:
  ///
  /// * [String] language:
  Future<List<RoomCard>?> listRooms({ String? category, String? language, Future<void>? abortTrigger, }) async {
    final response = await listRoomsWithHttpInfo(category: category, language: language, abortTrigger: abortTrigger,);
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

  /// Raise or lower your hand to speak
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [RaiseHandRequest] raiseHandRequest (required):
  Future<Response> raiseHandWithHttpInfo(String id, RaiseHandRequest raiseHandRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/hand'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = raiseHandRequest;

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

  /// Raise or lower your hand to speak
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [RaiseHandRequest] raiseHandRequest (required):
  Future<String?> raiseHand(String id, RaiseHandRequest raiseHandRequest, { Future<void>? abortTrigger, }) async {
    final response = await raiseHandWithHttpInfo(id, raiseHandRequest, abortTrigger: abortTrigger,);
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

  /// Still here (every 30 s)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> roomHeartbeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/heartbeat'
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

  /// Still here (every 30 s)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> roomHeartbeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await roomHeartbeatWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// A fresh LiveKit token for your current role (after moving on/off stage)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> roomTokenWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/token'
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

  /// A fresh LiveKit token for your current role (after moving on/off stage)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<RoomToken200Response?> roomToken(String id, { Future<void>? abortTrigger, }) async {
    final response = await roomTokenWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RoomToken200Response',) as RoomToken200Response;
    
    }
    return null;
  }

  /// Send a gift to a companion on stage (same prices and companion share as call gifts)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomGiftRequest] sendRoomGiftRequest (required):
  Future<Response> sendRoomGiftWithHttpInfo(String id, SendRoomGiftRequest sendRoomGiftRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/gifts'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = sendRoomGiftRequest;

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

  /// Send a gift to a companion on stage (same prices and companion share as call gifts)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomGiftRequest] sendRoomGiftRequest (required):
  Future<SendRoomGift201Response?> sendRoomGift(String id, SendRoomGiftRequest sendRoomGiftRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendRoomGiftWithHttpInfo(id, sendRoomGiftRequest, abortTrigger: abortTrigger,);
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

  /// Say something in the room feed (safety-filtered; one message every 2 s)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<Response> sendRoomMessageWithHttpInfo(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/messages'
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

  /// Say something in the room feed (safety-filtered; one message every 2 s)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<String?> sendRoomMessage(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendRoomMessageWithHttpInfo(id, sendRoomMessageRequest, abortTrigger: abortTrigger,);
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

  /// Send a reaction
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomReactionRequest] sendRoomReactionRequest (required):
  Future<Response> sendRoomReactionWithHttpInfo(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/react'
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

  /// Send a reaction
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomReactionRequest] sendRoomReactionRequest (required):
  Future<String?> sendRoomReaction(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendRoomReactionWithHttpInfo(id, sendRoomReactionRequest, abortTrigger: abortTrigger,);
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

  /// Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] userId (required):
  ///
  /// * [SetRoomStageRequest] setRoomStageRequest (required):
  Future<Response> setRoomStageWithHttpInfo(String id, String userId, SetRoomStageRequest setRoomStageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms/{id}/stage/{userId}'
      .replaceAll('{id}', id)
      .replaceAll('{userId}', userId);

    // ignore: prefer_final_locals
    Object? postBody = setRoomStageRequest;

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

  /// Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] userId (required):
  ///
  /// * [SetRoomStageRequest] setRoomStageRequest (required):
  Future<RoomState?> setRoomStage(String id, String userId, SetRoomStageRequest setRoomStageRequest, { Future<void>? abortTrigger, }) async {
    final response = await setRoomStageWithHttpInfo(id, userId, setRoomStageRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RoomState',) as RoomState;
    
    }
    return null;
  }

  /// Start a room (approved companions; one live room at a time)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [StartRoomRequest] startRoomRequest (required):
  Future<Response> startRoomWithHttpInfo(StartRoomRequest startRoomRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/rooms';

    // ignore: prefer_final_locals
    Object? postBody = startRoomRequest;

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

  /// Start a room (approved companions; one live room at a time)
  ///
  /// Parameters:
  ///
  /// * [StartRoomRequest] startRoomRequest (required):
  Future<RoomJoin?> startRoom(StartRoomRequest startRoomRequest, { Future<void>? abortTrigger, }) async {
    final response = await startRoomWithHttpInfo(startRoomRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RoomJoin',) as RoomJoin;
    
    }
    return null;
  }
}
