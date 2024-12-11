import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final filename = <String>[
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-060Ia.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0601a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0602a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0603a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0604a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0605a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0606a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0607a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0608a.json",
  "https://ListeningToGod.org/SermonEngagement/TextFiles/2024-10-0609a.json",
];

Future<bool> _checkUrl(String url) async {
  http.Response urlResponse = await http.get(Uri.parse(url));
  if (urlResponse.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<int> getMaxEngagementIndex() async {
  int index = 0;
  for (int i = 0; i < 10; i++) {
    String engagementFileName = filename[i];
    await _checkUrl(engagementFileName).then((filePresent) {
      if (filePresent) {
        index++;
      }
    });
  }
  return index;
}

Future<void> main() async {
  int numfiles = await getMaxEngagementIndex();
  String num = numfiles.toString();
  runApp(MyApp(num));
}

class MyApp extends StatelessWidget {
  final String numfiles;
  const MyApp(this.numfiles, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: Center(
          child: Text('Num Files =$numfiles'),
        ),
      ),
    );
  }
}
