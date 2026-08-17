import '../models/task.dart';

class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => "TaskException: $message";
}

class TaskRepository {
  final List<Task> _tasks = [];

  void add(Task task) => _tasks.add(task);

  void remove(Task task) {
    if (!_tasks.remove(task)) {
      throw TaskException("Impossible de supprimer la tâche : ${task.titre}");
    }
  }

  List<Task> getAll() => List.unmodifiable(_tasks);

  List<Task> getAllSortedByPriority() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) => a.priorite.index.compareTo(b.priorite.index));
    return sorted;
  }

  List<Task> listerParDate() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dateLimite == null || b.dateLimite == null) return 0;
      return a.dateLimite!.compareTo(b.dateLimite!);
    });
    return sorted;
  }
}