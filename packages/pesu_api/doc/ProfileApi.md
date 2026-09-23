# pesu_api.api.ProfileApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteAccount**](ProfileApi.md#deleteaccount) | **POST** /v1/me/delete | Permanently delete my account. Unused coins are forfeited; companions must withdraw earnings first.
[**getMe**](ProfileApi.md#getme) | **GET** /v1/me | 
[**listLanguages**](ProfileApi.md#listlanguages) | **GET** /v1/languages | Languages users can pick
[**registerDevice**](ProfileApi.md#registerdevice) | **PUT** /v1/devices | Register this phone's FCM token for call and message pushes
[**updateMe**](ProfileApi.md#updateme) | **PATCH** /v1/me | Update name, avatar or languages (primary language must be in `languages`)


# **deleteAccount**
> DeleteAccount200Response deleteAccount(deleteAccountRequest)

Permanently delete my account. Unused coins are forfeited; companions must withdraw earnings first.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProfileApi();
final deleteAccountRequest = DeleteAccountRequest(); // DeleteAccountRequest | 

try {
    final result = api_instance.deleteAccount(deleteAccountRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProfileApi->deleteAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteAccountRequest** | [**DeleteAccountRequest**](DeleteAccountRequest.md)|  | 

### Return type

[**DeleteAccount200Response**](DeleteAccount200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMe**
> Profile getMe()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProfileApi();

try {
    final result = api_instance.getMe();
    print(result);
} catch (e) {
    print('Exception when calling ProfileApi->getMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Profile**](Profile.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLanguages**
> List<ListLanguages200ResponseInner> listLanguages()

Languages users can pick

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = ProfileApi();

try {
    final result = api_instance.listLanguages();
    print(result);
} catch (e) {
    print('Exception when calling ProfileApi->listLanguages: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ListLanguages200ResponseInner>**](ListLanguages200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerDevice**
> String registerDevice(registerDeviceRequest)

Register this phone's FCM token for call and message pushes

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProfileApi();
final registerDeviceRequest = RegisterDeviceRequest(); // RegisterDeviceRequest | 

try {
    final result = api_instance.registerDevice(registerDeviceRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProfileApi->registerDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDeviceRequest** | [**RegisterDeviceRequest**](RegisterDeviceRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMe**
> Profile updateMe(updateMeRequest)

Update name, avatar or languages (primary language must be in `languages`)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProfileApi();
final updateMeRequest = UpdateMeRequest(); // UpdateMeRequest | 

try {
    final result = api_instance.updateMe(updateMeRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProfileApi->updateMe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateMeRequest** | [**UpdateMeRequest**](UpdateMeRequest.md)|  | 

### Return type

[**Profile**](Profile.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

