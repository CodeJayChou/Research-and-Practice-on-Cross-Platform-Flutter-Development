import 'package:cross_platform_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the initial short-video feed', (tester) async {
    await tester.pumpWidget(const ShortVideoApp());
    await tester.pumpAndSettle();

    expect(find.text('推荐'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('@城市漫游者'), findsOneWidget);
  });
}
