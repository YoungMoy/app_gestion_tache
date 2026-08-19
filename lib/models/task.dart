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