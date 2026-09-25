# pesu_api.api.ChatApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptChatRequest**](ChatApi.md#acceptchatrequest) | **POST** /v1/chats/requests/{id}/accept | Accept: the chat opens with their request as the first message
[**declineChatRequest**](ChatApi.md#declinechatrequest) | **POST** /v1/chats/requests/{id}/decline | Decline (they aren't told directly; they can ask again after 7 days)
[**getChatMessages**](ChatApi.md#getchatmessages) | **GET** /v1/chats/{id}/messages | The thread: messages and calls between you, newest first (page with ?before=<ISO time>)
[**listChatRequests**](ChatApi.md#listchatrequests) | **GET** /v1/chats/requests | Companions: requests waiting for an answer. Callers: the requests they sent (last 30 days).
[**listChats**](ChatApi.md#listchats) | **GET** /v1/chats | My conversations, most recent first, with unread counts
[**markChatRead**](ChatApi.md#markchatread) | **POST** /v1/chats/{id}/read | Mark the conversation read up to now
[**openChat**](ChatApi.md#openchat) | **POST** /v1/chats/with/{userId} | Open the chat with someone (created on first use). Needs a connected call or an accepted message request, and no blocks. A caller without either gets CHAT_NEEDS_REQUEST: send one with POST /chats/requests.
[**sendChatMessage**](ChatApi.md#sendchatmessage) | **POST** /v1/chats/{id}/messages | Send a message. Phone numbers, UPI IDs and payment or contact-app requests are refused (MESSAGE_BLOCKED).
[**sendChatRequest**](ChatApi.md#sendchatrequest) | **POST** /v1/chats/requests | Send a companion you haven't called yet one message request (she accepts or declines). Same safety filter and strikes as chat; a few a day; after a decline you can ask again in 7 days.


# **acceptChatRequest**
> Conversation acceptChatRequest(id)

Accept: the chat opens with their request as the first message

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.acceptChatRequest(id);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->acceptChatRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Conversation**](Conversation.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineChatRequest**
> String declineChatRequest(id)

Decline (they aren't told directly; they can ask again after 7 days)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.declineChatRequest(id);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->declineChatRequest: $e\n');
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

# **getChatMessages**
> GetChatMessages200Response getChatMessages(id, before, limit)

The thread: messages and calls between you, newest first (page with ?before=<ISO time>)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final before = ; // Object | 
final limit = 56; // int | 

try {
    final result = api_instance.getChatMessages(id, before, limit);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->getChatMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **before** | [**Object**](.md)|  | [optional] 
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**GetChatMessages200Response**](GetChatMessages200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChatRequests**
> ListChatRequests200Response listChatRequests()

Companions: requests waiting for an answer. Callers: the requests they sent (last 30 days).

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();

try {
    final result = api_instance.listChatRequests();
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->listChatRequests: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ListChatRequests200Response**](ListChatRequests200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChats**
> ListChats200Response listChats()

My conversations, most recent first, with unread counts

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();

try {
    final result = api_instance.listChats();
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->listChats: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ListChats200Response**](ListChats200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markChatRead**
> String markChatRead(id)

Mark the conversation read up to now

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.markChatRead(id);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->markChatRead: $e\n');
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

# **openChat**
> Conversation openChat(userId)

Open the chat with someone (created on first use). Needs a connected call or an accepted message request, and no blocks. A caller without either gets CHAT_NEEDS_REQUEST: send one with POST /chats/requests.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.openChat(userId);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->openChat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**Conversation**](Conversation.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendChatMessage**
> ChatItem sendChatMessage(id, sendChatMessageRequest)

Send a message. Phone numbers, UPI IDs and payment or contact-app requests are refused (MESSAGE_BLOCKED).

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendChatMessageRequest = SendChatMessageRequest(); // SendChatMessageRequest | 

try {
    final result = api_instance.sendChatMessage(id, sendChatMessageRequest);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->sendChatMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendChatMessageRequest** | [**SendChatMessageRequest**](SendChatMessageRequest.md)|  | 

### Return type

[**ChatItem**](ChatItem.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendChatRequest**
> ChatRequest sendChatRequest(sendChatRequestRequest)

Send a companion you haven't called yet one message request (she accepts or declines). Same safety filter and strikes as chat; a few a day; after a decline you can ask again in 7 days.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatApi();
final sendChatRequestRequest = SendChatRequestRequest(); // SendChatRequestRequest | 

try {
    final result = api_instance.sendChatRequest(sendChatRequestRequest);
    print(result);
} catch (e) {
    print('Exception when calling ChatApi->sendChatRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sendChatRequestRequest** | [**SendChatRequestRequest**](SendChatRequestRequest.md)|  | 

### Return type

[**ChatRequest**](ChatRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

