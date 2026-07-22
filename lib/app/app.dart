import 'package:flutter/material.dart';

// import '../core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';

class CrossPlatformApp extends StatelessWidget {
  const CrossPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cross Platform App',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      routes: AppRouter.routes,
    );
  }
}
