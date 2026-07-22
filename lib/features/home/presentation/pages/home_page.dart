import 'package:flutter/material.dart';

import '../models/home_channel.dart';
import '../widgets/home_video_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeChannel _selectedChannel = HomeChannel.recommended;

  @override
  Widget build(BuildContext context) {
    return HomeVideoView(
      selectedChannel: _selectedChannel,
      onChannelSelected: (channel) {
        if (channel == _selectedChannel) {
          return;
        }

        setState(() {
          _selectedChannel = channel;
        });
      },
      onMenuTap: () {},
      onSearchTap: () {},
    );
  }
}
