import 'package:flutter/material.dart';

import '../../../../core/utils/icon_utils.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _labels = ['首页', '商城', '发布', '消息', '我'];
  static const _publishAssetPath = 'assets/icons/bottom_tabbar/publish.svg';

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: List.generate(_labels.length, (index) {
                final isSelected = currentIndex == index;

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: index == 2 ? _labels[index] : null,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(index),
                      child: Center(
                        child: index == 2
                            ? IconUtils.svgAsset(
                                assetPath: _publishAssetPath,
                                size: 24,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Text(
                                    _labels[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  if (index == 0)
                                    Transform.translate(
                                      offset: const Offset(27, 0),
                                      child: _AnimatedHomeSwitchIcon(
                                        isVisible: isSelected,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedHomeSwitchIcon extends StatelessWidget {
  const _AnimatedHomeSwitchIcon({required this.isVisible});

  final bool isVisible;

  static const _assetPath = 'assets/icons/bottom_tabbar/home_switch.svg';

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: 18,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: isVisible ? Curves.easeOut : Curves.easeIn,
          child: IconUtils.svgAsset(assetPath: _assetPath, size: 12),
        ),
      ),
    );
  }
}
