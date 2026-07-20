
import 'native_capabilities_platform_interface.dart';

class NativeCapabilities {
  Future<String?> getPlatformVersion() {
    return NativeCapabilitiesPlatform.instance.getPlatformVersion();
  }
}
