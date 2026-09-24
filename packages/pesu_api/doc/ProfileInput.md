# pesu_api.model.ProfileInput

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
**companion** | [**ProfileInputCompanion**](ProfileInputCompanion.md) |  | 
**vipUntil** | **Object** | VIP active until this time; null if not VIP | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


