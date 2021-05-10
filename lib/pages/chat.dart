import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/Item.dart';
import 'package:intelligent_construction/component/message.dart';
import 'package:intelligent_construction/utils/request.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MessagesProvider provider = Provider.of<MessagesProvider>(context);
    provider.startListen();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: provider.currentUser != -1
                    ? provider.chatUsers[provider.currentUser].chatHis
                        .map((e) => MessageComponent(e.content, e.fromSelf))
                        .toList()
                    : [],
              )),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        labelText: "发送内容",
                        labelStyle: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 12,
                        ),
                        hintText: "请输入...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                  )),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        String message = controller.text;
                        controller.text = '';
                        provider.sentMessageTo(provider.currentUser, message);
                      })
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          decoration: BoxDecoration(
              border:
                  Border(left: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: ListView(
              children: provider.chatUsers.values
                  .map(
                    (commUser) => Card(
                      margin: EdgeInsets.zero,
                      child: MaterialButton(
                        textColor: commUser.id == provider.currentUser
                            ? Colors.blue
                            : Colors.black54,
                        child: Text(commUser.name),
                        onPressed: () {
                          provider.setCurrentUser(commUser.id);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  )
                  .toList()),
        ),
      ],
    );
  }
}
