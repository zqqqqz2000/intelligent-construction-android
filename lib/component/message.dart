import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageComponent extends StatelessWidget {
  String content;
  bool selfSend;

  MessageComponent(this.content, this.selfSend);

  @override
  Widget build(BuildContext context) {
    Widget maxPadding = Expanded(child: Container());
    List<Widget> rowChildWidgets = [];
    if (selfSend) rowChildWidgets.add(maxPadding);
    rowChildWidgets.add(Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          content,
        ),
      ),
    ));
    if (!selfSend) rowChildWidgets.add(maxPadding);
    return Row(
      children: rowChildWidgets,
    );
  }
}
