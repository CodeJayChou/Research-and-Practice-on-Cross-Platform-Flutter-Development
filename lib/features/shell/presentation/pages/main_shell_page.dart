import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder.dart';
import '../../../feed/presentation/pages/video_feed_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  static const _pages = [
    VideoFeedPage(),
    FeaturePlaceholder(
      icon: Icons.people_outline_rounded,
      title: '朋友',
      description: '好友动态将在后续迭代中接入。',
    ),
    FeaturePlaceholder(
      icon: Icons.add_box_outlined,
      title: '发布',
      description: '视频拍摄与发布能力将在后续迭代中接入。',
    ),
    FeaturePlaceholder(
      icon: Icons.chat_bubble_outline_rounded,
      title: '消息',
      description: '评论通知与私信能力将在后续迭代中接入。',
    ),
    FeaturePlaceholder(
      icon: Icons.person_outline_rounded,
      title: '我',
      description: '个人资料与作品列表将在后续迭代中接入。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xE6000000),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: '朋友',
          ),
          BottomNavigationBarItem(icon: _CreateButtonIcon(), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: '我',
          ),
        ],
      ),
    );
  }
}

class _CreateButtonIcon extends StatelessWidget {
  const _CreateButtonIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Icon(Icons.add, color: Colors.black, size: 22),
    );
  }
}
