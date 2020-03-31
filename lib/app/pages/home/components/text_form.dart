import 'package:discord_api_chat/app/shared/global/text_field_bloc.dart';
import 'package:flutter/material.dart';

import '../../../app_module.dart';
import '../../../shared/models/message_model.dart';
import '../home_widget.dart';

class TextForms extends StatelessWidget {
  TextForms({this.formController, this.blocPost});

  final TextEditingController controller = TextEditingController();
  final blocPost;

  final Controller formController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 2,
        child: Card(
          elevation: 0.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: formController.formKey,
                  child: StreamBuilder<String>(
                      stream: AppModule.to.bloc<TextBloc>().saida,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          controller.text = '${snapshot.data}';
                        // ${ChatModule.to.bloc<TextBloc>().idValue}';

                        return TextFormField(
                          maxLines: 5,
                          controller: controller,
                          style: TextStyle(decoration: TextDecoration.none),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(decoration: TextDecoration.none),
                            hintText: 'Escreva alguma coisa',
                          ),
                          autocorrect: false,
                          expands: false,
                          validator: (value) =>
                              value.isEmpty ? 'Deve escrever algo...' : null,
                          onSaved: (value) => blocPost.content = value,
                          onFieldSubmitted: (_) => _onSubmitt(context),
                        );
                      }),
                ),
                height: 50,
              ),
              IconButton(
                icon: Icon(Icons.send),
                iconSize: 25,
                onPressed: () => _onSubmitt(context),
                color: Colors.purple,
              )
            ],
          ),
        ),
      ),
    );
  }

  _onSubmitt(context) {
    if (formController.validade()) {
      var ctrlText = controller.text;
      if (ctrlText.startsWith('@')) {
        var edit = ctrlText.split(' ')[0];

        var fim =
            ctrlText.replaceAll(edit, AppModule.to.bloc<TextBloc>().idValue);

        print(edit + fim);

        blocPost.content = fim;

        blocPost.entrada.add(
          MessageModel(
            content: blocPost.content,
          ),
        );

        AppModule.to.bloc<TextBloc>().entrada.add(null);
        AppModule.to.bloc<TextBloc>().idEntry.add(null);

        controller.clear();

        blocPost.content = null;
      }

      blocPost.entrada.add(
        MessageModel(
          content: blocPost.content,
        ),
      );

      AppModule.to.bloc<TextBloc>().entrada.add(null);
      AppModule.to.bloc<TextBloc>().idEntry.add(null);

      controller.clear();

      blocPost.content = null;
    }
  }
}
