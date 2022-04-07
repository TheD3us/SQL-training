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