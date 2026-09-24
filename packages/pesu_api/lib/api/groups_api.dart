//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of pesu_api;


class GroupsApi {
  GroupsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Book a free seat in a scheduled group (reminder 10 min before)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> bookGroupSeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/book'
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

  /// Book a free seat in a scheduled group (reminder 10 min before)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<GroupCard?> bookGroupSeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await bookGroupSeatWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupCard',) as GroupCard;
    
    }
    return null;
  }

  /// Give up a booked seat
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> cancelGroupSeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/cancel-booking'
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

  /// Give up a booked seat
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> cancelGroupSeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await cancelGroupSeatWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; set it (within 7 days) to take seat bookings.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateGroupRequest] createGroupRequest (required):
  Future<Response> createGroupWithHttpInfo(CreateGroupRequest createGroupRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups';

    // ignore: prefer_final_locals
    Object? postBody = createGroupRequest;

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

  /// Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; set it (within 7 days) to take seat bookings.
  ///
  /// Parameters:
  ///
  /// * [CreateGroupRequest] createGroupRequest (required):
  Future<GroupHostState?> createGroup(CreateGroupRequest createGroupRequest, { Future<void>? abortTrigger, }) async {
    final response = await createGroupWithHttpInfo(createGroupRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupHostState',) as GroupHostState;
    
    }
    return null;
  }

  /// Host: end (or cancel) the group
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> endGroupWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/end'
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

  /// Host: end (or cancel) the group
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> endGroup(String id, { Future<void>? abortTrigger, }) async {
    final response = await endGroupWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [FlagGroupFrameRequest] flagGroupFrameRequest (required):
  Future<Response> flagGroupFrameWithHttpInfo(String id, FlagGroupFrameRequest flagGroupFrameRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/moderation'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = flagGroupFrameRequest;

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

  /// A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [FlagGroupFrameRequest] flagGroupFrameRequest (required):
  Future<FlagVideoFrame201Response?> flagGroupFrame(String id, FlagGroupFrameRequest flagGroupFrameRequest, { Future<void>? abortTrigger, }) async {
    final response = await flagGroupFrameWithHttpInfo(id, flagGroupFrameRequest, abortTrigger: abortTrigger,);
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

  /// Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> groupHeartbeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/heartbeat'
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

  /// Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<GroupHeartbeat200Response?> groupHeartbeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await groupHeartbeatWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupHeartbeat200Response',) as GroupHeartbeat200Response;
    
    }
    return null;
  }

  /// Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> groupHostHeartbeatWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/host-heartbeat'
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

  /// Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<GroupHostState?> groupHostHeartbeat(String id, { Future<void>? abortTrigger, }) async {
    final response = await groupHostHeartbeatWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupHostState',) as GroupHostState;
    
    }
    return null;
  }

  /// Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [JoinGroupRequest] joinGroupRequest (required):
  Future<Response> joinGroupWithHttpInfo(String id, JoinGroupRequest joinGroupRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/join'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = joinGroupRequest;

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

  /// Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [JoinGroupRequest] joinGroupRequest (required):
  Future<GroupJoin?> joinGroup(String id, JoinGroupRequest joinGroupRequest, { Future<void>? abortTrigger, }) async {
    final response = await joinGroupWithHttpInfo(id, joinGroupRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupJoin',) as GroupJoin;
    
    }
    return null;
  }

  /// Member: leave (stops the per-minute charge)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> leaveGroupWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/leave'
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

  /// Member: leave (stops the per-minute charge)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<String?> leaveGroup(String id, { Future<void>? abortTrigger, }) async {
    final response = await leaveGroupWithHttpInfo(id, abortTrigger: abortTrigger,);
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

  /// Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] language:
  Future<Response> listGroupsWithHttpInfo({ String? language, Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups';

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

  /// Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.
  ///
  /// Parameters:
  ///
  /// * [String] language:
  Future<ListGroups200Response?> listGroups({ String? language, Future<void>? abortTrigger, }) async {
    final response = await listGroupsWithHttpInfo(language: language, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListGroups200Response',) as ListGroups200Response;
    
    }
    return null;
  }

  /// Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> openGroupWithHttpInfo(String id, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/open'
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

  /// Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<GroupHostState?> openGroup(String id, { Future<void>? abortTrigger, }) async {
    final response = await openGroupWithHttpInfo(id, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GroupHostState',) as GroupHostState;
    
    }
    return null;
  }

  /// Report someone in the group. The host can also remove them.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ReportInGroupRequest] reportInGroupRequest (required):
  Future<Response> reportInGroupWithHttpInfo(String id, ReportInGroupRequest reportInGroupRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/report'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = reportInGroupRequest;

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

  /// Report someone in the group. The host can also remove them.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ReportInGroupRequest] reportInGroupRequest (required):
  Future<String?> reportInGroup(String id, ReportInGroupRequest reportInGroupRequest, { Future<void>? abortTrigger, }) async {
    final response = await reportInGroupWithHttpInfo(id, reportInGroupRequest, abortTrigger: abortTrigger,);
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

  /// Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendGiftRequest] sendGiftRequest (required):
  Future<Response> sendGroupGiftWithHttpInfo(String id, SendGiftRequest sendGiftRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/gifts'
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
  Future<SendRoomGift201Response?> sendGroupGift(String id, SendGiftRequest sendGiftRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendGroupGiftWithHttpInfo(id, sendGiftRequest, abortTrigger: abortTrigger,);
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

  /// Chat (members and the host; safety-filtered; one message every 2 s)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<Response> sendGroupMessageWithHttpInfo(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/messages'
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

  /// Chat (members and the host; safety-filtered; one message every 2 s)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [SendRoomMessageRequest] sendRoomMessageRequest (required):
  Future<String?> sendGroupMessage(String id, SendRoomMessageRequest sendRoomMessageRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendGroupMessageWithHttpInfo(id, sendRoomMessageRequest, abortTrigger: abortTrigger,);
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
  Future<Response> sendGroupReactionWithHttpInfo(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    // ignore: prefer_const_declarations
    final path = r'/v1/groups/{id}/react'
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
  Future<String?> sendGroupReaction(String id, SendRoomReactionRequest sendRoomReactionRequest, { Future<void>? abortTrigger, }) async {
    final response = await sendGroupReactionWithHttpInfo(id, sendRoomReactionRequest, abortTrigger: abortTrigger,);
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
