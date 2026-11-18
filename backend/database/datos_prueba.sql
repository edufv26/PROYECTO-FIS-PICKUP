INSERT INTO cafeterias (id_cafeteria, nombre) VALUES
('CAF_GRANDE', 'Cafetería Principal (Grande)'),
('CAF_CHICA_1', 'Cafetería Pequeña 1'),
('CAF_CHICA_2', 'Cafetería Pequeña 2');

INSERT INTO categorias (nombre) VALUES
('Desayunos'), ('Tortas'), ('Antojitos'), ('Comida Corrida'), ('Bebidas');

INSERT INTO productos (id_categoria, id_cafeteria, nombre, precio, disponible, stock) VALUES
(1, 'CAF_GRANDE', 'Chilaquiles Verdes con Pollo', 55.00, TRUE, 20),
(2, 'CAF_GRANDE', 'Torta de Milanesa Especial', 48.00, TRUE, 15),
(3, 'CAF_GRANDE', 'Orden de 3 Quesadillas', 42.00, TRUE, 25),
(4, 'CAF_GRANDE', 'Enchiladas Suizas', 60.00, FALSE, 0),
(5, 'CAF_GRANDE', 'Agua Fresca de Horchata (1L)', 25.00, TRUE, 30);

INSERT INTO usuarios (nombre_completo, correo_institucional, matricula, password_hash, rol, id_cafeteria) VALUES
('Carlos Hernández', 'carlos@tese.edu.mx', '202104012', '$2a$10$ZqgTYmF0Mfsw2sO.DnBHk.fpxLHMX1Ncoex3Mypj8vpyqq2d1qq0W', 'estudiante', NULL),
('Personal Cafetería Grande', 'cocina.grande@tese.edu.mx', NULL, '$2a$10$ZqgTYmF0Mfsw2sO.DnBHk.fpxLHMX1Ncoex3Mypj8vpyqq2d1qq0W', 'cafeteria', 'CAF_GRANDE');

INSERT INTO pedidos (id_usuario, folio, estado, sucursal, total, id_cafeteria) VALUES
(1, '#TESE-0001', 'PENDIENTE', 'Cafetería Principal (Grande)', 80.00, 'CAF_GRANDE'),
(1, '#TESE-0002', 'EN_PREPARACION', 'Cafetería Principal (Grande)', 84.00, 'CAF_GRANDE');

INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 55.00),
(1, 5, 1, 25.00),
(2, 3, 2, 42.00);
