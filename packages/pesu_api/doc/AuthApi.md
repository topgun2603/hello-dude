# pesu_api.api.AuthApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**logout**](AuthApi.md#logout) | **POST** /v1/auth/logout | 
[**refreshTokens**](AuthApi.md#refreshtokens) | **POST** /v1/auth/refresh | Swap a refresh token for a new token pair (the old one stops working)
[**sendOtp**](AuthApi.md#sendotp) | **POST** /v1/auth/otp/send | Send a 6-digit code to a mobile number
[**signInWithFirebase**](AuthApi.md#signinwithfirebase) | **POST** /v1/auth/firebase | Mobile app sign-in: the app verified the number with Firebase Auth and sends its ID token. Indian (+91) mobiles only. Same result as otp/verify.
[**signUp**](AuthApi.md#signup) | **POST** /v1/auth/signup | Create the account after OTP (Main + Language screens). Women (and transgender sign-ups) join as companions, men as callers.
[**verifyOtp**](AuthApi.md#verifyotp) | **POST** /v1/auth/otp/verify | Verify the code. Existing users get tokens; new numbers get a signup token.


# **logout**
> String logout(refreshTokensRequest)



### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final refreshTokensRequest = RefreshTokensRequest(); // RefreshTokensRequest | 

try {
    final result = api_instance.logout(refreshTokensRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->logout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokensRequest** | [**RefreshTokensRequest**](RefreshTokensRequest.md)|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshTokens**
> TokenPair refreshTokens(refreshTokensRequest)

Swap a refresh token for a new token pair (the old one stops working)

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final refreshTokensRequest = RefreshTokensRequest(); // RefreshTokensRequest | 

try {
    final result = api_instance.refreshTokens(refreshTokensRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->refreshTokens: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokensRequest** | [**RefreshTokensRequest**](RefreshTokensRequest.md)|  | 

### Return type

[**TokenPair**](TokenPair.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendOtp**
> SendOtp200Response sendOtp(sendOtpRequest)

Send a 6-digit code to a mobile number

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final sendOtpRequest = SendOtpRequest(); // SendOtpRequest | 

try {
    final result = api_instance.sendOtp(sendOtpRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->sendOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sendOtpRequest** | [**SendOtpRequest**](SendOtpRequest.md)|  | 

### Return type

[**SendOtp200Response**](SendOtp200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signInWithFirebase**
> OtpVerifyResult signInWithFirebase(signInWithFirebaseRequest)

Mobile app sign-in: the app verified the number with Firebase Auth and sends its ID token. Indian (+91) mobiles only. Same result as otp/verify.

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final signInWithFirebaseRequest = SignInWithFirebaseRequest(); // SignInWithFirebaseRequest | 

try {
    final result = api_instance.signInWithFirebase(signInWithFirebaseRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->signInWithFirebase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **signInWithFirebaseRequest** | [**SignInWithFirebaseRequest**](SignInWithFirebaseRequest.md)|  | 

### Return type

[**OtpVerifyResult**](OtpVerifyResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signUp**
> SignUp201Response signUp(signUpRequest)

Create the account after OTP (Main + Language screens). Women (and transgender sign-ups) join as companions, men as callers.

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final signUpRequest = SignUpRequest(); // SignUpRequest | 

try {
    final result = api_instance.signUp(signUpRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->signUp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **signUpRequest** | [**SignUpRequest**](SignUpRequest.md)|  | 

### Return type

[**SignUp201Response**](SignUp201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyOtp**
> OtpVerifyResult verifyOtp(verifyOtpRequest)

Verify the code. Existing users get tokens; new numbers get a signup token.

### Example
```dart
import 'package:pesu_api/api.dart';

final api_instance = AuthApi();
final verifyOtpRequest = VerifyOtpRequest(); // VerifyOtpRequest | 

try {
    final result = api_instance.verifyOtp(verifyOtpRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->verifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOtpRequest** | [**VerifyOtpRequest**](VerifyOtpRequest.md)|  | 

### Return type

[**OtpVerifyResult**](OtpVerifyResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

