class Project {
  int id;
  String name;
  String describe;
  int scale;
  int cost;
  int complete_per;
  int pic;
  double lng;
  double lat;
}

class Process {
  int id;
  int pid;
  String comment;
  int update_uid;
  int pic;
  String date;
}

class Message {
  Message(this.fromSelf, this.content);
  bool fromSelf;
  String content;
}

class ChatUser {
  int id;
  int unread;
  String name;
  String title;
  List<Message> chatHis;
}
