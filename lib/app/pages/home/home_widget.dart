import 'dart:async';

import 'package:discord_api_chat/app/app_module.dart';
import 'package:discord_api_chat/app/pages/home/components/message_tile.dart';
import 'package:discord_api_chat/app/pages/home/components/text_form.dart';
import 'package:discord_api_chat/app/shared/global/get_bloc.dart';
import 'package:discord_api_chat/app/shared/global/post_bloc.dart';
//import 'package:discord_api_chat/app/shared/models/embeds_model.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
//import 'package:discord_api_chat/app/shared/models/thumbnail_model.dart';
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

  final blocPost = AppModule.to.bloc<PostBloc>();

  @override
  void initState() {
    AppModule.to.bloc<AppBloc>().requisition();

    formController = Controller();

    // defines a timer
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      AppModule.to.bloc<AppBloc>().requisition();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discord-Api-Chat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<List<MessageModel>>(
            stream: AppModule.to.bloc<AppBloc>().saida,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.085),
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              MessageModel item = snapshot.data[index];

                              return MessageTile(
                                item: item,
                              );
                            },
                          ),
                        ),
                        StreamBuilder<int>(
                          stream: blocPost.saida,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) blocPost.entrada.add(null);

                            return TextForms(
                              formController: formController,
                              blocPost: blocPost,
                            );
                          },
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  @override
  void dispose() {
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
