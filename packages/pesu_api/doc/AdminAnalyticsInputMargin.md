# pesu_api.model.AdminAnalyticsInputMargin

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**gstPct** | **num** |  | 
**storeFeePct** | **num** |  | 
**netRevenuePaise** | **int** | Sales ÷ (1 + GST) × (1 − store fee) | 
**companionCostPaise** | **int** |  | 
**infraPaise** | **int** | Estimated LiveKit cost: (live viewer-minutes + 2 × group member-minutes + 2 × call minutes) × setting | 
**marginPaise** | **int** |  | 
**marginPct** | **num** |  | 
**targetPct** | **num** | Setting analytics.target_margin_pct | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


