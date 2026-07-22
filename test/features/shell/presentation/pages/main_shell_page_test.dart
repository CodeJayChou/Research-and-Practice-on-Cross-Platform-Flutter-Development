import 'package:cross_platform_app/features/shell/presentation/pages/main_shell_page.dart';
import 'package:cross_platform_app/features/shell/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets('switches pages with the bottom navigation bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShellPage()));

    expect(find.text('首页'), findsNWidgets(2));
    expect(find.byType(Icon), findsNothing);
    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(MainBottomNavigationBar),
        matching: find.text('发布'),
      ),
      findsNothing,
    );
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );

    final homeLabel = tester.widget<Text>(
      find.descendant(
        of: find.byType(MainBottomNavigationBar),
        matching: find.text('首页'),
      ),
    );
    expect(homeLabel.style?.color, Colors.black);
    final homeLabelCenter = tester.getCenter(
      find.descendant(
        of: find.byType(MainBottomNavigationBar),
        matching: find.text('首页'),
      ),
    );

    await tester.tap(find.text('商城'));
    await tester.pumpAndSettle();

    expect(find.text('商城'), findsNWidgets(2));
    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0,
    );
    expect(
      tester.getCenter(
        find.descendant(
          of: find.byType(MainBottomNavigationBar),
          matching: find.text('首页'),
        ),
      ),
      homeLabelCenter,
    );

    await tester.tap(find.bySemanticsLabel('发布'));
    await tester.pumpAndSettle();

    expect(find.text('发布'), findsOneWidget);
  });
}
