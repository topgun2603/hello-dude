# pesu_api.model.AdminKycCase

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**userId** | **String** |  | 
**displayName** | **String** |  | 
**phone** | **String** |  | 
**gender** | **String** |  | 
**primaryLanguage** | **String** |  | 
**status** | **String** |  | 
**submittedAt** | [**DateTime**](DateTime.md) |  | 
**aadhaar** | [**AdminKycCaseAadhaar**](AdminKycCaseAadhaar.md) |  | 
**declared** | [**AdminKycCaseDeclared**](AdminKycCaseDeclared.md) |  | 
**selfieBlinks** | **int** |  | 
**panLast4** | **String** |  | 
**upi** | **String** |  | 
**rejectReason** | **String** |  | 
**videoEnabled** | **bool** |  | 
**academy** | [**GetCompanionRewards200ResponseAcademy**](GetCompanionRewards200ResponseAcademy.md) |  | 
**documents** | **List<String>** |  | [default to const []]
**redo** | **List<String>** | Items the last rejection asked them to send again | [default to const []]
**voice** | [**AdminKycCaseVoice**](AdminKycCaseVoice.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


