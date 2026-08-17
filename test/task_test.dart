import 'dart:io';
import 'package:test/test.dart';
import 'package:app_gestion_tache/models/task.dart';
import 'package:app_gestion_tache/repositories/task_repository.dart';
import 'package:app_gestion_tache/services/task_file_storage.dart';

void main() {
  group('TaskRepository', () {
    test('ajout et suppression de tâches', () {
      final repo = TaskRepository();
      final task = UrgentTask('Envoyer un mail', Priorite.high);
      repo.add(task);
      expect(repo.getAll().length, 1);

      repo.remove(task);
      expect(repo.getAll().isEmpty, true);
    });

    test('marquer une tâche comme terminée', () {
      final repo = TaskRepository();
      final task = PersonalTask('Lire un livre', Priorite.low);
      repo.add(task);
      task.marquerTerminee();
      expect(task.estTerminee, true);
    });

    test('liste triée par priorité', () {
      final repo = TaskRepository();
      repo.add(UrgentTask('Envoyer un mail', Priorite.high));
      repo.add(PersonalTask('Faire les courses', Priorite.medium));
      repo.add(PersonalTask('Lire un livre', Priorite.low));

      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.titre, 'Lire un livre');
      expect(sorted.last.titre, 'Envoyer un mail');
    });
  });

  group('TaskFileStorage', () {
    final storage = TaskFileStorage('test_tasks.json');

    tearDown(() {
      final file = File('test_tasks.json');
      if (file.existsSync()) file.deleteSync();
    });

    test('sauvegarde et chargement de tâches', () {
      final repo = TaskRepository();
      repo.add(UrgentTask('Envoyer un mail', Priorite.high));
      storage.saveTasks(repo.getAll());

      final loadedTasks = storage.loadTasks();
      expect(loadedTasks.length, 1);
      expect(loadedTasks.first.titre, 'Envoyer un mail');
    });

    test('chargement depuis un fichier vide', () {
      final file = File('test_tasks.json');
      file.writeAsStringSync('');
      final loadedTasks = storage.loadTasks();
      expect(loadedTasks.isEmpty, true);
    });

    test('chargement depuis un fichier corrompu', () {
      final file = File('test_tasks.json');
      file.writeAsStringSync('texte_invalide');
      final loadedTasks = storage.loadTasks();
      expect(loadedTasks.isEmpty, true);
    });
  });
}