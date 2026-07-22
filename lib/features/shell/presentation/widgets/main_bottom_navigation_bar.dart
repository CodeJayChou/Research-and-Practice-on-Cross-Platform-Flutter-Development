import 'package:flutter/material.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _labels = ['首页', '商城', '发布', '消息', '我'];

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: Center(
                      child: Text(
                        _labels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
