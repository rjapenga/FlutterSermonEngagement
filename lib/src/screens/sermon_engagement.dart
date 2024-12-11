// Worked once - not the first time but not a second time
// Fails on audioSrc failed to load source. What do you need to do
// at the end / stop and clear. Etc
//import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:deep_pick/deep_pick.dart';
//import 'package:flaudio/src/providers/playback_provider.dart';
//import '../components/track_play_button.dart';
//import '../components/track_progress_bar.dart';

import '../components/navigation_destination.dart';
import '../components/control_buttons.dart';
import '../models/se_widgets.dart';
//import '../models/track.dart';
import '../models/engagement_text.dart';
import '../models/my_globals.dart';
//import '../providers/background_music.dart';
import '../screens/about.dart';
import '../screens/manual.dart';
import '../screens/settings.dart';

Future<void> loadAudio(String fileName, AudioPlayer player) async {
  try {
    await player.setAudioSource(AudioSource.uri(Uri.parse(fileName)),
        preload: false);
  } on PlayerException catch (e) {
    if (kDebugMode) {
      print("Audio source was unable to be loaded: $e");
    }
  } on PlayerInterruptedException catch (e) {
    if (kDebugMode) {
      print("Another audio source was loaded before: $e");
    }
  } on Exception catch (e) {
    if (kDebugMode) {
      print("No audio source has been previously set: $e");
    }
  }
}

// Begin Engagement
// ignore: must_be_immutable
class SermonEngagement extends StatefulWidget {
  SermonEngagement(
      {required this.currentSermonIndex,
      required this.engagementIndexT,
      required this.list,
      required this.player,
      super.key});
  int currentSermonIndex;
  int engagementIndexT;
  List<EngagementText> list;
  final AudioPlayer player;

  @override
  State<SermonEngagement> createState() =>
      // ignore: no_logic_in_create_state
      _SermonEngagementState(
          engagementIndexT: engagementIndexT,
          currentSermonIndex: currentSermonIndex);
}

class _SermonEngagementState extends State<SermonEngagement> {
  _SermonEngagementState(
      {required this.engagementIndexT, required this.currentSermonIndex});
  int engagementIndexT;
  int currentSermonIndex;
  int selectedPageIndex = 0;
  String playString = 'Play';
  String pauseString = 'Pause';
  Widget playIcon = const Icon(
    Icons.play_arrow,
    color: Colors.white,
  );
  Widget pauseIcon = const Icon(
    Icons.pause,
    color: Colors.white,
  );
  Future<void> initAudio(String engagementFileName, AudioPlayer player) async {
    await loadAudio(engagementFileName, player);
//    if (autoPlay) {
//      player.play();
//    }
  }

  // We need to override initState because that is where you can have a future for FutureBuilder
  // We get futureJson here and it can be used in the SermonEngagementState builder
  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
//    backgroundMusic.play();
//    playBackgroundMusic(Random().nextInt(7));
    String? engagementFileName = pick(jsonMap, currentSermonIndex,
            'engagements', engagementIndexT, 'audio_a')
        .asStringOrNull();
    if (engagementFileName == null || engagementFileName == '') {
      engagementFileName = '2024-03-170Ia.mp3';
    }
    String engagementFileNameT =
        "https://ListeningToGod.org/SermonEngagement/AudioFiles/$engagementFileName";
    initAudio(engagementFileNameT, widget.player);
  }

  void previousCallback() {
    setState(() {
      engagementIndexT--;
      if (engagementIndexT < 0) {
        engagementIndexT = maxEngagementIndex;
      }
    });
  }

  void previousCallbackNS() {
    engagementIndexT--;
    if (engagementIndexT < 0) {
      engagementIndexT = maxEngagementIndex;
    }
  }

  void nextCallback() {
    setState(() {
      engagementIndexT++;
      if (engagementIndexT > maxEngagementIndex) {
        engagementIndexT = 0;
      }
    });
  }

  void nextCallbackNS() {
    engagementIndexT++;
    if (engagementIndexT > maxEngagementIndex) {
      engagementIndexT = 0;
    }
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
          title: seText('Engagement', 35, Colors.black),
        ),
        // The body is a list of Widgets that can be called from the Top level
        // The Sermons index 0
        // The Manual index 1 and so on
        body: [
          // These are the four screens all contained with containers from bottom tab
          Container(
            decoration: seBoxDecoration(),
            child: Center(
              child: buildEngagementScreen(
                  context,
                  widget.currentSermonIndex,
                  engagementIndexT,
                  previousCallbackNS,
                  nextCallbackNS,
                  widget.list,
                  widget.player),
            ),
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

// jsonMap is a global just like in React Native
Widget buildEngagementScreen(
    BuildContext context,
    int currentSermonIndexT,
    int engagementIndex,
    Function previousCallbackNS,
    Function nextCallbackNS,
    List<EngagementText> list,
    AudioPlayer player) {
  String? engagementName = pick(
          jsonMap, currentSermonIndexT, 'engagements', engagementIndex, 'title')
      .asStringOrNull();
  if (engagementName == null ||
      engagementName == 'EMPTY' ||
      engagementName == '') {
    engagementName = 'Default Engagement';
  }
  String? title1 = pick(jsonMap, currentSermonIndexT, 'title').asStringOrNull();
  String? series1 =
      pick(jsonMap, currentSermonIndexT, 'series').asStringOrNull();
  String? date1 = pick(jsonMap, currentSermonIndexT, 'date').asStringOrNull();
  title1 ??= 'title is NULL';
  series1 ??= 'series is NULL';
  date1 ??= 'date is NULL';
  EngagementText engagementTextTmp = list[engagementIndex];
  String? jsonTextTmp = engagementTextTmp.text;
  return MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.blue, // unless transparent
      useMaterial3: true,
    ),
    title: 'Sermon Engagement App',
    home: Scaffold(
      body: Container(
        decoration: seBoxDecoration(),
        child: Column(
          children: <Widget>[
            ControlButtons(
              player,
              previousCallbackNS,
              nextCallbackNS,
            ),
//            TrackProgressBar(track: track2),
            Expanded(
              child: ListView(
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  seText(engagementName, 20, Colors.white),
                  seText(title1, 15, Colors.white),
                  seText(date1, 12, Colors.white),
                  seText(playAll ? "True" : "False", 12, Colors.white),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: HtmlWidget(
                      '<center>$jsonTextTmp</center>',
                      renderMode: RenderMode.column,
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
