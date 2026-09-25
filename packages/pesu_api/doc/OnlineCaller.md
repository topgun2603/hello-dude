# pesu_api.model.OnlineCaller

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
**language** | **String** |  | 
**canPay** | **bool** | Has coins for a few minutes of a voice call with you | 
**isVip** | **bool** |  | 
**isNew** | **bool** | Joined in the last 7 days | 
**inCall** | **bool** |  | 
**callsWithYou** | **int** |  | 
**lastCallAt** | [**DateTime**](DateTime.md) |  | 
**favouritedYou** | **bool** |  | 
**invitedRecently** | **bool** | You invited him in the last hour | 
**level** | **int** | Caller level (lifetime coins spent) | 
**levelName** | **String** |  | 
**badge** | [**UserBadge**](UserBadge.md) | Best active badge, e.g. '#2 fan this week' | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


