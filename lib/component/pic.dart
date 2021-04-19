import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/config.dart';
import 'package:intelligent_construction/utils/request.dart';
import 'package:path_provider/path_provider.dart';

Future<Widget> getPic(pid, height, width) async {
  var response = await api("/pic/get_img", {'id': pid});
  if (!response['success']) {
    return Placeholder(
      fallbackHeight: height,
      fallbackWidth: width,
    );
  }
  var dir = await getApplicationDocumentsDirectory();
  String fileName = response['pic_path'];
  try {
    await Dio().download(
        SERVER_URL + '/static/pics/' + fileName, '${dir.path}/$fileName');
  } catch(Except){}
  print(12323);
  var imgFile = File('${dir.path}/$fileName');
  print(await imgFile.length());
  return Image.file(imgFile);
}

class Pic extends StatelessWidget {
  int pid;
  double width;
  double height;

  Pic(this.pid, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    var future = getPic(pid, height, width);
    print(future);
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Widget> snap) {
        return snap.data;
      },
      future: future,
    );
  }
}
