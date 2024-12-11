import 'package:flaudio/src/models/engagement_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:deep_pick/deep_pick.dart';
//import '../models/my_globals.dart';

/*
Future _checkUrl(String url) async {
  http.Response urlResponse = await http.get(Uri.parse(url));
  if (urlResponse.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<int> getMaxEngagementIndex(int currentSermonIndex) async {
  // maxEngagementTextIndex is range -1 to 9 (-1 should never happen - no engagement files)
  String? engagementFileName;
  maxEngagementIndexShadow = 0;
  int index = 0;
  for (int i = 0; i < 10; i++) {
    engagementFileName =
        pick(jsonMap, currentSermonIndex, 'engagements', i, 'text_a')
            .asStringOrNull();
    if (engagementFileName == null || engagementFileName == '') {
      engagementFileName = '2024-03-170Ia.json';
    }
    _checkUrl(
            'https://ListeningToGod.org/SermonEngagement/TextFiles/$engagementFileName')
        .then((filePresent) {
      if (filePresent) {
        index++;
        maxEngagementIndexShadow++;
      }
    });
  }
  return index;
}
*/
Future<EngagementText> fetchText(
    String filename,
    int index,
//    List<EngagementText> futureEngagementTextsTmp, var client) async {
    List<EngagementText> futureEngagementTextsTmp) async {
  final response = await http.get(Uri.parse(filename));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    EngagementText tmp = EngagementText.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
    futureEngagementTextsTmp[index] = tmp;
//    futureEngagementTextsTmp.insert(index, tmp);
    return tmp;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Engagement Text');
  }
}
