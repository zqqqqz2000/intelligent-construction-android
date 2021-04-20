import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/config.dart';
import 'package:intelligent_construction/utils/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Widget> getPic(pid, height, width) async {
  print(pid);
  bool status = await Permission.storage.isGranted;
  if (!status) {
    await Permission.storage.request().isGranted;
  }
  var response = await api("/pic/get_img", {'id': pid});
  if (!response['success']) {
    return Placeholder(
      fallbackHeight: height,
      fallbackWidth: width,
    );
  }
  var dir = await getApplicationDocumentsDirectory();
  String fileName = response['pic_path'];
  // var imgFile = File('${dir.path}/$fileName');
  // if (await imgFile.exists()) {
  //   print('exists!');
  //   await imgFile.delete(recursive: true);
  // }
  // var responseImg = await Dio().download(
  //   SERVER_URL + '/static/pics/' + fileName,
  //   '${dir.path}/$fileName',
  //   deleteOnError: false,
  // );
  // return Image.file(imgFile);
  return Image.network(STATIC_URL + '/$fileName', errorBuilder: (context, error, trace) {
    print(error);
    return Text("加载失败");
  },);
  // return Placeholder();
}

class Pic extends StatelessWidget {
  int pid;
  double width;
  double height;

  Pic(this.pid, this.width, this.height) {
    print(pid);
  }

  @override
  Widget build(BuildContext context) {
    var future = getPic(pid, height, width);
    return FutureBuilder(
      initialData: Placeholder(
        fallbackHeight: height,
        fallbackWidth: width,
      ),
      builder: (context, AsyncSnapshot<Widget> snap) {
        return Container(
          child: snap.data,
        );
      },
      future: future,
    );
  }
}
