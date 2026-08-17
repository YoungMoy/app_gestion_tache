import 'dart:io';
import 'package:test/test.dart';
import 'package:app_gestion_tache/task.dart';
import 'package:app_gestion_tache/services/task_file_storage.dart';

void main() {
  group('TaskRepository', () {
    test('ajout et suppression de tâches', () {
      final repo = TaskRepository();
      final tache = UrgentTache('Envoyer un mail', Priorite.high);

      repo.add(tache);
      expect(repo.getAll().length, 1);

      repo.remove(tache);
      expect(repo.getAll().isEmpty, true);
    });

    test('marquer une tâche comme terminée', () {
      final repo = TaskRepository();
      final tache = PersonnelleTache('Lire un livre', Priorite.low);

      repo.add(tache);
      tache.marquerTerminee();

      expect(tache.terminee, true);
    });

    test('liste triée par priorité', () {
      final repo = TaskRepository();
      repo.add(UrgentTache('Envoyer un mail', Priorite.high));
      repo.add(PersonnelleTache('Faire les courses', Priorite.medium));
      repo.add(PersonnelleTache('Lire un livre', Priorite.low));

      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.description, 'Envoyer un mail');
      expect(sorted.last.description, 'Lire un livre');
    });
  });

  group('TaskFileStorage', () {
    final storage = TaskFileStorage('test_tasks.json');

    tearDown(() {
      final file = File('test_tasks.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('sauvegarde et chargement de tâches', () {
      final repo = TaskRepository();
      repo.add(UrgentTache('Envoyer un mail', Priorite.high));
      storage.saveTasks(repo.getAll());

      final loadedTasks = storage.loadTasks();
      expect(loadedTasks.length, 1);
      expect(loadedTasks.first.description, 'Envoyer un mail');
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