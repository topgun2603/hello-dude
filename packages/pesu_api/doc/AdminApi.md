# pesu_api.api.AdminApi

## Load the API package
```dart
import 'package:pesu_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAddStaff**](AdminApi.md#adminaddstaff) | **POST** /v1/admin/staff | Add a staff member: they sign in to the panel with this phone number (OTP)
[**adminAddUserNote**](AdminApi.md#adminaddusernote) | **POST** /v1/admin/users/{id}/notes | Add a private admin note to a caller or companion
[**adminAnalytics**](AdminApi.md#adminanalytics) | **GET** /v1/admin/analytics | Analytics for a date range (India time, both days included), with the previous period for comparison
[**adminApprovePayout**](AdminApi.md#adminapprovepayout) | **POST** /v1/admin/payouts/{id}/approve | Approve and send to UPI. Failures are credited back to the companion automatically.
[**adminAuditLog**](AdminApi.md#adminauditlog) | **GET** /v1/admin/audit | Latest admin actions
[**adminCreateBonusCampaign**](AdminApi.md#admincreatebonuscampaign) | **POST** /v1/admin/bonus-campaigns | Create a bonus campaign
[**adminCreateGift**](AdminApi.md#admincreategift) | **POST** /v1/admin/gifts | Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).
[**adminCreatePackage**](AdminApi.md#admincreatepackage) | **POST** /v1/admin/coin-packages | Add a coin pack. Create the Google Play product with the same SKU first.
[**adminCreatePromotion**](AdminApi.md#admincreatepromotion) | **POST** /v1/admin/promotions | 
[**adminCreateRate**](AdminApi.md#admincreaterate) | **POST** /v1/admin/rates | Add a rate version. Calls already running keep their old rate.
[**adminCreateRole**](AdminApi.md#admincreaterole) | **POST** /v1/admin/roles | Add a custom role
[**adminDashboard**](AdminApi.md#admindashboard) | **GET** /v1/admin/dashboard | Live numbers and today's totals (India time)
[**adminDecidePhoto**](AdminApi.md#admindecidephoto) | **POST** /v1/admin/photos/{userId}/decision | Approve (it replaces their avatar everywhere) or reject with a reason they'll see
[**adminDecideRefund**](AdminApi.md#admindeciderefund) | **POST** /v1/admin/refunds/{id}/decide | Approve (all or part of the coins) or reject a refund request
[**adminDeletePromotion**](AdminApi.md#admindeletepromotion) | **DELETE** /v1/admin/promotions/{id} | Delete a promotion and its view stats
[**adminDeleteRole**](AdminApi.md#admindeleterole) | **DELETE** /v1/admin/roles/{code} | Delete a custom role nobody has
[**adminEndGroup**](AdminApi.md#adminendgroup) | **POST** /v1/admin/groups/{id}/end | End or cancel a group now (moderation)
[**adminEndLive**](AdminApi.md#adminendlive) | **POST** /v1/admin/lives/{id}/end | End a live now (moderation)
[**adminEndRoom**](AdminApi.md#adminendroom) | **POST** /v1/admin/rooms/{id}/end | End a room now (moderation)
[**adminGetModerationFrame**](AdminApi.md#admingetmoderationframe) | **GET** /v1/admin/moderation/{id}/frame | The flagged frame (decrypted). Every view is audit-logged.
[**adminGetUser**](AdminApi.md#admingetuser) | **GET** /v1/admin/users/{id} | Everything about one caller or companion: profile, wallets, calls, money and safety history
[**adminGrantVip**](AdminApi.md#admingrantvip) | **POST** /v1/admin/users/{id}/vip | Give a caller VIP for some days (extends an active VIP). Audited; the caller is notified.
[**adminKycDecision**](AdminApi.md#adminkycdecision) | **POST** /v1/admin/kyc/{userId}/decision | Approve (companion can go online) or reject with a reason the companion will see
[**adminKycFile**](AdminApi.md#adminkycfile) | **GET** /v1/admin/kyc/{userId}/files/{doc} | Decrypted KYC image for side-by-side review. Every view is audit-logged.
[**adminKycQueue**](AdminApi.md#adminkycqueue) | **GET** /v1/admin/kyc | KYC review queue (oldest first) or decided cases
[**adminListBonusCampaigns**](AdminApi.md#adminlistbonuscampaigns) | **GET** /v1/admin/bonus-campaigns | Time-window bonus campaigns for companions
[**adminListCompanionLevels**](AdminApi.md#adminlistcompanionlevels) | **GET** /v1/admin/companion-levels | Companion levels
[**adminListGifts**](AdminApi.md#adminlistgifts) | **GET** /v1/admin/gifts | 
[**adminListGroups**](AdminApi.md#adminlistgroups) | **GET** /v1/admin/groups | Open groups, then the last 50 that ended
[**adminListLives**](AdminApi.md#adminlistlives) | **GET** /v1/admin/lives | Lives now, then the last 50 that ended
[**adminListModerationFlags**](AdminApi.md#adminlistmoderationflags) | **GET** /v1/admin/moderation | Video frames flagged for nudity by the app, oldest open first
[**adminListPackages**](AdminApi.md#adminlistpackages) | **GET** /v1/admin/coin-packages | 
[**adminListPayouts**](AdminApi.md#adminlistpayouts) | **GET** /v1/admin/payouts | 
[**adminListPhotos**](AdminApi.md#adminlistphotos) | **GET** /v1/admin/photos | Companion photos waiting for review, oldest first
[**adminListPromotions**](AdminApi.md#adminlistpromotions) | **GET** /v1/admin/promotions | Offers popup: every promotion with its reach and taps
[**adminListRates**](AdminApi.md#adminlistrates) | **GET** /v1/admin/rates | All call rates: current, scheduled and past
[**adminListRefunds**](AdminApi.md#adminlistrefunds) | **GET** /v1/admin/refunds | 
[**adminListReports**](AdminApi.md#adminlistreports) | **GET** /v1/admin/reports | 
[**adminListRoles**](AdminApi.md#adminlistroles) | **GET** /v1/admin/roles | Roles and the permission catalogue (for the permission grid)
[**adminListRooms**](AdminApi.md#adminlistrooms) | **GET** /v1/admin/rooms | Live voice rooms
[**adminListSettings**](AdminApi.md#adminlistsettings) | **GET** /v1/admin/settings | 
[**adminListStaff**](AdminApi.md#adminliststaff) | **GET** /v1/admin/staff | Everyone who can sign in to the admin panel
[**adminListUsers**](AdminApi.md#adminlistusers) | **GET** /v1/admin/users | Search callers or companions by name or the last digits of their number
[**adminListVipPlans**](AdminApi.md#adminlistvipplans) | **GET** /v1/admin/vip-plans | VIP plans (prices must match the Play Console products)
[**adminMe**](AdminApi.md#adminme) | **GET** /v1/admin/me | The signed-in staff member, their role and permissions (the panel hides what they can't do)
[**adminRejectPayout**](AdminApi.md#adminrejectpayout) | **POST** /v1/admin/payouts/{id}/reject | Reject a withdrawal; the amount goes back to the companion's balance
[**adminResolveModerationFlag**](AdminApi.md#adminresolvemoderationflag) | **POST** /v1/admin/moderation/{id}/resolve | Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video
[**adminResolveReport**](AdminApi.md#adminresolvereport) | **POST** /v1/admin/reports/{id}/resolve | Dismiss a report, or act on it by suspending the reported user
[**adminRevokeVip**](AdminApi.md#adminrevokevip) | **POST** /v1/admin/users/{id}/vip/revoke | End someone's VIP now (e.g. a mistaken grant). Play subscriptions must also be refunded in Play Console.
[**adminSendCoins**](AdminApi.md#adminsendcoins) | **POST** /v1/admin/users/{id}/coins | Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log
[**adminSendMessage**](AdminApi.md#adminsendmessage) | **POST** /v1/admin/users/{id}/message | Send a push notification to one caller or companion
[**adminSetPromotionActive**](AdminApi.md#adminsetpromotionactive) | **POST** /v1/admin/promotions/{id}/active | Switch a promotion on or off
[**adminSetUserStatus**](AdminApi.md#adminsetuserstatus) | **POST** /v1/admin/users/{id}/status | Suspend, ban or reactivate an account
[**adminSetVideo**](AdminApi.md#adminsetvideo) | **POST** /v1/admin/companions/{userId}/video | Unlock or lock video calls for a companion (after academy + clean record)
[**adminUpdateBonusCampaign**](AdminApi.md#adminupdatebonuscampaign) | **PUT** /v1/admin/bonus-campaigns/{id} | Edit or switch off a bonus campaign
[**adminUpdateCompanionLevel**](AdminApi.md#adminupdatecompanionlevel) | **PUT** /v1/admin/companion-levels/{level} | Change a level's name, thresholds or earnings boost (applies to calls that start after this)
[**adminUpdateGift**](AdminApi.md#adminupdategift) | **PUT** /v1/admin/gifts/{id} | 
[**adminUpdatePackage**](AdminApi.md#adminupdatepackage) | **PUT** /v1/admin/coin-packages/{id} | Edit a coin pack. The Google Play product price must be changed to match in Play Console.
[**adminUpdatePromotion**](AdminApi.md#adminupdatepromotion) | **PUT** /v1/admin/promotions/{id} | 
[**adminUpdateRole**](AdminApi.md#adminupdaterole) | **PUT** /v1/admin/roles/{code} | Edit a role's name, description and permissions (not the built-in Admin)
[**adminUpdateSetting**](AdminApi.md#adminupdatesetting) | **PUT** /v1/admin/settings/{key} | 
[**adminUpdateStaff**](AdminApi.md#adminupdatestaff) | **PUT** /v1/admin/staff/{id} | Change a staff member's role, or switch their access off/on
[**adminUpdateVipPlan**](AdminApi.md#adminupdatevipplan) | **PUT** /v1/admin/vip-plans/{id} | Change a VIP plan's price, badge or visibility


# **adminAddStaff**
> AdminStaff adminAddStaff(adminAddStaffRequest)

Add a staff member: they sign in to the panel with this phone number (OTP)

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
final adminAddStaffRequest = AdminAddStaffRequest(); // AdminAddStaffRequest | 

try {
    final result = api_instance.adminAddStaff(adminAddStaffRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminAddStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminAddStaffRequest** | [**AdminAddStaffRequest**](AdminAddStaffRequest.md)|  | 

### Return type

[**AdminStaff**](AdminStaff.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **adminAnalytics**
> AdminAnalytics adminAnalytics(from, to, minRatings)

Analytics for a date range (India time, both days included), with the previous period for comparison

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
final from = from_example; // String | Default: 29 days before `to`
final to = to_example; // String | Default: today
final minRatings = 56; // int | Ratings needed to appear in Top rated

try {
    final result = api_instance.adminAnalytics(from, to, minRatings);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **String**| Default: 29 days before `to` | [optional] 
 **to** | **String**| Default: today | [optional] 
 **minRatings** | **int**| Ratings needed to appear in Top rated | [optional] [default to 3]

### Return type

[**AdminAnalytics**](AdminAnalytics.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **adminCreateBonusCampaign**
> BonusCampaign adminCreateBonusCampaign(adminCreateBonusCampaignRequest)

Create a bonus campaign

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
final adminCreateBonusCampaignRequest = AdminCreateBonusCampaignRequest(); // AdminCreateBonusCampaignRequest | 

try {
    final result = api_instance.adminCreateBonusCampaign(adminCreateBonusCampaignRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreateBonusCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreateBonusCampaignRequest** | [**AdminCreateBonusCampaignRequest**](AdminCreateBonusCampaignRequest.md)|  | 

### Return type

[**BonusCampaign**](BonusCampaign.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **adminCreatePromotion**
> AdminPromotion adminCreatePromotion(adminCreatePromotionRequest)



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
final adminCreatePromotionRequest = AdminCreatePromotionRequest(); // AdminCreatePromotionRequest | 

try {
    final result = api_instance.adminCreatePromotion(adminCreatePromotionRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreatePromotion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreatePromotionRequest** | [**AdminCreatePromotionRequest**](AdminCreatePromotionRequest.md)|  | 

### Return type

[**AdminPromotion**](AdminPromotion.md)

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

# **adminCreateRole**
> AdminRole adminCreateRole(adminCreateRoleRequest)

Add a custom role

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
final adminCreateRoleRequest = AdminCreateRoleRequest(); // AdminCreateRoleRequest | 

try {
    final result = api_instance.adminCreateRole(adminCreateRoleRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminCreateRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminCreateRoleRequest** | [**AdminCreateRoleRequest**](AdminCreateRoleRequest.md)|  | 

### Return type

[**AdminRole**](AdminRole.md)

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

# **adminDecidePhoto**
> String adminDecidePhoto(userId, adminDecidePhotoRequest)

Approve (it replaces their avatar everywhere) or reject with a reason they'll see

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
final adminDecidePhotoRequest = AdminDecidePhotoRequest(); // AdminDecidePhotoRequest | 

try {
    final result = api_instance.adminDecidePhoto(userId, adminDecidePhotoRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminDecidePhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **adminDecidePhotoRequest** | [**AdminDecidePhotoRequest**](AdminDecidePhotoRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **adminDeletePromotion**
> String adminDeletePromotion(id)

Delete a promotion and its view stats

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

try {
    final result = api_instance.adminDeletePromotion(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminDeletePromotion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDeleteRole**
> String adminDeleteRole(code)

Delete a custom role nobody has

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
final code = code_example; // String | 

try {
    final result = api_instance.adminDeleteRole(code);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminDeleteRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminEndGroup**
> String adminEndGroup(id, adminRevokeVipRequest)

End or cancel a group now (moderation)

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
final adminRevokeVipRequest = AdminRevokeVipRequest(); // AdminRevokeVipRequest | 

try {
    final result = api_instance.adminEndGroup(id, adminRevokeVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminEndGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRevokeVipRequest** | [**AdminRevokeVipRequest**](AdminRevokeVipRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminEndLive**
> String adminEndLive(id, adminRevokeVipRequest)

End a live now (moderation)

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
final adminRevokeVipRequest = AdminRevokeVipRequest(); // AdminRevokeVipRequest | 

try {
    final result = api_instance.adminEndLive(id, adminRevokeVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminEndLive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRevokeVipRequest** | [**AdminRevokeVipRequest**](AdminRevokeVipRequest.md)|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminEndRoom**
> String adminEndRoom(id, adminRevokeVipRequest)

End a room now (moderation)

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
final adminRevokeVipRequest = AdminRevokeVipRequest(); // AdminRevokeVipRequest | 

try {
    final result = api_instance.adminEndRoom(id, adminRevokeVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminEndRoom: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRevokeVipRequest** | [**AdminRevokeVipRequest**](AdminRevokeVipRequest.md)|  | 

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

# **adminGrantVip**
> AdminGrantVip200Response adminGrantVip(id, adminGrantVipRequest)

Give a caller VIP for some days (extends an active VIP). Audited; the caller is notified.

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
final adminGrantVipRequest = AdminGrantVipRequest(); // AdminGrantVipRequest | 

try {
    final result = api_instance.adminGrantVip(id, adminGrantVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminGrantVip: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminGrantVipRequest** | [**AdminGrantVipRequest**](AdminGrantVipRequest.md)|  | 

### Return type

[**AdminGrantVip200Response**](AdminGrantVip200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **adminListBonusCampaigns**
> List<BonusCampaign> adminListBonusCampaigns()

Time-window bonus campaigns for companions

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
    final result = api_instance.adminListBonusCampaigns();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListBonusCampaigns: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<BonusCampaign>**](BonusCampaign.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListCompanionLevels**
> List<CompanionLevel> adminListCompanionLevels()

Companion levels

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
    final result = api_instance.adminListCompanionLevels();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListCompanionLevels: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<CompanionLevel>**](CompanionLevel.md)

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

# **adminListGroups**
> List<AdminGroup> adminListGroups()

Open groups, then the last 50 that ended

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
    final result = api_instance.adminListGroups();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListGroups: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminGroup>**](AdminGroup.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListLives**
> List<AdminLive> adminListLives()

Lives now, then the last 50 that ended

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
    final result = api_instance.adminListLives();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListLives: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminLive>**](AdminLive.md)

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

# **adminListPhotos**
> List<PendingPhoto> adminListPhotos()

Companion photos waiting for review, oldest first

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
    final result = api_instance.adminListPhotos();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListPhotos: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PendingPhoto>**](PendingPhoto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListPromotions**
> List<AdminPromotion> adminListPromotions()

Offers popup: every promotion with its reach and taps

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
    final result = api_instance.adminListPromotions();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListPromotions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminPromotion>**](AdminPromotion.md)

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

# **adminListRoles**
> AdminListRoles200Response adminListRoles()

Roles and the permission catalogue (for the permission grid)

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
    final result = api_instance.adminListRoles();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListRoles: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminListRoles200Response**](AdminListRoles200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListRooms**
> List<RoomCard> adminListRooms()

Live voice rooms

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
    final result = api_instance.adminListRooms();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListRooms: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<RoomCard>**](RoomCard.md)

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

# **adminListStaff**
> List<AdminStaff> adminListStaff()

Everyone who can sign in to the admin panel

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
    final result = api_instance.adminListStaff();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListStaff: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminStaff>**](AdminStaff.md)

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

# **adminListVipPlans**
> List<VipPlan> adminListVipPlans()

VIP plans (prices must match the Play Console products)

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
    final result = api_instance.adminListVipPlans();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminListVipPlans: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<VipPlan>**](VipPlan.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminMe**
> AdminMe adminMe()

The signed-in staff member, their role and permissions (the panel hides what they can't do)

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
    final result = api_instance.adminMe();
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminMe**](AdminMe.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRejectPayout**
> String adminRejectPayout(id, adminRevokeVipRequest)

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
final adminRevokeVipRequest = AdminRevokeVipRequest(); // AdminRevokeVipRequest | 

try {
    final result = api_instance.adminRejectPayout(id, adminRevokeVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminRejectPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRevokeVipRequest** | [**AdminRevokeVipRequest**](AdminRevokeVipRequest.md)|  | 

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

# **adminRevokeVip**
> String adminRevokeVip(id, adminRevokeVipRequest)

End someone's VIP now (e.g. a mistaken grant). Play subscriptions must also be refunded in Play Console.

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
final adminRevokeVipRequest = AdminRevokeVipRequest(); // AdminRevokeVipRequest | 

try {
    final result = api_instance.adminRevokeVip(id, adminRevokeVipRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminRevokeVip: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminRevokeVipRequest** | [**AdminRevokeVipRequest**](AdminRevokeVipRequest.md)|  | 

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

# **adminSetPromotionActive**
> AdminPromotion adminSetPromotionActive(id, adminSetPromotionActiveRequest)

Switch a promotion on or off

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
final adminSetPromotionActiveRequest = AdminSetPromotionActiveRequest(); // AdminSetPromotionActiveRequest | 

try {
    final result = api_instance.adminSetPromotionActive(id, adminSetPromotionActiveRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminSetPromotionActive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminSetPromotionActiveRequest** | [**AdminSetPromotionActiveRequest**](AdminSetPromotionActiveRequest.md)|  | 

### Return type

[**AdminPromotion**](AdminPromotion.md)

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

# **adminUpdateBonusCampaign**
> BonusCampaign adminUpdateBonusCampaign(id, adminCreateBonusCampaignRequest)

Edit or switch off a bonus campaign

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
final adminCreateBonusCampaignRequest = AdminCreateBonusCampaignRequest(); // AdminCreateBonusCampaignRequest | 

try {
    final result = api_instance.adminUpdateBonusCampaign(id, adminCreateBonusCampaignRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateBonusCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminCreateBonusCampaignRequest** | [**AdminCreateBonusCampaignRequest**](AdminCreateBonusCampaignRequest.md)|  | 

### Return type

[**BonusCampaign**](BonusCampaign.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateCompanionLevel**
> CompanionLevel adminUpdateCompanionLevel(level, adminUpdateCompanionLevelRequest)

Change a level's name, thresholds or earnings boost (applies to calls that start after this)

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
final level = 56; // int | 
final adminUpdateCompanionLevelRequest = AdminUpdateCompanionLevelRequest(); // AdminUpdateCompanionLevelRequest | 

try {
    final result = api_instance.adminUpdateCompanionLevel(level, adminUpdateCompanionLevelRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateCompanionLevel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **level** | **int**|  | 
 **adminUpdateCompanionLevelRequest** | [**AdminUpdateCompanionLevelRequest**](AdminUpdateCompanionLevelRequest.md)|  | 

### Return type

[**CompanionLevel**](CompanionLevel.md)

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

# **adminUpdatePromotion**
> AdminPromotion adminUpdatePromotion(id, adminCreatePromotionRequest)



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
final adminCreatePromotionRequest = AdminCreatePromotionRequest(); // AdminCreatePromotionRequest | 

try {
    final result = api_instance.adminUpdatePromotion(id, adminCreatePromotionRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdatePromotion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminCreatePromotionRequest** | [**AdminCreatePromotionRequest**](AdminCreatePromotionRequest.md)|  | 

### Return type

[**AdminPromotion**](AdminPromotion.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateRole**
> AdminRole adminUpdateRole(code, adminCreateRoleRequest)

Edit a role's name, description and permissions (not the built-in Admin)

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
final code = code_example; // String | 
final adminCreateRoleRequest = AdminCreateRoleRequest(); // AdminCreateRoleRequest | 

try {
    final result = api_instance.adminUpdateRole(code, adminCreateRoleRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  | 
 **adminCreateRoleRequest** | [**AdminCreateRoleRequest**](AdminCreateRoleRequest.md)|  | 

### Return type

[**AdminRole**](AdminRole.md)

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

# **adminUpdateStaff**
> AdminStaff adminUpdateStaff(id, adminUpdateStaffRequest)

Change a staff member's role, or switch their access off/on

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
final adminUpdateStaffRequest = AdminUpdateStaffRequest(); // AdminUpdateStaffRequest | 

try {
    final result = api_instance.adminUpdateStaff(id, adminUpdateStaffRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminUpdateStaffRequest** | [**AdminUpdateStaffRequest**](AdminUpdateStaffRequest.md)|  | 

### Return type

[**AdminStaff**](AdminStaff.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateVipPlan**
> VipPlan adminUpdateVipPlan(id, adminUpdateVipPlanRequest)

Change a VIP plan's price, badge or visibility

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
final adminUpdateVipPlanRequest = AdminUpdateVipPlanRequest(); // AdminUpdateVipPlanRequest | 

try {
    final result = api_instance.adminUpdateVipPlan(id, adminUpdateVipPlanRequest);
    print(result);
} catch (e) {
    print('Exception when calling AdminApi->adminUpdateVipPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminUpdateVipPlanRequest** | [**AdminUpdateVipPlanRequest**](AdminUpdateVipPlanRequest.md)|  | 

### Return type

[**VipPlan**](VipPlan.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

