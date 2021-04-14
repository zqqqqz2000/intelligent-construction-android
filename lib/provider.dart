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
  Project currentProjects;

  Project getProjects() {
    return currentProjects;
  }

  void setProjects(Project project) {
    this.currentProjects = project;
    notifyListeners();
  }
}