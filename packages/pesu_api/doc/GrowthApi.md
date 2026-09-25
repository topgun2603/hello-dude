# pesu_api.api.GrowthApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**claimCheckIn**](GrowthApi.md#claimcheckin) | **POST** /v1/checkin/claim | Claim today's bonus (once per IST day; repeating is harmless)
[**getCheckIn**](GrowthApi.md#getcheckin) | **GET** /v1/checkin | Daily bonus: today's streak day and the 7-day reward ladder
[**getCurrentEvent**](GrowthApi.md#getcurrentevent) | **GET** /v1/events/current | The festival event running now, if any
[**getLeaderboard**](GrowthApi.md#getleaderboard) | **GET** /v1/leaderboards | Top companions (coins spent on them) or top fans (gift coins sent): this week, last week, or an event
[**getMyLevel**](GrowthApi.md#getmylevel) | **GET** /v1/me/level | My caller level, from lifetime coins spent
[**getReferral**](GrowthApi.md#getreferral) | **GET** /v1/referral | Invite friends: my code, the reward and how many joined. Callers earn coins; companions earn ₹ in earnings (referrerPaise) — both when the invited caller makes their first recharge.
[**getShareCard**](GrowthApi.md#getsharecard) | **GET** /v1/share-card | What the share card shows: today's talk time, language and invite code (never who they talked to)


# **claimCheckIn**
> ClaimCheckIn200Response claimCheckIn()

Claim today's bonus (once per IST day; repeating is harmless)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.claimCheckIn();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->claimCheckIn: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ClaimCheckIn200Response**](ClaimCheckIn200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCheckIn**
> CheckIn getCheckIn()

Daily bonus: today's streak day and the 7-day reward ladder

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.getCheckIn();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getCheckIn: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CheckIn**](CheckIn.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentEvent**
> GetCurrentEvent200Response getCurrentEvent()

The festival event running now, if any

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.getCurrentEvent();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getCurrentEvent: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetCurrentEvent200Response**](GetCurrentEvent200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLeaderboard**
> GetLeaderboard200Response getLeaderboard(board, period, eventId)

Top companions (coins spent on them) or top fans (gift coins sent): this week, last week, or an event

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();
final board = board_example; // String | 
final period = period_example; // String | 
final eventId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getLeaderboard(board, period, eventId);
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getLeaderboard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **board** | **String**|  | 
 **period** | **String**|  | [optional] [default to 'this_week']
 **eventId** | **String**|  | [optional] 

### Return type

[**GetLeaderboard200Response**](GetLeaderboard200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMyLevel**
> GetMyLevel200Response getMyLevel()

My caller level, from lifetime coins spent

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.getMyLevel();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getMyLevel: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetMyLevel200Response**](GetMyLevel200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReferral**
> GetReferral200Response getReferral()

Invite friends: my code, the reward and how many joined. Callers earn coins; companions earn ₹ in earnings (referrerPaise) — both when the invited caller makes their first recharge.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.getReferral();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getReferral: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetReferral200Response**](GetReferral200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getShareCard**
> GetShareCard200Response getShareCard()

What the share card shows: today's talk time, language and invite code (never who they talked to)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = GrowthApi();

try {
    final result = api_instance.getShareCard();
    print(result);
} catch (e) {
    print('Exception when calling GrowthApi->getShareCard: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetShareCard200Response**](GetShareCard200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

