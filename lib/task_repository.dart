import '../models/task.dart';

class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => "TaskException: $message";
}

class TaskRepository {
  final List<TaskBase> _tasks = [];

  void add(TaskBase task) => _tasks.add(task);

  void remove(TaskBase task) {
    if (!_tasks.remove(task)) {
      throw TaskException("Suppression impossible : tâche '${task.titre}' introuvable");
    }
  }

  List<TaskBase> getAll() => List.unmodifiable(_tasks);

  List<TaskBase> getAllSortedByPriority() {
    final sorted = List<TaskBase>.from(_tasks);
    sorted.sort((a, b) => a.priorite.index.compareTo(b.priorite.index));
    return sorted;
  }

  List<TaskBase> getAllSortedByDate() {
    final sorted = List<TaskBase>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dateLimite == null && b.dateLimite == null) return 0;
      if (a.dateLimite == null) return 1;   // tâche sans date → après
      if (b.dateLimite == null) return -1;  // tâche avec date → avant
      return a.dateLimite!.compareTo(b.dateLimite!);
    });
    return sorted;
  }
}
