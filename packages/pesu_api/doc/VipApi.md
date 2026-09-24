# pesu_api.api.VipApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getVip**](VipApi.md#getvip) | **GET** /v1/vip | My VIP status, the perks and the plans on sale


# **getVip**
> GetVip200Response getVip()

My VIP status, the perks and the plans on sale

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = VipApi();

try {
    final result = api_instance.getVip();
    print(result);
} catch (e) {
    print('Exception when calling VipApi->getVip: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetVip200Response**](GetVip200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

