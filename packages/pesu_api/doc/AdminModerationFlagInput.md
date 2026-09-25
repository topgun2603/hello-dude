# pesu_api.model.AdminModerationFlagInput

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**createdAt** | **Object** |  | 
**score** | **num** | Model confidence 0–1 that the frame shows nudity | 
**status** | **String** |  | 
**note** | **String** |  | 
**reviewedAt** | **Object** |  | 
**reviewer** | **String** |  | 
**hasFrame** | **bool** | false once deleted under the retention policy | 
**call** | [**AdminModerationFlagInputCall**](AdminModerationFlagInputCall.md) |  | 
**liveId** | **String** |  | 
**groupId** | **String** |  | 
**subject** | [**AdminModerationFlagInputSubject**](AdminModerationFlagInputSubject.md) |  | 
**detectedBy** | [**AdminModerationFlagInputDetectedBy**](AdminModerationFlagInputDetectedBy.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


