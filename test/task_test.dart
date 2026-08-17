  group('TaskRepository', () {
    // ... tes tests existants ...

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
