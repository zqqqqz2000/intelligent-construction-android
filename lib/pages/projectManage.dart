import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';
import '../provider.dart';
import '../utils/request.dart';

class ProjectManage extends StatefulWidget {
  const ProjectManage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectManageState();
  }
}

class ProjectManageState extends State<ProjectManage> {
  @override
  Widget build(BuildContext context) {
    var sp = SharedPreferences.getInstance();
    sp.then((value) {
      var projectDicts = api('/project/get_project_from_uid',
          {'page': 1, 'token': value.getString('token')});
      projectDicts.then((value) {
        print(value);
      });
      // var projects = context.read<Projects>();
      // projects.setProjects(projects);
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Projects()),
        ChangeNotifierProvider(create: (context) => CurrentProject())
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Text("请选择项目"),
            TextButton(
              child: Text('选择项目'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheet(
                        onClosing: () {},
                        builder: (context) {
                          return Container(
                            height: 400,
                            child: ListView(
                              children: [
                                Text("项目1"),
                                Text("项目2"),
                                Text("项目3"),
                              ],
                            ),
                          );
                        }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
