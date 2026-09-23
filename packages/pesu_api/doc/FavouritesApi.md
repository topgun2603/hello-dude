# pesu_api.api.FavouritesApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addFavourite**](FavouritesApi.md#addfavourite) | **PUT** /v1/favourites/{companionId} | Add (or update) a favourite. notify = alert me when they come online.
[**listFavourites**](FavouritesApi.md#listfavourites) | **GET** /v1/favourites | My favourite companions, free ones first
[**removeFavourite**](FavouritesApi.md#removefavourite) | **DELETE** /v1/favourites/{companionId} | 


# **addFavourite**
> String addFavourite(companionId, addFavouriteRequest)

Add (or update) a favourite. notify = alert me when they come online.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FavouritesApi();
final companionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final addFavouriteRequest = AddFavouriteRequest(); // AddFavouriteRequest | 

try {
    final result = api_instance.addFavourite(companionId, addFavouriteRequest);
    print(result);
} catch (e) {
    print('Exception when calling FavouritesApi->addFavourite: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companionId** | **String**|  | 
 **addFavouriteRequest** | [**AddFavouriteRequest**](AddFavouriteRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFavourites**
> List<Favourite> listFavourites()

My favourite companions, free ones first

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FavouritesApi();

try {
    final result = api_instance.listFavourites();
    print(result);
} catch (e) {
    print('Exception when calling FavouritesApi->listFavourites: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Favourite>**](Favourite.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeFavourite**
> String removeFavourite(companionId)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FavouritesApi();
final companionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.removeFavourite(companionId);
    print(result);
} catch (e) {
    print('Exception when calling FavouritesApi->removeFavourite: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companionId** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

