# pesu_api.model.KycStateInput

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  | 
**rejectReason** | **String** |  | 
**redo** | **List<String>** | After a rejection: what to send again. Once all are sent, it goes back to review by itself. | [default to const []]
**age** | [**KycStateInputAge**](KycStateInputAge.md) |  | 
**selfie** | [**KycStateInputSelfie**](KycStateInputSelfie.md) |  | 
**voice** | [**KycStateInputVoice**](KycStateInputVoice.md) |  | 
**pan** | [**KycStateInputPan**](KycStateInputPan.md) |  | 
**upi** | [**KycStateInputUpi**](KycStateInputUpi.md) |  | 
**videoEnabled** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


