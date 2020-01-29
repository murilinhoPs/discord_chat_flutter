import 'package:discord_api_chat/app/shared/models/thumbnail_model.dart';

class Embeds {
  String url;
  String title;
  String description;
  Thumbnail thumbnail;
  Thumbnail image;

  Embeds({this.url, this.title, this.description, this.thumbnail, this.image});

  Embeds.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    description = json['description'];
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    image =
        json['image'] != null ? new Thumbnail.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }
}
