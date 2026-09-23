# pesu_api.api.LegalApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getLegalPage**](LegalApi.md#getlegalpage) | **GET** /v1/legal/{id} | One legal page as blocks the app renders natively
[**listLegalPages**](LegalApi.md#listlegalpages) | **GET** /v1/legal | The legal pages the app lists under Profile → Legal


# **getLegalPage**
> GetLegalPage200Response getLegalPage(id)

One legal page as blocks the app renders natively

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = LegalApi();
final id = id_example; // String | 

try {
    final result = api_instance.getLegalPage(id);
    print(result);
} catch (e) {
    print('Exception when calling LegalApi->getLegalPage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GetLegalPage200Response**](GetLegalPage200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLegalPages**
> List<ListLegalPages200ResponseInner> listLegalPages()

The legal pages the app lists under Profile → Legal

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = LegalApi();

try {
    final result = api_instance.listLegalPages();
    print(result);
} catch (e) {
    print('Exception when calling LegalApi->listLegalPages: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ListLegalPages200ResponseInner>**](ListLegalPages200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

