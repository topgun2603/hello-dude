# pesu_api.model.AdminModerationFlag

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**score** | **num** | Model confidence 0–1 that the frame shows nudity | 
**status** | **String** |  | 
**note** | **String** |  | 
**reviewedAt** | [**DateTime**](DateTime.md) |  | 
**reviewer** | **String** |  | 
**hasFrame** | **bool** | false once deleted under the retention policy | 
**call** | [**AdminModerationFlagCall**](AdminModerationFlagCall.md) |  | 
**subject** | [**AdminModerationFlagSubject**](AdminModerationFlagSubject.md) |  | 
**detectedBy** | [**AdminDashboard200ResponseActivityInnerUser**](AdminDashboard200ResponseActivityInnerUser.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


