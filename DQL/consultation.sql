USE distribuidora;

 /*
 =======================================================================
                          PRIMERA CONSULTA
            Consultar los productos con stock por debajo del mínimo.
 ======================================================================
 */

SELECT
    p.nombre AS producto,
    i.stock_actual,
    i.stock_minimo
FROM inventario AS i
INNER JOIN productos AS p
    ON p.id = i.producto_id
WHERE i.stock_actual < i.stock_minimo;


 /*
 =======================================================================
                          SEGUNDA CONSULTA
            Consultar los pedidos realizados entre dos fechas (BETWEEN).
 ======================================================================
 */

SELECT
    *
FROM pedidos
WHERE fecha BETWEEN '2026-08-01 08:30:00'
                AND '2026-08-04 11:20:00';


 /*
 =======================================================================
                          TERCERA CONSULTA
            Listar los productos más vendidos (con JOIN y GROUP BY).
 ======================================================================
 */

SELECT
    p.id,
    p.nombre AS producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
FROM detalle_pedido AS dp
INNER JOIN productos AS p
    ON p.id = dp.producto_id
GROUP BY
    p.id,
    p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 3;


 /*
 =======================================================================
                          CUARTA CONSULTA
            Mostrar clientes y la cantidad de pedidos realizados.
 ======================================================================
 */

SELECT
    c.id,
    c.nombre_completo AS nombre_cliente,
    COUNT(p.id) AS cantidad_pedidos
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nombre_completo
ORDER BY cantidad_pedidos DESC;


 /*
 =======================================================================
                          QUINTA CONSULTA
            Buscar clientes por nombre parcial usando LIKE.
 ======================================================================
 */

SELECT
    *
FROM clientes
WHERE nombre_completo LIKE 'M%';


 /*
 =======================================================================
                          SEXTA CONSULTA
            Consultar productos de ciertas categorías usando IN.
 ======================================================================
 */

SELECT
    *
FROM productos
WHERE categoria_id IN (
    SELECT id
    FROM categorias
);


 /*
 =======================================================================
                          SEPTIMA CONSULTA
            Mostrar el cliente con mayor número de pedidos (subconsulta).
 ======================================================================
 */

SELECT
    x.id,
    x.nombre_cliente,
    x.cantidad_pedidos
FROM (
    SELECT
        c.id,
        c.nombre_completo AS nombre_cliente,
        COUNT(p.id) AS cantidad_pedidos
    FROM clientes AS c
    INNER JOIN pedidos AS p
        ON p.cliente_id = c.id
    GROUP BY
        c.id,
        c.nombre_completo
) AS x
ORDER BY x.cantidad_pedidos DESC
LIMIT 1;


 /*
 =======================================================================
                          OCTAVA CONSULTA
            Consultar pedidos y sus totales agrupados por sede.
 ======================================================================
 */

SELECT
    s.id,
    s.nombre AS nombre_sede,
    s.ubicacion,
    COUNT(DISTINCT p.id) AS cantidad_pedidos,
    SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
FROM sedes AS s
INNER JOIN pedidos AS p
    ON p.sede_id = s.id
INNER JOIN detalle_pedido AS dp
    ON dp.pedido_id = p.id
GROUP BY
    s.id,
    s.nombre,
    s.ubicacion
ORDER BY total_ventas DESC;