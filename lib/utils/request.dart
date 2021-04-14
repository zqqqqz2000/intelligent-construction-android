import 'package:dio/dio.dart';
import 'package:intelligent_construction/config.dart';

api(String path, data) async {
  var response = await Dio().post(
    SERVER_URL + path,
    data: data,
    options: Options(
      headers: {
        'content': Headers.jsonContentType, // set content-length
      },
    ),
  );
  var responseBody = response.data;
  return responseBody;
}
