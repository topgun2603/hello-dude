# pesu_api.model.LiveCard

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**title** | **String** |  | 
**language** | **String** |  | 
**host** | [**LiveCardHost**](LiveCardHost.md) |  | 
**viewers** | **int** |  | 
**startedAt** | [**DateTime**](DateTime.md) |  | 
**snapshotUrl** | **String** | Recent still from the host's camera (signed path); null = use the host's photo/avatar | 
**pkBattleId** | **String** | An active PK battle this live is in (GET /pk/{id}) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


