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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: Text('Discord-Api-Chat'),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            StreamBuilder<List<MessageModel>>(
                stream: AppModule.to.bloc<AppBloc>().saida,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Padding(
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
                                message: item,
                              );
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                }),
            Align(
              alignment: Alignment.bottomCenter,
              // bottom: 0,
              // top: MediaQuery.of(context).size.height * 0.783,
              // left: 0,
              // right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1.0,
                        color: Colors.black12,
                        blurRadius: 3.0),
                  ],
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: blocPost.saida,
              builder: (context, snapshot) {
                return TextForms(
                  formController: formController,
                  blocPost: blocPost,
                );
              },
            ),
          ],
        ),
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
