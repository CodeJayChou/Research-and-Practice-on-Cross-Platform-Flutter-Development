import 'package:cross_platform_app/features/shell/presentation/pages/main_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('switches pages with the bottom navigation bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShellPage()));

    expect(find.text('首页'), findsNWidgets(2));
    expect(find.byType(Icon), findsNothing);

    await tester.tap(find.text('商城'));
    await tester.pump();

    expect(find.text('商城'), findsNWidgets(2));
  });
}
