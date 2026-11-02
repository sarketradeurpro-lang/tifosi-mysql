-- Compte MySQL local pour la base Tifosi.
-- Remplacer le mot de passe fictif avant l'execution.
-- Ne jamais enregistrer un vrai mot de passe dans un depot public.

CREATE USER IF NOT EXISTS 'tifosi'@'localhost'
    IDENTIFIED BY 'A_REMPLACER_PAR_UN_MOT_DE_PASSE_FORT';

GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
