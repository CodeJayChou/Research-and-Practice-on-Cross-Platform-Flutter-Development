import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppPageLayoutMode { standard, immersive }

@immutable
class AppSafeAreaConfig {
  const AppSafeAreaConfig({
    this.top = true,
    this.bottom = false,
    this.left = true,
    this.right = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
}

class AppPageLayout extends StatelessWidget {
  const AppPageLayout({
    required this.body,
    this.topBar,
    this.bottomBar,
    this.overlays = const [],
    this.backgroundColor = Colors.transparent,
    this.systemInsetColor,
    this.safeArea = const AppSafeAreaConfig(),
    this.systemUiOverlayStyle = defaultSystemUiOverlayStyle,
    this.clipBehavior = Clip.none,
    this.mode = AppPageLayoutMode.standard,
    super.key,
  });

  final Widget body;
  final Widget? topBar;
  final Widget? bottomBar;
  final List<Widget> overlays;
  final Color backgroundColor;
  final Color? systemInsetColor;
  final AppSafeAreaConfig safeArea;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final Clip clipBehavior;
  final AppPageLayoutMode mode;

  static const defaultSystemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: switch (mode) {
        AppPageLayoutMode.standard => _buildStandardLayout(),
        AppPageLayoutMode.immersive => _buildImmersiveLayout(),
      },
    );
  }

  Widget _buildStandardLayout() {
    final pageContent = ColoredBox(
      color: backgroundColor,
      child: Column(
        children: [
          ?topBar,
          Expanded(child: body),
          ?bottomBar,
        ],
      ),
    );

    return ColoredBox(
      color: systemInsetColor ?? backgroundColor,
      child: SafeArea(
        top: safeArea.top,
        bottom: safeArea.bottom,
        left: safeArea.left,
        right: safeArea.right,
        minimum: safeArea.minimum,
        maintainBottomViewPadding: safeArea.maintainBottomViewPadding,
        child: overlays.isEmpty
            ? pageContent
            : Stack(
                fit: StackFit.expand,
                clipBehavior: clipBehavior,
                children: [pageContent, ...overlays],
              ),
      ),
    );
  }

  Widget _buildImmersiveLayout() {
    final topBarLayer = topBar == null
        ? null
        : Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: safeArea.top,
              bottom: false,
              left: safeArea.left,
              right: safeArea.right,
              minimum: EdgeInsets.only(
                top: safeArea.minimum.top,
                left: safeArea.minimum.left,
                right: safeArea.minimum.right,
              ),
              child: topBar!,
            ),
          );
    final bottomBarLayer = bottomBar == null
        ? null
        : Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: safeArea.bottom,
              left: safeArea.left,
              right: safeArea.right,
              minimum: EdgeInsets.only(
                left: safeArea.minimum.left,
                right: safeArea.minimum.right,
                bottom: safeArea.minimum.bottom,
              ),
              maintainBottomViewPadding: safeArea.maintainBottomViewPadding,
              child: bottomBar!,
            ),
          );

    return ColoredBox(
      color: systemInsetColor ?? backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: clipBehavior,
        children: [
          ColoredBox(color: backgroundColor, child: body),
          ...overlays,
          ?topBarLayer,
          ?bottomBarLayer,
        ],
      ),
    );
  }
}
