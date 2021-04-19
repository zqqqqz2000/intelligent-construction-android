import 'package:dio/dio.dart';
import 'package:intelligent_construction/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

api(String path, data, {withToken = false}) async {
  var per = await SharedPreferences.getInstance();
  if (withToken)
    data['token'] = per.getString('token');
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

imgUp(String filePath) async {
  var filename = filePath.split('/')[filePath.split('/').length - 1];
  FormData formData = FormData.fromMap(
      {"pic": await MultipartFile.fromFile(filePath, filename: filename)});

  Dio dio = new Dio();
  var response = await dio.post(SERVER_URL + '/pic/upload', data: formData);
  var responseBody = response.data;
  return responseBody;
}
