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
- `test/task_test.dart` → tests unitaires (≥6 tests)
- `tasks.json` → fichier de stockage des tâches
- `pubspec.yaml` → Dépendances et configuration du projet
- `pubspec.lock` → Version figée des dépendances
- `analysis_options.yaml` → Règles d’analyse et de linting Dart


lib/
 ├── models/
 │    └── task.dart              # Définition des classes de tâches (TaskBase, UrgentTask, etc.)
 ├── repository/
 │    └── task_repository.dart   # Gestion des tâches (ajout, suppression, tri, exceptions)
 ├── storage/
 │    └── task_file_storage.dart # Persistance des tâches en JSON
bin/
 └── main.dart                   # Point d’entrée de l’application CLI
test/
 └── task_test.dart              # Tests unitaires (≥6 tests)
tasks.json                       # Fichier de stockage des tâches
pubspec.yaml                     # Dépendances et configuration du projet
pubspec.lock                     # Version figée des dépendances
analysis_options.yaml            # Règles d’analyse et de linting Dart

  Cette organisation en sous‑répertoires et fichiers de configuration permet de séparer clairement la logique métier, la gestion des données, la persistance et les règles de qualité du code. 


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

##  CI/CD
Un pipeline GitHub Actions est en place pour :
- Vérifier le code (`dart analyze`)
- Lancer les tests (`dart test`)
- Assurer la qualité continue

Fichier : `.github/workflows/dart.yml`

```yaml
name: Dart CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
      - run: dart pub get
      - run: dart analyze --fatal-infos --fatal-warnings
      - run: dart test



