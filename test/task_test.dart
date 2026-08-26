import 'dart:io';
import 'package:test/test.dart';
import 'package:app_gestion_tache/models/task.dart';
import 'package:app_gestion_tache/repository/task_repository.dart';
import 'package:app_gestion_tache/storage/task_file_storage.dart';

void main() {
  group('TaskRepository', () {
    test('ajout de tâche augmente la liste', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      repo.add(PersonalTask("Lire un livre", Priorite.high));
      expect(repo.getAll().length, 1);
    });

    test('supprimer une tâche réduit la liste', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      final task = PersonalTask("Faire les courses", Priorite.medium);
      repo.add(task);
      repo.remove(task);
      expect(repo.getAll().isEmpty, true);
    });

    test('marquer une tâche comme terminée change son état (immutabilité)', () {
      final tache = PersonalTask("Envoyer un mail", Priorite.low);
      final tacheTerminee = tache.markAsDone();
      expect(tacheTerminee.estTerminee, true);
      expect(tache.estTerminee, false);
    });

    test('markAsDone via repository met à jour la tâche', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      final tache = PersonalTask("Envoyer un mail", Priorite.low);
      repo.add(tache);
      repo.markAsDone(tache);
      expect(repo.getAll().first.estTerminee, true);
    });

    test('tri par priorité place high en premier', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      repo.add(PersonalTask("Tâche basse", Priorite.low));
      repo.add(PersonalTask("Tâche haute", Priorite.high));
      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.titre, "Tâche haute");
    });

    test('suppression de tâche inexistante lance une exception', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      final fakeTask = PersonalTask('Inconnue', Priorite.low);
      expect(() => repo.remove(fakeTask), throwsA(isA<TaskException>()));
    });

    test('ajout de tâche avec date limite et tri par date', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      repo.add(PersonalTask('Tâche A', Priorite.low, dateLimite: DateTime(2026, 8, 20)));
      repo.add(PersonalTask('Tâche B', Priorite.high, dateLimite: DateTime(2026, 8, 18)));
      repo.add(PersonalTask('Tâche C', Priorite.medium));

      final sorted = repo.getAllSortedByDate();
      expect(sorted.first.titre, 'Tâche B');
      expect(sorted[1].titre, 'Tâche A');
      expect(sorted.last.titre, 'Tâche C');
    });

    test('UrgentTask calcule le temps restant', () {
      final urgent = UrgentTask("Projet à rendre", Priorite.high, dateLimite: DateTime(2026, 8, 30));
      expect(urgent.tempsRestant(), isNotNull);
    });

    test('PersonalTask affiche la catégorie', () {
      final perso = PersonalTask("Aller au sport", Priorite.medium, categorie: "Santé");
      expect(perso.toString(), contains("Santé"));
    });
  });

  group('TaskFileStorage', () {
    test('sauvegarde et chargement de tâches', () {
      ITaskRepository<PersonalTask> repo = TaskRepository<PersonalTask>();
      repo.add(PersonalTask('Test sauvegarde', Priorite.medium));
      final storage = TaskFileStorage('test_save.json');
      storage.saveTasks(repo.getAll());

      final loaded = storage.loadTasks();
      expect(loaded.isNotEmpty, true);
      expect(loaded.first.titre, 'Test sauvegarde');
    });

    test('sauvegarde et chargement préservent estTerminee', () {
      final storage = TaskFileStorage('test_done.json');
      final tache = PersonalTask('Test terminé', Priorite.high).markAsDone();
      storage.saveTasks([tache]);

      final loaded = storage.loadTasks();
      expect(loaded.first.estTerminee, true);
    });

    test('chargement depuis un fichier vide', () {
      final file = File('test_empty.json');
      file.writeAsStringSync('');

      final storageEmpty = TaskFileStorage('test_empty.json');
      final loadedEmpty = storageEmpty.loadTasks();
      expect(loadedEmpty, isEmpty);
    });

    test('chargement depuis un fichier corrompu lance une exception', () {
      final file = File('test_corrupt.json');
      file.writeAsStringSync('texte invalide');

      final storageCorrupt = TaskFileStorage('test_corrupt.json');
      expect(() => storageCorrupt.loadTasks(), throwsA(isA<TaskStorageException>()));
    });
  });
}


