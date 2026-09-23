/// App-wide constants. The name is a placeholder until the owner picks the
/// final one — change it here and in android/app/src/main/AndroidManifest.xml.
class AppConfig {
  static const appName = 'Hello Dude!';
  static const tagline = 'Talk. Vibe. Connect.';

  /// Over USB the phone reaches the PC through `adb reverse tcp:9000 tcp:9000`,
  /// so 127.0.0.1 works. Override with --dart-define=API_BASE_URL=http://PC_IP:9000
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:9000',
  );
}
