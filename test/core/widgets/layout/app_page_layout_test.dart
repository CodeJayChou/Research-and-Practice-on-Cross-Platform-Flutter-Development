import 'package:cross_platform_app/core/widgets/layout/app_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('places the top bar below the device top inset', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    const topBarKey = ValueKey('top-bar');
    const overlayKey = ValueKey('overlay');

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: 32)),
          child: AppPageLayout(
            topBar: SizedBox(key: topBarKey, height: 56),
            body: SizedBox.expand(),
            overlays: [Align(key: overlayKey)],
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(topBarKey)).dy, 32);
    expect(find.byKey(overlayKey), findsOneWidget);
  });

  testWidgets('keeps immersive body behind the safe top bar', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    const bodyKey = ValueKey('body');
    const topBarKey = ValueKey('immersive-top-bar');

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: 32)),
          child: AppPageLayout(
            mode: AppPageLayoutMode.immersive,
            topBar: SizedBox(key: topBarKey, height: 56),
            body: SizedBox.expand(key: bodyKey),
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(bodyKey)).dy, 0);
    expect(tester.getTopLeft(find.byKey(topBarKey)).dy, 32);
  });
}
