import 'dart:async';

import 'package:discord_api_chat/app/app_module.dart';
import 'package:discord_api_chat/app/shared/global/get_bloc.dart';
import 'package:discord_api_chat/app/shared/global/post_bloc.dart';
import 'package:discord_api_chat/app/shared/models/attachments_model.dart';
import 'package:discord_api_chat/app/shared/models/embeds_model.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
import 'package:discord_api_chat/app/shared/models/thumbnail_model.dart';
import 'package:flutter/material.dart';

import '../../app_module.dart';
import '../../shared/global/post_bloc.dart';
import '../../shared/models/message_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Controller formController;

  var blocPost = AppModule.to.bloc<PostBloc>();

  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    AppModule.to.bloc<AppBloc>().requisition();
    formController = Controller();
    // defines a timer
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      //setState(() {
      AppModule.to.bloc<AppBloc>().requisition();
      //});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.replay),
        //   onPressed: () => AppModule.to.bloc<AppBloc>().requisition(),
        // ),
        title: Text('Discord-Api-Chat'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MessageModel>>(
          stream: AppModule.to.bloc<AppBloc>().saida,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.085),
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            MessageModel item = snapshot.data[index];

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
                                      style: TextStyle(
                                          color: Colors.deepPurple[800],
                                          fontSize: 16)),
                                  subtitle: Text(
                                    //        (item.content.contains('<@!>')) ?
                                    // item.content.replaceAll('<@! >', item.mentions[0].username):
                                    item.content,

                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey[800]),
                                  ),
                                  
                                ),
                                  item.attachments.length > 0 //|| 
                                    ? Image.network(item.attachments[0].url) 
                                    : item.embeds.length > 0 ?
                                    Image.network(item.embeds[0].image.url) 
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      )
                                //snapshot.data.contains('attachments') ?
                              ],
                            );
                          },
                        ),
                      ),
                      StreamBuilder<int>(
                          stream: blocPost.saida,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) blocPost.entrada.add(null);

                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    elevation: 0.0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Form(
                                            key: formController.formKey,
                                            child: TextFormField(
                                              controller: _controller,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Escreva alguma coisa',
                                              ),
                                              validator: (value) =>
                                                  value.isEmpty
                                                      ? 'Deve escrever algo...'
                                                      : null,
                                              onSaved: (value) =>
                                                  blocPost.content = value,
                                              onFieldSubmitted: (_) async {
                                                if (formController.validade()) {
                                                  _controller.clear();

                                                  blocPost.entrada.add(
                                                    MessageModel(
                                                      content: blocPost.content,
                                                      embed: Embeds(
                                                        title: 'Embed message',
                                                        description: 'hdhdhdhd',
                                                        image: Thumbnail(
                                                            url:
                                                                'https://i.pinimg.com/originals/ce/2b/27/ce2b274fa68d234865a6abf69644f472.png'),
                                                      ),
                                                    ),
                                                  );

                                                  blocPost.content = null;
                                                  blocPost.entrada.add(null);
                                                }
                                              },
                                            ),
                                          ),
                                          height: 50,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () async {
                                            if (formController.validade()) {
                                              _controller.clear();

                                              blocPost.entrada.add(
                                                MessageModel(
                                                  content: blocPost.content,
                                                  embed: Embeds(
                                                    image: Thumbnail(
                                                        url:
                                                            'https://i.pinimg.com/originals/ce/2b/27/ce2b274fa68d234865a6abf69644f472.png'),
                                                  ),
                                                ),
                                              );

                                              blocPost.content = null;
                                              blocPost.entrada.add(null);
                                            }
                                          },
                                          color: Colors.purple,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  @override
  void dispose() {
    blocPost.dispose();
    super.dispose();
  }
}

class Controller {
  var formKey = GlobalKey<FormState>();

  bool validade() {
    var formState = formKey.currentState;

    if (formState.validate()) {
      formState.save();
      return true;
    } else
      return false;
  }
}
