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
[**getReferral**](GrowthApi.md#getreferral) | **GET** /v1/referral | Invite friends: my code, the reward and how many friends joined
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

# **getReferral**
> GetReferral200Response getReferral()

Invite friends: my code, the reward and how many friends joined

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

