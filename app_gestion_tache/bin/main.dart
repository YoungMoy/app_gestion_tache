import 'dart:io';
import 'package:app_gestion_tache/task.dart';

void main() {
  final repo = TaskRepository();
  repo._tasks = loadTasks();
  while (true) {
    print("\nCommandes : add, list, done, remove, exit");
    final input = stdin.readLineSync();
    switch (input) {
      case 'add':
        print("Titre :");
        final titre = stdin.readLineSync()!;
        print("Priorité (low/medium/high) :");
        final pStr = stdin.readLineSync()!;
        final priorite = Priorite.values.firstWhere((p) => p.name == pStr);
        print("Date limite (YYYY-MM-DD) ou vide :");
        final dateStr = stdin.readLineSync();
        DateTime? dateLimite;
        if (dateStr != null && dateStr.isNotEmpty) {
          dateLimite = DateTime.parse(dateStr);
        }
        repo.add(Task(titre, priorite, dateLimite: dateLimite));
        break;
      case 'list':
        repo.listerParPriorite();
        break;
      case 'done':
        print("Index de la tâche terminée :");
        final idx = int.parse(stdin.readLineSync()!);
        repo.getAll()[idx].marquerTerminee();
        break;
      case 'remove':
        print("Index de la tâche à supprimer :");
        final idx = int.parse(stdin.readLineSync()!);
        repo.remove(idx);
        break;
      case 'exit':
        saveTasks(repo.getAll());
        print("Tâches sauvegardées.");
        return;
    }
  }
}
