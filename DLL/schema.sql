DROP DATABASE IF EXISTS distribuidora;

CREATE DATABASE distribuidora;

USE distribuidora;

-- ============================================================
-- TABLA: clientes
-- ============================================================

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    identificacion VARCHAR(30) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    correo VARCHAR(150) NOT NULL
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: categorias
-- ============================================================

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: productos
-- ============================================================

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    volumen_ml INT NOT NULL CHECK (volumen_ml > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (categoria_id) REFERENCES categorias (id)
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: encargados
-- ============================================================

CREATE TABLE encargados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: sedes
-- ============================================================

CREATE TABLE sedes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    encargado_id INT NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    FOREIGN KEY (encargado_id) REFERENCES encargados (id)
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: inventario
-- ============================================================

CREATE TABLE inventario (
    sede_id INT NOT NULL PRIMARY KEY,
    producto_id INT NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    FOREIGN KEY (sede_id) REFERENCES sedes (id),
    FOREIGN KEY (producto_id) REFERENCES productos (id)
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: pedidos
-- ============================================================

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT NOT NULL,
    sede_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (id),
    FOREIGN KEY (sede_id) REFERENCES sedes (id)
) ENGINE = InnoDB;

-- ============================================================
-- TABLA: detalle_pedido
-- ============================================================

CREATE TABLE detalle_pedido (
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    CONSTRAINT pk_detalle_pedido PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos (id),
    FOREIGN KEY (producto_id) REFERENCES productos (id)
) ENGINE = InnoDB;