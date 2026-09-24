# pesu_api.model.AnalyticsTotalsInput

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**connectedCalls** | **int** |  | 
**missedCalls** | **int** | Rang but never connected (missed, declined, failed) | 
**minutes** | **int** | Billed minutes | 
**avgCallSeconds** | **int** |  | 
**coinsSpent** | **int** | Calls + gifts, minus refunds | 
**coinsOnCalls** | **int** |  | 
**coinsOnGifts** | **int** |  | 
**coinsOnLives** | **int** |  | 
**coinsOnGroups** | **int** |  | 
**coinsRefunded** | **int** |  | 
**salesPaise** | **int** | Coin packs sold (gross, incl. GST) | 
**purchases** | **int** |  | 
**companionEarningsPaise** | **int** | Calls + gifts + bonuses, after reversals | 
**newCallers** | **int** |  | 
**newCompanions** | **int** |  | 
**activeCallers** | **int** | Callers with at least one connected call | 
**payingCallers** | **int** |  | 
**avgRating** | **num** |  | 
**ratings** | **int** |  | 
**companionOnlineMinutes** | **int** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


