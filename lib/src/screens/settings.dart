//import 'dart:math';

import 'package:flutter/material.dart';
import '../components/gradient.dart';
import '../models/se_widgets.dart';
import '../models/my_globals.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _firstTime = true;
  bool _playAll = true;
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

  Future<void> _loadBackgroundMusic() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundMusic = prefs.getBool('backgroundMusic') ?? true;
    });
  }

  Future<void> _setBackgroundMusic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('backgroundMusic', value);
    });
  }

  Future<void> _loadPlayAll() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _playAll = prefs.getBool('playAll') ?? true;
    });
  }

  Future<void> _setPlayAll(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playAll = value;
      prefs.setBool('playAll', value);
    });
  }

  Future<void> _loadFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTime = prefs.getBool('firstTime') ?? true;
    });
  }

  Future<void> _setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('firstTime', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadOptIn();
    _loadBackgroundMusic();
    _loadFirstTime();
    _loadPlayAll();
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
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
              //tileMode: TileMode.mirror,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      backgroundMusic ? Icons.music_note : Icons.music_off,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    label: backgroundMusic
                        ? seText('Disable Background Music', 24, Colors.white)
                        : seText('Enable Background Music', 24, Colors.white),
                    onPressed: () {
                      if (backgroundMusic) {
                        _setBackgroundMusic(false);
                      } else {
                        _setBackgroundMusic(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.black,
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: const Color.fromARGB(255, 4, 4, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      _playAll ? Icons.stop_circle : Icons.repeat,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    label: _playAll
                        ? seText('Disable PlayAll', 24, Colors.white)
                        : seText('Enable PlayAll', 24, Colors.white),
                    onPressed: () {
                      if (_playAll) {
                        _setPlayAll(false);
                      } else {
                        _setPlayAll(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.black,
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: const Color.fromARGB(255, 4, 4, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      _optIn ? Icons.flashlight_off : Icons.flashlight_on,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    label: _optIn
                        ? seText('Opt Out of Data Analytics', 24, Colors.white)
                        : seText('Opt In of Data Analytics', 24, Colors.white),
                    onPressed: () {
                      if (_optIn) {
                        _setOptIn(false);
                      } else {
                        _setOptIn(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.black,
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: const Color.fromARGB(255, 4, 4, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.build,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    label: seText('Configuration', 24, Colors.white),
                    onPressed: () {
                      if (_firstTime) {
                        _setFirstTime(false);
                      } else {
                        _setFirstTime(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.black,
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: const Color.fromARGB(255, 4, 4, 90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ])));
  }
}
