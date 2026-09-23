import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../app/config.dart';
import '../app/router.dart';
import 'session.dart';

/// Push notifications (Firebase Cloud Messaging).
///
/// * The server sends `incoming_call` as a data-only, high-priority message.
///   When the app is closed or in the background, [firebaseBackgroundHandler]
///   shows the native full-screen call UI (works on a locked phone).
/// * While the app is open the WebSocket already rings the in-app screen, so
///   foreground `incoming_call` pushes are ignored.
/// * Accept / Decline on the native UI arrive as [CallAction]s.
/// * Tapping a notification opens its screen once the session is signed in:
///   inbox notices (data has `notificationId`) -> /notifications,
///   chat messages (`type: chat_message`) -> `/chat/<conversationId>`.

/// Runs in its own isolate when a push arrives and the app isn't in front.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data['type'] == 'incoming_call') {
    await showIncomingCallUi(message.data);
  }
}

Future<void> showIncomingCallUi(Map<String, dynamic> d) =>
    FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: d['callId'] as String,
        nameCaller: d['callerName'] as String? ?? 'Caller',
        appName: AppConfig.appName,
        handle: d['callType'] == 'video' ? 'Video call' : 'Voice call',
        type: d['callType'] == 'video' ? 1 : 0,
        duration: 45000, // same as the server's ring timeout
        extra: Map<String, dynamic>.from(d),
        missedCallNotification: const NotificationParams(
          showNotification: true,
          subtitle: 'Missed call',
        ),
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          backgroundColor: '#0A0A18',
          actionColor: '#10B981',
          textColor: '#FFFFFF',
          incomingCallNotificationChannelName: 'Incoming calls',
          missedCallNotificationChannelName: 'Missed calls',
          isShowFullLockedScreen: true,
          isImportant: true,
          textAccept: 'Accept',
          textDecline: 'Decline',
        ),
      ),
    );

/// Close the native call UI once the in-app screen has taken over.
Future<void> dismissIncomingCallUi(String callId) =>
    FlutterCallkitIncoming.endCall(callId).catchError((_) {});

enum CallActionKind { accept, decline }

class CallAction {
  const CallAction(this.kind, this.callId, this.data);
  final CallActionKind kind;
  final String callId;

  /// The push payload: callType, callerName, callerAvatarId.
  final Map<String, dynamic> data;
}

class PushController {
  PushController(this._ref);
  final Ref _ref;
  final _actions = StreamController<CallAction>.broadcast();
  StreamSubscription<String>? _refresh;
  StreamSubscription<CallEvent?>? _callEvents;
  bool _started = false;

  /// Screen to open for a tapped notification, waiting for sign-in.
  String? _pendingRoute;

  /// Accept / Decline pressed on the native incoming-call UI.
  Stream<CallAction> get actions => _actions.stream;

  void start() {
    if (_started) return;
    _started = true;
    _callEvents = FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event) {
        case CallEventActionCallAccept(:final callKitParams):
          _emit(CallActionKind.accept, callKitParams);
        case CallEventActionCallDecline(:final callKitParams):
          _emit(CallActionKind.decline, callKitParams);
        default:
          break;
      }
    });
    FirebaseMessaging.onMessage.listen((m) {
      // Foreground: the WebSocket event already opened the in-app ringing screen.
      if (kDebugMode) debugPrint('push (foreground): ${m.data['type']}');
    });
    // Notification tapped while the app was in the background...
    FirebaseMessaging.onMessageOpenedApp.listen(_opened);
    // ...or the tap launched the app.
    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) _opened(m);
    });
  }

  void _opened(RemoteMessage m) {
    final d = m.data;
    final conversation = d['conversationId'];
    if (d['type'] == 'chat_message' && conversation is String) {
      _pendingRoute = '/chat/$conversation';
    } else if (d['notificationId'] != null) {
      _pendingRoute = '/notifications';
    } else {
      return; // e.g. incoming_call, handled by the call UI
    }
    openPendingInbox();
  }

  /// Opens the screen for a tapped notification. Waits for sign-in (the tap
  /// can arrive while the saved session is still being restored).
  void openPendingInbox() {
    final route = _pendingRoute;
    if (route == null) return;
    if (_ref.read(sessionProvider).status != SessionStatus.signedIn) return;
    _pendingRoute = null;
    // After this frame, so the router has settled on the signed-in home first.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ref.read(routerProvider).push(route),
    );
  }

  void _emit(CallActionKind kind, CallKitParams p) =>
      _actions.add(CallAction(kind, p.id, p.extra ?? const {}));

  /// A call accepted on the native UI while the app was closed: the app was
  /// started by that tap, so the event fired before anyone listened.
  Future<CallAction?> acceptedWhileClosed() async {
    try {
      final calls = await FlutterCallkitIncoming.activeCalls();
      final accepted = calls.where((c) => c.isAccepted).firstOrNull;
      return accepted == null
          ? null
          : CallAction(
              CallActionKind.accept,
              accepted.id,
              accepted.extra ?? const {},
            );
    } catch (_) {
      return null;
    }
  }

  /// After sign-in: ask for permission and register this phone's token.
  Future<void> register({required bool companion}) async {
    try {
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      if (companion && !await FlutterCallkitIncoming.canUseFullScreenIntent()) {
        // Android 14+: incoming calls over the lock screen need this switch.
        await FlutterCallkitIncoming.requestFullIntentPermission();
      }
      final token = await fm.getToken();
      if (token != null) await _send(token);
      _refresh ??= fm.onTokenRefresh.listen(_send);
    } catch (e) {
      // No Play services / offline: calls still ring while the app is open.
      if (kDebugMode) debugPrint('push registration failed: $e');
    }
  }

  Future<void> _send(String token) async {
    final api = _ref.read(apiProvider);
    await api.call(
      () => api.profile.registerDevice(RegisterDeviceRequest(fcmToken: token)),
    );
  }

  /// After sign-out: this phone must stop getting the old account's pushes.
  Future<void> unregister() async {
    await _refresh?.cancel();
    _refresh = null;
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }

  void dispose() {
    _refresh?.cancel();
    _callEvents?.cancel();
    _actions.close();
  }
}

/// Watched by the app root: registers on sign-in, unregisters on sign-out.
final pushProvider = Provider<PushController>((ref) {
  final push = PushController(ref)..start();
  ref.onDispose(push.dispose);
  ref.listen<SessionState>(sessionProvider, (prev, next) {
    final wasIn = prev?.status == SessionStatus.signedIn;
    final isIn = next.status == SessionStatus.signedIn;
    final roleChanged = prev?.profile?.role != next.profile?.role;
    if (isIn && (!wasIn || roleChanged)) {
      push.register(companion: next.profile?.role == ProfileRoleEnum.companion);
      push.openPendingInbox();
    } else if (wasIn && !isIn) {
      push.unregister();
    }
  }, fireImmediately: true);
  return push;
});
