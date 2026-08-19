# Application de gestion de tâches (Dart)

Ce projet est une application simple de gestion de tâches écrite en Dart.  
Il illustre l’utilisation de l’abstraction, de l’héritage, de l’encapsulation et de la persistance des données.

Fonctionnalités obligatoires :

Ajouter une tâche (titre, priorité : low/medium/high, date limite optionnelle)
Lister toutes les tâches (avec tri par priorité ou date)
Marquer une tâche comme terminée
Supprimer une tâche
Persister les données dans un fichier JSON local

Exigences techniques :

Utiliser les classes abstraites et l'héritage (ex: Task → UrgentTask)
Implémenter au moins une interface
Utiliser les génériques (ex: Repository<T>)
Gérer les erreurs avec des exceptions personnalisées
Écrire au moins 5 tests unitaires avec le package `test`

---

##  Structure du projet
- `lib/models/task.dart` → logique métier (classe abstraite `TaskBase`, `UrgentTask`, `PersonalTask`)
- `lib/repository/task_repository.dart` → gestion des tâches (ajout, suppression, tri par priorité et par date)
- `lib/storage/task_file_storage.dart` → persistance des tâches (sauvegarde/chargement JSON)
- `bin/main.dart` → point d’entrée de l’application
- `test/task_test.dart` → tests unitaires (≥5 tests)
- `tasks.json` → fichier de stockage des tâches

---

##  Exécution
Pour lancer l’application assurez vous que vous bien place dans le dossier racine du projet 
utilisez la commande suivante  :
```bash
dart run bin/main.dart

Tests
Pour exécuter les tests unitaires utilise la commande suivante :

bash
dart test

Fonctionnalités
Ajouter et supprimer des tâches

Marquer une tâche comme terminée

Lister les tâches triées par priorité ou par date limite

Sauvegarder et charger les tâches depuis un fichier JSON

Exemple de sortie
=== Liste des tâches triées par priorité ===
Envoyer un mail (priorité: Priorite.high, terminée: false)
Faire les courses (priorité: Priorite.medium, terminée: false)
Lire un livre (priorité: Priorite.low, terminée: false)

Tâche 'Envoyer un mail' marquée comme terminée.

Améliorations possibles
Réorganisation de l’architecture en sous‑répertoires (models, repository, storage)

Mise en place d’un pipeline CI/CD (GitHub Actions)

Utilisation d’un modèle d’injection de dépendances pour améliorer la testabilité
