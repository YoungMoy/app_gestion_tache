# Application de gestion de tâches (Dart)

Ce projet est une application de gestion de tâches écrite en Dart.  
Il illustre l’utilisation de l’abstraction, de l’héritage, de l’encapsulation et de la persistance des données.


>Structure du projet
 `lib/task.dart` → logique métier (classe abstraite `Tache`, `UrgentTache`, `PersonnelleTache`, `TaskRepository`)
 `lib/services/task_file_storage.dart` → persistance des tâches (sauvegarde/chargement JSON)
 `bin/main.dart` → point d’entrée de l’application
 `test/task_test.dart` → tests unitaires
 `tasks.json` → fichier de stockage des tâches


 Exécution
Pour lancer l’application :
```bash
dart run bin/main.dart

Tests
Pour exécuter les tests unitaires :
bash
dart test

Fonctionnalités
Ajouter et supprimer des tâches
Marquer une tâche comme terminée
Lister les tâches triées par priorité ou par date
Sauvegarder et charger les tâches depuis un fichier JSON

Exemple de sortie
Code
 >Liste des tâches triées par priorité
Envoyer un mail (priorité: Priorite.high, terminée: false)
Faire les courses (priorité: Priorite.medium, terminée: false)
Lire un livre (priorité: Priorite.low, terminée: false)

Tâche 'Envoyer un mail' marquée comme terminée.