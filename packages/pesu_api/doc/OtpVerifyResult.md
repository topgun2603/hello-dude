# pesu_api.model.OtpVerifyResult

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  | 
**tokens** | [**TokenPair**](TokenPair.md) | Set when status = signed_in | [optional] 
**profile** | [**Profile**](Profile.md) | Set when status = signed_in | [optional] 
**signupToken** | **String** | Set when status = needs_signup | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


