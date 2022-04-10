ALTER TABLE employes DROP
FOREIGN KEY FK_employe_service ;

ALTER TABLE employes DROP
FOREIGN KEY FK_employe_employe;

ALTER TABLE conges DROP
FOREIGN KEY FK_employe_conge;

ALTER TABLE conges_mens DROP
FOREIGN KEY FK_conges_congesmens;

DROP TABLE  conges_mens,conges, employes, services;

CREATE TABLE services 
(
	code_service CHAR(5) PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL
);

CREATE TABLE employes
(
	code_emp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    date_naissance DATE,
    date_embauche DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    salaire DECIMAL(8,2) NOT NULL DEFAULT 0,
    code_service CHAR(5) NOT NULL,
    code_chef INT,
    CONSTRAINT FK_employe_service FOREIGN KEY (code_service) REFERENCES services(code_service)
    
    
);

ALTER TABLE employes ADD
CONSTRAINT FK_employe_employe FOREIGN KEY (code_chef) 
REFERENCES employes(code_emp);

CREATE TABLE conges
(
	code_emp INT,
    annee NUMERIC(4,0) NOT NULL,
    nb_jours_acquis NUMERIC(2,0) DEFAULT 30,
    CONSTRAINT PK_conges PRIMARY KEY (code_emp, annee),
    CONSTRAINT FK_employe_conge FOREIGN KEY (code_emp) REFERENCES employes(code_emp)
    
);

CREATE TABLE conges_mens
(
	code_emp INT AUTO_INCREMENT,
    annee NUMERIC(4,0),
    mois NUMERIC(2,0),
    nb_jours_pris NUMERIC(2,0) DEFAULT 0,
    CONSTRAINT PK_conges_mens PRIMARY KEY (code_emp, annee, mois),
    CONSTRAINT FK_conge_congesmens FOREIGN KEY (code_emp, annee) REFERENCES conges(code_emp, annee)
);





/*
SELECT nom, prenom, cm.annee, c.nb_jours_acquis - SUM(nb_jours_pris) jours_restants
	FROM employes e, conges c, conges_mens cm
	WHERE e.code_emp = c.code_emp
		AND c.code_emp = cm.code_emp
		AND c.annee = cm.annee
		AND c.annee = 2006
    GROUP BY nom, prenom, cm.annee
    HAVING jours_restants > 10;
	
==============================================================================================
TP 8

Requete 1 

SELECT nom, prenom, adresse, cpo, ville FROM clients AS c
LEFT JOIN fiches as f ON f.no_cli = c.no_cli WHERE etat = 'EC';

Requete 2

SELECT nom, prenom, ville, designation,depart, retour FROM clients as c 
LEFT JOIN fiches AS f ON c.no_cli = f.no_cli
LEFT JOIN lignesfic AS lf ON lf.no_fic = f.no_fic
RIGHT JOIN articles AS a ON a.refart = lf.refart
WHERE nom = 'Dupond' AND prenom = 'Jean' AND ville = 'Paris';

Requete 3

SELECT refart, designation, libelle FROM articles AS a
LEFT JOIN categories AS c ON a.code_cate = c.code_cate
WHERE libelle LIKE '%ski%';

Requete 4

SELECT f.no_fic, etat,SUM((prix_jour * (DATEDIFF(retour, depart)+1))) AS total FROM fiches AS f
LEFT JOIN lignesfic AS lf ON f.no_fic = lf.no_fic
LEFT JOIN articles AS a ON a.refart = lf.refart
LEFT JOIN grilletarifs AS g ON g.code_gam = a.code_gam AND g.code_cate = a.code_cate
LEFT JOIN tarifs AS t ON t.code_tarif = g.code_tarif
WHERE etat = 'SO'
GROUP BY no_fic

Requete 5 

SELECT COUNT(f.no_fic), etat FROM fiches AS f 
LEFT JOIN lignesfic AS lf ON f.no_fic = lf.no_fic
LEFT JOIN articles AS a ON a.refart = lf.refart
WHERE retour IS NULL;

Requete 6 

SELECT nom, prenom, COUNT(lf.refart) FROM clients AS c
LEFT JOIN fiches AS f ON c.no_cli = f.no_cli
LEFT JOIN lignesfic AS lf ON f.no_fic = lf.no_fic
GROUP BY nom, prenom;

Requete 7

SELECT nom, prenom, SUM((prix_jour * (DATEDIFF(IFNULL(retour, CURRENT_TIMESTAMP), depart)+1))) AS total FROM clients AS c
INNER JOIN fiches AS f ON c.no_cli = f.no_cli
INNER JOIN lignesfic AS lf ON f.no_fic = lf.no_fic
INNER JOIN articles AS a ON a.refart = lf.refart
INNER JOIN grilletarifs AS g ON g.code_gam = a.code_gam AND g.code_cate = a.code_cate
INNER JOIN tarifs AS t ON t.code_tarif = g.code_tarif 
GROUP BY c.no_cli
HAVING total > 200;
==============================================================================================
ALTER TABLE employes DROP
FOREIGN KEY FK_employes_codeservice ;

ALTER TABLE employes DROP
FOREIGN KEY FK_employes_codechef;

ALTER TABLE conges DROP
FOREIGN KEY FK_conges_employes;

ALTER TABLE conges_mens DROP
FOREIGN KEY FK_conges_congesmens;

ALTER TABLE employes ADD
CONSTRAINT FK_employes_codeservice FOREIGN KEY (code_service)
REFERENCES services(code_service);

ALTER TABLE employes ADD
CONSTRAINT FK_employes_codechef FOREIGN KEY (code_chef)
REFERENCES employes(code_emp);

ALTER TABLE conges ADD
CONSTRAINT FK_conges_employes FOREIGN KEY (code_emp)
REFERENCES employes(code_emp);

ALTER TABLE conges_mens ADD
CONSTRAINT FK_conges_congesmens FOREIGN KEY (code_emp, annee)
REFERENCES conges(code_emp, annee);

===============================================================================================
*/
DROP TABLE  categories, gammes, lignesfic, articles, grilletarifs, tarifs, clients, fiches;
CREATE TABLE clients 
(
	no_cli numeric(6) PRIMARY KEY,
    nom varchar(30) NOT NULL,
    prenom varchar(30),
    adresse varchar(120),
    cpo char(5) NOT NULL,
    ville varchar(80) NOT NULL DEFAULT 'NANTES'
);

CREATE TABLE fiches
(
 no_fic numeric(6) PRIMARY KEY,
 no_cli numeric(6) NOT NULL,
 date_crea datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
 date_paye datetime,
 etat char(2) NOT NULL DEFAULT 'EC'
    
);

CREATE TABLE lignesfic
(
	no_fic numeric(6),
	no_lig numeric(3),
	refart char(8)NOT NULL,
	depart datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	retour datetime,
	CONSTRAINT PK_lignesfic PRIMARY KEY (no_fic,no_lig)
);

CREATE TABLE articles
(
	refart char(8) PRIMARY KEY,
	designation varchar(80) NOT NULL,
	code_gam char(5) NOT NULL,
	code_cate char(5) NOT NULL
);

CREATE TABLE gammes
(
	code_gam char(5) PRIMARY KEY,
	libelle varchar(30) NOT NULL
);

CREATE TABLE grilletarifs
(
	code_gam char(5),
	code_cate char(5),
	code_tarif char(5) NOT NULL,
	CONSTRAINT PK_grilletarifs PRIMARY KEY (code_gam, code_cate)
);

CREATE TABLE categories
(
	code_cate char(5) PRIMARY KEY,
	libelle varchar(30)
);

CREATE TABLE tarifs
(
	code_tarif char(5) PRIMARY KEY,
	libelle varchar(30),
	prix_jour numeric(5,2) NOT NULL
);

ALTER TABLE fiches ADD
CONSTRAINT FK_clients_fiches FOREIGN KEY (no_cli) 
REFERENCES clients(no_cli);

ALTER TABLE lignesfic ADD
CONSTRAINT FK_fiches_lignesfic FOREIGN KEY (no_fic) 
REFERENCES fiches(no_fic);

ALTER TABLE lignesfic ADD
CONSTRAINT FK_articles_lignesfic FOREIGN KEY (refart) 
REFERENCES articles(refart);

ALTER TABLE grilletarifs ADD
CONSTRAINT FK_gammes_grilletarif FOREIGN KEY (code_gam) 
REFERENCES gammes(code_gam);

ALTER TABLE articles ADD
CONSTRAINT FK_grilletarifs_article FOREIGN KEY (code_gam,code_cate) 
REFERENCES grilletarifs(code_gam,code_cate);

ALTER TABLE grilletarifs ADD
CONSTRAINT FK_categories_grilletarifs FOREIGN KEY (code_cate) 
REFERENCES categories(code_cate);

ALTER TABLE grilletarifs ADD
CONSTRAINT FK_tarifs_grilletarifs FOREIGN KEY (code_tarif) 
REFERENCES tarifs(code_tarif);





START TRANSACTION;
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(1, 'Albert', 'Anatole', 'Rue des accacias', '61000', 'Amiens');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(2, 'Bernard', 'Barnabé', 'Rue du bar', '01000', 'Bourg en Bresse');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(3, 'Dupond', 'Camille', 'Rue Crébillon', '44000', 'Nantes');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(4, 'Desmoulin', 'Daniel', 'Rue descendante', '21000', 'Dijon');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(5, 'Ernest', 'Etienne', 'Rue de l’échaffaud' ,'42000', 'Saint Étienne');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(6, 'Ferdinand', 'François', 'Rue de la convention', '44100', 'Nantes');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(9, 'Dupond', 'Jean', 'Rue des mimosas', '75018', 'Paris');
INSERT INTO clients (no_cli,nom,prenom,adresse,cpo, ville) VALUES(14,'Boutaud' ,'Sabine', 'Rue des platanes', '75002', 'Paris');

INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1001, 14, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -15 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -13 DAY), 'SO');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1002, 4, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL  - 13 DAY), NULL ,'EC');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1003, 1, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 12 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY), 'SO');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1004, 6, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL  - 11 DAY), NULL , 'EC');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1005, 3, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL  - 10 DAY), NULL ,'EC');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1006, 9, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL  - 10 DAY), NULL ,'RE');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1007, 1, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL  - 3 DAY), NULL, 'EC');
INSERT INTO fiches (no_fic, no_cli,date_crea, date_paye,etat) VALUES (1008, 2, CURRENT_TIMESTAMP,NULL ,'EC');

INSERT INTO gammes (code_gam, libelle) VALUES ('PR', 'Matériel Professionnel');
INSERT INTO gammes (code_gam, libelle) VALUES ('HG', 'Haut de gamme');
INSERT INTO gammes (code_gam, libelle) VALUES ('MG', 'Moyenne gamme');
INSERT INTO gammes (code_gam, libelle) VALUES ('EG', 'Entrée de gamme');

INSERT INTO categories (code_cate, libelle) VALUES ('MONO', 'Monoski');
INSERT INTO categories (code_cate, libelle) VALUES ('SURF', 'Surf');
INSERT INTO categories (code_cate, libelle) VALUES ('PA', 'Patinette');
INSERT INTO categories (code_cate, libelle) VALUES ('FOA', 'Ski de fond alternatif');
INSERT INTO categories (code_cate, libelle) VALUES ('FOP', 'Ski de fond patineur');
INSERT INTO categories (code_cate, libelle) VALUES ('SA', 'Ski alpin');

INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T1', 'Base', 10);
INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T2', 'Chocolat', 15);
INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T3', 'Bronze', 20);
INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T4', 'Argent', 30);
INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T5', 'Or', 50);
INSERT INTO tarifs (code_tarif, libelle, prix_jour) VALUES('T6', 'Platine', 90);

INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'MONO', 'T1');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'MONO', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'SURF', 'T1');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'SURF', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('HG', 'SURF', 'T3');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('PR', 'SURF', 'T5');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'PA', 'T1');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'PA', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'FOA', 'T1');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'FOA', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('HG', 'FOA', 'T4');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('PR', 'FOA', 'T6');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'FOP', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'FOP', 'T3');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('HG', 'FOP', 'T4');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('PR', 'FOP', 'T6');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('EG', 'SA', 'T1');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('MG', 'SA', 'T2');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('HG', 'SA', 'T4');
INSERT INTO grilletarifs (code_gam, code_cate, code_tarif) VALUES ('PR', 'SA', 'T6');

INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F01', 'Fischer Cruiser', 'EG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F02', 'Fischer Cruiser', 'EG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F03', 'Fischer Cruiser', 'EG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F04', 'Fischer Cruiser', 'EG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F05', 'Fischer Cruiser', 'EG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F10', 'Fischer Sporty Crown', 'MG', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F20', 'Fischer RCS Classic GOLD', 'PR', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F21', 'Fischer RCS Classic GOLD', 'PR', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F22', 'Fischer RCS Classic GOLD', 'PR', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F23', 'Fischer RCS Classic GOLD', 'PR', 'FOA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F50', 'Fischer SOSSkating VASA', 'HG', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F60', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F61', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F62', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F63', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('F64', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('P01', 'Décathlon Allegre junior 150', 'EG', 'PA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('P10', 'Fischer mini ski patinette', 'MG', 'PA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('P11', 'Fischer mini ski patinette', 'MG', 'PA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('S01', 'Décathlon Apparition', 'EG', 'SURF');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('S02', 'Décathlon Apparition', 'EG', 'SURF');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('S03', 'Décathlon Apparition', 'EG', 'SURF');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A01', 'Salomon 24X+Z12', 'EG', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A02', 'Salomon 24X+Z12', 'EG', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A03', 'Salomon 24X+Z12', 'EG', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A04', 'Salomon 24X+Z12', 'EG', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A05', 'Salomon 24X+Z12', 'EG', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A10', 'Salomon Pro Link Equipe 4S', 'PR', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A11', 'Salomon Pro Link Equipe 4S', 'PR', 'SA');
INSERT INTO articles (refart, designation, code_gam, code_cate) VALUES ('A21', 'Salomon 3V RACE JR+L10', 'PR', 'SA');

INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1001, 1, 'F05', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 15 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 13 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1001, 2, 'F50', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 15 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 14 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1001, 3, 'F60', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 13 DAY), NULL);
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1002, 1, 'A03', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 13 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 9 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1002, 2, 'A04', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 12 DAY) ,DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 7 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1002, 3, 'S03', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 8 DAY),NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1003, 1, 'F50', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 12 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1003, 2, 'F05', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 12 DAY) , DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1004, 1, 'P01', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 6 DAY), NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1005, 1, 'F05', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 9 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 5 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1005, 2, 'F10', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 4 DAY),NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1006, 1, 'S01', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 9 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1006, 2, 'S02', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY) ,DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 9 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1006, 3, 'S03', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 10 DAY) ,DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 9 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1007, 1, 'F50', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 3 DAY), DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 2 DAY));
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1007, 3, 'F60', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 1 DAY), NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1007, 2, 'F05', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL - 3 DAY), NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1007, 4, 'S02', CURRENT_TIMESTAMP, NULL );
INSERT INTO lignesfic (no_fic, no_lig, refart, depart, retour) VALUES (1008, 1, 'S01', CURRENT_TIMESTAMP, NULL );

UPDATE lignesfic SET retour = DATE_ADD(depart, INTERVAL 6 HOUR) WHERE no_fic = 1001 AND no_lig = 3;

COMMIT;