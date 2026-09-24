# pesu_api.model.Profile

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**displayName** | **String** |  | 
**avatarId** | **int** |  | 
**gender** | **String** |  | 
**role** | **String** |  | 
**primaryLanguage** | **String** |  | 
**languages** | **List<String>** |  | [default to const []]
**phone** | **String** | Masked, e.g. +91 ••••••3210 | 
**companion** | [**ProfileCompanion**](ProfileCompanion.md) |  | 
**vipUntil** | [**DateTime**](DateTime.md) | VIP active until this time; null if not VIP | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


