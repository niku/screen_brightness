// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_screen_brightness.dart';

/// Screen brightness platform interface which is implemented with
/// [federated plugins](flutter.dev/go/federated-plugins)
abstract class ScreenBrightnessPlatform extends PlatformInterface {
  /// Default constructor for [ScreenBrightnessPlatform]
  ScreenBrightnessPlatform() : super(token: _token);

  /// The token which [PlatformInterface.verifyToken] needs to be verify
  static final Object _token = Object();

  /// Private instance which will be only create once
  static ScreenBrightnessPlatform _instance = MethodChannelScreenBrightness();

  /// The default instance of [ScreenBrightnessPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenBrightness].
  static ScreenBrightnessPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ScreenBrightnessPlatform] when they register themselves.
  static set instance(ScreenBrightnessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns system screen brightness which is set when application is started.
  ///
  /// The value should be within 0.0 - 1.0. Otherwise, [RangeError.range] will
  /// be throw.
  ///
  /// This parameter is useful for user to get screen brightness value after
  /// calling [resetScreenBrightness]
  Future<double> get system async {
    throw UnimplementedError('system brightness has not been implemented.');
  }

  /// Returns current screen brightness which is current screen brightness value.
  ///
  /// The value should be within 0.0 - 1.0. Otherwise, [RangeError.range] will
  /// be throw.
  ///
  /// This parameter is useful for user to get screen brightness value after
  /// calling [setScreenBrightness]
  Future<double> get current async {
    throw UnimplementedError('current brightness has not been implemented.');
  }

  /// Set screen brightness with double value.
  ///
  /// The value should be within 0.0 - 1.0. Otherwise, [RangeError.range] will
  /// be throw.
  ///
  /// This method is useful for user to change screen brightness.
  Future<void> setScreenBrightness(double brightness) async {
    throw UnimplementedError(
        'setScreenBrightness(brightness) has not been implemented.');
  }

  /// Reset screen brightness with (Android)-1 or (iOS)system brightness value.
  ///
  /// This method is useful for user to reset screen brightness when user leave
  /// the page which has change the brightness value.
  Future<void> resetScreenBrightness() async {
    throw UnimplementedError(
        'resetScreenBrightness() has not been implemented.');
  }

  /// A stream return with screen brightness changes including
  /// [ScreenBrightness.setScreenBrightness],
  /// [ScreenBrightness.resetScreenBrightness], system control center or system
  /// setting.
  ///
  /// This stream is useful for user to listen to brightness changes.
  Stream<double> get onCurrentBrightnessChanged {
    throw UnimplementedError(
        'get onCurrentBrightnessChanged has not been implemented.');
  }
}
