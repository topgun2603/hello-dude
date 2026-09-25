# pesu_api.api.LivesApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptPk**](LivesApi.md#acceptpk) | **POST** /v1/pk/{id}/accept | Accept a PK challenge: the battle starts now
[**challengePk**](LivesApi.md#challengepk) | **POST** /v1/lives/{id}/pk | Host: challenge another live host to a 5-minute PK battle (she has 30 s to accept)
[**declinePk**](LivesApi.md#declinepk) | **POST** /v1/pk/{id}/decline | Decline a PK challenge
[**endLive**](LivesApi.md#endlive) | **POST** /v1/lives/{id}/end | Host: end the live
[**endPk**](LivesApi.md#endpk) | **POST** /v1/pk/{id}/end | Either host: end the battle early (current score decides)
[**flagLiveFrame**](LivesApi.md#flagliveframe) | **POST** /v1/lives/{id}/moderation | A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)
[**getLiveSnapshot**](LivesApi.md#getlivesnapshot) | **GET** /v1/lives/{id}/snapshot/{file} | A live's card snapshot, through a signed URL from GET /lives
[**getPk**](LivesApi.md#getpk) | **GET** /v1/pk/{id} | A battle with live scores, plus a listen-only token for the other side's room (hosts and viewers of either live)
[**joinLive**](LivesApi.md#joinlive) | **POST** /v1/lives/{id}/join | Watch. The first visit has a free preview. After it, send pay=true to keep watching at the per-minute price (the first minute is charged now, then one each minute you stay). 402 PAY_TO_WATCH / INSUFFICIENT_BALANCE otherwise.
[**leaveLive**](LivesApi.md#leavelive) | **POST** /v1/lives/{id}/leave | Viewer: stop watching (stops the per-minute charge)
[**listLives**](LivesApi.md#listlives) | **GET** /v1/lives | Live now, a page at a time, with the total and the price per minute. sort: for_you (favourites, your language, busiest), popular or new; favourites=true shows only favourites; q searches names and titles.
[**liveHeartbeat**](LivesApi.md#liveheartbeat) | **POST** /v1/lives/{id}/heartbeat | Viewer: still watching (every 20 s). Returns your access.
[**liveHostHeartbeat**](LivesApi.md#livehostheartbeat) | **POST** /v1/lives/{id}/host-heartbeat | Host: still live (every 15 s). Returns viewers and what this live has earned.
[**sendLiveGift**](LivesApi.md#sendlivegift) | **POST** /v1/lives/{id}/gifts | Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef. During a PK battle, toHostId may name the other host.
[**sendLiveMessage**](LivesApi.md#sendlivemessage) | **POST** /v1/lives/{id}/messages | Chat (paying viewers and the host; safety-filtered; one message every 2 s)
[**sendLiveReaction**](LivesApi.md#sendlivereaction) | **POST** /v1/lives/{id}/react | Send a reaction (anyone watching, preview included)
[**startLive**](LivesApi.md#startlive) | **POST** /v1/lives | Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.
[**uploadLiveSnapshot**](LivesApi.md#uploadlivesnapshot) | **POST** /v1/lives/{id}/snapshot | Host: a still for the live's card (about once a minute, already safety-checked on the phone)


# **acceptPk**
> PkBattle acceptPk(id)

Accept a PK challenge: the battle starts now

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.acceptPk(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->acceptPk: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PkBattle**](PkBattle.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **challengePk**
> PkBattle challengePk(id, challengePkRequest)

Host: challenge another live host to a 5-minute PK battle (she has 30 s to accept)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final challengePkRequest = ChallengePkRequest(); // ChallengePkRequest | 

try {
    final result = api_instance.challengePk(id, challengePkRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->challengePk: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **challengePkRequest** | [**ChallengePkRequest**](ChallengePkRequest.md)|  | 

### Return type

[**PkBattle**](PkBattle.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declinePk**
> PkBattle declinePk(id)

Decline a PK challenge

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.declinePk(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->declinePk: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PkBattle**](PkBattle.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **endLive**
> String endLive(id)

Host: end the live

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.endLive(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->endLive: $e\n');
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

# **endPk**
> String endPk(id)

Either host: end the battle early (current score decides)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.endPk(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->endPk: $e\n');
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

# **flagLiveFrame**
> FlagVideoFrame201Response flagLiveFrame(id, flagLiveFrameRequest)

A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final flagLiveFrameRequest = FlagLiveFrameRequest(); // FlagLiveFrameRequest | 

try {
    final result = api_instance.flagLiveFrame(id, flagLiveFrameRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->flagLiveFrame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **flagLiveFrameRequest** | [**FlagLiveFrameRequest**](FlagLiveFrameRequest.md)|  | 

### Return type

[**FlagVideoFrame201Response**](FlagVideoFrame201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLiveSnapshot**
> getLiveSnapshot(exp, sig, id, file)

A live's card snapshot, through a signed URL from GET /lives

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = LivesApi();
final exp = 56; // int | 
final sig = sig_example; // String | 
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final file = file_example; // String | 

try {
    api_instance.getLiveSnapshot(exp, sig, id, file);
} catch (e) {
    print('Exception when calling LivesApi->getLiveSnapshot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exp** | **int**|  | 
 **sig** | **String**|  | 
 **id** | **String**|  | 
 **file** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPk**
> GetPk200Response getPk(fromLiveId, id)

A battle with live scores, plus a listen-only token for the other side's room (hosts and viewers of either live)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final fromLiveId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | The live you're in
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getPk(fromLiveId, id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->getPk: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromLiveId** | **String**| The live you're in | 
 **id** | **String**|  | 

### Return type

[**GetPk200Response**](GetPk200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinLive**
> LiveJoin joinLive(id, joinLiveRequest)

Watch. The first visit has a free preview. After it, send pay=true to keep watching at the per-minute price (the first minute is charged now, then one each minute you stay). 402 PAY_TO_WATCH / INSUFFICIENT_BALANCE otherwise.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final joinLiveRequest = JoinLiveRequest(); // JoinLiveRequest | 

try {
    final result = api_instance.joinLive(id, joinLiveRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->joinLive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **joinLiveRequest** | [**JoinLiveRequest**](JoinLiveRequest.md)|  | 

### Return type

[**LiveJoin**](LiveJoin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveLive**
> String leaveLive(id)

Viewer: stop watching (stops the per-minute charge)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.leaveLive(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->leaveLive: $e\n');
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

# **listLives**
> ListLives200Response listLives(language, sort, favourites, q, limit, offset)

Live now, a page at a time, with the total and the price per minute. sort: for_you (favourites, your language, busiest), popular or new; favourites=true shows only favourites; q searches names and titles.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final language = language_example; // String | 
final sort = sort_example; // String | 
final favourites = favourites_example; // String | 
final q = q_example; // String | 
final limit = 56; // int | 
final offset = 56; // int | 

try {
    final result = api_instance.listLives(language, sort, favourites, q, limit, offset);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->listLives: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **language** | **String**|  | [optional] 
 **sort** | **String**|  | [optional] 
 **favourites** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] 
 **offset** | **int**|  | [optional] 

### Return type

[**ListLives200Response**](ListLives200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **liveHeartbeat**
> LiveAccess liveHeartbeat(id)

Viewer: still watching (every 20 s). Returns your access.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.liveHeartbeat(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->liveHeartbeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**LiveAccess**](LiveAccess.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **liveHostHeartbeat**
> LiveHostHeartbeat200Response liveHostHeartbeat(id)

Host: still live (every 15 s). Returns viewers and what this live has earned.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.liveHostHeartbeat(id);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->liveHostHeartbeat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**LiveHostHeartbeat200Response**](LiveHostHeartbeat200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendLiveGift**
> SendRoomGift201Response sendLiveGift(id, sendLiveGiftRequest)

Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef. During a PK battle, toHostId may name the other host.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendLiveGiftRequest = SendLiveGiftRequest(); // SendLiveGiftRequest | 

try {
    final result = api_instance.sendLiveGift(id, sendLiveGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->sendLiveGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendLiveGiftRequest** | [**SendLiveGiftRequest**](SendLiveGiftRequest.md)|  | 

### Return type

[**SendRoomGift201Response**](SendRoomGift201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendLiveMessage**
> String sendLiveMessage(id, sendRoomMessageRequest)

Chat (paying viewers and the host; safety-filtered; one message every 2 s)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomMessageRequest = SendRoomMessageRequest(); // SendRoomMessageRequest | 

try {
    final result = api_instance.sendLiveMessage(id, sendRoomMessageRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->sendLiveMessage: $e\n');
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

# **sendLiveReaction**
> String sendLiveReaction(id, sendRoomReactionRequest)

Send a reaction (anyone watching, preview included)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendRoomReactionRequest = SendRoomReactionRequest(); // SendRoomReactionRequest | 

try {
    final result = api_instance.sendLiveReaction(id, sendRoomReactionRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->sendLiveReaction: $e\n');
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

# **startLive**
> LiveJoin startLive(startLiveRequest)

Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final startLiveRequest = StartLiveRequest(); // StartLiveRequest | 

try {
    final result = api_instance.startLive(startLiveRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->startLive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startLiveRequest** | [**StartLiveRequest**](StartLiveRequest.md)|  | 

### Return type

[**LiveJoin**](LiveJoin.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadLiveSnapshot**
> String uploadLiveSnapshot(id, uploadLiveSnapshotRequest)

Host: a still for the live's card (about once a minute, already safety-checked on the phone)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = LivesApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final uploadLiveSnapshotRequest = UploadLiveSnapshotRequest(); // UploadLiveSnapshotRequest | 

try {
    final result = api_instance.uploadLiveSnapshot(id, uploadLiveSnapshotRequest);
    print(result);
} catch (e) {
    print('Exception when calling LivesApi->uploadLiveSnapshot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **uploadLiveSnapshotRequest** | [**UploadLiveSnapshotRequest**](UploadLiveSnapshotRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

