/*import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'sermon_list.freezed.dart';
part 'sermon_list.g.dart';

/// The response of the `GET /api/activity` endpoint.
///
/// It is defined using `freezed` and `json_serializable`.
@freezed
class Engagement {
  String title;
  String textA;
  String audioA;

  Engagement({
    required this.title,
    required this.textA,
    required this.audioA,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) => Engagement(
        title: json["title"],
        textA: json["text_a"],
        audioA: json["audio_a"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text_a": textA,
        "audio_a": audioA,
      };
}

class Activity with _$Activity {
  factory Activity({
    required int id,
    required String series,
    required String title,
    required String date,
    required List<Engagement> engagements,
  }) = $Activity;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

class Instruction {
  int id;
  String series;
  String title;
  DateTime date;
  List<Engagement> engagements;

  Instruction({
    required this.id,
    required this.series,
    required this.title,
    required this.date,
    required this.engagements,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        id: json["id"],
        series: json["series"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        engagements: List<Engagement>.from(
            json["engagements"].map((x) => Engagement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "series": series,
        "title": title,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "engagements": List<dynamic>.from(engagements.map((x) => x.toJson())),
      };
}

*/