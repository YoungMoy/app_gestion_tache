import 'dart:convert';
import 'dart:io';

enum Priorite { low, medium, high }

class Task {
  String titre;
  Priorite priorite;
  DateTime? dateLimite;
  bool estTerminee = false;

  Task(this.titre, this.priorite, {this.dateLimite});

  void afficherTitre() {
    print("Tâche : $titre (priorité $priorite, terminée: $estTerminee)");
  }

  void marquerTerminee() {
    estTerminee = true;
  }
}

class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => "TaskException: $message";
}

class TaskRepository {
  List<Task> _tasks = [];

  void add(Task task) {
    _tasks.add(task);
  }

  void remove(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw TaskException("Index invalide");
    }
    _tasks.removeAt(index);
  }

  List<Task> getAll() {
    return _tasks;
  }

  void listerParPriorite() {
    final ordre = {
      Priorite.low: 0,
      Priorite.medium: 1,
      Priorite.high: 2,
    };
    _tasks.sort((a, b) => ordre[b.priorite]!.compareTo(ordre[a.priorite]!));
    for (var t in _tasks) {
      t.afficherTitre();
    }
  }
}

void saveTasks(List<Task> tasks) {
  final file = File('tasks.json');
  final data = tasks.map((t) => {
        'titre': t.titre,
        'priorite': t.priorite.toString(),
        'dateLimite': t.dateLimite?.toIso8601String(),
        'estTerminee': t.estTerminee,
      }).toList();
  file.writeAsStringSync(jsonEncode(data));
}

List<Task> loadTasks() {
  final file = File('tasks.json');
  if (!file.existsSync()) return [];
  final data = jsonDecode(file.readAsStringSync()) as List;
  return data.map((json) {
    final titre = json['titre'];
    final prioriteStr = json['priorite'].split('.').last;
    final priorite = Priorite.values.firstWhere((p) => p.name == prioriteStr);
    final dateLimite = json['dateLimite'] != null
        ? DateTime.parse(json['dateLimite'])
        : null;
    final t = Task(titre, priorite, dateLimite: dateLimite);
    t.estTerminee = json['estTerminee'];
    return t;
  }).toList();
}
