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
SELECT SUBSTR(posfou,1,2) , nomfou FROM `fournis` 
WHERE posfou LIKE'75%' or posfou LIKE '78%' or posfou LIKE'92%' or posfou LIKE '77%' ORDER BY posfou DESC, nomfou;

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
SELECT entcom.numcom,nomfou,libart,qtecde * priuni FROM `entcom`,`fournis`,`ligcom`,`vente`,`produit`
WHERE obscom = 'commande urgente' AND entcom.numfou = fournis.numfou AND entcom.numcom = ligcom.numcom AND produit.codart = ligcom.codart
GROUP BY entcom.numcom,nomfou,libart;

-- 12 -Coder de 2 manières différentes la requête suivante : Lister le nom des fournisseurs susceptibles de livrer au moins un article.
SELECT nomfou FROM `entcom`,`fournis`,`ligcom`
WHERE entcom.numfou = fournis.numfou and entcom.numcom = ligcom.numcom  AND qteliv >= 1 GROUP BY nomfou;

-- 13 - Coder de 2 manières différentes la requête suivante : Lister les commandes dont le fournisseur est celui de la commande n°70210.
SELECT numcom, datcom FROM `entcom` WHERE numfou = (SELECT numfou FROM `entcom` WHERE numcom = 70210);

-- 14 - Dans les articles susceptibles d’être vendus, lister les articles moins chers (basés sur Prix1) que le moins cher des rubans (article dont le premier caractère commence par R).
SELECT libart,prix1 FROM `vente`,`produit`
WHERE produit.codart = vente.codart AND stkphy > 0 AND 'prix' < (select min(prix1) FROM `vente`,`produit` 
WHERE produit.codart = vente.codart AND libart  LIKE 'R%' )GROUP BY libart,prix1;

-- 15 - Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150 % du stock d'alerte.
SELECT libart, numfou, nomfou, stkale, stkphy FROM `produit`, `fournis` WHERE stkphy <= (stkale * 1.5);

-- 16 - Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150 % du stock d'alerte, et un délai de livraison d'au maximum 30 jours.
SELECT libart, fournis.numfou, nomfou, stkale, stkphy, delliv FROM `produit`, `fournis`, `vente` WHERE stkphy <= (stkale * 1.5) AND delliv < 30;

-- 17 - Avec le même type de sélection que ci-dessus, sortir un total des stocks par fournisseur, triés par total décroissant.
SELECT numfou, stkphy FROM `vente`, `produit` WHERE produit.codart = produit.codart GROUP BY numfou ORDER BY 'stock' DESC;

-- 18 - En fin d'année, sortir la liste des produits dont la quantité réellement commandée dépasse 90% de la quantité annuelle prévue.
SELECT libart, qtecde FROM `produit`, `ligcom` WHERE produit.codart = ligcom.codart GROUP BY libart, qteann HAVING qteann * 0.90 < qtecde;

-- 19 - Calculer le chiffre d'affaire par fournisseur pour l'année 2018, sachant que les prix indiqués sont hors taxes et que le taux de TVA est 20%.
SELECT numfou, qtecde * priuni * 0.20 FROM `ligcom`, `entcom` WHERE entcom.numcom = ligcom.numcom GROUP BY numfou;


-- MODIFIER UNE BDD

-- 1 - Appliquer une augmentation de tarif de 4% pour le prix 1, et de 2% pour le prix2, pour le fournisseur 9180.
UPDATE `vente` SET prix1 = prix *0.04 AND prix2 = prix2 * 0.02 WHERE numfou = 9180;

-- 2 - Dans la table vente, mettre à jour le prix2 des articles dont le prix2 est nul, en affectant la valeur du prix1.
UPDATE `vente` SET prix2 = prix1 WHERE prix2 IS NULL;

-- 3 - Mettre à jour le champ obscom, en renseignant ***** pour toutes les commandes dont le fournisseur a un indice de satisfaction inférieur à 5.
UPDATE `entcom` JOIN `fournis` ON entcom.numfou = fournis.numfou SET obscom = '****' WHERE satisf < 5;

-- 4 - Supprimer le produit "I110".
DELETE FROM `produit` WHERE codart = 'I110';
DELETE FROM `vente` WHERE codart = 'I110';
DELETE FROM `ligcom` WHERE codart = 'I110';