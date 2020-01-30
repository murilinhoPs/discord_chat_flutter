import 'attachments_model.dart';
import 'author_model.dart';
import 'embeds_model.dart';
import 'mentions_model.dart';

class MessageModel {
  String id;
  String content;
  String channelId;
  Author author;
  List<Attachments> attachments;
  Embeds embed;
  List<Embeds> embeds;
  List<Mentions> mentions;

  MessageModel(
      {this.id,
      this.content,
      this.channelId,
      this.author,
      this.attachments,
      this.embed,
      this.embeds,
      this.mentions});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    channelId = json['channel_id'];
    if (json['embeds'] != null) {
      embeds = new List<Embeds>();
      json['embeds'].forEach((v) {
        embeds.add(new Embeds.fromJson(v));
      });
    }
// Author
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
// Attachments
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
// Embeds

    embed =
        json['embed'] != null ? new Embeds.fromJson(json['embed']) : null;

// Mentions
    if (json['mentions'] != null) {
      mentions = new List<Mentions>();
      json['mentions'].forEach((v) {
        mentions.add(new Mentions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['channel_id'] = this.channelId;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.embed != null) {
      data['embed'] = this.embed.toJson();
    }
    if (this.mentions != null) {
      data['mentions'] = this.mentions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
