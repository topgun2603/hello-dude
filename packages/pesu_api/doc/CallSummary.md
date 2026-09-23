# pesu_api.model.CallSummary

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**type** | **String** |  | 
**status** | **String** |  | 
**direction** | **String** | outgoing = I was the caller | 
**other** | [**Party**](Party.md) |  | 
**language** | **String** |  | 
**coinsPerMin** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**startedAt** | [**DateTime**](DateTime.md) |  | 
**endedAt** | [**DateTime**](DateTime.md) |  | 
**endReason** | **String** |  | 
**durationSeconds** | **int** |  | 
**minutesCharged** | **int** |  | 
**coinsCharged** | **int** |  | 
**coinsRefunded** | **int** |  | 
**paiseEarned** | **int** | Companion side: earnings after any reversal | 
**myRating** | **int** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


