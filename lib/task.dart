/// Classe représentant une tâche générique avec titre, priorité et état.
abstract class Task {
  final String titre;
  final Priorite priorite;
  bool estTerminee = false;
  DateTime? dateLimite;

  Task(this.titre, this.priorite, {this.dateLimite});

  /// Marque la tâche comme terminée.
  void marquerTerminee() {
    estTerminee = true;
  }
}

enum Priorite { low, medium, high }

class UrgentTask extends Task {
  UrgentTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}

class PersonalTask extends Task {
  PersonalTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}