-- ============================================================
-- VISTA: resumen de pedidos por sede
-- Muestra cantidad de pedidos y total de ventas por sede.
-- ============================================================

CREATE VIEW vista_resumen_pedidos_por_sede AS
SELECT
    s.id AS sede_id,
    s.nombre AS sede,
    COUNT(DISTINCT p.id) AS total_pedidos,
    COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) AS total_ventas
FROM sedes s
LEFT JOIN pedidos p
    ON s.id = p.sede_id
LEFT JOIN detalle_pedido dp
    ON p.id = dp.pedido_id
GROUP BY
    s.id,
    s.nombre;


-- ============================================================
-- VISTA: productos bajo stock
-- Lista productos cuyo stock actual es menor o igual
-- al stock mínimo establecido.
-- ============================================================

CREATE VIEW vista_productos_bajo_stock AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto,
    s.id AS sede_id,
    s.nombre AS sede,
    i.stock_actual,
    i.stock_minimo
FROM inventario i
INNER JOIN productos p
    ON i.producto_id = p.id
INNER JOIN sedes s
    ON i.sede_id = s.id
WHERE i.stock_actual <= i.stock_minimo;


-- ============================================================
-- VISTA: clientes activos
-- Muestra clientes que tienen al menos un pedido registrado.
-- ============================================================

CREATE VIEW vista_clientes_activos AS
SELECT
    c.id AS cliente_id,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo,
    COUNT(p.id) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p
    ON c.id = p.cliente_id
GROUP BY
    c.id,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo;