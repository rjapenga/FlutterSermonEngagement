import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//import 'package:google_fonts/google_fonts.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  @override
  Widget build(BuildContext context) {
    String manual = '<div style="color:white;">'
        '<h1>Instructions</h1><br>'
        '<h2>From the Current Sermons Screen you can:</h2><br>'
        '<h3 style="color:yellow;">&bullet; Select the Particular Sermon</h3><br>'
        '<h2>From the Engagments Screen you can:</h2><br>'
        '<h3 style="color:yellow;">&bullet; Select the Particular part of the Sermon (the Engagement) OR</h3><br>'
        '<h3 style="color:yellow;">&bullet; Go back to select another Sermon</h3><br>'
        '<h2>From the Engagement Screen you can:</h2><br>'
        '<h3 style="color:yellow;">&bullet; Play or Pause the Audio</h3><br>'
        '<h3 style="color:yellow;">&bullet; Select the Next or Previous Engagement</h3><br>'
        '<h3 style="color:yellow;">&bullet; Select a Resource from an Engagement. Either a link at the end or a link embedded in the text</h3><br>'
        '<h3 style="color:yellow;">&bullet; Go Back to select another Engagement</h3><br>'
        '<h2>Modify the Settings from the Settings Screen</h2><br>'
        '<h2><b>NOTE: The icon represents the status - the words represent the action of the button. They are always the opposite.</h2><br>'
        '<h3 style="color:yellow;">&bullet; Enable/Disable the Background Music</h3>'
        '<h3 style="color:yellow;">&bullet; Opt in or Opt out of Data Analytics</h3>'
        '<h3 style="color:yellow;">&bullet; With a Password, change the cloud settings</h3>'
        '<h3 style="color:yellow;">&bullet; Enable the ability to play all Engagements for a particular Sermon</h3>'
        '<h3 style="color:yellow;">&bullet; Enable the Audio to automatically start on an Engagement</h3>'
        '<h2>With a Bluetooth device (like a headset) you can</h2><br>'
        '<h3 style="color:yellow;">&bullet; Pause or Play the selected Engagement</h3>'
        '<h3 style="color:yellow;">&bullet; Select the Next or Previous Engagement</h3>'
        '<h3 style="color:yellow;">&bullet; Increase or Decrease the Volume</h3>'
        '</div>';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.5, 1),
                      colors: <Color>[
                        Color.fromARGB(255, 0, 0, 200),
                        Color.fromARGB(255, 59, 89, 152),
                        Color.fromARGB(255, 27, 46, 106),
                      ], // Gradient from https://learnui.design/tools/gradient-generator.html
                      tileMode: TileMode.mirror,
                    ),
                  ),
//                  margin: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HtmlWidget(
                        manual,
                        renderMode: RenderMode.column,
                        textStyle:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
