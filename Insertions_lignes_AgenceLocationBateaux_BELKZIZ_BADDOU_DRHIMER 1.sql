-- Insertions_lignes_AgenceLocationBateaux_BELKZIZ_BADDOU_DRHIMER.sql

-- **************************
-- Insertion des donnees dans la base
-- Projet : Agence de Location de Bateaux
-- Membres : BELKZIZ, BADDOU, DRHIMER
-- **************************

-- Table CLIENT
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (1, 'Dupont', 'Jean', 'jean.dupont@example.com', '0601020304');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (2, 'Martin', 'Sophie', 'sophie.martin@example.com', '0605060708');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (3, 'Durand', 'Pierre', 'pierre.durand@example.com', '0608091011');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (4, 'Moreau', 'Marie', 'marie.moreau@example.com', '0612131415');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (5, 'Lefevre', 'Paul', 'paul.lefevre@example.com', '0616171819');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (6, 'Garcia', 'Laura', 'laura.garcia@example.com', '0620212223');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (7, 'Roux', 'Luc', 'luc.roux@example.com', '0624252627');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (8, 'Petit', 'Emma', 'emma.petit@example.com', '0628293031');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (9, 'Morel', 'Hugo', 'hugo.morel@example.com', '0632333435');
INSERT INTO Client (ID_Client, Nom, Prenom, Email, Telephone) VALUES (10, 'Fournier', 'Julie', 'julie.fournier@example.com', '0636373839');

-- Table BATEAU
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (1, 'Le Voyageur', 'Voilier', 6, 'Disponible', 200.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (2, 'L Ocean', 'Yacht', 10, 'Disponible', 500.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (3, 'Le Dauphin', 'Catamaran', 8, 'Disponible', 300.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (4, 'L Aventure', 'Voilier', 4, 'Disponible', 150.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (5, 'Le Soleil', 'Yacht', 12, 'Disponible', 600.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (6, 'La Liberte', 'Catamaran', 10, 'Disponible', 350.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (7, 'L Etoile', 'Voilier', 5, 'Disponible', 180.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (8, 'Le Tresor', 'Yacht', 15, 'Disponible', 700.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (9, 'Le Vent', 'Catamaran', 8, 'Disponible', 320.00);
INSERT INTO Bateau (ID_Bateau, Nom, Type, Capacite, Statut, Prix_Jour) VALUES (10, 'La Mer', 'Voilier', 6, 'Disponible', 220.00);

-- Table RESERVATION
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (1, 1, 1, TO_DATE('2023-11-01', 'YYYY-MM-DD'), TO_DATE('2023-11-05', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (2, 2, 2, TO_DATE('2023-11-03', 'YYYY-MM-DD'), TO_DATE('2023-11-07', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (3, 3, 3, TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_DATE('2023-11-10', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (4, 4, 4, TO_DATE('2023-11-10', 'YYYY-MM-DD'), TO_DATE('2023-11-15', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (5, 5, 5, TO_DATE('2023-11-12', 'YYYY-MM-DD'), TO_DATE('2023-11-18', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (6, 6, 6, TO_DATE('2023-11-15', 'YYYY-MM-DD'), TO_DATE('2023-11-20', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (7, 7, 7, TO_DATE('2023-11-18', 'YYYY-MM-DD'), TO_DATE('2023-11-22', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (8, 8, 8, TO_DATE('2023-11-20', 'YYYY-MM-DD'), TO_DATE('2023-11-25', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (9, 9, 9, TO_DATE('2023-11-22', 'YYYY-MM-DD'), TO_DATE('2023-11-28', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (10, 10, 10, TO_DATE('2023-11-25', 'YYYY-MM-DD'), TO_DATE('2023-11-30', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (11, 1, 1, TO_DATE('2023-12-01', 'YYYY-MM-DD'), TO_DATE('2023-12-05', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (12, 2, 2, TO_DATE('2023-12-02', 'YYYY-MM-DD'), TO_DATE('2023-12-06', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (13, 3, 3, TO_DATE('2023-12-03', 'YYYY-MM-DD'), TO_DATE('2023-12-07', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (14, 4, 4, TO_DATE('2023-12-04', 'YYYY-MM-DD'), TO_DATE('2023-12-08', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (15, 5, 5, TO_DATE('2023-12-05', 'YYYY-MM-DD'), TO_DATE('2023-12-09', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (16, 6, 6, TO_DATE('2023-12-06', 'YYYY-MM-DD'), TO_DATE('2023-12-10', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (17, 7, 7, TO_DATE('2023-12-07', 'YYYY-MM-DD'), TO_DATE('2023-12-11', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (18, 8, 8, TO_DATE('2023-12-08', 'YYYY-MM-DD'), TO_DATE('2023-12-12', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (19, 9, 9, TO_DATE('2023-12-09', 'YYYY-MM-DD'), TO_DATE('2023-12-13', 'YYYY-MM-DD'));
INSERT INTO Reservation (ID_Reservation, ID_Client, ID_Bateau, Date_Debut, Date_Fin) VALUES (20, 10, 10, TO_DATE('2023-12-10', 'YYYY-MM-DD'), TO_DATE('2023-12-14', 'YYYY-MM-DD'));

-- Table PAIEMENT
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (1, 1, 800.00, TO_DATE('2023-10-30', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (2, 2, 2000.00, TO_DATE('2023-11-01', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (3, 3, 1500.00, TO_DATE('2023-11-03', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (4, 4, 750.00, TO_DATE('2023-11-08', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (5, 5, 3600.00, TO_DATE('2023-11-10', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (6, 6, 1750.00, TO_DATE('2023-11-13', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (7, 7, 720.00, TO_DATE('2023-11-16', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (8, 8, 3500.00, TO_DATE('2023-11-18', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (9, 9, 1920.00, TO_DATE('2023-11-20', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (10, 10, 1100.00, TO_DATE('2023-11-23', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (11, 11, 800.00, TO_DATE('2023-11-29', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (12, 12, 2000.00, TO_DATE('2023-11-30', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (13, 13, 1200.00, TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (14, 14, 600.00, TO_DATE('2023-12-02', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (15, 15, 2400.00, TO_DATE('2023-12-03', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (16, 16, 1400.00, TO_DATE('2023-12-04', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (17, 17, 720.00, TO_DATE('2023-12-05', 'YYYY-MM-DD'), 'Virement');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (18, 18, 2800.00, TO_DATE('2023-12-06', 'YYYY-MM-DD'), 'Especes');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (19, 19, 1280.00, TO_DATE('2023-12-07', 'YYYY-MM-DD'), 'Carte');
INSERT INTO Paiement (ID_Paiement, ID_Reservation, Montant, Date_Paiement, Mode_Paiement) VALUES (20, 20, 880.00, TO_DATE('2023-12-08', 'YYYY-MM-DD'), 'Virement');

-- Table SERVICE
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (1, 1, 'Personnel de bord', 400.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (2, 1, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (3, 2, 'Repas inclus', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (4, 3, 'Personnel de bord', 500.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (5, 4, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (6, 5, 'Repas inclus', 300.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (7, 6, 'Personnel de bord', 500.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (8, 7, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (9, 8, 'Repas inclus', 250.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (10, 9, 'Personnel de bord', 600.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (11, 10, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (12, 11, 'Repas inclus', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (13, 12, 'Personnel de bord', 400.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (14, 13, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (15, 14, 'Repas inclus', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (16, 15, 'Personnel de bord', 400.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (17, 16, 'equipement de plonge', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (18, 17, 'Repas inclus', 200.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (19, 18, 'Personnel de bord', 400.00);
INSERT INTO Service (ID_Service, ID_Reservation, Type_Service, Cout) VALUES (20, 19, 'equipement de plonge', 200.00);

-- Fin des insertions
