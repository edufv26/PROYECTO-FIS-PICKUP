-- Creación de la base de datos (Ejecutar en tu instancia RDS PostgreSQL)
-- CREATE DATABASE AdmCafe;

-- 1. Tabla de Usuarios (Alumnos del TESE)
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(120) NOT NULL,
    correo_institucional VARCHAR(100) UNIQUE NOT NULL, -- Debe terminar en @tese.edu.mx
    matricula VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Categorías del Menú (Desayunos, Tortas, Antojitos, Comida Corrida, Bebidas)
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- 3. Tabla de Productos / Menú y Control de Inventario
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    id_categoria INT REFERENCES categorias(id_categoria) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(8, 2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE, -- Conecta con el switch de "Agotado / Disponible" del panel admin
    stock INT NOT NULL DEFAULT 0,
    imagen_url VARCHAR(255)
);

-- 4. Tabla de Pedidos (Para la vista de Tickets y el Kanban de Cafeterías)
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    folio VARCHAR(30) UNIQUE NOT NULL, -- Ej: #TESE-8492
    estado VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE', -- PENDIENTE, EN_PREPARACION, LISTO, ENTREGADO
    sucursal VARCHAR(50) NOT NULL DEFAULT 'Cafetería Grande (Principal)',
    total DECIMAL(8, 2) NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla de Detalle de Pedidos (Relación N:M entre pedidos y productos)
CREATE TABLE detalle_pedidos (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(8, 2) NOT NULL
);
