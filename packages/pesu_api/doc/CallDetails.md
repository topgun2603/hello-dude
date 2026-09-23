# pesu_api.model.CallDetails

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
**gifts** | [**List<CallDetailsGiftsInner>**](CallDetailsGiftsInner.md) |  | [default to const []]
**refundRequest** | [**RefundRequest**](RefundRequest.md) |  | 
**minutes** | [**List<CallDetailsMinutesInner>**](CallDetailsMinutesInner.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


