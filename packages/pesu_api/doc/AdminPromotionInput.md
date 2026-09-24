# pesu_api.model.AdminPromotionInput

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**title** | **String** |  | 
**body** | **String** |  | 
**highlight** | **String** |  | 
**badge** | **String** |  | 
**emoji** | **String** |  | 
**ctaLabel** | **String** |  | 
**ctaAction** | **String** | Where the button goes inside the app | 
**theme** | **String** |  | 
**confetti** | **bool** |  | 
**endsAt** | **Object** | Show a countdown when set | 
**audience** | **String** | never_paid / paid = callers with no / at least one credited coin purchase | 
**frequency** | **String** | every_open = each time the app opens; daily = once per IST day; once = only ever once | 
**priority** | **int** |  | 
**isActive** | **bool** |  | 
**startsAt** | **Object** |  | 
**status** | **String** |  | 
**shown** | **int** |  | 
**clicked** | **int** |  | 
**shownToday** | **int** |  | 
**clickedToday** | **int** |  | 
**reach** | **int** | Different people who saw it | 
**createdAt** | **Object** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


