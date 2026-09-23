# pesu_api.model.LegalBlock

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | **String** |  | 
**spans** | [**List<LegalSpan>**](LegalSpan.md) | h1, h2, p | [optional] [default to const []]
**items** | [**List<LegalCell>**](LegalCell.md) | ul, ol | [optional] [default to const []]
**head** | [**List<LegalCell>**](LegalCell.md) | table header cells | [optional] [default to const []]
**rows** | [**List<LegalRow>**](LegalRow.md) | table rows | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


