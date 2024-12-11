import 'dart:math';
import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/my_globals.dart';
import '../models/se_widgets.dart';
//import '../providers/background_music.dart';
import '../screens/about.dart';
import '../screens/settings.dart';
import '../screens/manual.dart';
import '../screens/build_engagement_texts.dart';
import '../components/navigation_destination.dart';

// The Widget Tree goes as follows:
// *Analytics (analytics.dart)
//   *Sermons (sermons.dart) get currentSermonIndex
//     BuildEngagementTextsList (builds the List of Texts
//                    futureEngagementTexts for that Sermon, and calculates
//                    maxSermonsEngagements )
//       *SermonEngagements (sermonIndex, futureEngagementTexts)
//         buildEngagementScreen(sermonIndex, futureEngagementTexts)
//           SermonEngagement(sermonIndex, futureEngagementTexts)
//             build_engagement_list(sermonIndex, futureEngagementTexts)
//
class Sermons extends StatefulWidget {
  const Sermons({super.key});
  @override
  State<Sermons> createState() => _SermonsState();
}

class _SermonsState extends State<Sermons> {
  _SermonsState();
  final player = AudioPlayer();
  int selectedPageIndex = 0; //Sermons / Manual / About / Settings
//  late AudioPlayer musicPlayer;
/*  String? appName = packageInfo?.appName;
  String? packageName = packageInfo?.packageName;
  String? version = packageInfo?.version;
  String? buildNumber = packageInfo?.buildNumber; */
  late AudioPlayer musicPlayer;
  List<String> appBarTitle = ['Sermons', 'Manual', 'About', 'Settings'];
  Future<void> _notFirstTime() async {
    if (appInitialized == false) {
      appInitialized = true;
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setBool('firstTime', false);
      });
    }
  }

  Future<void> playBackgroundMusic() async {
    List<String> musicPlaylist = []; //addable list
    int index = 0;
    int maxMusic = 0;
    while (1 == 1) {
      String? musicItem = pick(musicMap, index, 'mp3Music').asStringOrNull();
      if (musicItem == null && index != 0) {
        maxMusic = index; // max valid index
        break;
      } else if (musicItem == null && index == 0) {
        // nothing there - give something
        maxMusic = index; // max valid index
        musicPlaylist.add('"PachebelCanon.mp3"');
        break;
      } else if (musicItem != null && musicItem != '') {
        musicPlaylist.add(musicItem);
        index++;
      } else {
        // musicItem = ''
        maxMusic = index; // max valid index
        musicPlaylist.add('"PachebelCanon.mp3"');
        break;
      }
    }
    int rng = Random().nextInt(maxMusic);
//
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: [
        AudioSource.uri(Uri.parse(
            'https://ListeningToGod.org/SermonEngagement/music/${musicPlaylist[0]}')),
      ],
    );
    for (int i = 0; i < maxMusic; i++) {
      String musicFilename = musicPlaylist[i];
      String url =
          "https://ListeningToGod.org/SermonEngagement/music/$musicFilename";
      final mediaItem = AudioSource.uri(Uri.parse(url),
          tag: MediaItem(
            id: "music",
            album: "Classical",
            title: "No Copyright",
          ));

      playlist.add(mediaItem);
    }
    musicPlayer = AudioPlayer();
    try {
      await musicPlayer.setAudioSource(playlist,
          initialIndex: rng, initialPosition: Duration.zero);
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print("Error loading audio source: $e");
      }
    }
    await musicPlayer.setLoopMode(LoopMode.all);
    musicPlayer.setVolume(0.1);
//    musicPlayer.play();
  }

  Future<void> initAudioPlayer() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) {
        debugPrint('A stream error occurred: $e');
      }
    });
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  @override
  void initState() {
    super.initState();
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    initAudioPlayer();
    playBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
//    KeepScreenOn.turnOn();
// This case happens at start up when playing enabled
// IF firstTime = don't do anything. We haven't read backgroundMusic yet
//  state 0True
    if (prevBackgroundPlay == Music.uninitialized && backgroundMusic == true) {
      prevBackgroundPlay = Music.playing; // play
      musicPlayer.play();
      // background doesn't need to change
//      playBackgroundMusic();
    }
    // state 0false
    // if prev uninitialized and not playing do nothing
    // state 1true
    // if previously running and want to run
    // do nothing
    // state 1false
    // if the music is playing but changed in settings to stopped
    else if (prevBackgroundPlay == Music.playing && backgroundMusic == false) {
      musicPlayer.pause();
      prevBackgroundPlay = Music.stopped;
    }
    // state 2true
    // if the Music is not playing and want to start it and it has
    // been initialized
    else if (prevBackgroundPlay == Music.stopped && backgroundMusic == true) {
      prevBackgroundPlay = Music.playing;
      musicPlayer.play();
    }
    // State 2false
    else if (prevBackgroundPlay == Music.stopped && backgroundMusic == false) {
      // do nothing
    }

    _notFirstTime();
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
          Container(
            decoration: seBoxDecoration(),
            child: Center(
              child: _buildList(context),
            ),
          ),
          const ManualScreen(),
          const AboutScreen(),
          const SettingsScreen(),
        ][selectedPageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedPageIndex = index;
              appBarCurrentTitle = appBarTitle[index];
            });
          },
          destinations: nD,
        ),
      ),
    );
  }

  // #docregion list
  Widget _buildList(BuildContext context) {
    List<Container> sermons = [];
    int index = 0;
    while (1 == 1) {
      Container? c = buildDisplayList(jsonMap, index, context);
      index++;
      if (c == null) {
        break;
      }
      sermons.add(c);
    }
    return MaterialApp(
      home: Column(
        children: [
          Expanded(
            child: ListView(
              children: sermons,
            ),
          ),
        ],
      ),
    );
  }

  Container _tile(String title, String series, String date, IconData icon,
      int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: seLinearGradient(),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        border: seBorder(),
      ),
      child: seListTile(title, series, date, icon, index, context),
      //      isThreeLine: true,
    );
  }

  ListTile seListTile(String title, String series, String date, IconData icon,
      int index, BuildContext context) {
    return ListTile(
      //      isThreeLine: true,
      title: seText(title, 16, Colors.white),
      subtitle: Column(
        children: [
          seText(series, 14, Colors.white),
          seText(date, 12, Colors.white),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuildEngagementTextsList(
                currentSermonIndex: index, player: player),
          ),
        );
      },
    );
  }

  Container? buildDisplayList(json, int index, BuildContext context) {
    final String? title1 = pick(json, index, 'title').asStringOrNull();
    final String? series1 = pick(json, index, 'series').asStringOrNull();
    final String? date1 = pick(json, index, 'date').asStringOrNull();
    if (title1 == null || series1 == null || date1 == null) {
      return null;
    } else {
      return _tile(title1, series1, date1, Icons.theaters, index, context);
    }
    // #enddocregion list
  }
}
