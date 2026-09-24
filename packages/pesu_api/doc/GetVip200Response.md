# pesu_api.model.GetVip200Response

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**active** | **bool** |  | 
**expiresAt** | [**DateTime**](DateTime.md) |  | 
**source_** | **String** |  | 
**discountPct** | **int** |  | 
**weeklyGift** | [**GetVip200ResponseWeeklyGift**](GetVip200ResponseWeeklyGift.md) |  | 
**plans** | [**List<VipPlan>**](VipPlan.md) |  | [default to const []]
**purchasable** | **bool** | false until Google Play Billing is set up | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


