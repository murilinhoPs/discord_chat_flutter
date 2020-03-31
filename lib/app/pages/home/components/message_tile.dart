import 'package:discord_api_chat/app/shared/global/text_field_bloc.dart';
import 'package:flutter/material.dart';

import '../../../app_module.dart';
import '../../../shared/models/message_model.dart';

class MessageTile extends StatelessWidget {
  MessageTile({this.message});

  final MessageModel message;

  final String botUser = 'HelpBot';

  _blocData() {
    AppModule.to.bloc<TextBloc>().changeFormData('@${message.author.username}');

    AppModule.to.bloc<TextBloc>().idEntry.add('<@${message.author.id}>');
  }

  @override
  Widget build(BuildContext context) {
    String _contentText(MessageModel msg) {
      return (msg.content.contains('<@!'))
          ? msg.content.replaceAll(
              '<@!${msg.mentions[0].id}>', '@${msg.mentions[0].username}')
          : (msg.content.contains('<@'))
              ? msg.content.replaceAll(
                  '<@${msg.mentions[0].id}>', '@${msg.mentions[0].username}')
              : msg.content;
    }

    _contentImage(MessageModel file) {
      return file.attachments.length > 0
          ? Image.network(file.attachments[0].url)
          : file.embeds.length > 0
              ? Image.network(file.embeds[0].image.url)
              : Container(
                  height: 0,
                  width: 0,
                );
    }

    _contentAlignmentUser() {
      return Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              child: CircleAvatar(
                minRadius: 22,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn.discordapp.com/avatars/${message.author.id}/${message.author.avatar}.png'),
              ),
              tag: message.author.username,
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.author.username,
                  style: TextStyle(color: Colors.deepPurple[800], fontSize: 18),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    _contentText(message),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
                _contentImage(message)
              ],
            ),
          ],
        ),
      );
    }

    _contentAlignmentBot() {
      return Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  message.author.username,
                  style: TextStyle(color: Colors.deepPurple[800], fontSize: 18),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    _contentText(message),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
                _contentImage(message)
              ],
            ),
            SizedBox(width: 8.0),
            Hero(
              child: CircleAvatar(
                minRadius: 22,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn.discordapp.com/avatars/${message.author.id}/${message.author.avatar}.png'),
              ),
              tag: message.author.username,
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => _blocData(),
          child: message.author.username == 'HelpBot'
              ? Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: _contentAlignmentBot(),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: _contentAlignmentUser(),
                ),
        ),
      ],
    );
  }
}
