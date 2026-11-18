CREATE TABLE cafeterias (
    id_cafeteria VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

ALTER TABLE usuarios ADD COLUMN rol VARCHAR(20) NOT NULL DEFAULT 'estudiante';
ALTER TABLE usuarios ADD CONSTRAINT chk_rol CHECK (rol IN ('estudiante', 'cafeteria'));
ALTER TABLE usuarios ADD COLUMN id_cafeteria VARCHAR(20) REFERENCES cafeterias(id_cafeteria);
ALTER TABLE usuarios ALTER COLUMN matricula DROP NOT NULL;

ALTER TABLE productos ADD COLUMN id_cafeteria VARCHAR(20) REFERENCES cafeterias(id_cafeteria);

ALTER TABLE pedidos ADD COLUMN id_cafeteria VARCHAR(20) REFERENCES cafeterias(id_cafeteria);
ALTER TABLE pedidos ADD CONSTRAINT chk_estado CHECK (estado IN ('PENDIENTE', 'EN_PREPARACION', 'LISTO', 'ENTREGADO'));
