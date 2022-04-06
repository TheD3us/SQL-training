DROP TABLE conges, conges_mens, employes, services;



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
    FOREIGN KEY (code_service) REFERENCES services(code_service),
    FOREIGN KEY (code_emp) REFERENCES employes(code_emp)
    
);

CREATE TABLE services 
(
	code_service CHAR(5) PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL
);

CREATE TABLE conges
(
	code_emp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    annee NUMERIC(4,0) NOT NULL,
    nb_jours_acquis NUMERIC(2,0) DEFAULT 30,
    FOREIGN KEY (code_emp) REFERENCES employes(code_emp)
    
);

CREATE TABLE conges_mens
(
	code_emp INT AUTO_INCREMENT,
    annee NUMERIC(4,0),
    mois NUMERIC(2,0),
    nb_jours_pris NUMERIC(2,0) DEFAULT 0,
    CONSTRAINT PK_conges_mens PRIMARY KEY (code_emp, annee, mois),
    FOREIGN KEY (code_emp, annee) REFERENCES conges(code_emp, annee)
);