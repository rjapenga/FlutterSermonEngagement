import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

import '../components/navigation_destination.dart';
import '../models/se_widgets.dart';
import '../models/engagement_text.dart';
import '../models/my_globals.dart';
import '../screens/about.dart';
import '../screens/manual.dart';
import '../screens/settings.dart';
import '../screens/build_engagement_screen.dart';

class SermonEngagements extends StatefulWidget {
  const SermonEngagements(
      {required this.currentSermonIndex,
      required this.list,
      required this.player,
      super.key});
  final int currentSermonIndex;
  final List<EngagementText> list;
  final AudioPlayer player;

  @override
  State<SermonEngagements> createState() => _SermonEngagementsState();
}

class _SermonEngagementsState extends State<SermonEngagements> {
  int selectedPageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 1, 25, 45), // unless transparent
        useMaterial3: true,
      ),
      title: 'Sermon Engagement App',
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: (Navigator.canPop(context)
              ? BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                )
              : null),
          //color: Colors.black,
          centerTitle: true,
          title: seText(appBarCurrentTitle, 35, Colors.black),
        ),
        body: [
          // These are the four screens all contained with containers from bottom tab
          Container(
            decoration: seBoxDecoration(),
            child: Center(
                child: buildEngagementsScreen(context, widget.list,
                    widget.currentSermonIndex, widget.player)),
          ),
          const ManualScreen(),
          const AboutScreen(),
          const SettingsScreen(),
          seContainer('Settings'),
        ][selectedPageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: nD,
        ),
      ),
    );
  }
}
