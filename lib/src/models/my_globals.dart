//import '../models/engagement_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum Music { uninitialized, playing, stopped }

//
List<dynamic> jsonMap = [];
List<dynamic> musicMap = [];
late PackageInfo packageInfo;
//late Future<List<dynamic>> jsonTextRaw;
//int currentSermonIndex = 0;
int maxEngagementIndex = 0;
bool backgroundMusic = false;
bool autoPlay = true;
var deviceData = <String, dynamic>{};
late AndroidDeviceInfo androidDeviceInfo;
int maxEngagementIndexShadow = 0;
Music prevBackgroundPlay = Music.uninitialized;
bool appInitialized = false;
bool playAll = false;
String trackCompleted = "False";
String appBarCurrentTitle = 'Sermons';
