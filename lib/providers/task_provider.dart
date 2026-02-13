import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_nova/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');

      if (tasksJson != null) {
        final List<dynamic> decodedList = json.decode(tasksJson);
        _tasks = decodedList.map((item) => TaskModel.fromMap(item)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading tasks: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedList = json.encode(_tasks.map((task) => task.toMap()).toList());
      await prefs.setString('tasks', encodedList);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving tasks: $e");
      }
    }
  }

  void addTask(TaskModel task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final currentTask = _tasks[index];
      _tasks[index] = currentTask.copyWith(isCompleted: !currentTask.isCompleted);
      saveTasks();
      notifyListeners();
    }
  }

  // Filter helpers
  List<TaskModel> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<TaskModel> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  
  // Clear all data (for settings)
  Future<void> clearAllData() async {
    _tasks.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasks');
    notifyListeners();
  }
}
