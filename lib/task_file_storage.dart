import 'dart:convert';
import 'dart:io';
import '../task.dart';

class TaskFileStorage {
  void saveTasks(List<Tache> tasks) {
    final file = File('tasks.json');
    final data = tasks.map((t) => {
          'titre': t.titre,
          'priorite': t.priorite.toString(),
          'dateLimite': t.dateLimite?.toIso8601String(),
          'estTerminee': t.estTerminee,
        }).toList();
    file.writeAsStringSync(jsonEncode(data));
  }

  List<Tache> loadTasks() {
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
      final t = PersonnelleTache(titre, dateLimite ?? DateTime.now(), priorite);
      t.estTerminee = json['estTerminee'];
      return t;
    }).toList();
  }
}