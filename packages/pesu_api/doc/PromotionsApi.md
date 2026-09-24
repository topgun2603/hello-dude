# pesu_api.api.PromotionsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCurrentPromotion**](PromotionsApi.md#getcurrentpromotion) | **GET** /v1/promotions/current | The offer to show in the app-open bottom sheet, if any
[**logPromotionEvent**](PromotionsApi.md#logpromotionevent) | **POST** /v1/promotions/{id}/events | The app showed the sheet, or the user tapped its button (drives frequency and admin stats)


# **getCurrentPromotion**
> GetCurrentPromotion200Response getCurrentPromotion()

The offer to show in the app-open bottom sheet, if any

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PromotionsApi();

try {
    final result = api_instance.getCurrentPromotion();
    print(result);
} catch (e) {
    print('Exception when calling PromotionsApi->getCurrentPromotion: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetCurrentPromotion200Response**](GetCurrentPromotion200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logPromotionEvent**
> String logPromotionEvent(id, logPromotionEventRequest)

The app showed the sheet, or the user tapped its button (drives frequency and admin stats)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PromotionsApi();
final id = 56; // int | 
final logPromotionEventRequest = LogPromotionEventRequest(); // LogPromotionEventRequest | 

try {
    final result = api_instance.logPromotionEvent(id, logPromotionEventRequest);
    print(result);
} catch (e) {
    print('Exception when calling PromotionsApi->logPromotionEvent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **logPromotionEventRequest** | [**LogPromotionEventRequest**](LogPromotionEventRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

