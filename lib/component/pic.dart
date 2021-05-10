import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/config.dart';
import 'package:intelligent_construction/utils/request.dart';

Future<Widget> getPic(pid, height, width) async {
  print(pid);
  var response = await api("/pic/get_img", {'id': pid});
  if (!response['success']) {
    return Placeholder(
      fallbackHeight: height,
      fallbackWidth: width,
    );
  }
  String fileName = response['pic_path'];
  return Image.network(STATIC_URL + '/$fileName', errorBuilder: (context, error, trace) {
    print(error);
    return Text("加载失败");
  },);
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
