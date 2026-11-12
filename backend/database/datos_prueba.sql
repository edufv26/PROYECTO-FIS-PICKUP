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
