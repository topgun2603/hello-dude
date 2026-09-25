# pesu_api.model.OnlineCompanionInput

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
**photoUrl** | **String** | Approved profile photo (signed URL path); null = show the avatar | 
**primaryLanguage** | **String** |  | 
**languages** | **List<String>** |  | [default to const []]
**rating** | **num** | Average stars, null until rated | 
**ratingCount** | **int** |  | 
**audioEnabled** | **bool** | Takes voice calls right now | 
**videoEnabled** | **bool** | Takes video calls right now (unlocked and switched on) | 
**busy** | **bool** |  | 
**isFavourite** | **bool** |  | 
**rates** | [**CompanionRatesInput**](CompanionRatesInput.md) |  | 
**badge** | [**UserBadgeInput**](UserBadgeInput.md) | Best active badge, e.g. '#1 companion this week' | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


