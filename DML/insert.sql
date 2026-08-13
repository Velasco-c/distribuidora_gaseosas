USE distribuidora;

-- ============================================================
-- DATOS: clientes
-- ============================================================

INSERT INTO clientes (
    nombre_completo,
    identificacion,
    direccion,
    telefono,
    correo
) VALUES
    ('Carlos Méndez López', 'DPI-0101-45872-0101', 'Zona 1, Ciudad de Guatemala, Guatemala', '5551-2048', 'carlos.mendez@example.com'),
    ('María José García Pérez', 'DPI-0202-63841-0202', 'Zona 7, Ciudad de Guatemala, Guatemala', '5552-3176', 'maria.garcia@example.com'),
    ('José Luis Ramírez Castillo', 'DPI-0303-72915-0303', 'Zona 3, Quetzaltenango, Quetzaltenango', '5553-4289', 'jose.ramirez@example.com'),
    ('Ana Lucía Hernández Morales', 'DPI-0404-81526-0404', 'Zona 2, Escuintla, Escuintla', '5554-5193', 'ana.hernandez@example.com'),
    ('Pedro Antonio Gómez Díaz', 'DPI-0505-39274-0505', 'Zona 1, Antigua Guatemala, Sacatepéquez', '5555-6037', 'pedro.gomez@example.com'),
    ('Sofía Alejandra Pérez Ruiz', 'DPI-0606-54718-0606', 'Zona 1, Cobán, Alta Verapaz', '5556-7142', 'sofia.perez@example.com'),
    ('Miguel Ángel Choc Caal', 'DPI-0707-68193-0707', 'Zona 3, San Benito, Petén', '5557-8254', 'miguel.choc@example.com'),
    ('Daniela Isabel Morales Soto', 'DPI-0808-73625-0808', 'Zona 5, Huehuetenango, Huehuetenango', '5558-9361', 'daniela.morales@example.com'),
    ('Luis Fernando Vásquez Ortiz', 'DPI-0909-82461-0909', 'Zona 4, Chimaltenango, Chimaltenango', '5559-1472', 'luis.vasquez@example.com'),
    ('Gabriela Estefanía López Tuc', 'DPI-1010-91538-1010', 'Zona 1, Puerto Barrios, Izabal', '5550-2586', 'gabriela.lopez@example.com');

-- ============================================================
-- DATOS: categorias
-- ============================================================

INSERT INTO categorias (nombre) VALUES
    ('Colas'),
    ('Gaseosas de limón'),
    ('Gaseosas de naranja'),
    ('Gaseosas de uva'),
    ('Gaseosas de manzana'),
    ('Gaseosas de toronja'),
    ('Gaseosas de fresa'),
    ('Gaseosas de frutas'),
    ('Gaseosas sin azúcar'),
    ('Gaseosas tradicionales');

-- ============================================================
-- DATOS: productos
-- ============================================================

INSERT INTO productos (
    nombre,
    categoria_id,
    volumen_ml
) VALUES
    ('Cola Original 600 ml', 1, 600),
    ('Limón Refrescante 600 ml', 2, 600),
    ('Naranja Tropical 600 ml', 3, 600),
    ('Uva Intensa 600 ml', 4, 600),
    ('Manzana Verde 600 ml', 5, 600),
    ('Toronja Refrescante 600 ml', 6, 600),
    ('Fresa Gasificada 600 ml', 7, 600),
    ('Frutas Tropicales 600 ml', 8, 600),
    ('Cola Sin Azúcar 600 ml', 9, 600),
    ('Cola Tradicional 1.5 L', 10, 1500);

-- ============================================================
-- DATOS: encargados
-- ============================================================

INSERT INTO encargados (nombre) VALUES
    ('Jorge Alberto Pérez'),
    ('Marvin Estuardo López'),
    ('Karla Vanessa Morales'),
    ('Edwin Rolando García'),
    ('Andrea Michelle Hernández'),
    ('Byron Alexander Castillo'),
    ('Paola Fernanda Ramírez'),
    ('Óscar Estuardo Chacón'),
    ('Mónica Alejandra Díaz'),
    ('René Antonio Cifuentes');

-- ============================================================
-- DATOS: sedes
-- ============================================================

INSERT INTO sedes (
    nombre,
    ubicacion,
    encargado_id,
    capacidad
) VALUES
    ('Sede Central Guatemala', 'Zona 12, Ciudad de Guatemala, Guatemala', 1, 5000),
    ('Sede Quetzaltenango', 'Zona 3, Quetzaltenango, Quetzaltenango', 2, 3500),
    ('Sede Escuintla', 'Zona 1, Escuintla, Escuintla', 3, 3000),
    ('Sede Antigua', 'Zona 3, Antigua Guatemala, Sacatepéquez', 4, 2500),
    ('Sede Cobán', 'Zona 2, Cobán, Alta Verapaz', 5, 2800),
    ('Sede Petén', 'San Benito, Petén, Guatemala', 6, 2200),
    ('Sede Huehuetenango', 'Zona 5, Huehuetenango, Huehuetenango', 7, 2700),
    ('Sede Chimaltenango', 'Zona 4, Chimaltenango, Chimaltenango', 8, 2400),
    ('Sede Izabal', 'Puerto Barrios, Izabal, Guatemala', 9, 2600),
    ('Sede Sacatepéquez', 'Ciudad Vieja, Sacatepéquez, Guatemala', 10, 2000);

-- ============================================================
-- DATOS: inventario
-- ============================================================

INSERT INTO inventario (
    sede_id,
    producto_id,
    stock_actual,
    stock_minimo
) VALUES
    (1, 1, 1250, 300),
    (2, 2, 980, 250),
    (3, 3, 750, 200),
    (4, 4, 620, 150),
    (5, 5, 540, 120),
    (6, 6, 430, 100),
    (7, 7, 380, 100),
    (8, 8, 460, 120),
    (9, 9, 520, 150),
    (10, 10, 350, 80);

-- ============================================================
-- DATOS: pedidos
-- ============================================================
-- Cada cliente tendrá 3 pedidos en total.
-- Los pedidos 1-10 ya corresponden al primer pedido
-- de cada cliente.
-- Los pedidos 11-30 corresponden al segundo y tercer
-- pedido de cada cliente.
-- ============================================================

INSERT INTO pedidos (
    fecha,
    cliente_id,
    sede_id
) VALUES
    -- Primer pedido de cada cliente
    ('2026-08-01 08:30:00', 1, 1),
    ('2026-08-02 09:15:00', 2, 2),
    ('2026-08-03 10:00:00', 3, 3),
    ('2026-08-04 11:20:00', 4, 4),
    ('2026-08-05 13:45:00', 5, 5),
    ('2026-08-06 14:10:00', 6, 6),
    ('2026-08-07 15:30:00', 7, 7),
    ('2026-08-08 16:00:00', 8, 8),
    ('2026-08-09 09:40:00', 9, 9),
    ('2026-08-10 10:25:00', 10, 10),

    -- Segundo pedido de cada cliente
    ('2026-08-11 08:45:00', 1, 2),
    ('2026-08-12 09:30:00', 2, 3),
    ('2026-08-13 10:15:00', 3, 4),
    ('2026-08-14 11:40:00', 4, 5),
    ('2026-08-15 13:20:00', 5, 6),
    ('2026-08-16 14:35:00', 6, 7),
    ('2026-08-17 15:10:00', 7, 8),
    ('2026-08-18 16:25:00', 8, 9),
    ('2026-08-19 09:20:00', 9, 10),
    ('2026-08-20 10:50:00', 10, 1),

    -- Tercer pedido de cada cliente
    ('2026-08-21 08:20:00', 1, 3),
    ('2026-08-22 09:05:00', 2, 4),
    ('2026-08-23 10:30:00', 3, 5),
    ('2026-08-24 11:15:00', 4, 6),
    ('2026-08-25 13:50:00', 5, 7),
    ('2026-08-26 14:25:00', 6, 8),
    ('2026-08-27 15:45:00', 7, 9),
    ('2026-08-28 16:10:00', 8, 10),
    ('2026-08-29 09:35:00', 9, 1),
    ('2026-08-30 10:40:00', 10, 2);

-- ============================================================
-- DATOS: detalle_pedido
-- ============================================================

INSERT INTO detalle_pedido (
    pedido_id,
    producto_id,
    descripcion,
    precio_unitario,
    cantidad
) VALUES
    -- ========================================================
    -- Pedidos 1-10
    -- ========================================================

    (1, 1, 'Cola Original 600 ml', 7.50, 24),
    (2, 2, 'Limón Refrescante 600 ml', 7.00, 30),
    (3, 3, 'Naranja Tropical 600 ml', 7.50, 18),
    (4, 4, 'Uva Intensa 600 ml', 7.50, 20),
    (5, 5, 'Manzana Verde 600 ml', 7.00, 24),
    (6, 6, 'Toronja Refrescante 600 ml', 7.50, 18),
    (7, 7, 'Fresa Gasificada 600 ml', 8.00, 15),
    (8, 8, 'Frutas Tropicales 600 ml', 8.00, 20),
    (9, 9, 'Cola Sin Azúcar 600 ml', 8.50, 12),
    (10, 10, 'Cola Tradicional 1.5 L', 13.50, 24),

    -- ========================================================
    -- Pedidos 11-20
    -- ========================================================

    (11, 2, 'Limón Refrescante 600 ml', 7.00, 18),
    (11, 8, 'Frutas Tropicales 600 ml', 8.00, 12),

    (12, 3, 'Naranja Tropical 600 ml', 7.50, 24),
    (12, 9, 'Cola Sin Azúcar 600 ml', 8.50, 10),

    (13, 4, 'Uva Intensa 600 ml', 7.50, 20),
    (13, 7, 'Fresa Gasificada 600 ml', 8.00, 15),

    (14, 5, 'Manzana Verde 600 ml', 7.00, 30),
    (14, 10, 'Cola Tradicional 1.5 L', 13.50, 12),

    (15, 6, 'Toronja Refrescante 600 ml', 7.50, 22),
    (15, 1, 'Cola Original 600 ml', 7.50, 18),

    (16, 7, 'Fresa Gasificada 600 ml', 8.00, 16),
    (16, 3, 'Naranja Tropical 600 ml', 7.50, 20),

    (17, 8, 'Frutas Tropicales 600 ml', 8.00, 24),
    (17, 2, 'Limón Refrescante 600 ml', 7.00, 18),

    (18, 9, 'Cola Sin Azúcar 600 ml', 8.50, 20),
    (18, 5, 'Manzana Verde 600 ml', 7.00, 15),

    (19, 10, 'Cola Tradicional 1.5 L', 13.50, 18),
    (19, 4, 'Uva Intensa 600 ml', 7.50, 20),

    (20, 1, 'Cola Original 600 ml', 7.50, 30),
    (20, 6, 'Toronja Refrescante 600 ml', 7.50, 15),

    -- ========================================================
    -- Pedidos 21-30
    -- ========================================================

    (21, 3, 'Naranja Tropical 600 ml', 7.50, 20),
    (21, 8, 'Frutas Tropicales 600 ml', 8.00, 16),

    (22, 4, 'Uva Intensa 600 ml', 7.50, 24),
    (22, 9, 'Cola Sin Azúcar 600 ml', 8.50, 12),

    (23, 5, 'Manzana Verde 600 ml', 7.00, 18),
    (23, 2, 'Limón Refrescante 600 ml', 7.00, 20),

    (24, 6, 'Toronja Refrescante 600 ml', 7.50, 25),
    (24, 10, 'Cola Tradicional 1.5 L', 13.50, 10),

    (25, 7, 'Fresa Gasificada 600 ml', 8.00, 20),
    (25, 1, 'Cola Original 600 ml', 7.50, 24),

    (26, 8, 'Frutas Tropicales 600 ml', 8.00, 18),
    (26, 3, 'Naranja Tropical 600 ml', 7.50, 22),

    (27, 9, 'Cola Sin Azúcar 600 ml', 8.50, 16),
    (27, 6, 'Toronja Refrescante 600 ml', 7.50, 20),

    (28, 10, 'Cola Tradicional 1.5 L', 13.50, 15),
    (28, 5, 'Manzana Verde 600 ml', 7.00, 24),

    (29, 1, 'Cola Original 600 ml', 7.50, 28),
    (29, 7, 'Fresa Gasificada 600 ml', 8.00, 14),

    (30, 2, 'Limón Refrescante 600 ml', 7.00, 25),
    (30, 10, 'Cola Tradicional 1.5 L', 13.50, 12);