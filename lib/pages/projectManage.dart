import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/Item.dart';
import 'package:intelligent_construction/component/projectTimeline.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: Builder(
          builder: (context) {
            var currentProject = Provider.of<CurrentProject>(context);
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        currentProject.getProjects() == null
                            ? Text("请选择项目")
                            : Text(
                                "当前项目: " + currentProject.getProjects().name),
                        TextButton(
                          child: Text('选择项目'),
                          onPressed: () async {
                            var sp = await SharedPreferences.getInstance();
                            var projects = context.read<Projects>();
                            var projectDicts = await api(
                                '/project/get_project_from_uid',
                                {'page': 1, 'token': sp.getString('token')});
                            List<Project> res = [];
                            for (var proj in projectDicts['data']) {
                              var project = Project();
                              project.complete_per = proj['complete_per'];
                              project.cost = proj['cost'];
                              project.describe = proj['describe'];
                              project.id = proj['id'];
                              project.lat = proj['lat'];
                              project.lng = proj['lng'];
                              project.name = proj['name'];
                              project.pic = proj['pic'];
                              project.scale = proj['scale'];
                              res.add(project);
                            }
                            projects.setProjects(res);
                            // var projects = context.read<Projects>();
                            // projects.setProjects(projects);
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      return Container(
                                        height: 400,
                                        child: ListView(
                                          children:
                                              projects.getProjects().map((e) {
                                            return MaterialButton(
                                              onPressed: () {
                                                currentProject.setProjects(e);
                                                Navigator.pop(context);
                                              },
                                              child: SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.name,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        e.describe,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }));
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          child: ProjectTimeline(),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.add),
                  ),
                  bottom: 0,
                  right: 0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
