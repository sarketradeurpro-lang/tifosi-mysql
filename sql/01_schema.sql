-- Base de donnees Tifosi - schema relationnel
-- Compatible avec MySQL 8.0.16 ou une version plus recente.
-- Executer ce script avec un compte ayant les droits CREATE DATABASE.

CREATE DATABASE IF NOT EXISTS tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tifosi;

CREATE TABLE IF NOT EXISTS marque (
    id_marque INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_marque VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom_marque)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ingredient (
    id_ingredient INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_ingredient VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom_ingredient)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS focaccia (
    id_focaccia INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_focaccia VARCHAR(50) NOT NULL,
    prix DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_focaccia_nom UNIQUE (nom_focaccia),
    CONSTRAINT chk_focaccia_prix_positif CHECK (prix > 0)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS boisson (
    id_boisson INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_boisson VARCHAR(50) NOT NULL,
    id_marque INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_boisson),
    CONSTRAINT uq_boisson_nom_marque UNIQUE (nom_boisson, id_marque),
    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque)
        REFERENCES marque (id_marque)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Association plusieurs-a-plusieurs. La quantite est exprimee en grammes.
-- Le MCD impose au moins un ingredient par focaccia; ce minimum devra etre
-- controle par l'application ou une regle supplementaire.
CREATE TABLE IF NOT EXISTS focaccia_ingredient (
    id_focaccia INT UNSIGNED NOT NULL,
    id_ingredient INT UNSIGNED NOT NULL,
    quantite_grammes INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT chk_composition_quantite_positive CHECK (quantite_grammes > 0),
    CONSTRAINT fk_composition_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_composition_ingredient
        FOREIGN KEY (id_ingredient)
        REFERENCES ingredient (id_ingredient)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS client (
    id_client INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_client VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email UNIQUE (email)
) ENGINE = InnoDB;

-- Le MCD indique qu'un menu est constitue d'une seule focaccia.
CREATE TABLE IF NOT EXISTS menu (
    id_menu INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_menu VARCHAR(50) NOT NULL,
    prix DECIMAL(5, 2) NOT NULL,
    id_focaccia INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom UNIQUE (nom_menu),
    CONSTRAINT chk_menu_prix_positif CHECK (prix > 0),
    CONSTRAINT fk_menu_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Association plusieurs-a-plusieurs entre menu et boisson.
-- Le minimum d'une boisson par menu (cardinalite 1,n du MCD) devra etre
-- controle par l'application ou une regle supplementaire : une cle etrangere
-- seule ne peut pas imposer la presence d'au moins une ligne ici.
CREATE TABLE IF NOT EXISTS menu_boisson (
    id_menu INT UNSIGNED NOT NULL,
    id_boisson INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_menu_boisson_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_menu_boisson_boisson
        FOREIGN KEY (id_boisson)
        REFERENCES boisson (id_boisson)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Relation d'achat entre client et menu, avec sa date.
-- Une cle technique permet d'enregistrer plusieurs achats le meme jour.
CREATE TABLE IF NOT EXISTS achat (
    id_achat INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_client INT UNSIGNED NOT NULL,
    id_menu INT UNSIGNED NOT NULL,
    date_achat DATE NOT NULL,
    PRIMARY KEY (id_achat),
    CONSTRAINT fk_achat_client
        FOREIGN KEY (id_client)
        REFERENCES client (id_client)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_achat_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_achat_date (date_achat)
) ENGINE = InnoDB;
