# pesu_api.api.BookingsApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelBooking**](BookingsApi.md#cancelbooking) | **POST** /v1/bookings/{id}/cancel | Caller cancels; the held coins come back in full
[**confirmBooking**](BookingsApi.md#confirmbooking) | **POST** /v1/bookings/{id}/confirm | Companion accepts the booked time
[**createBooking**](BookingsApi.md#createbooking) | **POST** /v1/bookings | Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.
[**declineBooking**](BookingsApi.md#declinebooking) | **POST** /v1/bookings/{id}/decline | Companion declines; the caller's coins come back
[**getBookingSlots**](BookingsApi.md#getbookingslots) | **GET** /v1/companions/{id}/slots | Bookable times for the next few days (IST), and the durations offered
[**listBookings**](BookingsApi.md#listbookings) | **GET** /v1/bookings | My bookings: upcoming (and in progress) first, then the last 30 days
[**startBooking**](BookingsApi.md#startbooking) | **POST** /v1/bookings/{id}/start | Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.


# **cancelBooking**
> Booking cancelBooking(id, confirmBookingRequest)

Caller cancels; the held coins come back in full

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final confirmBookingRequest = ConfirmBookingRequest(); // ConfirmBookingRequest | 

try {
    final result = api_instance.cancelBooking(id, confirmBookingRequest);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->cancelBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **confirmBookingRequest** | [**ConfirmBookingRequest**](ConfirmBookingRequest.md)|  | 

### Return type

[**Booking**](Booking.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmBooking**
> Booking confirmBooking(id, confirmBookingRequest)

Companion accepts the booked time

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final confirmBookingRequest = ConfirmBookingRequest(); // ConfirmBookingRequest | 

try {
    final result = api_instance.confirmBooking(id, confirmBookingRequest);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->confirmBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **confirmBookingRequest** | [**ConfirmBookingRequest**](ConfirmBookingRequest.md)|  | 

### Return type

[**Booking**](Booking.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBooking**
> CreateBooking201Response createBooking(createBookingRequest)

Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final createBookingRequest = CreateBookingRequest(); // CreateBookingRequest | 

try {
    final result = api_instance.createBooking(createBookingRequest);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->createBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createBookingRequest** | [**CreateBookingRequest**](CreateBookingRequest.md)|  | 

### Return type

[**CreateBooking201Response**](CreateBooking201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineBooking**
> Booking declineBooking(id, confirmBookingRequest)

Companion declines; the caller's coins come back

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final confirmBookingRequest = ConfirmBookingRequest(); // ConfirmBookingRequest | 

try {
    final result = api_instance.declineBooking(id, confirmBookingRequest);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->declineBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **confirmBookingRequest** | [**ConfirmBookingRequest**](ConfirmBookingRequest.md)|  | 

### Return type

[**Booking**](Booking.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBookingSlots**
> GetBookingSlots200Response getBookingSlots(id)

Bookable times for the next few days (IST), and the durations offered

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getBookingSlots(id);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->getBookingSlots: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**GetBookingSlots200Response**](GetBookingSlots200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBookings**
> ListBookings200Response listBookings()

My bookings: upcoming (and in progress) first, then the last 30 days

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();

try {
    final result = api_instance.listBookings();
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->listBookings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ListBookings200Response**](ListBookings200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startBooking**
> Booking startBooking(id, confirmBookingRequest)

Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final confirmBookingRequest = ConfirmBookingRequest(); // ConfirmBookingRequest | 

try {
    final result = api_instance.startBooking(id, confirmBookingRequest);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->startBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **confirmBookingRequest** | [**ConfirmBookingRequest**](ConfirmBookingRequest.md)|  | 

### Return type

[**Booking**](Booking.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

