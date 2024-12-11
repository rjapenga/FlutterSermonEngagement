class EngagementText {
  String? version;
  String? date;
  String? text;
  List<Links>? links;

  EngagementText({this.version, this.date, this.text, this.links});

  EngagementText.fromJson(Map<String, dynamic> json) {
    try {
      version = json['version'];
      date = json['date'];
      text = json['text'];
      if (json['links'] != null) {
        links = <Links>[];
        json['links'].forEach((v) {
          links!.add(Links.fromJson(v));
        });
      }
    } catch (e) {
      date = "2024-01-01";
      text = "Dummy Text";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['date'] = date;
    data['text'] = text;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links {
  String? link;
  String? text;

  Links({this.link, this.text});

  Links.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['text'] = text;
    return data;
  }
}
