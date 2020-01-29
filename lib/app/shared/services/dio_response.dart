import 'package:dio/dio.dart';
import 'package:discord_api_chat/app/shared/models/message_model.dart';
import 'bot_key.dart' as bot;

class DiscordService {
  final Dio dio = Dio();

  Future<List<MessageModel>> responseGet() async {
    List<MessageModel> listMsg = [];

    try {
      Response response = await dio.get(
          'https://discordapp.com/api/channels/619306507242307584/messages?limit=20',
          options: Options(
            headers: {
              'accept': 'application/json',
              'Authorization': bot.BOT_KEY
            },
            contentType: 'application/json',
          ));

      for (var json in response.data) {
        listMsg.add(MessageModel.fromJson(json));
      }
      print(response.data);
      return listMsg;

      // return (response.data as List)
      //     .map((json) => MessageModel.fromJson(json))
      //     .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> responsePost(Map<String, dynamic> formData) async {
    try {
      Response response = await dio.post(
          'https://discordapp.com/api/channels/619306507242307584/messages',
          options: Options(
            headers: {
              'accept': 'application/json',
              'Authorization': bot.BOT_KEY
            },
          ),
          data: formData);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
