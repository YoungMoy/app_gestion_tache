import 'dart:io';
import 'dart:convert';

/// Classe de base représentant une tâche générique avec titre, priorité et état.
abstract class TaskBase {
  final String titre;
  final Priorite priorite;
  bool estTerminee = false;
  DateTime? dateLimite;

  TaskBase(this.titre, this.priorite, {this.dateLimite});

  /// Marque la tâche comme terminée.
  void marquerTerminee() {
    estTerminee = true;
  }
}

enum Priorite { low, medium, high }

class UrgentTask extends TaskBase {
  UrgentTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}

class PersonalTask extends TaskBase {
  PersonalTask(String titre, Priorite priorite, {DateTime? dateLimite})
      : super(titre, priorite, dateLimite: dateLimite);
}

