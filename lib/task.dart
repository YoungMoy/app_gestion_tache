enum Priorite { low, medium, high }

abstract class Tache {
  String titre;
  Priorite priorite;
  DateTime? dateLimite;
  bool estTerminee = false;

  Tache(this.titre, this.priorite, {this.dateLimite});

  void marquerTerminee() {
    estTerminee = true;
  }
}

class UrgentTache extends Tache {
  UrgentTache(String titre, DateTime dateLimite)
      : super(titre, Priorite.high, dateLimite: dateLimite);
}

class PersonnelleTache extends Tache {
  PersonnelleTache(String titre, DateTime dateLimite, Priorite priorite)
      : super(titre, priorite, dateLimite: dateLimite);
}

class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => "TaskException: $message";
}

class TaskRepository {
  final List<Tache> _tasks = [];

  void add(Tache task) {
    _tasks.add(task);
  }

  void remove(Tache task) {
    if (!_tasks.contains(task)) {
      throw TaskException("Tâche inexistante");
    }
    _tasks.remove(task);
  }

  List<Tache> getAll() => List.unmodifiable(_tasks);

  void loadTasks(List<Tache> tasks) {
    _tasks.clear();
    _tasks.addAll(tasks);
  }

  List<Tache> lister({String sortBy = "priorite"}) {
    var sorted = [..._tasks];
    if (sortBy == "date") {
      sorted.sort((a, b) => a.dateLimite!.compareTo(b.dateLimite!));
    } else {
      final ordre = {
        Priorite.low: 0,
        Priorite.medium: 1,
        Priorite.high: 2,
      };
      sorted.sort((a, b) => ordre[b.priorite]!.compareTo(ordre[a.priorite]!));
    }
    return sorted;
  }
}