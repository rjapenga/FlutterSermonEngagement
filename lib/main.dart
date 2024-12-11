import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
//import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:just_audio/just_audio.dart';
//import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:audio_session/audio_session.dart';
//import 'package:device_marketing_names/device_marketing_names.dart';
import './src/models/my_globals.dart';
import './src/screens/analytics.dart';
import './src/screens/sermons.dart';
import './src/components/common.dart';

Future<void> main() async {
  //Provides the [init] method to initialise just_audio for background playback
  //This package plugs into just_audio to add background playback support and remote controls
  //(notification, lock screen, headset buttons, smart watches, Android Auto and CarPlay).
  //It supports the simple use case where an app has a single AudioPlayer instance.
/*  await JustAudio.init(
    // Just doin' what they tell me https://github.com/ryanheise/just_audio/blob/minor/just_audio_background/README.md
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );*/
  var url = Uri.parse(
      'https://ListeningToGod.org/SermonEngagement/SermonEngagement53.json');
  var response = await http.get(url);
  jsonMap = jsonDecode(response.body) as List<dynamic>;
  var url1 = Uri.parse(
      'https://ListeningToGod.org/SermonEngagement/EngagementMusic07.json');
  var response1 = await http.get(url1);
  musicMap = jsonDecode(response1.body) as List<dynamic>;
  // prevBackgroundMusic is initially uninitialized
  // backgroundMusic is initialially uninitialized
  // Once backgroundMusic is read from storage - prevBackground takes on that value
  // How to know when backgroundMusic has been initialized?
  // backgroundMusic is read in from non-volitile storage true or false
/*  if (backgroundMusicTmp == true) {
    backgroundMusic = Music.uninitialized;
  } else {
    backgroundMusic = Music.stopped;
  }*/
  //initBackgroundMusic();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _firstTime = true;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // ignore: unused_field
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  /// Load the initial counter value from persistent storage on start,
  /// or fallback to 0 if it doesn't exist.
  Future<void> _loadFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTime = prefs.getBool('firstTime') ?? true;
    });
    backgroundMusic = prefs.getBool('backgroundMusic') ?? false;
    playAll = prefs.getBool('playAll') ?? false;
  }

  Future<PackageInfo> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'systemVersion': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'systemName': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initPlatformState() async {
    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS =>
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        TargetPlatform.linux => <String, dynamic>{
            'Error:': 'Linux platform isn\'t supported'
          },
        TargetPlatform.windows => <String, dynamic>{
            'Error:': 'Windows platform isn\'t supported'
          },
        TargetPlatform.macOS => <String, dynamic>{
            'Error:': 'Windows platform isn\'t supported'
          },
        TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
      };
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Future<void> initialize() async {
    await _loadFirstTime();
    await _init();
    packageInfo = await getVersionInfo();
    final deviceInfo = DeviceInfoPlugin();
    androidDeviceInfo = await deviceInfo.androidInfo;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
//    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//      statusBarColor: Colors.black,
//    ));
    initialize();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.

    //@override
    // TODO where does this go
    //
    /*
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.paused) {
        // Release the player's resources when not in use. We use "stop" so that
        // if the app resumes later, it will still remember what position to
        // resume from.
        //_player.stop();
      } 
    } */
  }

/*
  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
      A one-line description used by the device to identify the app for the user.
      On Android the titles appear above the task manager's app snapshots which are displayed 
      when the user bsses the "recent apps" button. On iOS this value cannot be used. 
      CFBundleDisplayName from the app's Info.plist is referred to instead whenever present, 
      CFBundleName otherwise.  
      */
      title: 'Sermon Engagement',
      //Turns on a little "DEBUG" banner in debug mode to indicate that the app is in debug mode.
      debugShowCheckedModeBanner: false,
      // Home Screen
      // ignore: dead_code
      home: _firstTime ? AnalyticsScreen() : Sermons(),
      builder: (context, child) {
        return Material(
          child: Column(
            children: [
              Expanded(child: child!),
            ],
          ),
        );
      },
    );
  }
}
