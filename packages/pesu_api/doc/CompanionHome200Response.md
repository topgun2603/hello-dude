# pesu_api.model.CompanionHome200Response

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**kycStatus** | **String** |  | 
**videoEnabled** | **bool** | Video is unlocked (KYC + academy + clean record) | 
**takesAudio** | **bool** | The companion's own switch: takes voice calls | 
**takesVideo** | **bool** | The companion's own switch: takes video calls (only counts when unlocked) | 
**online** | **bool** |  | 
**today** | [**CompanionHome200ResponseToday**](CompanionHome200ResponseToday.md) |  | 
**recent** | [**List<CompanionHome200ResponseRecentInner>**](CompanionHome200ResponseRecentInner.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


