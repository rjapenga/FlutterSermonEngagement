import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:http/http.dart' as http;
import '../components/fetch_text.dart';
import '../models/engagement_text.dart';
import '../models/my_globals.dart';
import 'sermon_engagements.dart';

class BuildEngagementTextsList extends StatefulWidget {
  const BuildEngagementTextsList(
      {required this.currentSermonIndex, required this.player, super.key});
  final int currentSermonIndex; // this will be pass down to all widgets
  final AudioPlayer player;
  @override
  State<BuildEngagementTextsList> createState() =>
      _BuildEngagementTextsListState();
}

class _BuildEngagementTextsListState extends State<BuildEngagementTextsList> {
  late Future<EngagementText> futureEngagementText;
  List<EngagementText> futureEngagementTexts = List<EngagementText>.filled(
      10, EngagementText(version: "1", date: "2024-09-22", text: "EMPTY"),
      growable: false); // This will be passed down
  @override
  void initState() {
    super.initState();
//    var client = http.Client();

    for (int index = 0; index < 10; index++) {
      String? title = pick(
              jsonMap, widget.currentSermonIndex, 'engagements', index, 'title')
          .asStringOrNull();
      String? engagementFilename = pick(jsonMap, widget.currentSermonIndex,
              'engagements', index, 'text_a')
          .asStringOrNull();
      if (engagementFilename == null || engagementFilename == '') {
        engagementFilename = '2024-03-170Ia.json';
      }
      if (title == "EMPTY") {
        break;
      } else {
        futureEngagementText = fetchText(
            'https://ListeningToGod.org/SermonEngagement/TextFiles/$engagementFilename',
            index,
            futureEngagementTexts);
//            client);
      }
    }
//    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EngagementText>(
        future: futureEngagementText,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SermonEngagements(
                currentSermonIndex: widget.currentSermonIndex,
                list: futureEngagementTexts,
                player: widget.player);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            // By default, show a loading spinner.
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 300.0,
                    width: 300.0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }
        });
  }
}
