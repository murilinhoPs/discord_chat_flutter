import 'dart:async';

import 'package:discord_api_chat/app/app_module.dart';
import 'package:discord_api_chat/app/shared/global/get_bloc.dart';
import 'package:discord_api_chat/app/shared/global/post_bloc.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var estado = {};

  String _now;
  Timer _everySecond;

  Controller form_controller;

  var blocPost = AppModule.to.bloc<PostBloc>();

  @override
  void initState() {
    AppModule.to.bloc<AppBloc>().requisition();

    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
        AppModule.to.bloc<AppBloc>().requisition();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.replay),
          onPressed: () => AppModule.to.bloc<AppBloc>().requisition(),
        ),
        title: Text('title'),
      ),
      body: StreamBuilder<List<MessageModel>>(
          stream: AppModule.to.bloc<AppBloc>().saida,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: false,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            MessageModel item = snapshot.data[index];
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  selected: true,
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
                                    item.content,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey[800]),
                                  ),
                                ),
                                item.attachments.length > 0
                                    ? Image.network(item.attachments[0].url)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                //snapshot.data.contains('attachments') ?
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: Card(
                                  child: Form(
                                    child: TextFormField(),
                                  ),
                                  elevation: 5.0,
                                ),
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.7,
                              ),
                              FloatingActionButton(
                                child: Icon(Icons.send),
                                onPressed: () {},
                                backgroundColor: Colors.purple,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class Controller {
  final formKey = GlobalKey<FormState>();

  bool validade() {
    var formState = formKey.currentState;

    if (formState.validate()) {
      formState.save();
      return true;
    } else
      return false;
  }
}
