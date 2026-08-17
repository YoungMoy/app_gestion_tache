import '../lib/models/task.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_file_storage.dart';

void main() {
  final repo = TaskRepository();
  final storage = TaskFileStorage('tasks.json');

  repo.add(UrgentTask('Envoyer un mail', Priorite.high));
  repo.add(PersonalTask('Lire un livre', Priorite.low));

  storage.saveTasks(repo.getAll());

  final loaded = storage.loadTasks();
  for (var task in loaded) {
    print('${task.titre} - ${task.priorite} - Terminé: ${task.estTerminee}');
  }
}