# pesu_api.model.AdminUserDetail

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**displayName** | **String** |  | 
**phone** | **String** | Masked | 
**gender** | **String** |  | 
**role** | **String** |  | 
**status** | **String** |  | 
**primaryLanguage** | **String** |  | 
**languages** | **List<String>** |  | [default to const []]
**avatarId** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**termsAcceptedAt** | [**DateTime**](DateTime.md) |  | 
**online** | **bool** | Has the app open right now (or is taking calls) | 
**takingCalls** | **bool** | Companion switched Online and taking calls | 
**lastActiveAt** | [**DateTime**](DateTime.md) | Last time the app was open | 
**lastSignInAt** | [**DateTime**](DateTime.md) |  | 
**activeSessions** | **int** |  | 
**devices** | **int** |  | 
**coins** | **int** |  | 
**earningsPaise** | **int** |  | 
**stats** | [**AdminUserDetailStats**](AdminUserDetailStats.md) |  | 
**companion** | [**AdminUserDetailCompanion**](AdminUserDetailCompanion.md) |  | 
**calls** | [**List<AdminUserDetailCallsInner>**](AdminUserDetailCallsInner.md) |  | [default to const []]
**ledger** | [**List<AdminUserDetailLedgerInner>**](AdminUserDetailLedgerInner.md) |  | [default to const []]
**purchases** | [**List<AdminUserDetailPurchasesInner>**](AdminUserDetailPurchasesInner.md) |  | [default to const []]
**payouts** | [**List<AdminUserDetailPayoutsInner>**](AdminUserDetailPayoutsInner.md) |  | [default to const []]
**reports** | [**List<AdminUserDetailReportsInner>**](AdminUserDetailReportsInner.md) |  | [default to const []]
**refunds** | [**List<AdminUserDetailRefundsInner>**](AdminUserDetailRefundsInner.md) |  | [default to const []]
**audit** | [**List<AdminUserDetailAuditInner>**](AdminUserDetailAuditInner.md) |  | [default to const []]
**notes** | [**List<AdminNote>**](AdminNote.md) |  | [default to const []]
**vip** | [**AdminUserDetailVip**](AdminUserDetailVip.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


