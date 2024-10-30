-- Maj_Consultation_De_Donnees_AgenceLocationBateaux_BELKZIZ_BADDOU_DRHIMER.sql

-- **************************************************
-- Mise a jour, suppression et consultation des donnÃƒÂ©es
-- Projet : Agence de Location de Bateaux
-- Membres : BELKZIZ, BADDOU, DRHIMER
-- **************************************************

-- =========================================
-- Requetes de Suppression
-- =========================================

-- -------------------------------------------------
-- Suppression d'un client s'il n'a pas de reservations en cours ou futures.
-- Supprimer le client ID 5 s'il n'a pas de reservations en cours ou futures.
DELETE FROM Client
WHERE ID_Client = 5
  AND NOT EXISTS (
    SELECT 1 FROM Reservation
    WHERE ID_Client = 5
      AND Date_Fin >= SYSDATE
  );

-- -------------------------------------------------
-- Suppression d'un bateau s'il n'a pas de reservations futures ou en cours.
-- Supprimer le bateau ID 10 s'il n'est pas reserver pour des dates futures.
DELETE FROM Bateau
WHERE ID_Bateau = 10
  AND NOT EXISTS (
    SELECT 1 FROM Reservation
    WHERE ID_Bateau = 10
      AND Date_Fin >= SYSDATE
  );

-- -------------------------------------------------
-- Annulation d'une reservations si le client l'annule avant la date de debut.
-- Annuler la reservations ID 3 et rendre le bateau association disponible.
DECLARE
  v_ID_Bateau NUMBER;
BEGIN
  SELECT ID_Bateau INTO v_ID_Bateau FROM Reservation WHERE ID_Reservation = 3;

  DELETE FROM Reservation
  WHERE ID_Reservation = 3
    AND Date_Debut > SYSDATE;

  -- Mettre ÃƒÂ  jour le statut du bateau ÃƒÂ  'Disponible' si la rÃƒÂ©servation a ÃƒÂ©tÃƒÂ© supprimÃƒÂ©e
  UPDATE Bateau
  SET Statut = 'Disponible'
  WHERE ID_Bateau = v_ID_Bateau;
END;
/

-- -------------------------------------------------
-- Suppression d'un paiement en cas d'erreur de transaction, en maintenant un historique pour audit.
-- Supprimer le paiement ID 5 suite ÃƒÂ  une erreur, en enregistrant la raison de la suppression.

-- CrÃƒÂ©ation de la table d'audit pour Paiement (si elle n'existe pas)
BEGIN
  EXECUTE IMMEDIATE '
    CREATE TABLE Paiement_Audit (
      ID_Paiement    NUMBER(10),
      ID_Reservation NUMBER(10),
      Montant        NUMBER(10,2),
      Date_Paiement  DATE,
      Mode_Paiement  VARCHAR2(20),
      Reason         VARCHAR2(255),
      Deletion_Date  DATE
    )';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      NULL; -- Table already exists
    ELSE
      RAISE;
    END IF;
END;
/

-- Enregistrer le paiement supprimÃƒÂ© dans la table d'audit
INSERT INTO Paiement_Audit (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement, Reason, Deletion_Date)
SELECT ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement, 'Erreur de transaction', SYSDATE
FROM Paiement
WHERE ID_Paiement = 5;

-- Supprimer le paiement de la table Paiement
DELETE FROM Paiement
WHERE ID_Paiement = 5;

-- -------------------------------------------------
-- Suppression d'un service supplÃƒÂ©mentaire si le client dÃƒÂ©cide de l'annuler avant le dÃƒÂ©but de la location.
-- Supprimer le service ID 2 de la rÃƒÂ©servation ID 1.
DELETE FROM Service
WHERE ID_Service = 2
  AND ID_Reservation = 1
  AND EXISTS (
    SELECT 1 FROM Reservation
    WHERE ID_Reservation = 1
      AND Date_Debut > SYSDATE
  );

-- =========================================
-- RequÃƒÂªtes de Mise a� Jour
-- =========================================

-- -------------------------------------------------
-- Requetes impliquant 1 table
-- -------------------------------------------------

-- 1. Mise ÃƒÂ  jour des coordonnÃƒÂ©es d'un client.
-- Mettre ÃƒÂ  jour le client ID 1 avec le nouveau numÃƒÂ©ro de tÃƒÂ©lÃƒÂ©phone '0612345678' et l'email 'nouveau.email@example.com'.
UPDATE Client
SET Telephone = '0612345678',
    Email = 'nouveau.email@example.com'
WHERE ID_Client = 1;

-- 2. Changement du statut d'un bateau.
-- Mettre le statut du bateau ID 2 ÃƒÂ  'En Maintenance' pour entretien.
UPDATE Bateau
SET Statut = 'En Maintenance'
WHERE ID_Bateau = 2;

-- -------------------------------------------------
-- RequÃƒÂªtes impliquant 2 tables
-- -------------------------------------------------

-- 1. Modification des dates d'une rÃƒÂ©servation et mise ÃƒÂ  jour du statut du bateau.
-- Modifier la rÃƒÂ©servation ID 4 pour qu'elle se dÃƒÂ©roule du 10/12/2023 au 15/12/2023, et mettre ÃƒÂ  jour le statut du bateau concernÃƒÂ©.
UPDATE Reservation
SET Date_Debut = TO_DATE('2023-12-10', 'YYYY-MM-DD'),
    Date_Fin = TO_DATE('2023-12-15', 'YYYY-MM-DD')
WHERE ID_Reservation = 4;

-- Mettre ÃƒÂ  jour le statut du bateau associÃƒÂ© ÃƒÂ  la rÃƒÂ©servation.
UPDATE Bateau
SET Statut = 'Loue'
WHERE ID_Bateau = (SELECT ID_Bateau FROM Reservation WHERE ID_Reservation = 4);

-- 2. Mise ÃƒÂ  jour du montant du paiement aprÃƒÂ¨s modification de la rÃƒÂ©servation.
-- Recalculer le paiement pour la rÃƒÂ©servation ID 4 en fonction des nouvelles dates et des services associÃƒÂ©s.
UPDATE Paiement
SET Montant = (
    (
        SELECT (Date_Fin - Date_Debut) * Prix_Jour
        FROM Reservation R
        JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau
        WHERE R.ID_Reservation = 4
    ) + NVL(
        (SELECT SUM(Cout) FROM Service WHERE ID_Reservation = 4),
        0
    )
)
WHERE ID_Reservation = 4;

-- -------------------------------------------------
-- RequÃƒÂªtes impliquant plus de 2 tables
-- -------------------------------------------------

-- 1. Transfert d'une rÃƒÂ©servation ÃƒÂ  un autre client avec ajustement du paiement et des services.
-- TransfÃƒÂ©rer la rÃƒÂ©servation ID 5 au client ID 6, ajuster les services associÃƒÂ©s et recalculer le montant du paiement.
UPDATE Reservation
SET ID_Client = 6
WHERE ID_Reservation = 5;

-- Recalculer le montant du paiement pour le nouveau client.
UPDATE Paiement
SET Montant = (
    (
        SELECT (Date_Fin - Date_Debut) * Prix_Jour
        FROM Reservation R
        JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau
        WHERE R.ID_Reservation = 5
    ) + NVL(
        (SELECT SUM(Cout) FROM Service WHERE ID_Reservation = 5),
        0
    )
)
WHERE ID_Reservation = 5;

-- 2. Mise ÃƒÂ  jour des informations d'un client avec propagation aux rÃƒÂ©servations futures.
-- Mettre ÃƒÂ  jour les coordonnÃƒÂ©es du client ID 7 et propager les changements ÃƒÂ  toutes ses rÃƒÂ©servations futures.
UPDATE Client
SET Telephone = '0654321098',
    Email = 'updated.email@example.com'
WHERE ID_Client = 7;

-- Ajouter un commentaire aux rÃƒÂ©servations futures du client.
UPDATE Reservation
SET Commentaire = 'CoordonnÃƒÂ©es du client mises ÃƒÂ  jour.'
WHERE ID_Client = 7 AND Date_Debut > SYSDATE;

-- =========================================
-- RequÃƒÂªtes de Consultation
-- =========================================

-- -------------------------------------------------
-- RequÃƒÂªtes impliquant 1 table
-- -------------------------------------------------

-- 1. Lister tous les bateaux avec le statut 'Disponible', triÃƒÂ©s par nom.
SELECT *
FROM Bateau
WHERE Statut = 'Disponible'
ORDER BY Nom;

-- 2. Afficher toutes les informations du client ID 3.
SELECT *
FROM Client
WHERE ID_Client = 3;

-- 3. Compter le nombre de bateaux pour chaque type (GROUP BY Type).
SELECT Type, COUNT(*) AS Nombre_Bateaux
FROM Bateau
GROUP BY Type;

-- 4. Afficher tous les types de services disponibles sans doublons.
SELECT DISTINCT Type_Service
FROM Service;

-- 5. Lister tous les paiements, triÃƒÂ©s par date de paiement dÃƒÂ©croissante.
SELECT *
FROM Paiement
ORDER BY Date_Paiement DESC;

-- -------------------------------------------------
-- RequÃƒÂªtes impliquant 2 tables avec jointures internes
-- -------------------------------------------------

-- 1. Afficher les rÃƒÂ©servations en joignant les tables 'Reservation' et 'Client' sur 'ID_Client'.
SELECT R.ID_Reservation, C.Nom, C.Prenom, R.Date_Debut, R.Date_Fin
FROM Reservation R
JOIN Client C ON R.ID_Client = C.ID_Client;

-- 2. Afficher les bateaux louÃƒÂ©s en joignant 'Reservation' et 'Bateau' sur 'ID_Bateau'.
SELECT B.Nom AS Nom_Bateau, R.Date_Debut, R.Date_Fin
FROM Reservation R
JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau;

-- 3. Afficher tous les clients et leurs rÃƒÂ©servations, en utilisant une jointure externe pour inclure les clients sans rÃƒÂ©servation.
SELECT C.ID_Client, C.Nom, C.Prenom, R.ID_Reservation
FROM Client C
LEFT JOIN Reservation R ON C.ID_Client = R.ID_Client;

-- 4. Compter le nombre de rÃƒÂ©servations par client (GROUP BY 'ID_Client').
SELECT C.ID_Client, C.Nom, C.Prenom, COUNT(R.ID_Reservation) AS Nombre_Reservations
FROM Client C
LEFT JOIN Reservation R ON C.ID_Client = R.ID_Client
GROUP BY C.ID_Client, C.Nom, C.Prenom;

-- 5. SÃƒÂ©lectionner les paiements supÃƒÂ©rieurs ÃƒÂ  1000Ã¢â€šÂ¬, triÃƒÂ©s par montant dÃƒÂ©croissant.
SELECT *
FROM Paiement
WHERE Montant > 1000
ORDER BY Montant DESC;

-- -------------------------------------------------
-- RequÃƒÂªtes impliquant plus de 2 tables avec jointures internes
-- -------------------------------------------------

-- 1. Joindre les tables 'Client', 'Reservation' et 'Bateau' pour afficher les clients avec leurs rÃƒÂ©servations et les bateaux associÃƒÂ©s.
SELECT C.Nom, C.Prenom, R.ID_Reservation, B.Nom AS Nom_Bateau, R.Date_Debut, R.Date_Fin
FROM Client C
JOIN Reservation R ON C.ID_Client = R.ID_Client
JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau;

-- 2. Joindre 'Paiement', 'Reservation', 'Client' et 'Bateau' pour afficher les paiements avec les dÃƒÂ©tails complets.
SELECT P.ID_Paiement, P.Montant, P.Date_Paiement, C.Nom, C.Prenom, B.Nom AS Nom_Bateau
FROM Paiement P
JOIN Reservation R ON P.ID_Reservation = R.ID_Reservation
JOIN Client C ON R.ID_Client = C.ID_Client
JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau;

-- 3. Joindre 'Service', 'Reservation' et 'Client' pour afficher les services par rÃƒÂ©servation et par client.
SELECT S.Type_Service, S.Cout, R.ID_Reservation, C.Nom, C.Prenom
FROM Service S
JOIN Reservation R ON S.ID_Reservation = R.ID_Reservation
JOIN Client C ON R.ID_Client = C.ID_Client;

-- 4. Compter le nombre de rÃƒÂ©servations pour chaque type de bateau (GROUP BY 'Type').
SELECT B.Type, COUNT(R.ID_Reservation) AS Nombre_Reservations
FROM Reservation R
JOIN Bateau B ON R.ID_Bateau = B.ID_Bateau
GROUP BY B.Type;

-- 5. Afficher les clients et leurs paiements, y compris ceux sans paiements, triÃƒÂ©s par nom de client.
SELECT C.ID_Client, C.Nom, C.Prenom, P.ID_Paiement, P.Montant
FROM Client C
LEFT JOIN Reservation R ON C.ID_Client = R.ID_Client
LEFT JOIN Paiement P ON R.ID_Reservation = P.ID_Reservation
ORDER BY C.Nom;

-- Fin des mises ÃƒÂ  jour, suppressions et consultations
