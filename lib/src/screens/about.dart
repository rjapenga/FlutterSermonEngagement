import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import '../models/my_globals.dart';
import '../models/se_widgets.dart';
//import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    String about = '<div style="color:white;">'
        '<h2>Native Build Version : ${packageInfo.buildNumber}</h2><br>'
        '<h2>Native App Version : ${packageInfo.version}</h2><br>'
//        '<h2>Device Name : Bob\'s A135</h2><br>'
//        '<h2>Device Year Class: 2014</h2><br>'
        '<h2>Device Manufacturer : ${androidDeviceInfo.manufacturer}</h2><br>'
        '<h2>Device Model Name : ${androidDeviceInfo.model}</h2><br>'
        '<h2>OS Version : ${deviceData['systemVersion']}</h2><br>'
        '</div>';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: seLinearGradient(),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: seBorder(),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HtmlWidget(
                  about,
                  renderMode: RenderMode.column,
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
