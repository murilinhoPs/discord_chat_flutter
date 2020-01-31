import 'package:flutter/material.dart';

import '../../../shared/models/message_model.dart';

class MessageTile extends StatelessWidget {
  MessageTile({this.item});

  final MessageModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Hero(
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://cdn.discordapp.com/avatars/${item.author.id}/${item.author.avatar}.png'),
            ),
            tag: item.author.username,
          ),
          title: Text(item.author.username,
              style: TextStyle(color: Colors.deepPurple[800], fontSize: 16)),
          subtitle: Text(
            //        (item.content.contains('<@!>')) ?
            // item.content.replaceAll('<@! >', item.mentions[0].username):
            item.content,

            style: TextStyle(fontSize: 17, color: Colors.grey[800]),
          ),
        ),
        item.attachments.length > 0 //||
            ? Image.network(item.attachments[0].url)
            : item.embeds.length > 0
                ? Image.network(item.embeds[0].image.url)
                : Container(
                    height: 0,
                    width: 0,
                  )
        //snapshot.data.contains('attachments') ?
      ],
    );
  }
}
