# pesu_api.model.AdminCreatePromotionRequest

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | 
**body** | **String** |  | [optional] [default to '']
**highlight** | **String** |  | [optional] 
**badge** | **String** |  | [optional] 
**emoji** | **String** |  | [optional] 
**ctaLabel** | **String** |  | 
**ctaAction** | **String** | Where the button goes inside the app | 
**theme** | **String** |  | 
**audience** | **String** | never_paid / paid = callers with no / at least one credited coin purchase | 
**frequency** | **String** | every_open = each time the app opens; daily = once per IST day; once = only ever once | 
**confetti** | **bool** |  | 
**priority** | **int** |  | 
**isActive** | **bool** |  | 
**startsAt** | **Object** |  | 
**endsAt** | **Object** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


