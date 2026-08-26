import '../models/task.dart';

abstract class ITaskRepository<T extends TaskBase> {
  void add(T task);
  void remove(T task);
  void markAsDone(T task);
  List<T> getAll();
  List<T> getAllSortedByPriority();
  List<T> getAllSortedByDate();
}

/// Exception personnalisée pour les erreurs liées aux tâches
class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => 'TaskException: $message';
}

/// Repository générique pour gérer des tâches
class TaskRepository<T extends TaskBase> implements ITaskRepository<T> {
  final List<T> _tasks = [];

  @override
  void add(T task) => _tasks.add(task);

  @override
  void remove(T task) {
    if (!_tasks.remove(task)) {
      throw TaskException("Suppression impossible : tâche '${task.titre}' introuvable");
    }
  }

  @override
  void markAsDone(T task) {
    final index = _tasks.indexOf(task);
    if (index == -1) throw TaskException('Tâche introuvable');
    // immuabilité : remplacer par une nouvelle instance
    _tasks[index] = _tasks[index].markAsDone() as T;
  }

  @override
  List<T> getAll() => List.unmodifiable(_tasks);

  @override
  List<T> getAllSortedByPriority() {
    final sorted = List<T>.from(_tasks);
    sorted.sort((a, b) => b.priorite.index.compareTo(a.priorite.index));
    return sorted;
  }

  @override
  List<T> getAllSortedByDate() {
    final sorted = List<T>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dateLimite == null && b.dateLimite == null) return 0;
      if (a.dateLimite == null) return 1;   // tâche sans date → après
      if (b.dateLimite == null) return -1;  // tâche avec date → avant
      return a.dateLimite!.compareTo(b.dateLimite!);
    });
    return sorted;
  }
}
