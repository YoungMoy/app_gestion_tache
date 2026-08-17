import 'package:app_gestion_tache/task.dart';
import 'package:app_gestion_tache/services/task_file_storage.dart';

void main() {
  final repo = TaskRepository();
  final storage = TaskFileStorage();

  // Charger les tâches depuis le fichier
  repo.loadTasks(storage.loadTasks());

  // Ajouter quelques tâches pour tester
  repo.add(UrgentTache("Envoyer un mail", DateTime.now()));
  repo.add(PersonnelleTache("Faire les courses", DateTime.now(), Priorite.medium));
  repo.add(PersonnelleTache("Lire un livre", DateTime.now(), Priorite.low));

  // Sauvegarder les tâches
  storage.saveTasks(repo.getAll());

  // Afficher les tâches triées par priorité
  print("=== Liste des tâches triées par priorité ===");
  for (var task in repo.lister(sortBy: "priorite")) {
    print("${task.titre} (priorité: ${task.priorite}, terminée: ${task.estTerminee})");
  }

  // Exemple : marquer une tâche comme terminée
  var tache = repo.getAll().first;
  tache.marquerTerminee();
  print("Tâche '${tache.titre}' marquée comme terminée.");
}