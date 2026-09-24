# pesu_api.api.RoomsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getRoom**](RoomsApi.md#getroom) | **GET** /v1/rooms/{id} | Current stage and members
[**joinRoom**](RoomsApi.md#joinroom) | **POST** /v1/rooms/{id}/join | Join as a listener (free). Rejoining keeps your role.
[**leaveRoom**](RoomsApi.md#leaveroom) | **POST** /v1/rooms/{id}/leave | Leave. When the host leaves, the room ends.
[**listRoomCategories**](RoomsApi.md#listroomcategories) | **GET** /v1/room-categories | Room categories (All + these)
[**listRooms**](RoomsApi.md#listrooms) | **GET** /v1/rooms | Live rooms, biggest first (optionally one category / language)
[**raiseHand**](RoomsApi.md#raisehand) | **POST** /v1/rooms/{id}/hand | Raise or lower your hand to speak
[**roomHeartbeat**](RoomsApi.md#roomheartbeat) | **POST** /v1/rooms/{id}/heartbeat | Still here (every 30 s)
[**roomToken**](RoomsApi.md#roomtoken) | **POST** /v1/rooms/{id}/token | A fresh LiveKit token for your current role (after moving on/off stage)
[**sendRoomGift**](RoomsApi.md#sendroomgift) | **POST** /v1/rooms/{id}/gifts | Send a gift to a companion on stage (same prices and companion share as call gifts)
[**sendRoomMessage**](RoomsApi.md#sendroommessage) | **POST** /v1/rooms/{id}/messages | Say something in the room feed (safety-filtered; one message every 2 s)
[**sendRoomReaction**](RoomsApi.md#sendroomreaction) | **POST** /v1/rooms/{id}/react | Send a reaction
[**setRoomStage**](RoomsApi.md#setroomstage) | **POST** /v1/rooms/{id}/stage/{userId} | Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.
[**startRoom**](RoomsApi.md#startroom) | **POST** /v1/rooms | Start a room (approved companions; one live room at a time)


# **getRoom**
> RoomState getRoom(id)

Current stage and members

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getRoom(id);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->getRoom: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RoomState**](RoomState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinRoom**
> RoomJoin joinRoom(id)

Join as a listener (free). Rejoining keeps your role.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.joinRoom(id);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->joinRoom: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RoomJoin**](RoomJoin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveRoom**
> String leaveRoom(id)

Leave. When the host leaves, the room ends.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.leaveRoom(id);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->leaveRoom: $e\n');
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

# **listRoomCategories**
> List<ListLanguages200ResponseInner> listRoomCategories()

Room categories (All + these)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();

try {
    final result = api_instance.listRoomCategories();
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->listRoomCategories: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ListLanguages200ResponseInner>**](ListLanguages200ResponseInner.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRooms**
> List<RoomCard> listRooms(category, language)

Live rooms, biggest first (optionally one category / language)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final category = category_example; // String | 
final language = language_example; // String | 

try {
    final result = api_instance.listRooms(category, language);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->listRooms: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional] 
 **language** | **String**|  | [optional] 

### Return type

[**List<RoomCard>**](RoomCard.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **raiseHand**
> String raiseHand(id, raiseHandRequest)

Raise or lower your hand to speak

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final raiseHandRequest = RaiseHandRequest(); // RaiseHandRequest | 

try {
    final result = api_instance.raiseHand(id, raiseHandRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->raiseHand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **raiseHandRequest** | [**RaiseHandRequest**](RaiseHandRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **roomHeartbeat**
> String roomHeartbeat(id)

Still here (every 30 s)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.roomHeartbeat(id);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->roomHeartbeat: $e\n');
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

# **roomToken**
> RoomToken200Response roomToken(id)

A fresh LiveKit token for your current role (after moving on/off stage)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.roomToken(id);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->roomToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RoomToken200Response**](RoomToken200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendRoomGift**
> SendRoomGift201Response sendRoomGift(id, sendRoomGiftRequest)

Send a gift to a companion on stage (same prices and companion share as call gifts)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomGiftRequest = SendRoomGiftRequest(); // SendRoomGiftRequest | 

try {
    final result = api_instance.sendRoomGift(id, sendRoomGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->sendRoomGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendRoomGiftRequest** | [**SendRoomGiftRequest**](SendRoomGiftRequest.md)|  | 

### Return type

[**SendRoomGift201Response**](SendRoomGift201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendRoomMessage**
> String sendRoomMessage(id, sendRoomMessageRequest)

Say something in the room feed (safety-filtered; one message every 2 s)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomMessageRequest = SendRoomMessageRequest(); // SendRoomMessageRequest | 

try {
    final result = api_instance.sendRoomMessage(id, sendRoomMessageRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->sendRoomMessage: $e\n');
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

# **sendRoomReaction**
> String sendRoomReaction(id, sendRoomReactionRequest)

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

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomReactionRequest = SendRoomReactionRequest(); // SendRoomReactionRequest | 

try {
    final result = api_instance.sendRoomReaction(id, sendRoomReactionRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->sendRoomReaction: $e\n');
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

# **setRoomStage**
> RoomState setRoomStage(id, userId, setRoomStageRequest)

Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final setRoomStageRequest = SetRoomStageRequest(); // SetRoomStageRequest | 

try {
    final result = api_instance.setRoomStage(id, userId, setRoomStageRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->setRoomStage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **userId** | **String**|  | 
 **setRoomStageRequest** | [**SetRoomStageRequest**](SetRoomStageRequest.md)|  | 

### Return type

[**RoomState**](RoomState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startRoom**
> RoomJoin startRoom(startRoomRequest)

Start a room (approved companions; one live room at a time)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RoomsApi();
final startRoomRequest = StartRoomRequest(); // StartRoomRequest | 

try {
    final result = api_instance.startRoom(startRoomRequest);
    print(result);
} catch (e) {
    print('Exception when calling RoomsApi->startRoom: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startRoomRequest** | [**StartRoomRequest**](StartRoomRequest.md)|  | 

### Return type

[**RoomJoin**](RoomJoin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

