-- Package_plsql_AgenceLocationBateaux_BELKZIZ_BADDOU_DRHIMER.sql

-- *********************************************************
-- D�finition et impl�mentation des packages PL/SQL
-- Projet : Agence de Location de Bateaux
-- Membres : BELKZIZ, BADDOU, DRHIMER
-- *********************************************************

-- =========================================
-- Package pour la table CLIENT
-- =========================================

-- ******************************
-- Sp�cification du package pkg_client
-- ******************************
CREATE OR REPLACE PACKAGE pkg_client IS
    -- Variables globales
    v_total_clients NUMBER;

    -- Erreurs
    e_client_not_found EXCEPTION;
    e_email_duplicate EXCEPTION;

    -- M�thodes
    PROCEDURE ajouter_client(p_nom IN VARCHAR2, p_prenom IN VARCHAR2, p_email IN VARCHAR2, p_telephone IN VARCHAR2, p_id_client OUT NUMBER);
    PROCEDURE modifier_client(p_id_client IN NUMBER, p_email IN VARCHAR2, p_telephone IN VARCHAR2);
    PROCEDURE supprimer_client(p_id_client IN NUMBER);
    FUNCTION consulter_client(p_id_client IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE compter_clients;
END pkg_client;
/
-- ******************************
-- Corps du package pkg_client
-- ******************************
CREATE OR REPLACE PACKAGE BODY pkg_client IS
    -- M�thodes

    PROCEDURE ajouter_client(p_nom IN VARCHAR2, p_prenom IN VARCHAR2, p_email IN VARCHAR2, p_telephone IN VARCHAR2, p_id_client OUT NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier l'unicit� de l'email
        SELECT COUNT(*) INTO v_count FROM Client WHERE Email = p_email;
        IF v_count > 0 THEN
            RAISE e_email_duplicate;
        ELSE
            -- G�n�rer un nouvel ID_Client
            SELECT NVL(MAX(ID_Client), 0) + 1 INTO p_id_client FROM Client;
            INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone)
            VALUES (p_id_client, p_nom, p_prenom, p_email, p_telephone);
        END IF;
    EXCEPTION
        WHEN e_email_duplicate THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : L''email existe d�j�.');
    END ajouter_client;

    PROCEDURE modifier_client(p_id_client IN NUMBER, p_email IN VARCHAR2, p_telephone IN VARCHAR2) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le client existe
        SELECT COUNT(*) INTO v_count FROM Client WHERE ID_Client = p_id_client;
        IF v_count = 0 THEN
            RAISE e_client_not_found;
        ELSE
            UPDATE Client
            SET Email = p_email,
                Telephone = p_telephone
            WHERE ID_Client = p_id_client;
        END IF;
    EXCEPTION
        WHEN e_client_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Client non trouv�.');
    END modifier_client;

    PROCEDURE supprimer_client(p_id_client IN NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le client a des r�servations en cours ou futures
        SELECT COUNT(*) INTO v_count FROM Reservation WHERE ID_Client = p_id_client AND Date_Fin >= SYSDATE;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le client a des r�servations en cours ou futures.');
        ELSE
            DELETE FROM Client WHERE ID_Client = p_id_client;
        END IF;
    END supprimer_client;

    FUNCTION consulter_client(p_id_client IN NUMBER) RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT * FROM Client WHERE ID_Client = p_id_client;
        RETURN rc;
    END consulter_client;

    PROCEDURE compter_clients IS
    BEGIN
        SELECT COUNT(*) INTO v_total_clients FROM Client;
        DBMS_OUTPUT.PUT_LINE('Nombre total de clients : ' || v_total_clients);
    END compter_clients;

END pkg_client;
/

-- =========================================
-- Package pour la table BATEAU
-- =========================================

-- ******************************
-- Sp�cification du package pkg_bateau
-- ******************************
CREATE OR REPLACE PACKAGE pkg_bateau IS
    -- Variables globales
    v_total_bateaux NUMBER;

    -- Erreurs
    e_bateau_not_found EXCEPTION;
    e_nom_bateau_duplicate EXCEPTION;

    -- M�thodes
    PROCEDURE ajouter_bateau(p_nom IN VARCHAR2, p_type IN VARCHAR2, p_capacite IN NUMBER, p_prix_jour IN NUMBER, p_id_bateau OUT NUMBER);
    PROCEDURE modifier_statut_bateau(p_id_bateau IN NUMBER, p_statut IN VARCHAR2);
    PROCEDURE supprimer_bateau(p_id_bateau IN NUMBER);
    FUNCTION consulter_bateau(p_id_bateau IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE compter_bateaux;
END pkg_bateau;
/
-- ******************************
-- Corps du package pkg_bateau
-- ******************************
CREATE OR REPLACE PACKAGE BODY pkg_bateau IS
    -- M�thodes

    PROCEDURE ajouter_bateau(p_nom IN VARCHAR2, p_type IN VARCHAR2, p_capacite IN NUMBER, p_prix_jour IN NUMBER, p_id_bateau OUT NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier l'unicit� du nom du bateau
        SELECT COUNT(*) INTO v_count FROM Bateau WHERE Nom = p_nom;
        IF v_count > 0 THEN
            RAISE e_nom_bateau_duplicate;
        ELSE
            -- G�n�rer un nouvel ID_Bateau
            SELECT NVL(MAX(ID_Bateau), 0) + 1 INTO p_id_bateau FROM Bateau;
            INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour)
            VALUES (p_id_bateau, p_nom, p_type, p_capacite, 'Disponible', p_prix_jour);
        END IF;
    EXCEPTION
        WHEN e_nom_bateau_duplicate THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le nom du bateau existe d�j�.');
    END ajouter_bateau;

    PROCEDURE modifier_statut_bateau(p_id_bateau IN NUMBER, p_statut IN VARCHAR2) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le bateau existe
        SELECT COUNT(*) INTO v_count FROM Bateau WHERE ID_Bateau = p_id_bateau;
        IF v_count = 0 THEN
            RAISE e_bateau_not_found;
        ELSE
            UPDATE Bateau
            SET Statut = p_statut
            WHERE ID_Bateau = p_id_bateau;
        END IF;
    EXCEPTION
        WHEN e_bateau_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Bateau non trouv�.');
    END modifier_statut_bateau;

    PROCEDURE supprimer_bateau(p_id_bateau IN NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le bateau a des r�servations futures ou en cours
        SELECT COUNT(*) INTO v_count FROM Reservation WHERE ID_Bateau = p_id_bateau AND Date_Fin >= SYSDATE;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le bateau a des r�servations en cours ou futures.');
        ELSE
            DELETE FROM Bateau WHERE ID_Bateau = p_id_bateau;
        END IF;
    END supprimer_bateau;

    FUNCTION consulter_bateau(p_id_bateau IN NUMBER) RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT * FROM Bateau WHERE ID_Bateau = p_id_bateau;
        RETURN rc;
    END consulter_bateau;

    PROCEDURE compter_bateaux IS
    BEGIN
        SELECT COUNT(*) INTO v_total_bateaux FROM Bateau;
        DBMS_OUTPUT.PUT_LINE('Nombre total de bateaux : ' || v_total_bateaux);
    END compter_bateaux;

END pkg_bateau;
/

-- =========================================
-- Package pour la table RESERVATION
-- =========================================

-- ******************************
-- Sp�cification du package pkg_reservation
-- ******************************
CREATE OR REPLACE PACKAGE pkg_reservation IS
    -- Erreurs
    e_reservation_not_found EXCEPTION;
    e_bateau_non_disponible EXCEPTION;
    e_bateau_en_maintenance EXCEPTION;

    -- M�thodes
    PROCEDURE creer_reservation(p_id_client IN NUMBER, p_id_bateau IN NUMBER, p_date_debut IN DATE, p_date_fin IN DATE, p_id_reservation OUT NUMBER);
    PROCEDURE modifier_reservation(p_id_reservation IN NUMBER, p_date_debut IN DATE, p_date_fin IN DATE);
    PROCEDURE annuler_reservation(p_id_reservation IN NUMBER);
    FUNCTION consulter_reservation(p_id_reservation IN NUMBER) RETURN SYS_REFCURSOR;
END pkg_reservation;
/
-- ******************************
-- Corps du package pkg_reservation
-- ******************************
CREATE OR REPLACE PACKAGE BODY pkg_reservation IS
    -- M�thodes

    PROCEDURE creer_reservation(p_id_client IN NUMBER, p_id_bateau IN NUMBER, p_date_debut IN DATE, p_date_fin IN DATE, p_id_reservation OUT NUMBER) IS
        v_statut VARCHAR2(20);
        v_count INTEGER;
    BEGIN
        -- V�rifier le statut du bateau
        SELECT Statut INTO v_statut FROM Bateau WHERE ID_Bateau = p_id_bateau;
        IF v_statut = 'En Maintenance' THEN
            RAISE e_bateau_en_maintenance;
        ELSIF v_statut = 'Lou�' THEN
            RAISE e_bateau_non_disponible;
        ELSE
            -- V�rifier la disponibilit� du bateau sur la p�riode
            SELECT COUNT(*) INTO v_count FROM Reservation
            WHERE ID_Bateau = p_id_bateau
              AND (p_date_debut BETWEEN Date_Debut AND Date_Fin
                   OR p_date_fin BETWEEN Date_Debut AND Date_Fin
                   OR Date_Debut BETWEEN p_date_debut AND p_date_fin);
            IF v_count > 0 THEN
                RAISE e_bateau_non_disponible;
            ELSE
                -- G�n�rer un nouvel ID_Reservation
                SELECT NVL(MAX(ID_Reservation), 0) + 1 INTO p_id_reservation FROM Reservation;
                INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin)
                VALUES (p_id_reservation, p_id_client, p_id_bateau, p_date_debut, p_date_fin);
                -- Mettre � jour le statut du bateau
                UPDATE Bateau SET Statut = 'Lou�' WHERE ID_Bateau = p_id_bateau;
            END IF;
        END IF;
    EXCEPTION
        WHEN e_bateau_non_disponible THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le bateau n''est pas disponible pour cette p�riode.');
        WHEN e_bateau_en_maintenance THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le bateau est en maintenance.');
    END creer_reservation;

    PROCEDURE modifier_reservation(p_id_reservation IN NUMBER, p_date_debut IN DATE, p_date_fin IN DATE) IS
        v_id_bateau NUMBER;
        v_count INTEGER;
    BEGIN
        -- V�rifier si la r�servation existe
        SELECT ID_Bateau INTO v_id_bateau FROM Reservation WHERE ID_Reservation = p_id_reservation;
        -- V�rifier la disponibilit� du bateau pour les nouvelles dates
        SELECT COUNT(*) INTO v_count FROM Reservation
        WHERE ID_Bateau = v_id_bateau
          AND ID_Reservation != p_id_reservation
          AND (p_date_debut BETWEEN Date_Debut AND Date_Fin
               OR p_date_fin BETWEEN Date_Debut AND Date_Fin
               OR Date_Debut BETWEEN p_date_debut AND p_date_fin);
        IF v_count > 0 THEN
            RAISE e_bateau_non_disponible;
        ELSE
            UPDATE Reservation
            SET Date_Debut = p_date_debut,
                Date_Fin = p_date_fin
            WHERE ID_Reservation = p_id_reservation;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : R�servation non trouv�e.');
        WHEN e_bateau_non_disponible THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Le bateau n''est pas disponible pour ces nouvelles dates.');
    END modifier_reservation;

    PROCEDURE annuler_reservation(p_id_reservation IN NUMBER) IS
        v_id_bateau NUMBER;
    BEGIN
        -- R�cup�rer l'ID du bateau
        SELECT ID_Bateau INTO v_id_bateau FROM Reservation WHERE ID_Reservation = p_id_reservation;
        -- Supprimer la r�servation
        DELETE FROM Reservation WHERE ID_Reservation = p_id_reservation;
        -- Mettre � jour le statut du bateau s'il n'a plus de r�servations futures
        DECLARE
            v_count INTEGER;
        BEGIN
            SELECT COUNT(*) INTO v_count FROM Reservation WHERE ID_Bateau = v_id_bateau AND Date_Fin >= SYSDATE;
            IF v_count = 0 THEN
                UPDATE Bateau SET Statut = 'Disponible' WHERE ID_Bateau = v_id_bateau;
            END IF;
        END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : R�servation non trouv�e.');
    END annuler_reservation;

    FUNCTION consulter_reservation(p_id_reservation IN NUMBER) RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT * FROM Reservation WHERE ID_Reservation = p_id_reservation;
        RETURN rc;
    END consulter_reservation;

END pkg_reservation;
/

-- =========================================
-- Package pour la table PAIEMENT
-- =========================================

-- ******************************
-- Sp�cification du package pkg_paiement
-- ******************************
CREATE OR REPLACE PACKAGE pkg_paiement IS
    -- Erreurs
    e_paiement_not_found EXCEPTION;
    e_paiement_already_exists EXCEPTION;

    -- M�thodes
    PROCEDURE enregistrer_paiement(p_id_reservation IN NUMBER, p_montant IN NUMBER, p_mode_paiement IN VARCHAR2, p_id_paiement OUT NUMBER);
    PROCEDURE modifier_paiement(p_id_paiement IN NUMBER, p_montant IN NUMBER);
    PROCEDURE supprimer_paiement(p_id_paiement IN NUMBER);
    FUNCTION consulter_paiement(p_id_paiement IN NUMBER) RETURN SYS_REFCURSOR;
END pkg_paiement;
/
-- ******************************
-- Corps du package pkg_paiement
-- ******************************
CREATE OR REPLACE PACKAGE BODY pkg_paiement IS
    -- M�thodes

    PROCEDURE enregistrer_paiement(p_id_reservation IN NUMBER, p_montant IN NUMBER, p_mode_paiement IN VARCHAR2, p_id_paiement OUT NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si un paiement existe d�j� pour cette r�servation
        SELECT COUNT(*) INTO v_count FROM Paiement WHERE ID_Reservation = p_id_reservation;
        IF v_count > 0 THEN
            RAISE e_paiement_already_exists;
        ELSE
            -- G�n�rer un nouvel ID_Paiement
            SELECT NVL(MAX(ID_Paiement), 0) + 1 INTO p_id_paiement FROM Paiement;
            INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement)
            VALUES (p_id_paiement, p_id_reservation, p_montant, SYSDATE, p_mode_paiement);
        END IF;
    EXCEPTION
        WHEN e_paiement_already_exists THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Un paiement existe d�j� pour cette r�servation.');
    END enregistrer_paiement;

    PROCEDURE modifier_paiement(p_id_paiement IN NUMBER, p_montant IN NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le paiement existe
        SELECT COUNT(*) INTO v_count FROM Paiement WHERE ID_Paiement = p_id_paiement;
        IF v_count = 0 THEN
            RAISE e_paiement_not_found;
        ELSE
            UPDATE Paiement
            SET Montant = p_montant
            WHERE ID_Paiement = p_id_paiement;
        END IF;
    EXCEPTION
        WHEN e_paiement_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Paiement non trouv�.');
    END modifier_paiement;

    PROCEDURE supprimer_paiement(p_id_paiement IN NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le paiement existe
        SELECT COUNT(*) INTO v_count FROM Paiement WHERE ID_Paiement = p_id_paiement;
        IF v_count = 0 THEN
            RAISE e_paiement_not_found;
        ELSE
            DELETE FROM Paiement WHERE ID_Paiement = p_id_paiement;
        END IF;
    EXCEPTION
        WHEN e_paiement_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Paiement non trouv�.');
    END supprimer_paiement;

    FUNCTION consulter_paiement(p_id_paiement IN NUMBER) RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT * FROM Paiement WHERE ID_Paiement = p_id_paiement;
        RETURN rc;
    END consulter_paiement;

END pkg_paiement;
/

-- =========================================
-- Package pour la table SERVICE
-- =========================================

-- ******************************
-- Sp�cification du package pkg_service
-- ******************************
CREATE OR REPLACE PACKAGE pkg_service IS
    -- Erreurs
    e_service_not_found EXCEPTION;

    -- M�thodes
    PROCEDURE ajouter_service(p_id_reservation IN NUMBER, p_type_service IN VARCHAR2, p_cout IN NUMBER, p_id_service OUT NUMBER);
    PROCEDURE supprimer_service(p_id_service IN NUMBER);
    FUNCTION consulter_service(p_id_service IN NUMBER) RETURN SYS_REFCURSOR;
END pkg_service;
/
-- ******************************
-- Corps du package pkg_service
-- ******************************
CREATE OR REPLACE PACKAGE BODY pkg_service IS
    -- M�thodes

    PROCEDURE ajouter_service(p_id_reservation IN NUMBER, p_type_service IN VARCHAR2, p_cout IN NUMBER, p_id_service OUT NUMBER) IS
    BEGIN
        -- G�n�rer un nouvel ID_Service
        SELECT NVL(MAX(ID_Service), 0) + 1 INTO p_id_service FROM Service;
        INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout)
        VALUES (p_id_service, p_id_reservation, p_type_service, p_cout);
    END ajouter_service;

    PROCEDURE supprimer_service(p_id_service IN NUMBER) IS
        v_count INTEGER;
    BEGIN
        -- V�rifier si le service existe
        SELECT COUNT(*) INTO v_count FROM Service WHERE ID_Service = p_id_service;
        IF v_count = 0 THEN
            RAISE e_service_not_found;
        ELSE
            DELETE FROM Service WHERE ID_Service = p_id_service;
        END IF;
    EXCEPTION
        WHEN e_service_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Service non trouv�.');
    END supprimer_service;

    FUNCTION consulter_service(p_id_service IN NUMBER) RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT * FROM Service WHERE ID_Service = p_id_service;
        RETURN rc;
    END consulter_service;

END pkg_service;
/

-- =========================================
-- Tests des m�thodes des packages
-- =========================================

-- ******************************
-- Tests du package pkg_client
-- ******************************
DECLARE
    v_id_client NUMBER;
BEGIN
    -- Ajouter un client
    pkg_client.ajouter_client('TestNom', 'TestPrenom', 'test.email@example.com', '0600000000', v_id_client);
    -- Consulter le client
    DECLARE
        rc SYS_REFCURSOR;
        v_client Client%ROWTYPE;
    BEGIN
        rc := pkg_client.consulter_client(p_id_client => v_id_client);
        FETCH rc INTO v_client;
        DBMS_OUTPUT.PUT_LINE('Client ajout� : ' || v_client.Nom || ' ' || v_client.Prenom);
        CLOSE rc;
    END;
    -- Compter les clients
    pkg_client.compter_clients;
    -- Modifier le client
    pkg_client.modifier_client(p_id_client => v_id_client, p_email => 'nouveau.email@example.com', p_telephone => '0612345678');
    -- Supprimer le client
    pkg_client.supprimer_client(p_id_client => v_id_client);
END;
/

-- ******************************
-- Tests du package pkg_bateau
-- ******************************
DECLARE
    v_id_bateau NUMBER;
BEGIN
    -- Ajouter un bateau
    pkg_bateau.ajouter_bateau('TestBateau', 'Voilier', 8, 250.00, v_id_bateau);
    -- Consulter le bateau
    DECLARE
        rc SYS_REFCURSOR;
        v_bateau Bateau%ROWTYPE;
    BEGIN
        rc := pkg_bateau.consulter_bateau(p_id_bateau => v_id_bateau);
        FETCH rc INTO v_bateau;
        DBMS_OUTPUT.PUT_LINE('Bateau ajout� : ' || v_bateau.Nom);
        CLOSE rc;
    END;
    -- Compter les bateaux
    pkg_bateau.compter_bateaux;
    -- Modifier le statut du bateau
    pkg_bateau.modifier_statut_bateau(p_id_bateau => v_id_bateau, p_statut => 'En Maintenance');
    -- Supprimer le bateau
    pkg_bateau.supprimer_bateau(p_id_bateau => v_id_bateau);
END;
/

-- ******************************
-- Tests du package pkg_reservation
-- ******************************
DECLARE
    v_id_reservation NUMBER;
BEGIN
    -- Cr�er une r�servation
    pkg_reservation.creer_reservation(p_id_client => 1, p_id_bateau => 2, p_date_debut => TO_DATE('2023-12-01', 'YYYY-MM-DD'), p_date_fin => TO_DATE('2023-12-05', 'YYYY-MM-DD'), v_id_reservation);
    -- Consulter la r�servation
    DECLARE
        rc SYS_REFCURSOR;
        v_reservation Reservation%ROWTYPE;
    BEGIN
        rc := pkg_reservation.consulter_reservation(p_id_reservation => v_id_reservation);
        FETCH rc INTO v_reservation;
        DBMS_OUTPUT.PUT_LINE('R�servation cr��e pour le client ID : ' || v_reservation.ID_Client);
        CLOSE rc;
    END;
    -- Modifier la r�servation
    pkg_reservation.modifier_reservation(p_id_reservation => v_id_reservation, p_date_debut => TO_DATE('2023-12-02', 'YYYY-MM-DD'), p_date_fin => TO_DATE('2023-12-06', 'YYYY-MM-DD'));
    -- Annuler la r�servation
    pkg_reservation.annuler_reservation(p_id_reservation => v_id_reservation);
END;
/

-- ******************************
-- Tests du package pkg_paiement
-- ******************************
DECLARE
    v_id_paiement NUMBER;
BEGIN
    -- Enregistrer un paiement
    pkg_paiement.enregistrer_paiement(p_id_reservation => 1, p_montant => 1000.00, p_mode_paiement => 'Carte', v_id_paiement);
    -- Consulter le paiement
    DECLARE
        rc SYS_REFCURSOR;
        v_paiement Paiement%ROWTYPE;
    BEGIN
        rc := pkg_paiement.consulter_paiement(p_id_paiement => v_id_paiement);
        FETCH rc INTO v_paiement;
        DBMS_OUTPUT.PUT_LINE('Paiement enregistr� pour la r�servation ID : ' || v_paiement.ID_Reservation);
        CLOSE rc;
    END;
    -- Modifier le paiement
    pkg_paiement.modifier_paiement(p_id_paiement => v_id_paiement, p_montant => 1200.00);
    -- Supprimer le paiement
    pkg_paiement.supprimer_paiement(p_id_paiement => v_id_paiement);
END;
/

-- ******************************
-- Tests du package pkg_service
-- ******************************
DECLARE
    v_id_service NUMBER;
BEGIN
    -- Ajouter un service
    pkg_service.ajouter_service(p_id_reservation => 1, p_type_service => 'Guide Touristique', p_cout => 300.00, v_id_service);
    -- Consulter le service
    DECLARE
        rc SYS_REFCURSOR;
        v_service Service%ROWTYPE;
    BEGIN
        rc := pkg_service.consulter_service(p_id_service => v_id_service);
        FETCH rc INTO v_service;
        DBMS_OUTPUT.PUT_LINE('Service ajout� : ' || v_service.Type_Service);
        CLOSE rc;
    END;
    -- Supprimer le service
    pkg_service.supprimer_service(p_id_service => v_id_service);
END;
/

-- =========================================
-- Triggers
-- =========================================

-- ******************************
-- Trigger 1 : V�rification du statut du bateau avant une r�servation
-- ******************************
CREATE OR REPLACE TRIGGER trg_verif_statut_bateau
BEFORE INSERT OR UPDATE ON Reservation
FOR EACH ROW
DECLARE
    v_statut VARCHAR2(20);
    v_count INTEGER;
BEGIN
    SELECT Statut INTO v_statut FROM Bateau WHERE ID_Bateau = :NEW.ID_Bateau;
    IF v_statut <> 'Disponible' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le bateau n''est pas disponible pour la r�servation.');
    END IF;

    -- V�rifier la disponibilit� du bateau pour la p�riode
    SELECT COUNT(*) INTO v_count FROM Reservation
    WHERE ID_Bateau = :NEW.ID_Bateau
      AND ( :NEW.Date_Debut BETWEEN Date_Debut AND Date_Fin
           OR :NEW.Date_Fin BETWEEN Date_Debut AND Date_Fin
           OR Date_Debut BETWEEN :NEW.Date_Debut AND :NEW.Date_Fin)
      AND (ID_Reservation != NVL(:NEW.ID_Reservation, -1));
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Le bateau est d�j� r�serv� pour cette p�riode.');
    END IF;
END;
/

-- ******************************
-- Trigger 2 : Mise � jour automatique du statut du bateau apr�s suppression d'une r�servation
-- ******************************
CREATE OR REPLACE TRIGGER trg_maj_statut_bateau_apres_suppression
AFTER DELETE ON Reservation
FOR EACH ROW
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Reservation WHERE ID_Bateau = :OLD.ID_Bateau AND Date_Fin >= SYSDATE;
    IF v_count = 0 THEN
        UPDATE Bateau SET Statut = 'Disponible' WHERE ID_Bateau = :OLD.ID_Bateau;
    END IF;
END;
/

-- Fin du script
