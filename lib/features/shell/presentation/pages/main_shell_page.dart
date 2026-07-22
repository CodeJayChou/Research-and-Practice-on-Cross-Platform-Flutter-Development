import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../messages/presentation/pages/messages_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../publish/presentation/pages/publish_page.dart';
import '../../../shop/presentation/pages/shop_page.dart';
import '../widgets/main_bottom_navigation_bar.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    ShopPage(),
    PublishPage(),
    MessagesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
