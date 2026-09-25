# pesu_api.model.FlagVideoFrameRequest

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**frameBase64** | **String** | JPEG of the flagged frame, at most 400 KB | 
**score** | **num** | On-device model confidence | 
**own** | **bool** | true = the frame is from the sender's own camera (the app checks its own video) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


