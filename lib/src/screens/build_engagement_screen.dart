import 'package:deep_pick/deep_pick.dart';
//import 'package:flaudio/src/components/fetch_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/se_widgets.dart';
import '../models/engagement_text.dart';
import '../models/my_globals.dart';
//import '../components/fetch_text.dart';
import 'sermon_engagement.dart';

Widget buildEngagementsScreen(BuildContext context, List<EngagementText> list,
    int currentSermonIndex, AudioPlayer player) {
  List<Container> engagements = [];
  int engagementIndex = 0;
//  Future<int> maxIndex = getMaxEngagementIndex(currentSermonIndex);
  while (1 == 1) {
    Container? c = buildEngagementsList(
        jsonMap, currentSermonIndex, engagementIndex, context, list, player);
    if (c != null) {
      engagements.add(c);
    } else {
      maxEngagementIndex = engagementIndex - 1;
      break;
    }
    engagementIndex++;
  }
  String? title1 = pick(jsonMap, currentSermonIndex, 'title').asStringOrNull();
  String? series1 =
      pick(jsonMap, currentSermonIndex, 'series').asStringOrNull();
  String? date1 = pick(jsonMap, currentSermonIndex, 'date').asStringOrNull();
  title1 ??= 'title is NULL';
  series1 ??= 'series is NULL';
  date1 ??= 'date is NULL';
  return MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor:
          const Color.fromARGB(255, 1, 25, 45), // unless transparent
      useMaterial3: true,
    ),
    title: 'Sermon Engagement App',
    home: Scaffold(
      body: Container(
        decoration: seBoxDecoration(),
        child: Column(
          children: [
            seText(title1, 20, Colors.white),
            seText(series1, 15, Colors.white),
            seText(date1, 12, Colors.white),
//            seText(maxEngagementIndexShadow.toString(), 12, Colors.white),
//            seText(maxIndex.toString(), 12, Colors.white),
            seText(date1, 12, Colors.white),
            Expanded(
              child: ListView(
                children: engagements,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Container? buildEngagementsList(
    json,
    int currentSermonIndex,
    int engagementIndexT,
    BuildContext context,
    List<EngagementText> list,
    AudioPlayer player) {
  final String? engagement =
      pick(json, currentSermonIndex, 'engagements', engagementIndexT, 'title')
          .asStringOrNull();
  if (engagement == null || engagement == 'EMPTY' || engagement == '') {
    return null;
  } else {
    return engagementTile(engagement, Icons.theaters, engagementIndexT, context,
        list, currentSermonIndex, player);
  }
}

Container engagementTile(
    String engagement,
    IconData icon,
    int engagementIndexT,
    BuildContext context,
    List<EngagementText> list,
    int currentSermonIndex,
    AudioPlayer player) {
  return Container(
    decoration: BoxDecoration(
      gradient: seLinearGradient(),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      border: seBorder(),
    ),
    child: engagementButton(engagement, icon, engagementIndexT, context, list,
        currentSermonIndex, player),
    //      isThreeLine: true,
  );
}

ListTile engagementButton(
    String engagement,
    IconData icon,
    int engagementIndexT,
    BuildContext context,
    List<EngagementText> list,
    int currentSermonIndex,
    AudioPlayer player) {
  return ListTile(
    //      isThreeLine: true,
    title: Text(
      engagement,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    onTap: () {
      String? engagementFileName = pick(jsonMap, currentSermonIndex,
              'engagements', engagementIndexT, 'text_a')
          .asStringOrNull();
      if (engagementFileName == null || engagementFileName == '') {
        engagementFileName = '2024-03-170Ia.json';
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SermonEngagement(
              currentSermonIndex: currentSermonIndex,
              engagementIndexT: engagementIndexT,
              list: list,
              player: player),
        ),
      );
    },
  );
}
