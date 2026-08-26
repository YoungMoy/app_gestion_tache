/// Classe de base représentant une tâche générique avec titre, priorité et état.
abstract class TaskBase {
  final String titre;
  final Priorite priorite;
  final bool estTerminee;
  final DateTime? dateLimite;

  TaskBase(this.titre, this.priorite, {this.dateLimite, this.estTerminee = false});

  /// Retourne une nouvelle tâche marquée comme terminée (immutabilité).
  TaskBase markAsDone();
}

enum Priorite { low, medium, high }

/// Tâche urgente avec comportement spécifique
class UrgentTask extends TaskBase {
  UrgentTask(String titre, Priorite priorite, {DateTime? dateLimite, bool estTerminee = false})
      : super(titre, priorite, dateLimite: dateLimite, estTerminee: estTerminee);

  /// Calculer le temps restant avant la deadline
  Duration? tempsRestant() {
    if (dateLimite == null) return null;
    return dateLimite!.difference(DateTime.now());
  }

  @override
  UrgentTask markAsDone() {
    return UrgentTask(titre, priorite, dateLimite: dateLimite, estTerminee: true);
  }
}

/// Tâche personnelle avec propriété spécifique
class PersonalTask extends TaskBase {
  final String? categorie;

  PersonalTask(String titre, Priorite priorite, {DateTime? dateLimite, bool estTerminee = false, this.categorie})
      : super(titre, priorite, dateLimite: dateLimite, estTerminee: estTerminee);

  @override
  PersonalTask markAsDone() {
    return PersonalTask(titre, priorite, dateLimite: dateLimite, estTerminee: true, categorie: categorie);
  }

  @override
  String toString() => "[Perso] $titre - Catégorie: ${categorie ?? "Divers"}";
}


