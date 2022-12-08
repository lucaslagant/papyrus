-- 1 - Quelles sont les commandes du fournisseur n°9120 ?
SELECT * FROM `entcom` WHERE numfou = 9120;

-- 2 - Afficher le code des fournisseurs pour lesquels des commandes ont été passées.
SELECT COUNT(numcom), numfou FROM `entcom` GROUP BY numfou;

-- 3 - Afficher le nombre de commandes fournisseurs passées, et le nombre de fournisseur concernés.
SELECT COUNT(numcom) FROM `entcom`;
SELECT COUNT(numfou) FROM `entcom`;

-- 4 - Extraire les produits ayant un stock inférieur ou égal au stock d'alerte, et dont la quantité annuelle est inférieure à 1000.
SELECT codart, libart, stkphy, stkale, qteann FROM `produit` WHERE stkphy <= stkale AND qteann < 1000;

-- 5 - Quels sont les fournisseurs situés dans les départements 75, 78, 92, 77 ?
SELECT SUBSTR(posfou,1,2) , nomfou FROM `fournis` WHERE posfou LIKE'75%' or posfou LIKE '78%' or posfou LIKE'92%' or posfou LIKE '77%' ORDER BY posfou DESC, nomfou;

-- 6 - Quelles sont les commandes passées en mars et en avril ?
SELECT datcom FROM `entcom`;
SELECT numcom, datcom FROM `entcom` WHERE month(datcom) = 3 or month(datcom) = 4;

-- 7 - Quelles sont les commandes du jour qui ont des observations particulières ?
SELECT numcom, datcom FROM `entcom` WHERE obscom IS NOT null AND year(datcom)= year(CURRENT_TIMESTAMP ());

-- 8 - Lister le total de chaque commande par total décroissant.
SELECT qtecde * priuni, numcom FROM `ligcom` GROUP BY numcom DESC;

-- 9 - Lister les commandes dont le total est supérieur à 10000€ ; on exclura dans le calcul du total les articles commandés en quantité supérieure ou égale à 1000.
SELECT numcom, qtecde * priuni as 'TOTAL' FROM `ligcom` WHERE qtecde < 1000 GROUP BY numcom, qtecde  * priuni >10000;

-- 10 - Lister les commandes par nom de fournisseur.
SELECT nomfou, datcom, numcom FROM `fournis`,`entcom` WHERE entcom.numfou = fournis.numfou;

-- 11 - Sortir les produits des commandes ayant le mot "urgent' en observation.
