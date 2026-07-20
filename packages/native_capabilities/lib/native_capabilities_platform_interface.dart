import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_capabilities_method_channel.dart';

abstract class NativeCapabilitiesPlatform extends PlatformInterface {
  /// Constructs a NativeCapabilitiesPlatform.
  NativeCapabilitiesPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeCapabilitiesPlatform _instance = MethodChannelNativeCapabilities();

  /// The default instance of [NativeCapabilitiesPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeCapabilities].
  static NativeCapabilitiesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeCapabilitiesPlatform] when
  /// they register themselves.
  static set instance(NativeCapabilitiesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
