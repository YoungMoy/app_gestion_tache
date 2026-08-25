import 'dart:convert';
import 'dart:io';
import '../models/task.dart';

abstract class ITaskStorage {
  void saveTasks(List<TaskBase> tasks);
  List<TaskBase> loadTasks();
}

class TaskFileStorage implements ITaskStorage {
  final String fileName;
  TaskFileStorage(this.fileName);

  @override
  void saveTasks(List<TaskBase> tasks) {
    final file = File(fileName);
    final jsonData = tasks.map((t) => {
          'titre': t.titre,
          'priorite': t.priorite.index,
          'estTerminee': t.estTerminee,
          'dateLimite': t.dateLimite?.toIso8601String(),
          'type': t.runtimeType.toString(), // on stocke le type
        }).toList();
    file.writeAsStringSync(jsonEncode(jsonData));
  }

  @override
  List<TaskBase> loadTasks() {
    final file = File(fileName);
    if (!file.existsSync()) return [];

    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) return [];
      final data = jsonDecode(content) as List;
      return data.map((json) {
        final priorite = Priorite.values[json['priorite']];
        final dateLimite = json['dateLimite'] != null
            ? DateTime.parse(json['dateLimite'])
            : null;
      
final estTerminee = json['estTerminee'] ?? false;
TaskBase task;
if (json['type'] == 'UrgentTask') {
  task = UrgentTask(
    json['titre'],
    priorite,
    dateLimite: dateLimite,
    estTerminee: estTerminee,
  );
} else {
  task = PersonalTask(
    json['titre'],
    priorite,
    dateLimite: dateLimite,
    estTerminee: estTerminee,
  );
}
return task;

      }).toList();
    } on FormatException catch (e) {
      print("Erreur de format JSON: $e");
      return [];
    } on IOException catch (e) {
      print("Erreur d'entrée/sortie: $e");
      return [];
    }
  }
}
