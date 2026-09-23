import 'dart:convert';
import 'dart:io';

import 'package:pesu_api/api.dart';

/// A sentence the user can read, from any error the API layer throws.
/// The server sends `{ error: { code, message } }`; its message is already friendly.
String friendlyError(Object error) {
  if (error is ApiException) {
    final inner = error.innerException;
    // The generated client wraps network failures as ApiException(400, ..., innerException).
    if (inner is SocketException ||
        inner is HttpException ||
        inner is IOException) {
      return "Can't reach the server. Check your connection and try again.";
    }
    final body = error.message;
    if (body != null) {
      try {
        final message = _errorField(jsonDecode(body), 'message');
        if (message != null && message.isNotEmpty) return message;
      } catch (_) {
        /* not JSON */
      }
    }
    if (error.code == 401) return 'Please sign in again.';
  }
  if (error is SocketException)
    return "Can't reach the server. Check your connection and try again.";
  return 'Something went wrong. Please try again.';
}

/// The server's machine-readable error code (e.g. OTP_INVALID), if any.
String? errorCode(Object error) {
  if (error is! ApiException || error.message == null) return null;
  try {
    return _errorField(jsonDecode(error.message!), 'code');
  } catch (_) {
    return null;
  }
}

String? _errorField(Object? body, String field) {
  if (body is! Map) return null;
  final error = body['error'];
  if (error is! Map) return null;
  final value = error[field];
  return value is String ? value : null;
}
