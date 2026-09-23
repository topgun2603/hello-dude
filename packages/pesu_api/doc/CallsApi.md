# pesu_api.api.CallsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptCall**](CallsApi.md#acceptcall) | **POST** /v1/calls/{id}/accept | Companion answers a ringing call and gets their join token
[**endCall**](CallsApi.md#endcall) | **POST** /v1/calls/{id}/end | Hang up (either side). Safe to repeat.
[**flagVideoFrame**](CallsApi.md#flagvideoframe) | **POST** /v1/calls/{id}/moderation | Report a video frame the app's on-device check flagged as nudity (the other person's video)
[**getCall**](CallsApi.md#getcall) | **GET** /v1/calls/{id} | Call details: every billed minute, refunds included
[**listCalls**](CallsApi.md#listcalls) | **GET** /v1/calls | Call history, newest first. Page with `before` = createdAt of the last call seen.
[**listGifts**](CallsApi.md#listgifts) | **GET** /v1/gifts | Gifts a caller can send during a call
[**matchCall**](CallsApi.md#matchcall) | **POST** /v1/calls/match | Instant match: ring a free online companion who speaks the language
[**rateCall**](CallsApi.md#ratecall) | **POST** /v1/calls/{id}/rating | Rate a finished call (once)
[**rejectCall**](CallsApi.md#rejectcall) | **POST** /v1/calls/{id}/reject | 
[**requestRefund**](CallsApi.md#requestrefund) | **POST** /v1/calls/{id}/refund-request | Ask for a refund on a finished call (once per call)
[**sendGift**](CallsApi.md#sendgift) | **POST** /v1/calls/{id}/gifts | Send a gift during a live call. clientRef makes a retried tap safe.
[**startCall**](CallsApi.md#startcall) | **POST** /v1/calls | Call a specific companion. Nothing is charged until both sides join.


# **acceptCall**
> JoinInfo acceptCall(id)

Companion answers a ringing call and gets their join token

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.acceptCall(id);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->acceptCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JoinInfo**](JoinInfo.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **endCall**
> CallSummary endCall(id)

Hang up (either side). Safe to repeat.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.endCall(id);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->endCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**CallSummary**](CallSummary.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **flagVideoFrame**
> FlagVideoFrame201Response flagVideoFrame(id, flagVideoFrameRequest)

Report a video frame the app's on-device check flagged as nudity (the other person's video)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final flagVideoFrameRequest = FlagVideoFrameRequest(); // FlagVideoFrameRequest | 

try {
    final result = api_instance.flagVideoFrame(id, flagVideoFrameRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->flagVideoFrame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **flagVideoFrameRequest** | [**FlagVideoFrameRequest**](FlagVideoFrameRequest.md)|  | 

### Return type

[**FlagVideoFrame201Response**](FlagVideoFrame201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCall**
> CallDetails getCall(id)

Call details: every billed minute, refunds included

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getCall(id);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->getCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**CallDetails**](CallDetails.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listCalls**
> ListCalls200Response listCalls(before, limit)

Call history, newest first. Page with `before` = createdAt of the last call seen.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final before = ; // Object | 
final limit = 56; // int | 

try {
    final result = api_instance.listCalls(before, limit);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->listCalls: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **before** | [**Object**](.md)|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**ListCalls200Response**](ListCalls200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGifts**
> List<Gift> listGifts()

Gifts a caller can send during a call

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = CallsApi();

try {
    final result = api_instance.listGifts();
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->listGifts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Gift>**](Gift.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **matchCall**
> MatchCall201Response matchCall(matchCallRequest)

Instant match: ring a free online companion who speaks the language

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final matchCallRequest = MatchCallRequest(); // MatchCallRequest | 

try {
    final result = api_instance.matchCall(matchCallRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->matchCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **matchCallRequest** | [**MatchCallRequest**](MatchCallRequest.md)|  | 

### Return type

[**MatchCall201Response**](MatchCall201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rateCall**
> String rateCall(id, rateCallRequest)

Rate a finished call (once)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final rateCallRequest = RateCallRequest(); // RateCallRequest | 

try {
    final result = api_instance.rateCall(id, rateCallRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->rateCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **rateCallRequest** | [**RateCallRequest**](RateCallRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rejectCall**
> String rejectCall(id)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.rejectCall(id);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->rejectCall: $e\n');
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

# **requestRefund**
> RefundRequest requestRefund(id, requestRefundRequest)

Ask for a refund on a finished call (once per call)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final requestRefundRequest = RequestRefundRequest(); // RequestRefundRequest | 

try {
    final result = api_instance.requestRefund(id, requestRefundRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->requestRefund: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **requestRefundRequest** | [**RequestRefundRequest**](RequestRefundRequest.md)|  | 

### Return type

[**RefundRequest**](RefundRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendGift**
> SendGift201Response sendGift(id, sendGiftRequest)

Send a gift during a live call. clientRef makes a retried tap safe.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final sendGiftRequest = SendGiftRequest(); // SendGiftRequest | 

try {
    final result = api_instance.sendGift(id, sendGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->sendGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendGiftRequest** | [**SendGiftRequest**](SendGiftRequest.md)|  | 

### Return type

[**SendGift201Response**](SendGift201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startCall**
> JoinInfo startCall(startCallRequest)

Call a specific companion. Nothing is charged until both sides join.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CallsApi();
final startCallRequest = StartCallRequest(); // StartCallRequest | 

try {
    final result = api_instance.startCall(startCallRequest);
    print(result);
} catch (e) {
    print('Exception when calling CallsApi->startCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startCallRequest** | [**StartCallRequest**](StartCallRequest.md)|  | 

### Return type

[**JoinInfo**](JoinInfo.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

