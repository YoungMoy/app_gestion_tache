import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../repository/task_repository.dart'; // pour TaskException

abstract class ITaskStorage {
  void saveTasks(List<TaskBase> tasks);
  List<TaskBase> loadTasks();
}

/// Exception spécifique au stockage
class TaskStorageException extends TaskException {
  TaskStorageException(String message) : super(message);
}

class TaskFileStorage implements ITaskStorage {
  final String fileName;
  TaskFileStorage(this.fileName);

  @override
  void saveTasks(List<TaskBase> tasks) {
    final file = File(fileName);
    try {
      final jsonData = tasks.map((t) => {
            'titre': t.titre,
            'priorite': t.priorite.index,
            'estTerminee': t.estTerminee,
            'dateLimite': t.dateLimite?.toIso8601String(),
            'type': t.runtimeType.toString(),
          }).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } on IOException catch (e) {
      throw TaskStorageException("Erreur lors de la sauvegarde : $e");
    }
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

        if (json['type'] == 'UrgentTask') {
          return UrgentTask(json['titre'], priorite,
              dateLimite: dateLimite, estTerminee: estTerminee);
        } else {
          return PersonalTask(json['titre'], priorite,
              dateLimite: dateLimite, estTerminee: estTerminee);
        }
      }).toList();
    } on FormatException catch (e) {
      throw TaskStorageException("Erreur de format JSON : $e");
    } on IOException catch (e) {
      throw TaskStorageException("Erreur d'entrée/sortie : $e");
    }
  }
}
