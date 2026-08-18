import 'dart:io';
import 'dart:convert';

/// Classe de base représentant une tâche générique avec titre, priorité et état.
abstract class TaskBase {
  final String titre;
  final Priorite priorite;
  bool estTerminee = false;
  DateTime? dateLimite;

  TaskBase(this.titre, this.priorite, {this.dateLimite});

  /// Marque la tâche comme terminée.
  void marquerTerminee() {
    estTerminee = true;
  }
}

enum Priorite { low, medium, high }

class UrgentTask extends TaskBase {
  UrgentTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}

class PersonalTask extends TaskBase {
  PersonalTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}

/// Exception personnalisée pour les erreurs liées aux tâches
class TaskException implements Exception {
  final String message;
  TaskException([this.message = "Erreur de tâche"]);
  @override
  String toString() => "TaskException: $message";
}

/// Repository pour gérer une liste de tâches
class TaskRepository {
  final List<TaskBase> _tasks = [];

  void add(TaskBase task) => _tasks.add(task);

  void remove(dynamic taskOrIndex) {
    if (taskOrIndex is int) {
      if (taskOrIndex < 0 || taskOrIndex >= _tasks.length) {
        throw TaskException("Index invalide");
      }
      _tasks.removeAt(taskOrIndex);
    } else if (taskOrIndex is TaskBase) {
      if (!_tasks.remove(taskOrIndex)) {
        throw TaskException("Tâche inexistante");
      }
    } else {
      throw TaskException("Paramètre invalide");
    }
  }

  List<TaskBase> getAll() => List.unmodifiable(_tasks);

  List<TaskBase> getAllSortedByDate() {
    final sorted = [..._tasks];
    sorted.sort((a, b) {
      if (a.dateLimite == null && b.dateLimite == null) return 0;
      if (a.dateLimite == null) return 1;
      if (b.dateLimite == null) return -1;
      return a.dateLimite!.compareTo(b.dateLimite!);
    });
    return sorted;
  }

  void listerParPriorite() {
    _tasks.sort((a, b) => b.priorite.index.compareTo(a.priorite.index));
  }
}

/// Sauvegarde les tâches dans un fichier JSON
void saveTasks(List<TaskBase> tasks, {String filePath = 'tasks.json'}) {
  final file = File(filePath);
  final jsonList = tasks.map((t) => {
        'titre': t.titre,
        'priorite': t.priorite.index,
        'estTerminee': t.estTerminee,
        'dateLimite': t.dateLimite?.toIso8601String(),
        'type': t.runtimeType.toString(),
      }).toList();

  file.writeAsStringSync(jsonEncode(jsonList));
}

/// Charge les tâches depuis un fichier JSON
List<TaskBase> loadTasks({String filePath = 'tasks.json'}) {
  final file = File(filePath);
  if (!file.existsSync()) return [];

  try {
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return [];

    final jsonList = jsonDecode(content) as List;
    return jsonList.map((map) {
      final titre = map['titre'] as String;
      final priorite = Priorite.values[map['priorite'] as int];
      final estTerminee = map['estTerminee'] as bool;
      final dateLimite = map['dateLimite'] != null
          ? DateTime.parse(map['dateLimite'])
          : null;

      TaskBase task;
      if (map['type'] == 'UrgentTask') {
        task = UrgentTask(titre, priorite, dateLimite: dateLimite);
      } else {
        task = PersonalTask(titre, priorite, dateLimite: dateLimite);
      }
      if (estTerminee) task.marquerTerminee();
      return task;
    }).toList();
  } catch (e) {
    // Fichier corrompu → retourne liste vide
    return [];
  }
}