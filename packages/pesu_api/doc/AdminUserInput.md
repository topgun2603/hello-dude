# pesu_api.model.AdminUserInput

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
**role** | **String** |  | 
**status** | **String** |  | 
**primaryLanguage** | **String** |  | 
**createdAt** | **Object** |  | 
**coins** | **int** |  | 
**earningsPaise** | **int** |  | 
**calls** | **int** |  | 
**reportsAgainst** | **int** |  | 
**kycStatus** | **String** |  | 
**online** | **bool** | Has the app open right now (or is taking calls) | 
**takingCalls** | **bool** | Companion switched Online and taking calls | 
**lastSeenAt** | **Object** | Latest of: app open, last online (companions), last sign-in, last call | 
**avatarId** | **int** | 1 female, 2 male, 3 transgender illustrations; other ids are letter circles | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


