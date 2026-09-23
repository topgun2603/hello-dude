# pesu_api.api.SafetyApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**blockUser**](SafetyApi.md#blockuser) | **POST** /v1/blocks | Block someone: neither side can see or call the other
[**listBlocks**](SafetyApi.md#listblocks) | **GET** /v1/blocks | 
[**reportUser**](SafetyApi.md#reportuser) | **POST** /v1/reports | Report someone (also blocks them). Pass callId when reporting a call.
[**unblockUser**](SafetyApi.md#unblockuser) | **DELETE** /v1/blocks/{userId} | 


# **blockUser**
> String blockUser(blockUserRequest)

Block someone: neither side can see or call the other

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SafetyApi();
final blockUserRequest = BlockUserRequest(); // BlockUserRequest | 

try {
    final result = api_instance.blockUser(blockUserRequest);
    print(result);
} catch (e) {
    print('Exception when calling SafetyApi->blockUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockUserRequest** | [**BlockUserRequest**](BlockUserRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBlocks**
> List<ListBlocks200ResponseInner> listBlocks()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SafetyApi();

try {
    final result = api_instance.listBlocks();
    print(result);
} catch (e) {
    print('Exception when calling SafetyApi->listBlocks: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ListBlocks200ResponseInner>**](ListBlocks200ResponseInner.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportUser**
> ReportUser201Response reportUser(reportUserRequest)

Report someone (also blocks them). Pass callId when reporting a call.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SafetyApi();
final reportUserRequest = ReportUserRequest(); // ReportUserRequest | 

try {
    final result = api_instance.reportUser(reportUserRequest);
    print(result);
} catch (e) {
    print('Exception when calling SafetyApi->reportUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reportUserRequest** | [**ReportUserRequest**](ReportUserRequest.md)|  | 

### Return type

[**ReportUser201Response**](ReportUser201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unblockUser**
> String unblockUser(userId)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SafetyApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.unblockUser(userId);
    print(result);
} catch (e) {
    print('Exception when calling SafetyApi->unblockUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

