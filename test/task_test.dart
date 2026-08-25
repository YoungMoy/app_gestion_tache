import 'dart:io';
import 'package:test/test.dart';
import 'package:app_gestion_tache/models/task.dart';
import 'package:app_gestion_tache/repository/task_repository.dart';
import 'package:app_gestion_tache/storage/task_file_storage.dart';

void main() {
  group('TaskRepository', () {
    test('ajout de tâche augmente la liste', () {
      final repo = TaskRepository();
      repo.add(PersonalTask("Lire un livre", Priorite.high));
      expect(repo.getAll().length, 1);
    });

    test('supprimer une tâche réduit la liste', () {
      final repo = TaskRepository();
      final task = PersonalTask("Faire les courses", Priorite.medium);
      repo.add(task);
      repo.remove(task);
      expect(repo.getAll().isEmpty, true);
    });

    test('marquer une tâche comme terminée change son état', () {
      final tache = PersonalTask("Envoyer un mail", Priorite.low);
      final tacheTerminee = tache.terminee();
      expect(tacheTerminee.estTerminee, true);
    });

    test('tri par priorité place high en premier', () {
      final repo = TaskRepository();
      repo.add(PersonalTask("Tâche basse", Priorite.low));
      repo.add(PersonalTask("Tâche haute", Priorite.high));
      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.titre, "Tâche haute");
    });

    test('suppression de tâche inexistante lance une exception', () {
      final repo = TaskRepository();
      final fakeTask = PersonalTask('Inconnue', Priorite.low);
      expect(() => repo.remove(fakeTask), throwsA(isA<TaskException>()));
    });

    test('ajout de tâche avec date limite et tri par date', () {
      final repo = TaskRepository();
      repo.add(PersonalTask('Tâche A', Priorite.low, dateLimite: DateTime(2026, 8, 20)));
      repo.add(PersonalTask('Tâche B', Priorite.high, dateLimite: DateTime(2026, 8, 18)));
      repo.add(PersonalTask('Tâche C', Priorite.medium)); // sans date

      final sorted = repo.getAllSortedByDate();
      expect(sorted.first.titre, 'Tâche B'); // 18 août
      expect(sorted[1].titre, 'Tâche A');   // 20 août
      expect(sorted.last.titre, 'Tâche C'); // sans date
    });
  });

  group('TaskFileStorage', () {
    test('sauvegarde et chargement de tâches', () {
      final repo = TaskRepository();
      repo.add(PersonalTask('Test sauvegarde', Priorite.medium));
      final storage = TaskFileStorage('test_save.json');
      storage.saveTasks(repo.getAll());

      final loaded = storage.loadTasks();
      expect(loaded.isNotEmpty, true);
      expect(loaded.first.titre, 'Test sauvegarde');
    });

    test('chargement depuis un fichier vide', () {
      final file = File('test_empty.json');
      file.writeAsStringSync(''); // on crée un fichier vide

      final storageEmpty = TaskFileStorage('test_empty.json');
      final loadedEmpty = storageEmpty.loadTasks();
      expect(loadedEmpty, isEmpty);
    });

    test('chargement depuis un fichier corrompu', () {
      final file = File('test_corrupt.json');
      file.writeAsStringSync('texte invalide'); // contenu corrompu

      final storageCorrupt = TaskFileStorage('test_corrupt.json');
      final loadedCorrupt = storageCorrupt.loadTasks();
      expect(loadedCorrupt, isEmpty);
    });
  });
}


