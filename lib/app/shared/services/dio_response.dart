import 'package:dio/dio.dart';

class DiscordService {
  final Dio dio = Dio();

  responseGet() async {
    Response response = await dio.get(
      '',
      options: Options(
        headers: {'accept': "application/json", 'Authorization': 'BOT_KEY'},
      ),
    );
    return response.data;
  }
}
