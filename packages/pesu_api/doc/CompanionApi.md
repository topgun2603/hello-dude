# pesu_api.api.CompanionApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**answerLessonQuiz**](CompanionApi.md#answerlessonquiz) | **POST** /v1/companion/academy/{lessonId}/answers | Submit quiz answers (option index per question). All must be right to pass.
[**applyAsCompanion**](CompanionApi.md#applyascompanion) | **POST** /v1/companion/apply | Become a companion. Switches the account to companion mode and returns new tokens.
[**companionEarnings**](CompanionApi.md#companionearnings) | **GET** /v1/companion/earnings | Balance, last 7 days and withdrawals
[**companionHome**](CompanionApi.md#companionhome) | **GET** /v1/companion/home | Companion home: status and today's numbers (India time)
[**getAcademy**](CompanionApi.md#getacademy) | **GET** /v1/companion/academy | Lessons, in order, with my progress (quiz answers are not included)
[**getCompanionRewards**](CompanionApi.md#getcompanionrewards) | **GET** /v1/companion/rewards | Rewards screen: level, today's goal, online streak and bonuses
[**getKyc**](CompanionApi.md#getkyc) | **GET** /v1/companion/kyc | Verification progress
[**requestPayout**](CompanionApi.md#requestpayout) | **POST** /v1/companion/payouts | Withdraw to UPI. The amount leaves the balance now; a failed payout is credited back.
[**setCompanionCallTypes**](CompanionApi.md#setcompanioncalltypes) | **PUT** /v1/companion/call-types | Choose which calls to take: voice, video or both (video only once it's unlocked)
[**setPresence**](CompanionApi.md#setpresence) | **POST** /v1/companion/presence | Go online / offline. While online, call again every 60 s as a heartbeat.
[**setUpi**](CompanionApi.md#setupi) | **PUT** /v1/companion/upi | Step 3b / later: UPI ID for withdrawals
[**submitKyc**](CompanionApi.md#submitkyc) | **POST** /v1/companion/kyc/submit | Send everything for review
[**uploadAadhaar**](CompanionApi.md#uploadaadhaar) | **POST** /v1/companion/kyc/aadhaar | Step 1: Aadhaar offline e-KYC ZIP (from myaadhaar.uidai.gov.in) + its 4-character share code
[**uploadPan**](CompanionApi.md#uploadpan) | **POST** /v1/companion/kyc/pan | Step 3a: PAN number + photo of the card (needed for TDS)
[**uploadSelfie**](CompanionApi.md#uploadselfie) | **POST** /v1/companion/kyc/selfie | Step 2: live selfie. The app runs the blink check (ML Kit) before sending.


# **answerLessonQuiz**
> AnswerLessonQuiz200Response answerLessonQuiz(lessonId, answerLessonQuizRequest)

Submit quiz answers (option index per question). All must be right to pass.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final lessonId = 56; // int | 
final answerLessonQuizRequest = AnswerLessonQuizRequest(); // AnswerLessonQuizRequest | 

try {
    final result = api_instance.answerLessonQuiz(lessonId, answerLessonQuizRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->answerLessonQuiz: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lessonId** | **int**|  | 
 **answerLessonQuizRequest** | [**AnswerLessonQuizRequest**](AnswerLessonQuizRequest.md)|  | 

### Return type

[**AnswerLessonQuiz200Response**](AnswerLessonQuiz200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **applyAsCompanion**
> SignUp201Response applyAsCompanion(applyAsCompanionRequest)

Become a companion. Switches the account to companion mode and returns new tokens.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final applyAsCompanionRequest = ApplyAsCompanionRequest(); // ApplyAsCompanionRequest | 

try {
    final result = api_instance.applyAsCompanion(applyAsCompanionRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->applyAsCompanion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applyAsCompanionRequest** | [**ApplyAsCompanionRequest**](ApplyAsCompanionRequest.md)|  | 

### Return type

[**SignUp201Response**](SignUp201Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companionEarnings**
> CompanionEarnings200Response companionEarnings()

Balance, last 7 days and withdrawals

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.companionEarnings();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->companionEarnings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompanionEarnings200Response**](CompanionEarnings200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companionHome**
> CompanionHome200Response companionHome()

Companion home: status and today's numbers (India time)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.companionHome();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->companionHome: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompanionHome200Response**](CompanionHome200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAcademy**
> GetAcademy200Response getAcademy()

Lessons, in order, with my progress (quiz answers are not included)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.getAcademy();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->getAcademy: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetAcademy200Response**](GetAcademy200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCompanionRewards**
> GetCompanionRewards200Response getCompanionRewards()

Rewards screen: level, today's goal, online streak and bonuses

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.getCompanionRewards();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->getCompanionRewards: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetCompanionRewards200Response**](GetCompanionRewards200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getKyc**
> KycState getKyc()

Verification progress

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.getKyc();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->getKyc: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestPayout**
> Payout requestPayout(requestPayoutRequest)

Withdraw to UPI. The amount leaves the balance now; a failed payout is credited back.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final requestPayoutRequest = RequestPayoutRequest(); // RequestPayoutRequest | 

try {
    final result = api_instance.requestPayout(requestPayoutRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->requestPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestPayoutRequest** | [**RequestPayoutRequest**](RequestPayoutRequest.md)|  | 

### Return type

[**Payout**](Payout.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setCompanionCallTypes**
> SetCompanionCallTypes200Response setCompanionCallTypes(setCompanionCallTypesRequest)

Choose which calls to take: voice, video or both (video only once it's unlocked)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final setCompanionCallTypesRequest = SetCompanionCallTypesRequest(); // SetCompanionCallTypesRequest | 

try {
    final result = api_instance.setCompanionCallTypes(setCompanionCallTypesRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->setCompanionCallTypes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setCompanionCallTypesRequest** | [**SetCompanionCallTypesRequest**](SetCompanionCallTypesRequest.md)|  | 

### Return type

[**SetCompanionCallTypes200Response**](SetCompanionCallTypes200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setPresence**
> SetPresence200Response setPresence(setPresenceRequest)

Go online / offline. While online, call again every 60 s as a heartbeat.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final setPresenceRequest = SetPresenceRequest(); // SetPresenceRequest | 

try {
    final result = api_instance.setPresence(setPresenceRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->setPresence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setPresenceRequest** | [**SetPresenceRequest**](SetPresenceRequest.md)|  | 

### Return type

[**SetPresence200Response**](SetPresence200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setUpi**
> KycState setUpi(setUpiRequest)

Step 3b / later: UPI ID for withdrawals

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final setUpiRequest = SetUpiRequest(); // SetUpiRequest | 

try {
    final result = api_instance.setUpi(setUpiRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->setUpi: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setUpiRequest** | [**SetUpiRequest**](SetUpiRequest.md)|  | 

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitKyc**
> KycState submitKyc()

Send everything for review

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();

try {
    final result = api_instance.submitKyc();
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->submitKyc: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadAadhaar**
> KycState uploadAadhaar(uploadAadhaarRequest)

Step 1: Aadhaar offline e-KYC ZIP (from myaadhaar.uidai.gov.in) + its 4-character share code

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final uploadAadhaarRequest = UploadAadhaarRequest(); // UploadAadhaarRequest | 

try {
    final result = api_instance.uploadAadhaar(uploadAadhaarRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->uploadAadhaar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadAadhaarRequest** | [**UploadAadhaarRequest**](UploadAadhaarRequest.md)|  | 

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadPan**
> KycState uploadPan(uploadPanRequest)

Step 3a: PAN number + photo of the card (needed for TDS)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final uploadPanRequest = UploadPanRequest(); // UploadPanRequest | 

try {
    final result = api_instance.uploadPan(uploadPanRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->uploadPan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadPanRequest** | [**UploadPanRequest**](UploadPanRequest.md)|  | 

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadSelfie**
> KycState uploadSelfie(uploadSelfieRequest)

Step 2: live selfie. The app runs the blink check (ML Kit) before sending.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CompanionApi();
final uploadSelfieRequest = UploadSelfieRequest(); // UploadSelfieRequest | 

try {
    final result = api_instance.uploadSelfie(uploadSelfieRequest);
    print(result);
} catch (e) {
    print('Exception when calling CompanionApi->uploadSelfie: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadSelfieRequest** | [**UploadSelfieRequest**](UploadSelfieRequest.md)|  | 

### Return type

[**KycState**](KycState.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

