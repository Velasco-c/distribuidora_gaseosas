CREATE DATABASE IF NOT EXISTS distribuidora;

USE distribuidora;

-- ============================================================
-- TABLA: clientes
-- ============================================================

CREATE TABLE clientes (
    id INT AUTO_INCREMENT,
    nombre_completo VARCHAR(150) NOT NULL,
    identificacion VARCHAR(30) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    correo VARCHAR(150) NOT NULL,

    CONSTRAINT pk_clientes
        PRIMARY KEY (id),

    CONSTRAINT uq_clientes_identificacion
        UNIQUE (identificacion),

    CONSTRAINT uq_clientes_correo
        UNIQUE (correo)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: categorias
-- ============================================================

CREATE TABLE categorias (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_categorias
        PRIMARY KEY (id),

    CONSTRAINT uq_categorias_nombre
        UNIQUE (nombre)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: productos
-- ============================================================

CREATE TABLE productos (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    volumen_ml INT NOT NULL,

    CONSTRAINT pk_productos
        PRIMARY KEY (id),

    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categorias (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_productos_nombre_volumen
        UNIQUE (nombre, volumen_ml),

    CONSTRAINT chk_productos_volumen
        CHECK (volumen_ml > 0)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: encargados
-- ============================================================

CREATE TABLE encargados (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,

    CONSTRAINT pk_encargados
        PRIMARY KEY (id)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: almacenamientos
-- ============================================================

CREATE TABLE almacenamientos (
    id INT AUTO_INCREMENT,
    capacidad INT NOT NULL,

    CONSTRAINT pk_almacenamientos
        PRIMARY KEY (id),

    CONSTRAINT chk_almacenamientos_capacidad
        CHECK (capacidad > 0)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: sedes
-- ============================================================

CREATE TABLE sedes (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    encargado_id INT NOT NULL,
    almacenamiento_id INT NOT NULL,

    CONSTRAINT pk_sedes
        PRIMARY KEY (id),

    CONSTRAINT uq_sedes_nombre
        UNIQUE (nombre),

    CONSTRAINT fk_sedes_encargado
        FOREIGN KEY (encargado_id)
        REFERENCES encargados (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sedes_almacenamiento
        FOREIGN KEY (almacenamiento_id)
        REFERENCES almacenamientos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: inventario
-- ============================================================

CREATE TABLE inventario (
    sede_id INT NOT NULL,
    producto_id INT NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,

    CONSTRAINT pk_inventario
        PRIMARY KEY (sede_id, producto_id),

    CONSTRAINT fk_inventario_sede
        FOREIGN KEY (sede_id)
        REFERENCES sedes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_inventario_stock_actual
        CHECK (stock_actual >= 0),

    CONSTRAINT chk_inventario_stock_minimo
        CHECK (stock_minimo >= 0)

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: pedidos
-- ============================================================

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT NOT NULL,
    sede_id INT NOT NULL,

    CONSTRAINT pk_pedidos
        PRIMARY KEY (id),

    CONSTRAINT fk_pedidos_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES clientes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pedidos_sede
        FOREIGN KEY (sede_id)
        REFERENCES sedes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE = InnoDB;


-- ============================================================
-- TABLA: detalle_pedido
-- ============================================================

CREATE TABLE detalle_pedido (
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    detalles_pedido VARCHAR(255) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,

    CONSTRAINT pk_detalle_pedido
        PRIMARY KEY (pedido_id, producto_id),

    CONSTRAINT fk_detalle_pedido_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_pedido_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_detalle_pedido_precio
        CHECK (precio_unitario >= 0),

    CONSTRAINT chk_detalle_pedido_cantidad
        CHECK (cantidad > 0)

) ENGINE = InnoDB;
