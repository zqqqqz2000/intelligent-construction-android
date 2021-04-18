import 'package:flutter/cupertino.dart';
import 'package:intelligent_construction/Item.dart';

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
  Project currentProject;

  Project getProject() {
    return currentProject;
  }

  void setProject(Project project) {
    this.currentProject = project;
    notifyListeners();
  }
}