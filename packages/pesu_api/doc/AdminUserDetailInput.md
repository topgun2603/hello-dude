# pesu_api.model.AdminUserDetailInput

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
**createdAt** | **Object** |  | 
**termsAcceptedAt** | **Object** |  | 
**online** | **bool** | Has the app open right now (or is taking calls) | 
**takingCalls** | **bool** | Companion switched Online and taking calls | 
**lastActiveAt** | **Object** | Last time the app was open | 
**lastSignInAt** | **Object** |  | 
**activeSessions** | **int** |  | 
**devices** | **int** |  | 
**coins** | **int** |  | 
**earningsPaise** | **int** |  | 
**stats** | [**AdminUserDetailInputStats**](AdminUserDetailInputStats.md) |  | 
**companion** | [**AdminUserDetailInputCompanion**](AdminUserDetailInputCompanion.md) |  | 
**calls** | [**List<AdminUserDetailInputCallsInner>**](AdminUserDetailInputCallsInner.md) |  | [default to const []]
**ledger** | [**List<AdminUserDetailInputLedgerInner>**](AdminUserDetailInputLedgerInner.md) |  | [default to const []]
**purchases** | [**List<AdminUserDetailInputPurchasesInner>**](AdminUserDetailInputPurchasesInner.md) |  | [default to const []]
**payouts** | [**List<AdminUserDetailInputPayoutsInner>**](AdminUserDetailInputPayoutsInner.md) |  | [default to const []]
**reports** | [**List<AdminUserDetailInputReportsInner>**](AdminUserDetailInputReportsInner.md) |  | [default to const []]
**refunds** | [**List<AdminUserDetailInputRefundsInner>**](AdminUserDetailInputRefundsInner.md) |  | [default to const []]
**audit** | [**List<AdminUserDetailInputAuditInner>**](AdminUserDetailInputAuditInner.md) |  | [default to const []]
**notes** | [**List<AdminNoteInput>**](AdminNoteInput.md) |  | [default to const []]
**vip** | [**AdminUserDetailInputVip**](AdminUserDetailInputVip.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


