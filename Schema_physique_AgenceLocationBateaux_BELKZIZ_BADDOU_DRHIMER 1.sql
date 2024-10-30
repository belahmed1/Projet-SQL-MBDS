-- Schema_physique_AgenceLocationBateaux_BELKZIZ_BADDOU_DRHIMER.sql

-- **************************************************
-- CrÃ©ation du schÃ©ma physique de donnÃ©es
-- Projet : Agence de Location de Bateaux
-- Membres : BELKZIZ, BADDOU, DRHIMER
-- **************************************************

-- ==================================================
-- Suppression des tables existantes (si nÃ©cessaire)
-- ==================================================

-- Pour Ã©viter les erreurs lors de la crÃ©ation des tables, nous supprimons les tables existantes.
-- Attention : Cette opÃ©ration supprimera toutes les donnÃ©es prÃ©sentes dans les tables.

DROP TABLE Service CASCADE CONSTRAINTS PURGE;
DROP TABLE Paiement CASCADE CONSTRAINTS PURGE;
DROP TABLE Reservation CASCADE CONSTRAINTS PURGE;
DROP TABLE Bateau CASCADE CONSTRAINTS PURGE;
DROP TABLE Client CASCADE CONSTRAINTS PURGE;


DROP SEQUENCE seq_client;
DROP SEQUENCE seq_bateau;
DROP SEQUENCE seq_reservation;
DROP SEQUENCE seq_paiement;
DROP SEQUENCE seq_service;
-- ==================================================
-- CrÃ©ation des tables
-- ==================================================

-- ---------------------------
-- Table CLIENT
-- ---------------------------

CREATE TABLE Client (
    ID_Client      NUMBER(10)    PRIMARY KEY,
    Nom            VARCHAR2(50)  NOT NULL,
    Prenom         VARCHAR2(50)  NOT NULL,
    Email          VARCHAR2(100) NOT NULL ,
    Telephone      VARCHAR2(15)  NOT NULL
);


-- ---------------------------
-- Table BATEAU
-- ---------------------------

CREATE TABLE Bateau (
    ID_Bateau      NUMBER(10)    PRIMARY KEY,
    Nom            VARCHAR2(100) NOT NULL UNIQUE,
    Type          VARCHAR2(50)  NOT NULL,
    Capacite       NUMBER(3)     NOT NULL CHECK (Capacite > 0),
    Statut         VARCHAR2(20)  NOT NULL CHECK (Statut IN ('Disponible', 'Loue', 'En Maintenance')),
    Prix_Jour      NUMBER(10,2)  NOT NULL CHECK (Prix_Jour > 0)
);

-- ---------------------------
-- Table RESERVATION
-- ---------------------------

CREATE TABLE Reservation (
    ID_Reservation NUMBER(10)    PRIMARY KEY,
    ID_Client      NUMBER(10)    NOT NULL,
    ID_Bateau      NUMBER(10)    NOT NULL,
    Date_Debut     DATE          NOT NULL,
    Date_Fin       DATE          NOT NULL,
    Commentaire    VARCHAR2(255),
    CONSTRAINT fk_reservation_client FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client) ON DELETE CASCADE,
    CONSTRAINT fk_reservation_bateau FOREIGN KEY (ID_Bateau) REFERENCES Bateau(ID_Bateau) ON DELETE CASCADE,
    CONSTRAINT chk_date_reservation CHECK (Date_Fin > Date_Debut)
);

-- ---------------------------
-- Table PAIEMENT
-- ---------------------------

CREATE TABLE Paiement (
    ID_Paiement    NUMBER(10)    PRIMARY KEY,
    ID_Reservation NUMBER(10)    UNIQUE NOT NULL,
    Montant        NUMBER(10,2)  NOT NULL CHECK (Montant > 0),
    Date_Paiement  DATE          NOT NULL,
    Mode_Paiement  VARCHAR2(20)  NOT NULL CHECK (Mode_Paiement IN ('Carte', 'Virement', 'Especes')),
    CONSTRAINT fk_paiement_reservation FOREIGN KEY (ID_Reservation) REFERENCES Reservation(ID_Reservation) ON DELETE CASCADE
);

-- ---------------------------
-- Table SERVICE
-- ---------------------------

CREATE TABLE Service (
    ID_Service     NUMBER(10)    PRIMARY KEY,
    ID_Reservation NUMBER(10)    NOT NULL,
    Type_Service   VARCHAR2(50)  NOT NULL,
    Cout           NUMBER(10,2)  NOT NULL CHECK (Cout >= 0),
    CONSTRAINT fk_service_reservation FOREIGN KEY (ID_Reservation) REFERENCES Reservation(ID_Reservation) ON DELETE CASCADE
);

-- ==================================================
-- CrÃ©ation des index (si nÃ©cessaire)
-- ==================================================

-- Index sur le statut des bateaux pour optimiser les requÃªtes de recherche
CREATE INDEX idx_bateau_statut ON Bateau(Statut);

-- Index sur le type de bateau
CREATE INDEX idx_bateau_type ON Bateau(Type);

-- Index sur l'email des clients pour assurer l'unicitÃ© et optimiser les recherches
CREATE UNIQUE INDEX idx_client_email ON Client(Email);

-- ==================================================
-- CrÃ©ation des sÃ©quences pour les identifiants automatiques (optionnel)
-- ==================================================


-- SÃ©quence pour la table Client
CREATE SEQUENCE seq_client
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- SÃ©quence pour la table Bateau
CREATE SEQUENCE seq_bateau
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- SÃ©quence pour la table Reservation
CREATE SEQUENCE seq_reservation
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- SÃ©quence pour la table Paiement
CREATE SEQUENCE seq_paiement
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- SÃ©quence pour la table Service
CREATE SEQUENCE seq_service
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- ==================================================
-- CrÃ©ation des triggers pour l'auto-incrÃ©mentation des identifiants (optionnel)
-- ==================================================

-- Trigger pour la table Client
CREATE OR REPLACE TRIGGER trg_client_id
BEFORE INSERT ON Client
FOR EACH ROW
BEGIN
    IF :NEW.ID_Client IS NULL THEN
        SELECT seq_client.NEXTVAL INTO :NEW.ID_Client FROM dual;
    END IF;
END;
/

-- Trigger pour la table Bateau
CREATE OR REPLACE TRIGGER trg_bateau_id
BEFORE INSERT ON Bateau
FOR EACH ROW
BEGIN
    IF :NEW.ID_Bateau IS NULL THEN
        SELECT seq_bateau.NEXTVAL INTO :NEW.ID_Bateau FROM dual;
    END IF;
END;
/

-- Trigger pour la table Reservation
CREATE OR REPLACE TRIGGER trg_reservation_id
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    IF :NEW.ID_Reservation IS NULL THEN
        SELECT seq_reservation.NEXTVAL INTO :NEW.ID_Reservation FROM dual;
    END IF;
END;
/

-- Trigger pour la table Paiement
CREATE OR REPLACE TRIGGER trg_paiement_id
BEFORE INSERT ON Paiement
FOR EACH ROW
BEGIN
    IF :NEW.ID_Paiement IS NULL THEN
        SELECT seq_paiement.NEXTVAL INTO :NEW.ID_Paiement FROM dual;
    END IF;
END;
/

-- Trigger pour la table Service
CREATE OR REPLACE TRIGGER trg_service_id
BEFORE INSERT ON Service
FOR EACH ROW
BEGIN
    IF :NEW.ID_Service IS NULL THEN
        SELECT seq_service.NEXTVAL INTO :NEW.ID_Service FROM dual;
    END IF;
END;
/





-- ==================================================
-- Fin du script
-- ==================================================

-- Instructions pour l'exÃ©cution du script :

-- 1. Connectez-vous Ã  votre base de donnÃ©es Oracle en utilisant un outil tel que SQL*Plus ou Oracle SQL Developer.
-- 2. Ouvrez ce script dans l'Ã©diteur SQL de votre choix.
-- 3. ExÃ©cutez le script dans son intÃ©gralitÃ© pour crÃ©er toutes les tables, sÃ©quences et triggers.
-- 4. VÃ©rifiez qu'aucune erreur ne s'est produite lors de l'exÃ©cution.
-- 5. Vous pouvez ensuite procÃ©der Ã  l'insertion des donnÃ©es en utilisant le script d'insertion fourni prÃ©cÃ©demment.

-- Remarques :

-- - Les sÃ©quences et triggers sont optionnels et permettent d'auto-incrÃ©menter les identifiants si vous ne souhaitez pas les fournir manuellement lors des insertions.
-- - Les contraintes d'intÃ©gritÃ© rÃ©fÃ©rentielle (clÃ©s Ã©trangÃ¨res) sont dÃ©finies avec l'option ON DELETE CASCADE pour supprimer automatiquement les enregistrements dÃ©pendants en cas de suppression.
-- - Les index crÃ©Ã©s amÃ©liorent les performances des requÃªtes de recherche sur les colonnes frÃ©quemment utilisÃ©es dans les clauses WHERE.
-- - Assurez-vous que l'utilisateur Oracle avec lequel vous vous connectez dispose des privilÃ¨ges suffisants pour crÃ©er des tables, sÃ©quences et triggers.

-- Fin du script.
