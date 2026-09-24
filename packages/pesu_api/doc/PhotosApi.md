# pesu_api.api.PhotosApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteMyPhoto**](PhotosApi.md#deletemyphoto) | **DELETE** /v1/me/photo | Remove my photo (and any waiting for review); the avatar shows again
[**getMyPhoto**](PhotosApi.md#getmyphoto) | **GET** /v1/me/photo | My profile photo and its review status
[**getPhoto**](PhotosApi.md#getphoto) | **GET** /v1/photos/{userId}/{file} | A profile photo, through a signed URL from the API (never linked directly)
[**uploadMyPhoto**](PhotosApi.md#uploadmyphoto) | **PUT** /v1/me/photo | Upload a profile photo (companions). It's cleaned (metadata removed) and shown after an admin approves it; until then your current photo or avatar stays.


# **deleteMyPhoto**
> MyPhoto deleteMyPhoto()

Remove my photo (and any waiting for review); the avatar shows again

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PhotosApi();

try {
    final result = api_instance.deleteMyPhoto();
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->deleteMyPhoto: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MyPhoto**](MyPhoto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMyPhoto**
> MyPhoto getMyPhoto()

My profile photo and its review status

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PhotosApi();

try {
    final result = api_instance.getMyPhoto();
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->getMyPhoto: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MyPhoto**](MyPhoto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPhoto**
> getPhoto(exp, sig, userId, file)

A profile photo, through a signed URL from the API (never linked directly)

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = PhotosApi();
final exp = 56; // int | 
final sig = sig_example; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final file = file_example; // String | 

try {
    api_instance.getPhoto(exp, sig, userId, file);
} catch (e) {
    print('Exception when calling PhotosApi->getPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exp** | **int**|  | 
 **sig** | **String**|  | 
 **userId** | **String**|  | 
 **file** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadMyPhoto**
> MyPhoto uploadMyPhoto(uploadMyPhotoRequest)

Upload a profile photo (companions). It's cleaned (metadata removed) and shown after an admin approves it; until then your current photo or avatar stays.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PhotosApi();
final uploadMyPhotoRequest = UploadMyPhotoRequest(); // UploadMyPhotoRequest | 

try {
    final result = api_instance.uploadMyPhoto(uploadMyPhotoRequest);
    print(result);
} catch (e) {
    print('Exception when calling PhotosApi->uploadMyPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadMyPhotoRequest** | [**UploadMyPhotoRequest**](UploadMyPhotoRequest.md)|  | 

### Return type

[**MyPhoto**](MyPhoto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

