-- Requetes de verification des donnees de test Tifosi.
-- A lancer apres 01_schema.sql et 02_donnees_test.sql dans la base tifosi.
-- Les resultats obtenus correspondent a l'execution verifiee sous MySQL 8.4.9.

SET NAMES utf8mb4;
USE tifosi;

-- 1. But : afficher les noms des focaccias par ordre alphabetique.
-- Resultat attendu : 8 lignes, de l'Américaine a la Tradizione.
-- Resultat obtenu : 8 focaccias, par ordre alphabétique :
-- Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne,
-- Raclaccia et Tradizione.
SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;

-- 2. But : compter les ingredients de reference.
-- Resultat attendu : 25.
-- Resultat obtenu : 25 ingrédients.
SELECT COUNT(*) AS nombre_total_ingredients
FROM ingredient;

-- 3. But : calculer le prix moyen des focaccias.
-- Resultat attendu : 10.375 EUR (affichage numerique non arrondi).
-- Resultat obtenu : prix moyen de 10.375000.
SELECT AVG(prix) AS prix_moyen
FROM focaccia;

-- 4. But : lister chaque boisson avec sa marque, par nom de boisson.
-- Resultat attendu : 12 lignes ; les Coca-cola et Fanta avec Coca-cola,
-- les Pepsi et Lipton avec Pepsico, les Monster avec Monster,
-- et Eau de source avec Cristalline.
-- Resultat obtenu : 12 boissons avec leur marque.
SELECT b.nom_boisson, m.nom_marque
FROM boisson AS b
INNER JOIN marque AS m ON m.id_marque = b.id_marque
ORDER BY b.nom_boisson ASC;

-- 5. But : afficher les ingredients associes a Raclaccia.
-- Resultat attendu : 7 ingredients : Ail, Base Tomate, Champignon,
-- Cresson, Parmesan, Poivre et Raclette.
-- Resultat obtenu : 7 ingrédients : Ail (2 g), Base Tomate (200 g),
-- Champignon (40 g), Cresson (20 g), Parmesan (50 g), Poivre (1 g), Raclette (50 g).
SELECT i.nom_ingredient, fi.quantite_grammes
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
INNER JOIN ingredient AS i ON i.id_ingredient = fi.id_ingredient
WHERE f.nom_focaccia = 'Raclaccia'
ORDER BY i.nom_ingredient ASC;

-- 6. But : compter les ingredients de chaque focaccia.
-- Resultat attendu : Mozaccia 10, Gorgonzollaccia 8, Raclaccia 7,
-- Emmentalaccia 7, Tradizione 9, Hawaienne 9, Américaine 8, Paysanne 12.
-- Resultat obtenu : Mozaccia 10, Gorgonzollaccia 8, Raclaccia 7,
-- Emmentalaccia 7, Tradizione 9, Hawaienne 9, Américaine 8, Paysanne 12.
SELECT f.nom_focaccia, COUNT(fi.id_ingredient) AS nombre_ingredients
FROM focaccia AS f
LEFT JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY f.id_focaccia;

-- 7. But : trouver toutes les focaccias ayant le nombre maximal d'ingredients.
-- Resultat attendu : Paysanne, avec 12 ingredients (y compris toute egalite).
-- Resultat obtenu : Paysanne, 12 ingrédients.
SELECT f.nom_focaccia, COUNT(fi.id_ingredient) AS nombre_ingredients
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
HAVING COUNT(fi.id_ingredient) = (
    SELECT MAX(composition.nombre_ingredients)
    FROM (
        SELECT COUNT(*) AS nombre_ingredients
        FROM focaccia_ingredient
        GROUP BY id_focaccia
    ) AS composition
)
ORDER BY f.nom_focaccia ASC;

-- 8. But : lister les focaccias contenant l'ingredient Ail.
-- Resultat attendu : Gorgonzollaccia, Mozaccia, Paysanne et Raclaccia.
-- Resultat obtenu : Gorgonzollaccia, Mozaccia, Paysanne et Raclaccia.
SELECT f.nom_focaccia
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
INNER JOIN ingredient AS i ON i.id_ingredient = fi.id_ingredient
WHERE i.nom_ingredient = 'Ail'
ORDER BY f.nom_focaccia ASC;

-- 9. But : reperer les ingredients sans association a une focaccia.
-- Resultat attendu : Salami et Tomate cerise.
-- Resultat obtenu : Salami et Tomate cerise.
SELECT i.nom_ingredient
FROM ingredient AS i
LEFT JOIN focaccia_ingredient AS fi ON fi.id_ingredient = i.id_ingredient
WHERE fi.id_ingredient IS NULL
ORDER BY i.nom_ingredient ASC;

-- 10. But : lister les focaccias sans Champignon.
-- Resultat attendu : Américaine et Hawaienne.
-- Resultat obtenu : Américaine et Hawaienne.
SELECT f.nom_focaccia
FROM focaccia AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM focaccia_ingredient AS fi
    INNER JOIN ingredient AS i ON i.id_ingredient = fi.id_ingredient
    WHERE fi.id_focaccia = f.id_focaccia
      AND i.nom_ingredient = 'Champignon'
)
ORDER BY f.nom_focaccia ASC;
