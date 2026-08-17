import '../lib/models/task.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_file_storage.dart';

void main() {
  final repo = TaskRepository();
  final storage = TaskFileStorage('tasks.json');

  // Ajout de tâches
  repo.add(UrgentTask('Envoyer un mail', Priorite.high));
  repo.add(PersonalTask('Lire un livre', Priorite.low));
  repo.add(Task('Faire les courses', Priorite.medium, dateLimite: DateTime(2026, 8, 20)));

  // Suppression d'une tâche
  repo.remove(repo.getAll().first);
  print("Première tâche supprimée.");

  // Sauvegarde
  storage.saveTasks(repo.getAll());

  // Chargement
  final loaded = storage.loadTasks();
  for (var task in loaded) {
    print('${task.titre} - ${task.priorite} - Terminé: ${task.estTerminee}');
  }

  // Liste triée par date
  print("=== Tâches triées par date limite ===");
  for (var task in repo.listerParDate()) {
    print('${task.titre} - ${task.dateLimite ?? "Pas de date"}');
  }
}
