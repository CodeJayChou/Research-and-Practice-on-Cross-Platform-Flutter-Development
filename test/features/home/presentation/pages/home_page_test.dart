import 'package:cross_platform_app/features/home/presentation/pages/home_page.dart';
import 'package:cross_platform_app/features/home/presentation/models/home_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects a home channel from the top navigation bar', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(343, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.byKey(const ValueKey('home-video-surface')), findsOneWidget);
    expect(find.text('直播'), findsOneWidget);
    expect(find.text('朋友'), findsOneWidget);
    expect(find.text('同城'), findsOneWidget);
    expect(find.text('团购'), findsOneWidget);
    expect(find.text('关注'), findsOneWidget);
    expect(find.text('热点'), findsOneWidget);
    expect(find.text('短剧'), findsOneWidget);
    expect(find.text('美食'), findsOneWidget);
    expect(find.text('音乐'), findsOneWidget);
    expect(find.text('游戏'), findsOneWidget);
    expect(find.text('科技'), findsOneWidget);
    expect(find.text('体育'), findsOneWidget);
    expect(find.text('推荐'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-hot-badge')), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    expect(
      tester.widget<TabBar>(find.byType(TabBar)).indicator,
      isA<UnderlineTabIndicator>(),
    );
    expect(
      (tester.widget<TabBar>(find.byType(TabBar)).indicator!
              as UnderlineTabIndicator)
          .insets,
      const EdgeInsets.only(left: 3, right: 3, bottom: 7),
    );
    expect(
      tester.widget<TabBar>(find.byType(TabBar)).controller?.index,
      HomeChannel.recommended.index,
    );

    await tester.ensureVisible(find.text('热点'));
    await tester.tap(find.text('热点'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TabBar>(find.byType(TabBar)).controller?.index,
      HomeChannel.hot.index,
    );
    expect(
      find.byKey(const ValueKey('home-channel-content-hot')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('音乐'));
    await tester.tap(find.text('音乐'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TabBar>(find.byType(TabBar)).controller?.index,
      HomeChannel.music.index,
    );
    expect(find.text('音乐频道内容'), findsOneWidget);

    await tester.ensureVisible(find.text('游戏'));
    await tester.tap(find.text('游戏'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TabBar>(find.byType(TabBar)).controller?.index,
      HomeChannel.games.index,
    );
    expect(find.text('游戏频道内容'), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('home-video-pager')),
      const Offset(-300, 0),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<TabBar>(find.byType(TabBar)).controller?.index,
      HomeChannel.technology.index,
    );
    expect(
      find.byKey(const ValueKey('home-channel-content-technology')),
      findsOneWidget,
    );

    final livePositionBeforeDrag = tester.getTopLeft(find.text('直播')).dx;
    await tester.drag(find.byType(TabBar), const Offset(180, 0));
    await tester.pumpAndSettle();
    final livePositionAfterDrag = tester.getTopLeft(find.text('直播')).dx;

    expect(livePositionAfterDrag, greaterThan(livePositionBeforeDrag));
  });
}
