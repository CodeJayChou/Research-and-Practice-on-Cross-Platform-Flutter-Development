import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/shell/presentation/pages/main_shell_page.dart';
import 'app_routes.dart';

class ShortVideoApp extends StatelessWidget {
  const ShortVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Video',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      routes: {AppRoutes.home: (_) => const MainShellPage()},
    );
  }
}
