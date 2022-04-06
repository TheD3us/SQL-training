CREATE TABLE employes
(
	code_emp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    date_naissance DATE,
    date_embauche DATE,
    salaire DECIMAL(8,2) NOT NULL,
    code_service CHAR(5) NOT NULL,
    code_chef INT
    
);

CREATE TABLE services 
(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	code_service CHAR(5) NOT NULL,
    libelle VARCHAR(30) NOT NULL
);

CREATE TABLE conges_mens
(
	code_emp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    annee NUMERIC(4,0) NOT NULL,
    mois NUMERIC(2,0) NOT NULL,
    nb_jours_pris NUMERIC(2,0) DEFAULT 0
);

CREATE TABLE conges
(
	code_emp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    annee NUMERIC(4,0) NOT NULL,
    nb_jours_acquis NUMERIC(2,0) DEFAULT 30
);