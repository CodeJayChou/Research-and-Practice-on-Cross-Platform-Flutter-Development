import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_capabilities_platform_interface.dart';

/// An implementation of [NativeCapabilitiesPlatform] that uses method channels.
class MethodChannelNativeCapabilities extends NativeCapabilitiesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_capabilities');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
