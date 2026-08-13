USE distribuidora;

-- 1. Vista para consolidar el total de ventas por cliente
-- Permite saber cuánto ha comprado cada cliente en total.
CREATE OR REPLACE VIEW view_ventas_por_cliente AS
SELECT 
    c.nombre_completo AS cliente,
    SUM(dp.cantidad) AS total_productos_comprados,
    SUM(dp.cantidad * dp.precio_unitario) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
JOIN detalle_pedido dp ON p.id = dp.pedido_id
GROUP BY c.id, c.nombre_completo;

-- 2. Vista para consolidar el inventario por sede
-- Permite ver el stock actual frente al mínimo requerido y el porcentaje de ocupación
CREATE OR REPLACE VIEW view_inventario_por_sede AS
SELECT 
    s.nombre AS sede,
    p.nombre AS producto,
    i.stock_actual,
    i.stock_minimo,
    CASE 
        WHEN i.stock_actual <= i.stock_minimo THEN 'Alerta: Stock Bajo'
        ELSE 'Stock Normal'
    END AS estado_stock
FROM sedes s
JOIN inventario i ON s.id = i.sede_id
JOIN productos p ON i.producto_id = p.id;

-- 3. Vista para consolidar ventas por sede
-- Permite ver qué sede ha vendido más y cuántos pedidos ha procesado
CREATE OR REPLACE VIEW view_ventas_por_sede AS
SELECT 
    s.nombre AS sede,
    COUNT(p.id) AS total_pedidos_atendidos,
    SUM(dp.cantidad) AS total_unidades_vendidas
FROM sedes s
JOIN pedidos p ON s.id = p.sede_id
JOIN detalle_pedido dp ON p.id = dp.pedido_id
GROUP BY s.id, s.nombre;