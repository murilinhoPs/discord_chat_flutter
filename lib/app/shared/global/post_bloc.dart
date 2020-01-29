import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
import 'package:discord_api_chat/app/shared/services/dio_response.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends BlocBase {
  final _service = DiscordService();

  final _controller$ = BehaviorSubject<MessageModel>();

  String content;

  MessageModel get messageValue => _controller$.value;
  Stream<int> get saida => _controller$.switchMap(streamPost);
  Sink<MessageModel> get entrada => _controller$.sink;

  Stream<int> streamPost(MessageModel data) async* {
    yield 0;
    try {
      final response = await _service.responsePost(data.toJson());
      yield response;
    } catch (e) {
      _controller$.addError(e);
    }
  }

  @override
  void dispose() {
    _controller$.close();
    super.dispose();
  }
}
