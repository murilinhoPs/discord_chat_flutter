import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:discord_api_chat/app/shared/global/get_bloc.dart';
import 'package:discord_api_chat/app/shared/global/post_bloc.dart';
import 'package:discord_api_chat/app/shared/global/text_field_bloc.dart';
import 'package:flutter/widgets.dart';

import 'app_widget.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (_) => AppBloc(),
        ),
        Bloc(
          (_) => PostBloc(),
        ),
        Bloc(
          (_) => TextBloc(),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
