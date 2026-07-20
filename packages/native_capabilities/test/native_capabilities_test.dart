import 'package:flutter_test/flutter_test.dart';
import 'package:native_capabilities/native_capabilities.dart';
import 'package:native_capabilities/native_capabilities_platform_interface.dart';
import 'package:native_capabilities/native_capabilities_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeCapabilitiesPlatform
    with MockPlatformInterfaceMixin
    implements NativeCapabilitiesPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativeCapabilitiesPlatform initialPlatform = NativeCapabilitiesPlatform.instance;

  test('$MethodChannelNativeCapabilities is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeCapabilities>());
  });

  test('getPlatformVersion', () async {
    NativeCapabilities nativeCapabilitiesPlugin = NativeCapabilities();
    MockNativeCapabilitiesPlatform fakePlatform = MockNativeCapabilitiesPlatform();
    NativeCapabilitiesPlatform.instance = fakePlatform;

    expect(await nativeCapabilitiesPlugin.getPlatformVersion(), '42');
  });
}
