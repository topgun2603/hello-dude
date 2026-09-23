# pesu_api.model.AdminDashboard200Response

## Load the model package
```dart
import 'package:pesu_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**live** | [**AdminDashboard200ResponseLive**](AdminDashboard200ResponseLive.md) |  | 
**today** | [**AdminDashboard200ResponseToday**](AdminDashboard200ResponseToday.md) |  | 
**yesterday** | [**AdminDashboard200ResponseYesterday**](AdminDashboard200ResponseYesterday.md) |  | 
**byHour** | [**List<AdminDashboard200ResponseByHourInner>**](AdminDashboard200ResponseByHourInner.md) |  | [default to const []]
**languages** | [**List<AdminDashboard200ResponseLanguagesInner>**](AdminDashboard200ResponseLanguagesInner.md) |  | [default to const []]
**openReports** | **int** |  | 
**openReportsByReason** | **Map<String, int>** |  | [default to const {}]
**pendingKyc** | **int** |  | 
**pendingPayouts** | [**AdminDashboard200ResponsePendingPayouts**](AdminDashboard200ResponsePendingPayouts.md) |  | 
**flaggedPayouts** | **int** | Requested payouts carrying at least one risk flag | 
**billingExceptions** | **int** |  | 
**openRefunds** | **int** | Refund requests waiting for a decision | 
**openModeration** | **int** | Video frames flagged for nudity, waiting for review | 
**activity** | [**List<AdminDashboard200ResponseActivityInner>**](AdminDashboard200ResponseActivityInner.md) | Latest 8 events, newest first | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


