import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/gradient.dart';
import '../screens/sermons.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _optIn = true;
  Future<void> _loadOptIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _optIn = prefs.getBool('optIn') ?? true;
    });
  }

  Future<void> _setOptIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('optIn', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadOptIn();
    return Scaffold(
        appBar: AppBar(
          title: Text("Analytics"),
        ),
        body: GradientBackground(
            gradient: LinearGradient(
              begin: Alignment(0, -1.0),
              end: Alignment(0, 1.0),
              colors: <Color>[
                Color.fromARGB(255, 17, 88, 241),
                Color.fromRGBO(7, 40, 147, 1),
                Color.fromARGB(255, 4, 4, 90),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "This app records data analytics about how the app is used. There is no connection"
                      " or linking between the recorded usage and your identity."
                      " You can opt out of this data collecting if you choose"
                      " by clicking on Opt Out of Data Analytics.",
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.black,
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: const Color.fromARGB(255, 4, 4, 90)),
                    onPressed: !_optIn
                        ? null
                        : () {
                            // Set Opt In False
                            _setOptIn(false);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Sermons(),
                              ),
                            );
                          },
                    child: Text(
                      'Opt Out',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 4, 4, 90),
                          fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.black,
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: const Color.fromARGB(255, 4, 4, 90)),
                    onPressed: _optIn
                        ? null
                        : () {
                            // Set Opt In
//                            print(_optIn);
                            _setOptIn(true);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Sermons(),
                              ),
                            );
                          },
                    child: Text(
                      'Opt In',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 4, 4, 90),
                          fontSize: 24),
                    ),
                  ),
                ])));
  }
}
