import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
import 'package:discord_api_chat/app/shared/services/dio_response.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends BlocBase {
  final _service = DiscordService();

  final _controller$ = BehaviorSubject<MessageModel>();

  String content;

  Stream<int> get saida => _controller$.switchMap(streamPost);
  Sink<MessageModel> get entrada => _controller$.sink;

  streamPost(MessageModel data) async {

    try {
      final response = await _service.responsePost(data.toJson());
      print(response);
      print(data.toJson());
      return response;
      //yield response;
    } catch (e) {
      print(e);
      _controller$.addError(e);
    }
  }

  @override
  void dispose() {
    _controller$.close();
    super.dispose();
  }
}
