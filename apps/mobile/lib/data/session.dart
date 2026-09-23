import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pesu_api/api.dart';

import 'api.dart';

final apiProvider = Provider<PesuApi>((ref) => PesuApi());

enum SessionStatus { loading, signedOut, signedIn }

@immutable
class SessionState {
  const SessionState(this.status, [this.profile]);
  final SessionStatus status;
  final Profile? profile;
}

/// Who is signed in. Only the refresh token and profile are persisted
/// (encrypted storage); the short-lived access token lives in memory.
class SessionController extends Notifier<SessionState> {
  static const _kRefresh = 'refresh_token';
  static const _kProfile = 'profile';
  final _storage = const FlutterSecureStorage();

  PesuApi get _api => ref.read(apiProvider);

  @override
  SessionState build() {
    _api.onUnauthorized = _refresh;
    _restore();
    return const SessionState(SessionStatus.loading);
  }

  Future<void> _restore() async {
    try {
      final profileJson = await _storage.read(key: _kProfile);
      final refresh = await _storage.read(key: _kRefresh);
      if (refresh == null || profileJson == null) {
        state = const SessionState(SessionStatus.signedOut);
        return;
      }
      // Show the app straight away with the saved profile; tokens refresh on first use.
      state = SessionState(
        SessionStatus.signedIn,
        Profile.fromJson(jsonDecode(profileJson)),
      );
      if (await _refresh() == null) return;
      final me = await _api.call(() => _api.profile.getMe());
      await setProfile(me);
    } catch (_) {
      // Offline at start-up: keep the saved session if there is one.
      if (state.status == SessionStatus.loading)
        state = const SessionState(SessionStatus.signedOut);
    }
  }

  Future<void> signIn(TokenPair tokens, Profile profile) async {
    _api.accessToken = tokens.accessToken;
    await _storage.write(key: _kRefresh, value: tokens.refreshToken);
    await setProfile(profile);
  }

  Future<void> setProfile(Profile profile) async {
    await _storage.write(key: _kProfile, value: jsonEncode(profile.toJson()));
    state = SessionState(SessionStatus.signedIn, profile);
  }

  Future<void> signOut() async {
    final refresh = await _storage.read(key: _kRefresh);
    if (refresh != null) {
      try {
        await _api.auth.logout(RefreshTokensRequest(refreshToken: refresh));
      } catch (_) {
        /* best effort */
      }
    }
    await _storage.deleteAll();
    _api.accessToken = null;
    state = const SessionState(SessionStatus.signedOut);
  }

  Future<String?>? _inFlight;

  /// Swaps the refresh token for a new pair. Concurrent callers share one request.
  Future<String?> _refresh() =>
      _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);

  Future<String?> _doRefresh() async {
    final refresh = await _storage.read(key: _kRefresh);
    if (refresh == null) return null;
    try {
      final pair = await _api.auth.refreshTokens(
        RefreshTokensRequest(refreshToken: refresh),
      );
      if (pair == null) throw ApiException(500, 'empty');
      await _storage.write(key: _kRefresh, value: pair.refreshToken);
      _api.accessToken = pair.accessToken;
      return pair.accessToken;
    } on ApiException catch (e) {
      if (e.code == 401) {
        await _storage.deleteAll();
        state = const SessionState(SessionStatus.signedOut);
        return null;
      }
      rethrow;
    }
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
