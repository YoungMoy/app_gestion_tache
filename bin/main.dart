import 'package:app_gestion_tache/models/task.dart';
import 'package:app_gestion_tache/repository/task_repository.dart';
import 'package:app_gestion_tache/storage/task_file_storage.dart';

void main() {
  // Dépôts spécialisés
  ITaskRepository<UrgentTask> urgentRepo = TaskRepository<UrgentTask>();
  ITaskRepository<PersonalTask> personalRepo = TaskRepository<PersonalTask>();

  final storage = TaskFileStorage('tasks.json');

  // Ajout de tâches urgentes
  urgentRepo.add(UrgentTask('Envoyer un mail', Priorite.high, dateLimite: DateTime(2026, 8, 30)));

  // Ajout de tâches personnelles
  personalRepo.add(PersonalTask('Lire un livre', Priorite.low, categorie: 'Loisirs'));
  personalRepo.add(PersonalTask('Faire les courses', Priorite.medium, dateLimite: DateTime(2026, 8, 20), categorie: 'Maison'));

  // Suppression d’une tâche personnelle
  personalRepo.remove(personalRepo.getAll().first);
  print('Première tâche personnelle supprimée.');

  // Sauvegarde (on peut fusionner les deux listes si besoin)
  storage.saveTasks([...urgentRepo.getAll(), ...personalRepo.getAll()]);

  // Chargement
  final loaded = storage.loadTasks();
  for (var task in loaded) {
    print('${task.titre} - ${task.priorite} - Terminé: ${task.estTerminee}');
  }

  // Liste triée par date (exemple avec les tâches personnelles)
  print('Tâches personnelles triées par date limite');
  for (var task in personalRepo.getAllSortedByDate()) {
    print('${task.titre} - ${task.dateLimite ?? 'Pas de date'}');
  }

  // Exemple d’utilisation spécifique
  final urgent = urgentRepo.getAll().first;
  print('Temps restant pour la tâche urgente '${urgent.titre}': ${urgent.tempsRestant()}');
}

