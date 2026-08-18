import 'task.dart';

/// Exception personnalisée pour les erreurs liées aux tâches
class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => "TaskException: $message";
}

/// Repository générique pour gérer des tâches
class TaskRepository<T extends TaskBase> {
  final List<T> _tasks = [];

  /// Ajouter une tâche
  void add(T task) => _tasks.add(task);

  /// Supprimer une tâche
  void remove(T task) {
    if (!_tasks.remove(task)) {
      throw TaskException("Suppression impossible : tâche '${task.titre}' introuvable");
    }
  }

  /// Récupérer toutes les tâches
  List<T> getAll() => List.unmodifiable(_tasks);

  /// Trier par priorité
  List<T> getAllSortedByPriority() {
    final sorted = List<T>.from(_tasks);
    sorted.sort((a, b) => a.priorite.index.compareTo(b.priorite.index));
    return sorted;
  }

  /// Trier par date limite
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

