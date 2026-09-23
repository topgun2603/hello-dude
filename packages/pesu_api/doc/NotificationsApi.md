# pesu_api.api.NotificationsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /v1/notifications | My notifications, newest first (page with ?before=<id>)
[**markNotificationsRead**](NotificationsApi.md#marknotificationsread) | **POST** /v1/notifications/read | Mark some notifications read (ids), or every one with all: true (\"Read all\")
[**unreadNotificationCount**](NotificationsApi.md#unreadnotificationcount) | **GET** /v1/notifications/unread-count | Number for the bell badge


# **listNotifications**
> ListNotifications200Response listNotifications(before, limit)

My notifications, newest first (page with ?before=<id>)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = NotificationsApi();
final before = 56; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.listNotifications(before, limit);
    print(result);
} catch (e) {
    print('Exception when calling NotificationsApi->listNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **before** | **int**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 40]

### Return type

[**ListNotifications200Response**](ListNotifications200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markNotificationsRead**
> UnreadNotificationCount200Response markNotificationsRead(markNotificationsReadRequest)

Mark some notifications read (ids), or every one with all: true (\"Read all\")

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = NotificationsApi();
final markNotificationsReadRequest = MarkNotificationsReadRequest(); // MarkNotificationsReadRequest | 

try {
    final result = api_instance.markNotificationsRead(markNotificationsReadRequest);
    print(result);
} catch (e) {
    print('Exception when calling NotificationsApi->markNotificationsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markNotificationsReadRequest** | [**MarkNotificationsReadRequest**](MarkNotificationsReadRequest.md)|  | 

### Return type

[**UnreadNotificationCount200Response**](UnreadNotificationCount200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unreadNotificationCount**
> UnreadNotificationCount200Response unreadNotificationCount()

Number for the bell badge

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = NotificationsApi();

try {
    final result = api_instance.unreadNotificationCount();
    print(result);
} catch (e) {
    print('Exception when calling NotificationsApi->unreadNotificationCount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UnreadNotificationCount200Response**](UnreadNotificationCount200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

