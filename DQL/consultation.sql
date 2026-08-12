USE distribuidora;
 /*
 =======================================================================
                          PRIMERA CONSULTA
            Consultar los productos con stock por debajo del mínimo.
 ======================================================================
 */
SELECT p.nombre as producto, i.stock_actual FROM inventario i 
INNER JOIN productos p ON p.id = i.producto_id
WHERE i.stock_actual < i.stock_minimo
GROUP BY p.nombre,i.stock_actual;

 /*
 =======================================================================
                          SEGUNDA CONSULTA
            Consultar los pedidos realizados entre dos fechas (BETWEEN).
 ======================================================================
 */
 SELECT * FROM pedidos WHERE fecha BETWEEN '2026-08-01 08:30:00' AND '2026-08-04 11:20:00';
 
 /*
 =======================================================================
                          TERCERA CONSULTA
            Listar los productos más vendidos (con JOIN y GROUP BY).
 ======================================================================
 */
SELECT p.nombre,SUM(dp.cantidad*dp.precio_unitario) AS total FROM detalle_pedido dp 
INNER JOIN productos p ON p.id = dp.producto_id 
GROUP BY p.id, p.nombre 
ORDER BY total DESC LIMIT 3;

 /*
 =======================================================================
                          CUARTA CONSULTA
            Mostrar clientes y la cantidad de pedidos realizados.
 ======================================================================
 */
SELECT p.id,c.nombre_completo AS nombre_cliente, dp.descripcion, dp.cantidad,dp.precio_unitario, SUM(dp.cantidad*dp.precio_unitario) AS total FROM pedidos p 
INNER JOIN detalle_pedido dp ON dp.pedido_id = p.id
INNER JOIN clientes c ON c.id = p.cliente_id
GROUP BY p.id,c.nombre_completo , dp.descripcion, dp.cantidad, dp.cantidad,dp.precio_unitario;

 /*
 =======================================================================
                          QUINTA CONSULTA
            Buscar clientes por nombre parcial usando LIKE.
 ======================================================================
 */
 DESCRIBE clientes;
SELECT * 
FROM clientes
WHERE nombre_completo LIKE 'M%';

 /*
 =======================================================================
                          SEXTA CONSULTA
            Consultar productos de ciertas categorías usando IN.
 ======================================================================
 */
 DESCRIBE pedidos;
SELECT * 
FROM productos
WHERE categoria_id IN (SELECT id FROM categorias);

 /*
 =======================================================================
                          SEPTIMA CONSULTA
            Mostrar el cliente con mayor número de pedidos (subconsulta).
 ======================================================================
 */
SELECT *
FROM (
SELECT p.id,c.nombre_completo as nombre_cliente, COUNT(1) AS cantidad_pedidos
FROM pedidos p INNER JOIN clientes c ON c.id = p.cliente_id
GROUP BY p.id,c.nombre_completo
ORDER BY cantidad_pedidos DESC LIMIT 1
) AS X;

 /*
 =======================================================================
                          OCTAVA CONSULTA
            Consultar pedidos y sus totales agrupados por sede.
 ======================================================================
 */
DESCRIBE detalle_pedido;
SELECT p.id AS id_pedidos,c.nombre_completo,s.nombre AS nombre_sede, s.ubicacion AS ubicacion, dp.cantidad AS cantidad_pedidos ,SUM(dp.precio_unitario * dp.cantidad) AS total
FROM pedidos p 
INNER JOIN sedes s ON s.id = p.sede_id
INNER JOIN clientes c ON c.id = p.cliente_id
INNER JOIN detalle_pedido dp ON dp.pedido_id = p.id
GROUP BY p.id,c.nombre_completo,s.nombre,s.ubicacion,dp.precio_unitario, dp.cantidad;