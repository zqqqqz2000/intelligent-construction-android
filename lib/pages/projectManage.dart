import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  DateTime projectTime = DateTime.now();
  String projectTitle = '';
  String projectDes = '';
  int projectPic;
  Widget img;

  @override
  Widget build(BuildContext context) {
    if (img == null)
      img = Placeholder(
        strokeWidth: 0,
        fallbackWidth: 60,
        fallbackHeight: 60,
      );
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
                        currentProject.getProject() == null
                            ? Text("请选择项目")
                            : Text("当前项目: " + currentProject.getProject().name),
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
                                                currentProject.setProject(e);
                                                Navigator.pop(context);
                                              },
                                              child: SizedBox(
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
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, state) {
                                return SimpleDialog(
                                  contentPadding: EdgeInsets.all(20),
                                  title: const Text("添加进度"),
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "进度标题"),
                                        onChanged: (content) {
                                          projectTitle = content;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: TextField(
                                          decoration: const InputDecoration(
                                            // border: OutlineInputBorder(),
                                            hintText: "进度详情",
                                          ),
                                          maxLines: 10,
                                          onChanged: (content) {
                                            projectDes = content;
                                          }),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        img,
                                        IconButton(
                                            icon: Icon(Icons.add_a_photo),
                                            onPressed: () async {
                                              var ip = ImagePicker();
                                              var image = await ip.getImage(
                                                  source: ImageSource.camera);
                                              var response =
                                                  await imgUp(image.path);
                                              state(() {
                                                if (response['success']) {
                                                  projectPic = response['id'];
                                                }
                                                img = Image.file(
                                                  File(image.path),
                                                  height: 60,
                                                  width: 60,
                                                );
                                              });
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.date_range),
                                            onPressed: () async {
                                              projectTime =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1984),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 1),
                                              );
                                            })
                                      ],
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        var response = await api(
                                            "/project/add_project_process",
                                            {
                                              'pid': currentProject
                                                  .getProject()
                                                  .id,
                                              'comment': projectDes,
                                              'date': projectTime.toString(),
                                              'pic': projectPic,
                                            },
                                            withToken: true);
                                        if (!response['success']) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Text(response['info']),
                                                );
                                              });
                                        } else {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text("添加进度成功")));
                                        }
                                      },
                                      child: Text('报送进度'),
                                    )
                                  ],
                                );
                              },
                            );
                          });
                    },
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
