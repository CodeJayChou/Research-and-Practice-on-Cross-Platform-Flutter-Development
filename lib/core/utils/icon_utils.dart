import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class IconUtils {
  static Widget svgAsset({
    required String assetPath,
    required double size,
    Color? color,
    String? semanticLabel,
  }) {
    final icon = RepaintBoundary(
      child: SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );

    if (semanticLabel == null) {
      return ExcludeSemantics(child: icon);
    }

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(child: icon),
    );
  }
}
