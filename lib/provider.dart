import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intelligent_construction/Item.dart';
import 'utils/request.dart';

class Projects extends ChangeNotifier {
  List<Project> _projects;

  List<Project> getProjects() {
    return _projects;
  }

  void setProjects(List<Project> projects) {
    this._projects = projects;
    notifyListeners();
  }
}

class CurrentProject extends ChangeNotifier {
  Project _currentProject;

  Project getProject() {
    return _currentProject;
  }

  void setProject(Project project) {
    this._currentProject = project;
    notifyListeners();
  }
}

class Processes extends ChangeNotifier {
  List<Process> _processes = [];

  List<Process> getProcesses() {
    return _processes;
  }

  void setProcesses(List<Process> processes) {
    this._processes = processes;
    notifyListeners();
  }
}

class MessagesProvider extends ChangeNotifier {
  Map<int, ChatUser> chatUsers = {};
  int currentUser = -1;
  bool start = false;

  void startListen() async {
    if (start) return;
    var response =
        await api('/communicate/get_chat_users', {}, withToken: true);
    List<dynamic> uids = response['uid'];
    List<ChatUser> userList = [];
    for (var uid in uids) {
      var uInfoResponse = await api(
          '/communicate/get_communicate_account_info',
          Map<String, dynamic>.from({
            'uid': uid,
          }),
          withToken: true);
      uInfoResponse = uInfoResponse['info'];
      ChatUser user = ChatUser();
      user.id = uid;
      user.unread = 0;
      user.chatHis = [];
      user.name = uInfoResponse['username'];
      user.title = uInfoResponse['role'];
      userList.add(user);
    }
    setChatUsers(userList);
    start = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var id in chatUsers.keys) {
        getMessageFrom(id);
      }
    });
  }

  void setChatUsers(List<ChatUser> chatUsersList) {
    chatUsers = {};
    for (var item in chatUsersList) {
      chatUsers[item.id] = item;
    }
    notifyListeners();
  }

  void setCurrentUser(id) {
    currentUser = id;
    notifyListeners();
  }

  void getMessageFrom(int id) async {
    var response = await api(
        "/communicate/get_message_from", Map<String, dynamic>.from({'uid': id}),
        withToken: true);
    List data = response['data'];
    if (data.length != 0) {
      if (currentUser != id) chatUsers[id].unread++;
      for (String s in data) {
        Message m = Message(false, s);
        chatUsers[id].chatHis.add(m);
      }
      notifyListeners();
    }
  }

  void sentMessageTo(int id, String message) async {
    await api(
        "/communicate/send_message_to",
        {
          'uid': id,
          'data': message,
        },
        withToken: true);
    Message m = Message(true, message);
    chatUsers[id].chatHis.add(m);
    notifyListeners();
  }
}
