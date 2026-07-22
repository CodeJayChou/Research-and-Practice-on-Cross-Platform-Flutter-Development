import 'package:flutter/widgets.dart';

import '../../features/shell/presentation/pages/main_shell_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (_) => const MainShellPage(),
  };
}
