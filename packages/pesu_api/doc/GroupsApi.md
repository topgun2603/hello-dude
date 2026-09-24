# pesu_api.api.GroupsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookGroupSeat**](GroupsApi.md#bookgroupseat) | **POST** /v1/groups/{id}/book | Book a free seat in a scheduled group (reminder 10 min before)
[**cancelGroupSeat**](GroupsApi.md#cancelgroupseat) | **POST** /v1/groups/{id}/cancel-booking | Give up a booked seat
[**createGroup**](GroupsApi.md#creategroup) | **POST** /v1/groups | Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; set it (within 7 days) to take seat bookings.
[**endGroup**](GroupsApi.md#endgroup) | **POST** /v1/groups/{id}/end | Host: end (or cancel) the group
[**flagGroupFrame**](GroupsApi.md#flaggroupframe) | **POST** /v1/groups/{id}/moderation | A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.
[**groupHeartbeat**](GroupsApi.md#groupheartbeat) | **POST** /v1/groups/{id}/heartbeat | Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.
[**groupHostHeartbeat**](GroupsApi.md#grouphostheartbeat) | **POST** /v1/groups/{id}/host-heartbeat | Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.
[**joinGroup**](GroupsApi.md#joingroup) | **POST** /v1/groups/{id}/join | Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.
[**leaveGroup**](GroupsApi.md#leavegroup) | **POST** /v1/groups/{id}/leave | Member: leave (stops the per-minute charge)
[**listGroups**](GroupsApi.md#listgroups) | **GET** /v1/groups | Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.
[**openGroup**](GroupsApi.md#opengroup) | **POST** /v1/groups/{id}/open | Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.
[**reportInGroup**](GroupsApi.md#reportingroup) | **POST** /v1/groups/{id}/report | Report someone in the group. The host can also remove them.
[**sendGroupGift**](GroupsApi.md#sendgroupgift) | **POST** /v1/groups/{id}/gifts | Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.
[**sendGroupMessage**](GroupsApi.md#sendgroupmessage) | **POST** /v1/groups/{id}/messages | Chat (members and the host; safety-filtered; one message every 2 s)
[**sendGroupReaction**](GroupsApi.md#sendgroupreaction) | **POST** /v1/groups/{id}/react | Send a reaction


# **bookGroupSeat**
> GroupCard bookGroupSeat(id)

Book a free seat in a scheduled group (reminder 10 min before)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.bookGroupSeat(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->bookGroupSeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GroupCard**](GroupCard.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelGroupSeat**
> String cancelGroupSeat(id)

Give up a booked seat

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.cancelGroupSeat(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->cancelGroupSeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGroup**
> GroupHostState createGroup(createGroupRequest)

Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; set it (within 7 days) to take seat bookings.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final createGroupRequest = CreateGroupRequest(); // CreateGroupRequest | 

try {
    final result = api_instance.createGroup(createGroupRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->createGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createGroupRequest** | [**CreateGroupRequest**](CreateGroupRequest.md)|  | 

### Return type

[**GroupHostState**](GroupHostState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **endGroup**
> String endGroup(id)

Host: end (or cancel) the group

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.endGroup(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->endGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **flagGroupFrame**
> FlagVideoFrame201Response flagGroupFrame(id, flagGroupFrameRequest)

A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final flagGroupFrameRequest = FlagGroupFrameRequest(); // FlagGroupFrameRequest | 

try {
    final result = api_instance.flagGroupFrame(id, flagGroupFrameRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->flagGroupFrame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **flagGroupFrameRequest** | [**FlagGroupFrameRequest**](FlagGroupFrameRequest.md)|  | 

### Return type

[**FlagVideoFrame201Response**](FlagVideoFrame201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupHeartbeat**
> GroupHeartbeat200Response groupHeartbeat(id)

Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.groupHeartbeat(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->groupHeartbeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GroupHeartbeat200Response**](GroupHeartbeat200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupHostHeartbeat**
> GroupHostState groupHostHeartbeat(id)

Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.groupHostHeartbeat(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->groupHostHeartbeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GroupHostState**](GroupHostState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinGroup**
> GroupJoin joinGroup(id, joinGroupRequest)

Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final joinGroupRequest = JoinGroupRequest(); // JoinGroupRequest | 

try {
    final result = api_instance.joinGroup(id, joinGroupRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->joinGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **joinGroupRequest** | [**JoinGroupRequest**](JoinGroupRequest.md)|  | 

### Return type

[**GroupJoin**](GroupJoin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveGroup**
> String leaveGroup(id)

Member: leave (stops the per-minute charge)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.leaveGroup(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->leaveGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGroups**
> ListGroups200Response listGroups(language)

Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final language = language_example; // String | 

try {
    final result = api_instance.listGroups(language);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->listGroups: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **language** | **String**|  | [optional] 

### Return type

[**ListGroups200Response**](ListGroups200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **openGroup**
> GroupHostState openGroup(id)

Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.openGroup(id);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->openGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GroupHostState**](GroupHostState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportInGroup**
> String reportInGroup(id, reportInGroupRequest)

Report someone in the group. The host can also remove them.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final reportInGroupRequest = ReportInGroupRequest(); // ReportInGroupRequest | 

try {
    final result = api_instance.reportInGroup(id, reportInGroupRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->reportInGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reportInGroupRequest** | [**ReportInGroupRequest**](ReportInGroupRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendGroupGift**
> SendRoomGift201Response sendGroupGift(id, sendGiftRequest)

Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendGiftRequest = SendGiftRequest(); // SendGiftRequest | 

try {
    final result = api_instance.sendGroupGift(id, sendGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->sendGroupGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendGiftRequest** | [**SendGiftRequest**](SendGiftRequest.md)|  | 

### Return type

[**SendRoomGift201Response**](SendRoomGift201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendGroupMessage**
> String sendGroupMessage(id, sendRoomMessageRequest)

Chat (members and the host; safety-filtered; one message every 2 s)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomMessageRequest = SendRoomMessageRequest(); // SendRoomMessageRequest | 

try {
    final result = api_instance.sendGroupMessage(id, sendRoomMessageRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->sendGroupMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendRoomMessageRequest** | [**SendRoomMessageRequest**](SendRoomMessageRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendGroupReaction**
> String sendGroupReaction(id, sendRoomReactionRequest)

Send a reaction

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GroupsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomReactionRequest = SendRoomReactionRequest(); // SendRoomReactionRequest | 

try {
    final result = api_instance.sendGroupReaction(id, sendRoomReactionRequest);
    print(result);
} catch (e) {
    print('Exception when calling GroupsApi->sendGroupReaction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendRoomReactionRequest** | [**SendRoomReactionRequest**](SendRoomReactionRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

