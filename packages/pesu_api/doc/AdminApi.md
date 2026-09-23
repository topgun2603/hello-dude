# pesu_api.api.AdminApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAddUserNote**](AdminApi.md#adminaddusernote) | **POST** /v1/admin/users/{id}/notes | Add a private admin note to a caller or companion
[**adminApprovePayout**](AdminApi.md#adminapprovepayout) | **POST** /v1/admin/payouts/{id}/approve | Approve and send to UPI. Failures are credited back to the companion automatically.
[**adminAuditLog**](AdminApi.md#adminauditlog) | **GET** /v1/admin/audit | Latest admin actions
[**adminCreateGift**](AdminApi.md#admincreategift) | **POST** /v1/admin/gifts | Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).
[**adminCreatePackage**](AdminApi.md#admincreatepackage) | **POST** /v1/admin/coin-packages | Add a coin pack. Create the Google Play product with the same SKU first.
[**adminCreateRate**](AdminApi.md#admincreaterate) | **POST** /v1/admin/rates | Add a rate version. Calls already running keep their old rate.
[**adminDashboard**](AdminApi.md#admindashboard) | **GET** /v1/admin/dashboard | Live numbers and today's totals (India time)
[**adminDecideRefund**](AdminApi.md#admindeciderefund) | **POST** /v1/admin/refunds/{id}/decide | Approve (all or part of the coins) or reject a refund request
[**adminGetModerationFrame**](AdminApi.md#admingetmoderationframe) | **GET** /v1/admin/moderation/{id}/frame | The flagged frame (decrypted). Every view is audit-logged.
[**adminGetUser**](AdminApi.md#admingetuser) | **GET** /v1/admin/users/{id} | Everything about one caller or companion: profile, wallets, calls, money and safety history
[**adminKycDecision**](AdminApi.md#adminkycdecision) | **POST** /v1/admin/kyc/{userId}/decision | Approve (companion can go online) or reject with a reason the companion will see
[**adminKycFile**](AdminApi.md#adminkycfile) | **GET** /v1/admin/kyc/{userId}/files/{doc} | Decrypted KYC image for side-by-side review. Every view is audit-logged.
[**adminKycQueue**](AdminApi.md#adminkycqueue) | **GET** /v1/admin/kyc | KYC review queue (oldest first) or decided cases
[**adminListGifts**](AdminApi.md#adminlistgifts) | **GET** /v1/admin/gifts | 
[**adminListModerationFlags**](AdminApi.md#adminlistmoderationflags) | **GET** /v1/admin/moderation | Video frames flagged for nudity by the app, oldest open first
[**adminListPackages**](AdminApi.md#adminlistpackages) | **GET** /v1/admin/coin-packages | 
[**adminListPayouts**](AdminApi.md#adminlistpayouts) | **GET** /v1/admin/payouts | 
[**adminListRates**](AdminApi.md#adminlistrates) | **GET** /v1/admin/rates | All call rates: current, scheduled and past
[**adminListRefunds**](AdminApi.md#adminlistrefunds) | **GET** /v1/admin/refunds | 
[**adminListReports**](AdminApi.md#adminlistreports) | **GET** /v1/admin/reports | 
[**adminListSettings**](AdminApi.md#adminlistsettings) | **GET** /v1/admin/settings | 
[**adminListUsers**](AdminApi.md#adminlistusers) | **GET** /v1/admin/users | Search callers or companions by name or the last digits of their number
[**adminRejectPayout**](AdminApi.md#adminrejectpayout) | **POST** /v1/admin/payouts/{id}/reject | Reject a withdrawal; the amount goes back to the companion's balance
[**adminResolveModerationFlag**](AdminApi.md#adminresolvemoderationflag) | **POST** /v1/admin/moderation/{id}/resolve | Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video
[**adminResolveReport**](AdminApi.md#adminresolvereport) | **POST** /v1/admin/reports/{id}/resolve | Dismiss a report, or act on it by suspending the reported user
[**adminSendCoins**](AdminApi.md#adminsendcoins) | **POST** /v1/admin/users/{id}/coins | Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log
[**adminSendMessage**](AdminApi.md#adminsendmessage) | **POST** /v1/admin/users/{id}/message | Send a push notification to one caller or companion
[**adminSetUserStatus**](AdminApi.md#adminsetuserstatus) | **POST** /v1/admin/users/{id}/status | Suspend, ban or reactivate an account
[**adminSetVideo**](AdminApi.md#adminsetvideo) | **POST** /v1/admin/companions/{userId}/video | Unlock or lock video calls for a companion (after academy + clean record)
[**adminUpdateGift**](AdminApi.md#adminupdategift) | **PUT** /v1/admin/gifts/{id} | 
[**adminUpdatePackage**](AdminApi.md#adminupdatepackage) | **PUT** /v1/admin/coin-packages/{id} | Edit a coin pack. The Google Play product price must be changed to match in Play Console.
[**adminUpdateSetting**](AdminApi.md#adminupdatesetting) | **PUT** /v1/admin/settings/{key} | 


# **adminAddUserNote**
> AdminNote adminAddUserNote(id, adminAddUserNoteRequest)

Add a private admin note to a caller or companion

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminAddUserNoteRequest = AdminAddUserNoteRequest(); // AdminAddUserNoteRequest | 

try {
    final result = api_instance.adminAddUserNote(id, adminAddUserNoteRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminAddUserNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminAddUserNoteRequest** | [**AdminAddUserNoteRequest**](AdminAddUserNoteRequest.md)|  | 

### Return type

[**AdminNote**](AdminNote.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApprovePayout**
> AdminPayout adminApprovePayout(id)

Approve and send to UPI. Failures are credited back to the companion automatically.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.adminApprovePayout(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminApprovePayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminPayout**](AdminPayout.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuditLog**
> List<AdminAuditLog200ResponseInner> adminAuditLog(limit)

Latest admin actions

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final limit = 56; // int | 

try {
    final result = api_instance.adminAuditLog(limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminAuditLog: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**List<AdminAuditLog200ResponseInner>**](AdminAuditLog200ResponseInner.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCreateGift**
> AdminGift adminCreateGift(adminCreateGiftRequest)

Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final adminCreateGiftRequest = AdminCreateGiftRequest(); // AdminCreateGiftRequest | 

try {
    final result = api_instance.adminCreateGift(adminCreateGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreateGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreateGiftRequest** | [**AdminCreateGiftRequest**](AdminCreateGiftRequest.md)|  | 

### Return type

[**AdminGift**](AdminGift.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCreatePackage**
> AdminCoinPackage adminCreatePackage(adminCreatePackageRequest)

Add a coin pack. Create the Google Play product with the same SKU first.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final adminCreatePackageRequest = AdminCreatePackageRequest(); // AdminCreatePackageRequest | 

try {
    final result = api_instance.adminCreatePackage(adminCreatePackageRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreatePackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreatePackageRequest** | [**AdminCreatePackageRequest**](AdminCreatePackageRequest.md)|  | 

### Return type

[**AdminCoinPackage**](AdminCoinPackage.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCreateRate**
> AdminCallRate adminCreateRate(adminCreateRateRequest)

Add a rate version. Calls already running keep their old rate.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final adminCreateRateRequest = AdminCreateRateRequest(); // AdminCreateRateRequest | 

try {
    final result = api_instance.adminCreateRate(adminCreateRateRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreateRate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreateRateRequest** | [**AdminCreateRateRequest**](AdminCreateRateRequest.md)|  | 

### Return type

[**AdminCallRate**](AdminCallRate.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboard**
> AdminDashboard200Response adminDashboard()

Live numbers and today's totals (India time)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();

try {
    final result = api_instance.adminDashboard();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminDashboard: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminDashboard200Response**](AdminDashboard200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDecideRefund**
> String adminDecideRefund(id, adminDecideRefundRequest)

Approve (all or part of the coins) or reject a refund request

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminDecideRefundRequest = AdminDecideRefundRequest(); // AdminDecideRefundRequest | 

try {
    final result = api_instance.adminDecideRefund(id, adminDecideRefundRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminDecideRefund: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminDecideRefundRequest** | [**AdminDecideRefundRequest**](AdminDecideRefundRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminGetModerationFrame**
> adminGetModerationFrame(id)

The flagged frame (decrypted). Every view is audit-logged.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.adminGetModerationFrame(id);
} catch (e) {
    print('Exception when calling AdminApi->adminGetModerationFrame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminGetUser**
> AdminUserDetail adminGetUser(id)

Everything about one caller or companion: profile, wallets, calls, money and safety history

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.adminGetUser(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminGetUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminUserDetail**](AdminUserDetail.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminKycDecision**
> String adminKycDecision(userId, adminKycDecisionRequest)

Approve (companion can go online) or reject with a reason the companion will see

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminKycDecisionRequest = AdminKycDecisionRequest(); // AdminKycDecisionRequest | 

try {
    final result = api_instance.adminKycDecision(userId, adminKycDecisionRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminKycDecision: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **adminKycDecisionRequest** | [**AdminKycDecisionRequest**](AdminKycDecisionRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminKycFile**
> adminKycFile(userId, doc)

Decrypted KYC image for side-by-side review. Every view is audit-logged.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final doc = doc_example; // String | 

try {
    api_instance.adminKycFile(userId, doc);
} catch (e) {
    print('Exception when calling AdminApi->adminKycFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **doc** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminKycQueue**
> List<AdminKycCase> adminKycQueue(status)

KYC review queue (oldest first) or decided cases

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final status = status_example; // String | 

try {
    final result = api_instance.adminKycQueue(status);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminKycQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'submitted']

### Return type

[**List<AdminKycCase>**](AdminKycCase.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListGifts**
> List<AdminGift> adminListGifts()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();

try {
    final result = api_instance.adminListGifts();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListGifts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminGift>**](AdminGift.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListModerationFlags**
> List<AdminModerationFlag> adminListModerationFlags(status, limit)

Video frames flagged for nudity by the app, oldest open first

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final status = status_example; // String | 
final limit = 56; // int | 

try {
    final result = api_instance.adminListModerationFlags(status, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListModerationFlags: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'open']
 **limit** | **int**|  | [optional] [default to 200]

### Return type

[**List<AdminModerationFlag>**](AdminModerationFlag.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListPackages**
> List<AdminCoinPackage> adminListPackages()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();

try {
    final result = api_instance.adminListPackages();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListPackages: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminCoinPackage>**](AdminCoinPackage.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListPayouts**
> AdminListPayouts200Response adminListPayouts(status)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final status = status_example; // String | 

try {
    final result = api_instance.adminListPayouts(status);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListPayouts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'requested']

### Return type

[**AdminListPayouts200Response**](AdminListPayouts200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListRates**
> List<AdminCallRate> adminListRates()

All call rates: current, scheduled and past

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();

try {
    final result = api_instance.adminListRates();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListRates: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminCallRate>**](AdminCallRate.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListRefunds**
> List<AdminRefund> adminListRefunds(status)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final status = status_example; // String | 

try {
    final result = api_instance.adminListRefunds(status);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListRefunds: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'requested']

### Return type

[**List<AdminRefund>**](AdminRefund.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListReports**
> List<AdminReport> adminListReports(status, limit)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final status = status_example; // String | 
final limit = 56; // int | 

try {
    final result = api_instance.adminListReports(status, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListReports: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'open']
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**List<AdminReport>**](AdminReport.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListSettings**
> List<AdminListSettings200ResponseInner> adminListSettings()



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();

try {
    final result = api_instance.adminListSettings();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListSettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminListSettings200ResponseInner>**](AdminListSettings200ResponseInner.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListUsers**
> AdminListUsers200Response adminListUsers(role, q, status, limit, offset)

Search callers or companions by name or the last digits of their number

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final role = role_example; // String | 
final q = q_example; // String | 
final status = status_example; // String | 
final limit = 56; // int | 
final offset = 56; // int | 

try {
    final result = api_instance.adminListUsers(role, q, status, limit, offset);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListUsers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**|  | [optional] [default to 'caller']
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**AdminListUsers200Response**](AdminListUsers200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRejectPayout**
> String adminRejectPayout(id, adminRejectPayoutRequest)

Reject a withdrawal; the amount goes back to the companion's balance

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminRejectPayoutRequest = AdminRejectPayoutRequest(); // AdminRejectPayoutRequest | 

try {
    final result = api_instance.adminRejectPayout(id, adminRejectPayoutRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminRejectPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRejectPayoutRequest** | [**AdminRejectPayoutRequest**](AdminRejectPayoutRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminResolveModerationFlag**
> String adminResolveModerationFlag(id, adminResolveModerationFlagRequest)

Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminResolveModerationFlagRequest = AdminResolveModerationFlagRequest(); // AdminResolveModerationFlagRequest | 

try {
    final result = api_instance.adminResolveModerationFlag(id, adminResolveModerationFlagRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminResolveModerationFlag: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminResolveModerationFlagRequest** | [**AdminResolveModerationFlagRequest**](AdminResolveModerationFlagRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminResolveReport**
> String adminResolveReport(id, adminResolveReportRequest)

Dismiss a report, or act on it by suspending the reported user

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminResolveReportRequest = AdminResolveReportRequest(); // AdminResolveReportRequest | 

try {
    final result = api_instance.adminResolveReport(id, adminResolveReportRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminResolveReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminResolveReportRequest** | [**AdminResolveReportRequest**](AdminResolveReportRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSendCoins**
> AdminSendCoins200Response adminSendCoins(id, adminSendCoinsRequest)

Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminSendCoinsRequest = AdminSendCoinsRequest(); // AdminSendCoinsRequest | 

try {
    final result = api_instance.adminSendCoins(id, adminSendCoinsRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminSendCoins: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminSendCoinsRequest** | [**AdminSendCoinsRequest**](AdminSendCoinsRequest.md)|  | 

### Return type

[**AdminSendCoins200Response**](AdminSendCoins200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSendMessage**
> AdminSendMessage200Response adminSendMessage(id, adminSendMessageRequest)

Send a push notification to one caller or companion

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminSendMessageRequest = AdminSendMessageRequest(); // AdminSendMessageRequest | 

try {
    final result = api_instance.adminSendMessage(id, adminSendMessageRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminSendMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminSendMessageRequest** | [**AdminSendMessageRequest**](AdminSendMessageRequest.md)|  | 

### Return type

[**AdminSendMessage200Response**](AdminSendMessage200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSetUserStatus**
> String adminSetUserStatus(id, adminSetUserStatusRequest)

Suspend, ban or reactivate an account

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminSetUserStatusRequest = AdminSetUserStatusRequest(); // AdminSetUserStatusRequest | 

try {
    final result = api_instance.adminSetUserStatus(id, adminSetUserStatusRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminSetUserStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminSetUserStatusRequest** | [**AdminSetUserStatusRequest**](AdminSetUserStatusRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSetVideo**
> String adminSetVideo(userId, adminSetVideoRequest)

Unlock or lock video calls for a companion (after academy + clean record)

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final adminSetVideoRequest = AdminSetVideoRequest(); // AdminSetVideoRequest | 

try {
    final result = api_instance.adminSetVideo(userId, adminSetVideoRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminSetVideo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **adminSetVideoRequest** | [**AdminSetVideoRequest**](AdminSetVideoRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateGift**
> AdminGift adminUpdateGift(id, adminUpdateGiftRequest)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 56; // int | 
final adminUpdateGiftRequest = AdminUpdateGiftRequest(); // AdminUpdateGiftRequest | 

try {
    final result = api_instance.adminUpdateGift(id, adminUpdateGiftRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateGift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminUpdateGiftRequest** | [**AdminUpdateGiftRequest**](AdminUpdateGiftRequest.md)|  | 

### Return type

[**AdminGift**](AdminGift.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdatePackage**
> AdminCoinPackage adminUpdatePackage(id, adminUpdatePackageRequest)

Edit a coin pack. The Google Play product price must be changed to match in Play Console.

### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final id = 56; // int | 
final adminUpdatePackageRequest = AdminUpdatePackageRequest(); // AdminUpdatePackageRequest | 

try {
    final result = api_instance.adminUpdatePackage(id, adminUpdatePackageRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdatePackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminUpdatePackageRequest** | [**AdminUpdatePackageRequest**](AdminUpdatePackageRequest.md)|  | 

### Return type

[**AdminCoinPackage**](AdminCoinPackage.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateSetting**
> String adminUpdateSetting(key, adminUpdateSettingRequest)



### Example
```dart
import 'package:pesu_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminApi();
final key = key_example; // String | 
final adminUpdateSettingRequest = AdminUpdateSettingRequest(); // AdminUpdateSettingRequest | 

try {
    final result = api_instance.adminUpdateSetting(key, adminUpdateSettingRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateSetting: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **adminUpdateSettingRequest** | [**AdminUpdateSettingRequest**](AdminUpdateSettingRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

