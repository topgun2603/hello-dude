import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app/config.dart';
import 'api.dart';
import 'session.dart';

/// Server push over /v1/ws: incoming_call, call_accepted, call_connected,
/// low_balance, call_ended. Reconnects on its own while signed in.
class Realtime {
  Realtime(this._api);
  final PesuApi _api;
  final _events = StreamController<Map<String, dynamic>>.broadcast();
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _retry;
  bool _running = false;

  Stream<Map<String, dynamic>> get events => _events.stream;

  /// Events for one call only.
  Stream<Map<String, dynamic>> forCall(String callId) =>
      events.where((e) => e['callId'] == callId);

  void start() {
    if (_running) return;
    _running = true;
    _connect();
  }

  void stop() {
    _running = false;
    _retry?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  Future<void> _connect() async {
    if (!_running) return;
    var token = _api.currentAccessToken;
    if (token == null || token.isEmpty)
      token = await _api.onUnauthorized?.call();
    if (token == null) return _scheduleRetry();

    final base = AppConfig.apiBaseUrl.replaceFirst(RegExp('^http'), 'ws');
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse('$base/v1/ws?token=${Uri.encodeQueryComponent(token)}'),
      );
      await channel.ready;
      _channel = channel;
      _sub = channel.stream.listen(
        (raw) {
          final msg = jsonDecode(raw as String);
          if (msg is Map<String, dynamic>) _events.add(msg);
        },
        onDone: () async {
          // 4401 = the access token expired while connected; refresh before reconnecting.
          if (channel.closeCode == 4401) await _api.onUnauthorized?.call();
          _scheduleRetry();
        },
        onError: (_) => _scheduleRetry(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    if (!_running) return;
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 2), _connect);
  }
}

final realtimeProvider = Provider<Realtime>((ref) {
  final rt = Realtime(ref.read(apiProvider));
  ref.listen(sessionProvider, (_, next) {
    if (next.status == SessionStatus.signedIn) {
      rt.start();
    } else {
      rt.stop();
    }
  }, fireImmediately: true);
  ref.onDispose(rt.stop);
  return rt;
});
