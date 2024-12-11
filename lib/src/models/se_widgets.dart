import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

//import '../models/track.dart';
/*
Track track = Track(
  id: "track1",
  title: "Introduction / Scripture",
  artist: "Kyle",
  date: "2024-09-08",
  audioUrl:
      "https://ListeningToGod.org/SermonEngagement/AudioFiles/2024-09-080Ia.mp3",
  imageUrl:
      "https://ListeningToGod.org/SermonEngagement/Images/WithGodTitle.jpg",
);
*/
BoxDecoration seBoxDecoration() {
  return BoxDecoration(
    gradient: seLinearGradient(),
  );
}

Container seContainer(String s) {
  return Container(
    decoration: seBoxDecoration(),
    child: Center(
      child: Column(
        children: [
          HtmlWidget(
            s,
          ),
        ],
      ),
    ),
  );
}

Border seBorder() {
  return const Border(
    top: BorderSide(
        width: 2, color: Colors.white, style: BorderStyle.solid), //BorderSide
    bottom: BorderSide(
        width: 2, color: Colors.white, style: BorderStyle.solid), //BorderSide
    left: BorderSide(
        width: 2, color: Colors.white, style: BorderStyle.solid), //Borderside
    right: BorderSide(
        width: 2, color: Colors.white, style: BorderStyle.solid), //BorderSide
  ); //Bor
}

LinearGradient seLinearGradient() {
  return const LinearGradient(
    begin: Alignment(0, -1.0),
    end: Alignment(0, 1.0),
    colors: <Color>[
      Color.fromARGB(255, 17, 88, 241),
      Color.fromRGBO(7, 40, 147, 1),
      Color.fromARGB(255, 4, 4, 90),
    ], // Gradient from https://learnui.design/tools/gradient-generator.html
    tileMode: TileMode.mirror,
  );
}

Text seText(String text, double size, Color? color) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.lato(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );
}
