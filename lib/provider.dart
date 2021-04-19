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
