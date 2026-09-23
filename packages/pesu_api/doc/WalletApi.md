# pesu_api.api.WalletApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getWallet**](WalletApi.md#getwallet) | **GET** /v1/wallet | 
[**listCoinPackages**](WalletApi.md#listcoinpackages) | **GET** /v1/coin-packages | Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.
[**listLedger**](WalletApi.md#listledger) | **GET** /v1/wallet/ledger | Every coin in or out, newest first. Page with `before` = last id seen.


# **getWallet**
> GetWallet200Response getWallet()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = WalletApi();

try {
    final result = api_instance.getWallet();
    print(result);
} catch (e) {
    print('Exception when calling WalletApi->getWallet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetWallet200Response**](GetWallet200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listCoinPackages**
> List<ListCoinPackages200ResponseInner> listCoinPackages()

Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = WalletApi();

try {
    final result = api_instance.listCoinPackages();
    print(result);
} catch (e) {
    print('Exception when calling WalletApi->listCoinPackages: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ListCoinPackages200ResponseInner>**](ListCoinPackages200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLedger**
> ListLedger200Response listLedger(kind, before, limit)

Every coin in or out, newest first. Page with `before` = last id seen.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = WalletApi();
final kind = kind_example; // String | 
final before = 56; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.listLedger(kind, before, limit);
    print(result);
} catch (e) {
    print('Exception when calling WalletApi->listLedger: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | [optional] [default to 'coins']
 **before** | **int**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 30]

### Return type

[**ListLedger200Response**](ListLedger200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

