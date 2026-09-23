# pesu_api.model.CallDetailsInput

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
**other** | [**PartyInput**](PartyInput.md) |  | 
**language** | **String** |  | 
**coinsPerMin** | **int** |  | 
**createdAt** | **Object** |  | 
**startedAt** | **Object** |  | 
**endedAt** | **Object** |  | 
**endReason** | **String** |  | 
**durationSeconds** | **int** |  | 
**minutesCharged** | **int** |  | 
**coinsCharged** | **int** |  | 
**coinsRefunded** | **int** |  | 
**paiseEarned** | **int** | Companion side: earnings after any reversal | 
**myRating** | **int** |  | 
**gifts** | [**List<CallDetailsInputGiftsInner>**](CallDetailsInputGiftsInner.md) |  | [default to const []]
**refundRequest** | [**RefundRequestInput**](RefundRequestInput.md) |  | 
**minutes** | [**List<CallDetailsInputMinutesInner>**](CallDetailsInputMinutesInner.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


