import 'dart:convert';
import 'dart:io';
import '../models/task.dart';

abstract class ITaskStorage {
  void saveTasks(List<Task> tasks);
  List<Task> loadTasks();
}

class TaskFileStorage implements ITaskStorage {
  final String fileName;
  TaskFileStorage(this.fileName);

  @override
  void saveTasks(List<Task> tasks) {
    final file = File(fileName);
    final jsonData = tasks.map((t) => {
          'titre': t.titre,
          'priorite': t.priorite.index,
          'estTerminee': t.estTerminee,
          'dateLimite': t.dateLimite?.toIso8601String()
        }).toList();
    file.writeAsStringSync(jsonEncode(jsonData));
  }

  @override
  List<Task> loadTasks() {
    final file = File(fileName);
    if (!file.existsSync()) return [];

    try {
      final content = file.readAsStringSync();
      final data = jsonDecode(content) as List;
      return data.map((json) {
        return Task(
          json['titre'],
          Priorite.values[json['priorite']],
          dateLimite: json['dateLimite'] != null
              ? DateTime.parse(json['dateLimite'])
              : null,
        );
      }).toList();
    } catch (e) {
      print("Erreur de lecture JSON: $e");
      return [];
    }
  }
}