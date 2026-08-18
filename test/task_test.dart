import 'dart:io';
import 'package:test/test.dart';
import 'package:app_gestion_tache/models/task.dart';

void main() {
  group('TaskRepository', () {
    test('ajout de tâche augmente la liste', () {
      final repo = TaskRepository();
      repo.add(PersonalTask("Lire un livre", Priorite.high));
      expect(repo.getAll().length, 1);
    });

    test('supprimer une tâche réduit la liste', () {
      final repo = TaskRepository();
      repo.add(PersonalTask("Faire les courses", Priorite.medium));
      repo.remove(0);
      expect(repo.getAll().isEmpty, true);
    });

    test('supprimer avec index invalide lance TaskException', () {
      final repo = TaskRepository();
      expect(() => repo.remove(5), throwsA(isA<TaskException>()));
    });

    test('marquer une tâche comme terminée change son état', () {
      final tache = PersonalTask("Envoyer un mail", Priorite.low);
      tache.marquerTerminee();
      expect(tache.estTerminee, true);
    });

    test('tri par priorité place high en premier', () {
      final repo = TaskRepository();
      repo.add(PersonalTask("Tâche basse", Priorite.low));
      repo.add(PersonalTask("Tâche haute", Priorite.high));
      repo.listerParPriorite();
      expect(repo.getAll().first.titre, "Tâche haute");
    });

    test('suppression de tâche inexistante lance une exception', () {
      final repo = TaskRepository();
      final task = PersonalTask('Inconnue', Priorite.low);
      expect(() => repo.remove(task), throwsA(isA<TaskException>()));
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
      saveTasks(repo.getAll(), filePath: 'test_save.json');

      final loaded = loadTasks(filePath: 'test_save.json');
      expect(loaded.isNotEmpty, true);
      expect(loaded.first.titre, 'Test sauvegarde');
    });

    test('chargement depuis un fichier vide', () {
      final file = File('test_empty.json');
      file.writeAsStringSync(''); // on crée un fichier vide

      final loaded = loadTasks(filePath: 'test_empty.json');
      expect(loaded, isEmpty);
    });

    test('chargement depuis un fichier corrompu', () {
      final file = File('test_corrupt.json');
      file.writeAsStringSync('texte invalide'); // contenu corrompu

      final loaded = loadTasks(filePath: 'test_corrupt.json');
      expect(loaded, isEmpty);
    });
  });
}

