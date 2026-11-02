# Projet Tifosi

Projet scolaire de conception d'une base de données MySQL pour le restaurant de street-food italien Tifosi. Le schéma comprend les six entités du modèle : `ingredient`, `focaccia`, `marque`, `boisson`, `client` et `menu`, ainsi que les associations `focaccia_ingredient`, `menu_boisson` et `achat`.

Les classeurs fournis contiennent des données pour les marques, les boissons, les ingrédients et les focaccias. Ils ne fournissent pas de données client ou menu ; aucune n'a été inventée.

## Prérequis

- Un serveur MySQL **8.0.16 ou plus récent**. Le schéma utilise des contraintes `CHECK` ; MySQL les applique à partir de la version 8.0.16.
- Un compte MySQL ayant les droits nécessaires pour créer la base et les tables.
- Le client MySQL ou MySQL Workbench pour ouvrir les scripts.

L'exécution dont les résultats sont rapportés ci-dessous a été réalisée sous **MySQL 8.4.9**, selon la sortie transmise.

Référence : [contraintes CHECK - Manuel de référence MySQL 8.4](https://dev.mysql.com/doc/refman/8.4/en/create-table-check-constraints.html).

## Scripts et ordre d'exécution

Exécuter les scripts dans cet ordre :

1. **`sql/01_schema.sql`** - avec un compte ayant les droits de création requis. Crée la base `tifosi` en `utf8mb4` et les tables du schéma, leurs clés et leurs contraintes.
2. **`sql/02_donnees_test.sql`** - insère les données source : 4 marques, 25 ingrédients, 12 boissons, 8 focaccias et leurs associations focaccia-ingrédient avec les quantités en grammes. À exécuter une seule fois sur une base `tifosi` vide ; ce script ne supprime ni ne remplace les données existantes.
3. **`sql/03_requetes_test.sql`** - contient dix requêtes de vérification et distingue les résultats attendus des résultats obtenus.

**`sql/00_compte_tifosi.example.sql` est facultatif** : c'est un exemple de configuration locale du compte `tifosi`, limité à la base `tifosi.*`. Le fichier contient seulement une valeur de mot de passe fictive. N'ajoutez aucun vrai mot de passe au fichier versionné et ne publiez aucun mot de passe réel sur GitHub. Gardez tout secret utilisé pour une configuration locale en dehors des fichiers versionnés.

Les tables `client`, `menu`, `menu_boisson` et `achat` figurent dans le schéma, mais restent sans données de test, car les classeurs fournis n'en contiennent pas.

## Résultats des vérifications

Les résultats ci-dessous sont ceux de la sortie MySQL 8.4.9 transmise :

1. **Noms des focaccias par ordre alphabétique :** Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione.
2. **Nombre total d'ingrédients :** 25.
3. **Prix moyen :** 10.375000.
4. **Boissons avec leur marque, triées par nom :** 12 boissons avec leur marque.
5. **Ingrédients de la Raclaccia :** Ail (2 g), Base Tomate (200 g), Champignon (40 g), Cresson (20 g), Parmesan (50 g), Poivre (1 g), Raclette (50 g).
6. **Nombre d'ingrédients par focaccia :** Mozaccia 10, Gorgonzollaccia 8, Raclaccia 7, Emmentalaccia 7, Tradizione 9, Hawaienne 9, Américaine 8, Paysanne 12.
7. **Focaccia(s) ayant le plus d'ingrédients :** Paysanne, 12.
8. **Focaccias contenant de l'ail :** Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia.
9. **Ingrédients inutilisés :** Salami, Tomate cerise.
10. **Focaccias sans champignon :** Américaine, Hawaienne.

## Références MySQL

- [Contraintes CHECK - Manuel de référence MySQL 8.4](https://dev.mysql.com/doc/refman/8.4/en/create-table-check-constraints.html)
- [CREATE USER - Manuel de référence MySQL 8.4](https://dev.mysql.com/doc/refman/8.4/en/create-user.html)
- [GRANT - Manuel de référence MySQL 8.4](https://dev.mysql.com/doc/refman/8.4/en/grant.html)
