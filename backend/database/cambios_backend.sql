CREATE TABLE cafeterias (
    id_cafeteria VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

ALTER TABLE usuarios ADD COLUMN rol VARCHAR(20) NOT NULL DEFAULT 'estudiante';
ALTER TABLE usuarios ADD CONSTRAINT chk_rol CHECK (rol IN ('estudiante', 'cafeteria'));
ALTER TABLE usuarios ADD COLUMN id_cafeteria VARCHAR(20) REFERENCES cafeterias(id_cafeteria);
ALTER TABLE usuarios ALTER COLUMN matricula DROP NOT NULL;

ALTER TABLE productos ADD COLUMN id_cafeteria VARCHAR(20) REFERENCES cafeterias(id_cafeteria);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id_usuario),
    id_cafeteria VARCHAR(20) NOT NULL REFERENCES cafeterias(id_cafeteria),
    total DECIMAL(8, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_estado CHECK (estado IN ('PENDIENTE', 'EN_PREPARACION', 'LISTO', 'ENTREGADO'))
);

CREATE TABLE detalle_pedido (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES pedidos(id_pedido),
    id_producto INT NOT NULL REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(8, 2) NOT NULL
);
